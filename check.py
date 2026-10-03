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
        ("word-sum4.bend", "Word.mul(n, g, h)", "Word.add(n, g, h)", "finish"),
        ("coordinate-sum4.bend", "Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.add(Nat.mul(e, f), Nat.mul(g, h)))", "Nat.mul(8n, Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.add(Nat.mul(e, f), Nat.mul(g, h))))", "width_bound"),
        ("validation.bend", "U32.from_nat(x) * U32.from_nat(z) + U32.from_nat(y) * U32.from_nat(w)", "U32.from_nat(x) * U32.from_nat(w) + U32.from_nat(y) * U32.from_nat(z)", "guarded_dot_exact"),
        ("validation.bend", "Nat.is_le(x, 16000n) && Nat.is_le(y, 16000n)", "True{}", "accepted_points_determinant"),
        ("validation.bend", "U32.is_gt(Arithmetic.u32_sum3(x, v, u, s, r, y), Arithmetic.u32_sum3(y, u, v, r, s, x))", "U32.is_le(Arithmetic.u32_sum3(x, v, u, s, r, y), Arithmetic.u32_sum3(y, u, v, r, s, x))", "guarded_determinant"),
        ("coordinate-sum.bend", "Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.mul(e, f))", "Nat.mul(8n, Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.mul(e, f)))", "sum_width_bound"),
        ("word-sum3.bend", "Word.mul(n, e, f)", "Word.add(n, e, f)", "sum3_finish"),
        ("word-sum3.bend", "sum3(32n, aw, bw, cw, dw, ew, fw)", "sum3(32n, aw, bw, cw, fw, ew, dw)", "literal_u32_sum3_exact"),
        ("word-division4.bend", "WCon{second(p, t), quotient(p, t)}", "WCon{head(p, t), quotient(p, t)}", "division4_loop_bits"),
        ("word-division4.bend", "case True{} True{}: 3", "case True{} True{}: 2", "bit_division_step"),
        ("word-subtraction.bend", "W.add_carry(n, a, Word.not(n, b), c)", "W.add_carry(n, a, b, c)", "subtraction_low_agrees"),
        ("word-subtraction.bend", "case EQ{}: c", "case EQ{}: True{}", "carry_step"),
        ("word-subtraction.bend", "Word.sub(n, a, b)", "Word.add(n, a, b)", "ordered_subtraction"),
        ("word-comparison.bend", "Word.cmp(n, a, b)", "EQ{}", "word_comparison_exact"),
        ("word-comparison.bend", "Word.cmp(n, a, b)", "Word.cmp(n, b, a)", "word_comparison_exact"),
        ("word-complement.bend", "Word.not(n, w)", "w", "complement_value"),
        ("word-multiplication.bend", "Word.mul.go(n, m, a, b, acc)", "Word.mul.go(n, m, a, b, Word.zero(n))", "loop_exact"),
        ("word-multiplication.bend", "Word.mul(n, a, b)", "Word.add(n, a, b)", "bounded_multiplication"),
        ("word-shift.bend", "W.Carry{c, WNil{}}", "W.Carry{False{}, WNil{}}", "shift_value"),
        ("word-conversion.bend", "Word.inc(n, from_nat(p, n))", "Word.zero(n)", "bounded_conversion"),
        ("word-arithmetic.bend", "case 0n: 1n", "case 0n: 0n", "high_carry_value"),
        ("word-arithmetic.bend", "Carry{c, WNil{}}", "Carry{False{}, WNil{}}", "whole_word_value"),
        ("word-arithmetic.bend", "prepend(p, False{}, add_carry(p, at, bt, False{}))", "prepend(p, True{}, add_carry(p, at, bt, False{}))", "low_word_agrees"),
        ("exact-arithmetic.bend", "cyclic_sum(ax, by, bx, y, x, ay, d)", "Nat.add(cyclic_sum(ax, by, bx, y, x, ay, d), 1n)", "edge_reversal_left"),
        ("validation.bend", "bounded_valid(sections_bounded(sections), sections)", "True{}", "validator_sound"),
        ("validation.bend", "Nat.is_eq(section_count(sections), 33n) && validate(sections)", "validate(sections)", "artwork_gate_sound"),
        ("topology.bend", "connected && (witnessed && (no_five && (ribbons &&", "True{} && (witnessed && (no_five && (ribbons &&", "topology_report_sound"),
    ]
    # This is the U32 law's postcondition at a fixed payload assignment.
    # Its premise is checked independently before mutation. The full generic
    # mismatch diagnostic currently overflows Bend's printer on this mutant.
    payload = [f"C.from_nat({v}n, 32n)" for v in (2, 3, 1, 2, 3, 1)]
    exact = "S.exact(32n, " + ", ".join(payload) + ")"
    actual = "S.u32_sum3(" + ", ".join("U32{" + p + "}" for p in payload) + ")"
    (directory / "sum3-counter.bend").write_text(
        "import Base\nimport ./word-sum3.bend as S\nimport ./word-conversion.bend as C\nimport ./word-arithmetic.bend as W\n"
        f"def literal_u32_sum3_premise() -> {{Nat.is_lt({exact}, W.capacity(32n)) == True{{}} : Bool}}:\n  {{==}}\n"
        f"def literal_u32_sum3_exact() -> {{U32.to_nat({actual}) == {exact} : Nat}}:\n  {{==}}\n")
    bend(directory, "sum3-counter.bend", "--verdict")
    for file, old, new, law in controls:
        path = directory / file
        original = path.read_text()
        assert original.count(old) == 1, (file, old)
        path.write_text(original.replace(old, new))
        try:
            # A mutant that cannot even compile is not a useful proof control.
            bend(directory, file, "--check-only")
            output = bend(directory, "sum3-counter.bend" if law == "literal_u32_sum3_exact" else "PROOF.bend", success=False)
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


