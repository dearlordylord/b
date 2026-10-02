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
    for edit in ("endpoint", "control"):
        mutant = copy.deepcopy(root)
        seam = next(e for e in mutant.iter(ns + "path") if "-seam-" in e.attrib.get("id", ""))
        data = seam.attrib["d"]
        if edit == "endpoint":
            seam.attrib["d"] = data.replace("M", "M1", 1)
        else:
            seam.attrib["d"] = data.replace("Q", "Q1", 1)
        try:
            verify(mutant)
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
    for text in controls:
        assert text != original
        path.write_text(text)
        try:
            bend(directory, "generate.bend", "--check-only")
            result = subprocess.run(["bend", "generate.bend"], cwd=directory,
                                    capture_output=True, text=True, timeout=5)
            output = result.stdout + result.stderr
            assert result.returncode != 0 and "Artwork geometry validation failed" in output, output
            assert "<svg" not in output, "invalid geometry emitted an SVG"
        finally:
            path.write_text(original)
    return len(controls)


if __name__ == "__main__":
    with tempfile.TemporaryDirectory(prefix="bend-svg-check-") as temp:
        directory = Path(temp)
        for file in HERE.glob("*.bend"):
            shutil.copy2(file, directory / file.name)
        bend(directory, "PROOF.bend", "--verdict")
        print("BendTT: all five geometry/serialization laws accepted")
        print(f"Literal arithmetic checks: {literal_checks(directory)} accepted")
        print(f"Compiling mutations rejected by their laws: {negative_controls(directory)}")
        print(f"Invalid artworks rejected by Bend before SVG emission: {bend_artwork_negative_controls(directory)}")
    root = ET.parse(HERE / "b.svg").getroot()
    print("Independent exact SVG geometry:", verify(root))
    svg_negative_controls(root)
    print("Broken SVG endpoint/control negative controls rejected")
