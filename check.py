"""Run Bend/BendTT, negative controls, and independent SVG artifact checks."""
import copy
import re
import shutil
import subprocess
import sys
import tempfile
import xml.etree.ElementTree as ET
from pathlib import Path

sys.dont_write_bytecode = True
from verify import verify
from topology_verify import nerve, verify_topology

HERE = Path(__file__).resolve().parent


def bend(directory, file, *args, success=True):
    result = subprocess.run(["bend", file, *args], cwd=directory,
                            capture_output=True, text=True, timeout=5)
    output = result.stdout + result.stderr
    if success:
        assert result.returncode == 0 and "ALL PROOFS CHECK" in output, output
    else:
        assert result.returncode != 0 and "expected" in output.lower(), output
    return output


def negative_controls(directory):
    controls = [
        ("core.bend", "Seam{boundary_left(cell_start(cell)),",
         "Seam{boundary_right(cell_start(cell)),", "seam_attaches_left"),
        ("core.bend", "cell_center(cell), boundary_right(cell_start(cell))}",
         "cell_center(cell), boundary_left(cell_start(cell))}", "seam_attaches_right"),
        ("core.bend", '"M" ++ point_svg(seam_start(s))',
         '"M" ++ point_svg(seam_end(s))', "svg_uses_boundaries"),
        ("geometry.bend", "Nat.mul(Nat.mul(v, v), start)",
         "Nat.add(Nat.mul(Nat.mul(v, v), start), 1n)", "seam_inside_cell_coordinate"),
        ("geometry.bend", "F.weight_total(u, v)",
         "Nat.add(F.weight_total(u, v), 1n)", "corner_weights_normalize"),
    ]
    controls += [
        ("word-conversion.bend", "Word.inc(n, from_nat(p, n))", "Word.zero(n)", "bounded_conversion"),
        ("word-arithmetic.bend", "case 0n: 1n", "case 0n: 0n", "high_carry_value"),
        ("word-arithmetic.bend", "Carry{c, WNil{}}", "Carry{False{}, WNil{}}", "whole_word_value"),
        ("word-arithmetic.bend", "prepend(p, False{}, add_carry(p, at, bt, False{}))", "prepend(p, True{}, add_carry(p, at, bt, False{}))", "low_word_agrees"),
        ("exact-arithmetic.bend", "cyclic_sum(ax, by, bx, y, x, ay, d)", "Nat.add(cyclic_sum(ax, by, bx, y, x, ay, d), 1n)", "edge_reversal_left"),
        ("validation.bend", "bounded_valid(sections_bounded(sections), sections)", "True{}", "validator_sound"),
        ("validation.bend", "Nat.is_eq(section_count(sections), 33n) && validate(sections)", "validate(sections)", "artwork_gate_sound"),
        ("topology.bend", "connected && (witnessed && (no_five && (ribbons &&", "True{} && (witnessed && (no_five && (ribbons &&", "topology_report_sound"),
    ]
    for file, old, new, law in controls:
        path = directory / file
        original = path.read_text()
        assert original.count(old) == 1, (file, old)
        path.write_text(original.replace(old, new))
        try:
            # A mutant that cannot even compile is not a useful proof control.
            bend(directory, file, "--check-only")
            output = bend(directory, "PROOF.bend", success=False)
            assert law in output, output
        finally:
            path.write_text(original)
    return len(controls)


def literal_checks(directory):
    # Concrete equations independently evaluate the algebra, rather than
    # obtaining evidence by calling the theorem being tested.
    rows = ["import Base", "import ./geometry.bend as G"]
    count = 0
    for u in range(5):
        for v in range(5):
            for seed in range(8):
                l0, l1, r0, r1 = [4 * ((seed * k + 3) % 9) for k in (1, 3, 5, 7)]
                control = (l0 + l1 + r0 + r1) // 4
                rows += [f"def sample_{count}() -> {{Nat.mul(4n, G.bezier_numerator({l0}n, {control}n, {r0}n, {u}n, {v}n)) == G.cell_numerator({l0}n, {l1}n, {r0}n, {r1}n, {u}n, {v}n) : Nat}}:", "  {==}"]
                count += 1
    (directory / "samples.bend").write_text("\n".join(rows) + "\n")
    bend(directory, "samples.bend")
    return count


def svg_negative_controls(root):
    ns = "{http://www.w3.org/2000/svg}"
    for edit in ("endpoint", "control", "transform"):
        mutant = copy.deepcopy(root)
        seam = next(e for e in mutant.iter(ns + "path") if "-seam-" in e.attrib.get("id", ""))
        data = seam.attrib["d"]
        if edit == "transform":
            mutant.find(ns + "g").set("transform", "translate(20000 0)")
        elif edit == "endpoint":
            seam.attrib["d"] = data.replace("M", "M1", 1)
        else:
            seam.attrib["d"] = data.replace("Q", "Q1", 1)
        try:
            verify_topology(mutant)
        except ValueError:
            continue
        raise AssertionError(f"SVG validator accepted broken {edit}")