def literal_validator_checks(directory):
    # These are finite executed examples of the production validator, not
    # universal proofs. Large literal geometry must not be unfolded as a
    # kernel goal; the universal structural laws remain in PROOF.bend.
    executable = directory / "validator-tests"
    build = subprocess.run(["bend", "validation-tests.bend", "-o", str(executable)],
                           cwd=directory, capture_output=True, text=True, timeout=5)
    assert build.returncode == 0, build.stdout + build.stderr
    result = subprocess.run([str(executable)], cwd=directory,
                            capture_output=True, text=True, timeout=5)
    assert result.returncode == 0 and "validator-tests: True" in result.stdout, result.stdout + result.stderr
    return 7


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
        print("BendTT: all 67 public laws accepted")
        bend(directory, "word-sum4-tests.bend", "--verdict")
        print("Composed four-product word sum fixtures accepted")
        bend(directory, "coordinate-dot-pair-tests.bend", "--verdict")
        print("Guarded production dot-pair sum fixtures accepted")
        bend(directory, "coordinate-sum4-tests.bend", "--verdict")
        print("Coordinate guards imply the four-product U32 bound")
        bend(directory, "coordinate-dot-tests.bend", "--verdict")
        print("Guarded production dot-product fixtures accepted")
        bend(directory, "coordinate-runtime-tests.bend", "--verdict")
        print("Guarded production U32 sum and determinant fixtures accepted")
        bend(directory, "coordinate-sum-tests.bend", "--verdict")
        print("Coordinate guard implies the 32-bit three-product bound")
        bend(directory, "word-sum3-tests.bend", "--verdict")
        print("Composed three-product sum and overflow-boundary fixtures accepted")
        bend(directory, "word-division4-tests.bend", "--verdict")
        print("Actual division-by-four, quotient and remainder fixtures accepted")
        bend(directory, "word-subtraction-tests.bend", "--verdict")
        print("Ordered subtraction, borrow and wrapping-boundary fixtures accepted")
        bend(directory, "word-comparison-tests.bend", "--verdict")
        print("Comparison and complement fixtures accepted")
        bend(directory, "word-multiplication-tests.bend", "--verdict")
        print("Actual shift-and-add loop and U32 arithmetic fixtures accepted")
        bend(directory, "word-shift-tests.bend", "--verdict")
        print("Shift, retained-bit and word-range fixtures accepted")
        bend(directory, "word-conversion-tests.bend", "--verdict")
        print("Generic and actual U32 conversion fixtures accepted")
        bend(directory, "word-bounds-tests.bend", "--verdict")
        print("Word capacity and strict-bound fixtures accepted")
        bend(directory, "word-tests.bend", "--verdict")
        print("Word carry and exact-value fixtures accepted")
        bend(directory, "arithmetic-tests.bend", "--verdict")
        print("Four exact orientation fixtures accepted")
        print(f"Concrete validator boundary checks accepted: {literal_validator_checks(directory)}")
        result = subprocess.run(["bend", "topology-tests.bend"], cwd=directory, capture_output=True, text=True, timeout=5)
        assert result.returncode == 0 and "topology-tests: True" in result.stdout, result.stdout + result.stderr
        print("Bend topology fixtures accepted")
        print(f"Literal arithmetic checks: {literal_checks(directory)} accepted")
        print(f"Compiling mutations rejected by the proof gate: {negative_controls(directory)}")
        print("Note: selector/remainder/product mutants fail in shared carry_step/bit_division_step/sum3_finish/sum_width_bound/width_bound/finish lemmas")
        print("Note: U32 wrapper mutant uses a literal law instance with its premise checked; generic error printing overflows")
        print(f"Invalid artworks rejected by Bend before SVG emission: {bend_artwork_negative_controls(directory)}")
    root = ET.parse(HERE / "b.svg").getroot()
    print("Independent exact SVG geometry:", verify(root))
    print("Independent exact fill topology:", verify_topology(root))
    topology_reference_controls()
    svg_negative_controls(root)
    print("Broken SVG endpoint/control/transform negative controls rejected")