def bend_artwork_negative_controls(directory):
    path = directory / "artwork.bend"
    original = path.read_text()
    first = re.search(r"Core.Section\{(Core.Pt\{\d+n, \d+n\}), (Core.Pt\{\d+n, \d+n\})\}", original)
    assert first
    controls = [
        original[:first.start()] + original[first.start():].replace("5072n", "20000n", 1),
        original[:first.start()] +
        original[first.start():].replace(first.group(0),
                                        f"Core.Section{{{first.group(1)}, {first.group(1)}}}", 1),
    ]
    start = original.index("def stem()")
    moved = re.sub(r"Core.Pt\{(\d+)n,", lambda m: f"Core.Pt{{{int(m[1]) + 10000}n,", original[start:])
    controls.append(original[:start] + moved)
    for index, text in enumerate(controls):
        assert text != original
        path.write_text(text)
        try:
            if index == 2:
                (directory / "geometry-only.bend").write_text(
                    "import Base\nimport ./artwork.bend as A\nimport ./validation.bend as V\n"
                    "def main() -> IO(Unit):\n  do IO<Unit>:\n"
                    '    IO.print(Bool.show(V.expected_artwork(A.stem())))\n')
                probe = subprocess.run(["bend", "geometry-only.bend"], cwd=directory,
                                       capture_output=True, text=True, timeout=5)
                assert probe.returncode == 0 and "True" in probe.stdout, probe.stdout + probe.stderr
            bend(directory, "generate.bend", "--check-only")
            result = subprocess.run(["bend", "generate.bend"], cwd=directory,
                                    capture_output=True, text=True, timeout=5)
            output = result.stdout + result.stderr
            assert result.returncode != 0 and "Artwork geometry validation failed" in output, output
            assert "<svg" not in output, "invalid geometry emitted an SVG"
        finally:
            path.write_text(original)
    return len(controls)


def topology_reference_controls():
    def box(x, y, u, v):
        return [(x, y), (u, y), (u, v), (x, v)]
    a, b = box(0, 0, 10, 2), box(0, 0, 2, 10)
    c = [(0, 8), (8, 0), (10, 0), (0, 10)]
    assert nerve([a, b, c]) == {"components": 1, "holes": 1, "euler": 0, "simplices": [3, 3]}
    assert nerve([a] * 5) == {"components": 1, "holes": 0, "euler": 1, "simplices": [5, 10, 10, 5, 1]}
    assert nerve([box(0, 0, 4, 4), box(4, 4, 8, 8)])["components"] == 1
    assert nerve([box(0, 0, 4, 4), box(5, 5, 9, 9)])["components"] == 2
    print("Independent topology controls: empty triple, filled K5, point contact and gap accepted")


if __name__ == "__main__":
    with tempfile.TemporaryDirectory(prefix="bend-svg-check-") as temp:
        directory = Path(temp)
        for file in HERE.glob("*.bend"):
            shutil.copy2(file, directory / file.name)
        bend(directory, "PROOF.bend", "--verdict")
        print("BendTT: all 30 public laws accepted")
        bend(directory, "word-conversion-tests.bend", "--verdict")
        print("Generic and actual U32 conversion fixtures accepted")
        bend(directory, "word-bounds-tests.bend", "--verdict")
        print("Word capacity and strict-bound fixtures accepted")
        bend(directory, "word-tests.bend", "--verdict")
        print("Word carry and exact-value fixtures accepted")
        bend(directory, "arithmetic-tests.bend", "--verdict")
        print("Four exact orientation fixtures accepted")
        bend(directory, "validation-tests.bend", "--verdict")
        print("Seven concrete validator boundary checks accepted")
        result = subprocess.run(["bend", "topology-tests.bend"], cwd=directory, capture_output=True, text=True, timeout=5)
        assert result.returncode == 0 and "topology-tests: True" in result.stdout, result.stdout + result.stderr
        print("Bend topology fixtures accepted")
        print(f"Literal arithmetic checks: {literal_checks(directory)} accepted")
        print(f"Compiling mutations rejected by their laws: {negative_controls(directory)}")
        print(f"Invalid artworks rejected by Bend before SVG emission: {bend_artwork_negative_controls(directory)}")
    root = ET.parse(HERE / "b.svg").getroot()
    print("Independent exact SVG geometry:", verify(root))
    print("Independent exact fill topology:", verify_topology(root))
    topology_reference_controls()
    svg_negative_controls(root)
    print("Broken SVG endpoint/control/transform negative controls rejected")
