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
from proof_scope import proof_scope
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


def literal_transverse_checks(directory):
    executable = directory / "transverse-tests"
    build = subprocess.run(["bend", "coordinate-transverse-tests.bend", "-o", str(executable)],
                           cwd=directory, capture_output=True, text=True, timeout=5)
    assert build.returncode == 0, build.stdout + build.stderr
    result = subprocess.run([str(executable)], cwd=directory,
                            capture_output=True, text=True, timeout=5)
    assert result.returncode == 0 and "transverse-tests: True" in result.stdout, result.stdout + result.stderr
    return 3


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
        ("cell-transverse.bend", "C.boundary_right(C.cell_start(cell))", "C.boundary_right(C.cell_finish(cell))", "source_corners_transverse_exact"),
        ("cell-transverse.bend", "M.center(cell)", "C.boundary_left(C.cell_finish(cell))", "source_corners_transverse_exact"),
        ("side-bridge.bend", "case (x, (y, d)): points(a, b, x, y, d)", "case (x, (y, d)): points(a, b, y, x, d)", "accepted_side_exact"),
        ("side-bridge.bend", "A.exact_side(U32.to_nat(ax), U32.to_nat(ay), U32.to_nat(bx), U32.to_nat(by), x, y, d)", "A.exact_side(U32.to_nat(bx), U32.to_nat(by), U32.to_nat(ax), U32.to_nat(ay), x, y, d)", "accepted_side_exact"),
        ("topology.bend", "case P{x, y}: W{x, y, 1}", "case P{x, y}: W{x, y, 0}", "vertex_witness_exact"),
        ("sample-arithmetic.bend", "Nat.sub(64n, n)", "Nat.add(64n, n)", "numerator_limit"),
        ("sample-arithmetic.bend", "Word.sub(bits, sixty_four, n)", "Word.add(bits, sixty_four, n)", "sample_finish"),
        ("topology.bend", "+m = U32.sub(64, n)", "+m = U32.add(64, n)", "guarded_sample_exact"),
        ("topology.bend", "W{(x * m + u * n : U32), (y * m + v * n : U32), 64}", "W{(x * m + u * n : U32), (y * m + v * n : U32), 63}", "guarded_sample_exact"),
        ("topology.bend", "Nat.is_eq(Nat.mod(x, 4n), 0n)", "True{}", "accepted_point_unrounded"),
        ("grid-scaling.bend", "Nat.mul(U32.to_nat(x), 4n)", "Nat.mul(U32.to_nat(x), 3n)", "unrounded_point"),
        ("grid-scaling.bend", "Nat.is_le(U32.to_nat(x), W.capacity(width)) && Nat.is_le(U32.to_nat(y), W.capacity(width))", "Nat.is_le(U32.to_nat(x), W.capacity(0n)) && Nat.is_le(U32.to_nat(y), W.capacity(0n))", "scaled_envelope"),
        ("topology.bend", "P{U32.div(U32.from_nat(x), 4), U32.div(U32.from_nat(y), 4)}", "P{U32.div(U32.from_nat(x), 3), U32.div(U32.from_nat(y), 3)}", "topology_scaled_exact"),
        ("homogeneous.bend", "Nat.add(Nat.add(Nat.mul(Nat.mul(a, b), d), Nat.mul(c, y)), Nat.mul(x, e))", "Nat.mul(8n, Nat.add(Nat.add(Nat.mul(Nat.mul(a, b), d), Nat.mul(c, y)), Nat.mul(x, e)))", "homogeneous_sum_bound"),
        ("homogeneous.bend", "S.sum3(n, Word.mul(n, a, b), d, c, y, x, e)", "S.sum3(n, Word.add(n, a, b), d, c, y, x, e)", "word_homogeneous_exact"),
        ("topology.bend", "ax * by * d + bx * y + x * ay", "ax * by + bx * y + x * ay", "guarded_side_exact"),
        ("core.bend", "Pt{Nat.div(x, 4n), Nat.div(y, 4n)}", "Pt{Nat.div(x, 3n), Nat.div(y, 3n)}", "cell_center_model"),
        ("centroid.bend", "Nat.div(sum(a, b, c, d), 4n)", "Nat.div(sum(a, b, c, d), 5n)", "mean_four_exact"),
        ("validation.bend", "point_equal(point_four(Core.cell_center(cell)), Core.point_add(Core.point_add(Core.boundary_left(a), Core.boundary_right(a)), Core.point_add(Core.boundary_left(b), Core.boundary_right(b))))", "True{}", "validated_centroid_mean"),
        ("word-squares.bend", "Word.mul(n, b, b)", "Word.add(n, b, b)", "bounded_squares_exact"),
        ("validation.bend", "(dx * dx + dy * dy : U32)", "(dx * dx + dx * dy : U32)", "guarded_width_exact"),
        ("validation.bend", "U32.sub(U32.max(a, b), U32.min(a, b))", "U32.sub(U32.min(a, b), U32.max(a, b))", "u32_absolute_exact"),
        ("absolute-difference.bend", "Bool.pick(Nat, less, Nat.sub(b, a), Nat.sub(a, b))", "Bool.pick(Nat, less, Nat.sub(a, b), Nat.sub(b, a))", "choice_value"),
        ("validation.bend", "U32.is_gt((dot(right, right) + dot(control, left) : U32), (dot(right, left) + dot(control, right) : U32))", "U32.is_le((dot(right, right) + dot(control, left) : U32), (dot(right, left) + dot(control, right) : U32))", "guarded_transverse_exact"),
        ("coordinate-transverse.bend", "Nat.is_gt(S.exact(cx, rx, cy, ry, lx, lx, ly, ly), S.exact(cx, lx, cy, ly, lx, rx, ly, ry))", "Nat.is_le(S.exact(cx, rx, cy, ry, lx, lx, ly, ly), S.exact(cx, lx, cy, ly, lx, rx, ly, ry))", "transverse_finish"),
        ("validation.bend", "U32.is_gt((dot(control, right) + dot(left, left) : U32), (dot(control, left) + dot(left, right) : U32))", "U32.is_le((dot(control, right) + dot(left, left) : U32), (dot(control, left) + dot(left, right) : U32))", "guarded_transverse_exact"),
        ("word-sum4.bend", "Word.mul(n, g, h)", "Word.add(n, g, h)", "finish"),
        ("coordinate-sum4.bend", "Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.add(Nat.mul(e, f), Nat.mul(g, h)))", "Nat.mul(8n, Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.add(Nat.mul(e, f), Nat.mul(g, h))))", "width_bound"),
        ("validation.bend", "U32.from_nat(x) * U32.from_nat(z) + U32.from_nat(y) * U32.from_nat(w)", "U32.from_nat(x) * U32.from_nat(w) + U32.from_nat(y) * U32.from_nat(z)", "guarded_dot_exact"),
        ("validation.bend", "Nat.is_le(x, Limit.maximum()) && Nat.is_le(y, Limit.maximum())", "True{}", "accepted_points_determinant"),
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
            if law == "literal_u32_sum3_exact":
                proof_root = "sum3-counter.bend"
            elif law == "source_corners_transverse_exact":
                proof_root = "CELL_TRANSVERSE_PROOF.bend"
            elif law == "accepted_side_exact":
                proof_root = "SIDE_BRIDGE_PROOF.bend"
            elif law in {"numerator_limit", "sample_finish", "guarded_sample_exact", "vertex_witness_exact"}:
                proof_root = "SAMPLE_ARITHMETIC_PROOF.bend"
            elif law in {"accepted_point_unrounded", "unrounded_point", "scaled_envelope"}:
                proof_root = "GRID_SCALING_PROOF.bend"
            elif law == "topology_scaled_exact":
                proof_root = "SCALED_COORDINATE_PROOF.bend"
            elif law in {"homogeneous_sum_bound", "word_homogeneous_exact", "guarded_side_exact"}:
                proof_root = "WITNESS_ARITHMETIC_PROOF.bend"
            elif file in {"word-division4.bend", "word-subtraction.bend", "word-complement.bend"}:
                proof_root = "DIVISION_PROOF.bend"
            elif law in {"cell_center_model", "mean_four_exact", "validated_centroid_mean"}:
                proof_root = "CENTROID_PROOF.bend"
            elif law in {"guarded_width_exact", "accepted_points_width"} or file in {"word-squares.bend", "natural-squares.bend"}:
                proof_root = "WIDTH_PROOF.bend"
            elif law in {"accepted_points_determinant", "guarded_determinant"}:
                proof_root = "DOT_PROOF.bend"
            elif law == "guarded_dot_exact":
                proof_root = "coordinate-dot-proof.bend"
            elif "absolute" in law or file.startswith("absolute-"):
                proof_root = "ABSOLUTE_PROOF.bend"
            elif "transverse" in law:
                proof_root = "TRANSVERSE_PROOF.bend"
            elif file in {"core.bend", "geometry.bend", "topology.bend"} or law in {"validator_sound", "artwork_gate_sound"}:
                proof_root = "PROOF.bend"
            else:
                proof_root = "ARITHMETIC_PROOF.bend"
            try:
                output = bend(directory, proof_root, success=False)
            except AssertionError as error:
                raise AssertionError(f"Mutation {file}: {law} did not produce a proof diagnostic\n{error}") from error
            assert law in output, output
            if law == "accepted_side_exact":
                (directory / "side-counter.bend").write_text(
                    "import Base\nimport ./topology.bend as T\nimport ./grid-scaling.bend as G\n"
                    "import ./sample-arithmetic.bend as S\nimport ./side-bridge.bend as M\n"
                    "def premises() -> {G.envelope(12n, T.P{1, 1}) && G.envelope(12n, T.P{2, 3}) && S.envelope(12n, T.W{1, 0, 1}) == True{} : Bool}:\n  {==}\n"
                    "def actual() -> {T.side(T.P{1, 1}, T.P{2, 3}, T.W{1, 0, 1}) == LT{} : Cmp}:\n  {==}\n"
                    "def wrong_model() -> {M.exact(T.P{1, 1}, T.P{2, 3}, T.W{1, 0, 1}) == GT{} : Cmp}:\n  {==}\n")
                bend(directory, "side-counter.bend", "--verdict")
            if law == "numerator_limit":
                (directory / "sample-counter.bend").write_text(
                    "import Base\nimport ./sample-arithmetic.bend as M\nimport ./word-arithmetic.bend as W\n"
                    "def premises() -> {Nat.is_le(1n, W.capacity(0n)) && Nat.is_le(64n, 64n) == True{} : Bool}:\n  {==}\n"
                    "def broken_bound() -> {Nat.is_le(M.numerator(1n, 1n, 64n), W.capacity(6n)) == False{} : Bool}:\n  {==}\n")
                bend(directory, "sample-counter.bend", "--verdict")
            if law == "guarded_sample_exact":
                expression = ("Nat.is_eq(x_coordinate(T.sample(T.P{1, 2}, T.P{3, 4}, 32)), M.numerator(1n, 3n, 32n))"
                              if old == "+m = U32.sub(64, n)" else
                              "Nat.is_eq(denominator(T.sample(T.P{1, 2}, T.P{3, 4}, 32)), 64n)")
                (directory / "sample-production-counter.bend").write_text(
                    "import Base\nimport ./sample-arithmetic.bend as M\nimport ./grid-scaling.bend as G\nimport ./topology.bend as T\n"
                    "def x_coordinate(w: T.Witness) -> Nat:\n  match w:\n    case T.W{x, y, d}: U32.to_nat(x)\n"
                    "def denominator(w: T.Witness) -> Nat:\n  match w:\n    case T.W{x, y, d}: U32.to_nat(d)\n"
                    "def premises() -> {G.envelope(12n, T.P{1, 2}) && G.envelope(12n, T.P{3, 4}) && U32.is_le(32, 64) == True{} : Bool}:\n  {==}\n"
                    f"def wrong_value() -> {{{expression} == False{{}} : Bool}}:\n  {{==}}\n")
                bend(directory, "sample-production-counter.bend", "--verdict")
            if law == "accepted_point_unrounded":
                (directory / "grid-counter.bend").write_text(
                    "import Base\nimport ./topology.bend as T\nimport ./core.bend as C\n"
                    "import ./grid-scaling.bend as G\nimport ./validation.bend as V\n"
                    "def admitted() -> {T.point_guard(C.Pt{3n, 0n}) == True{} : Bool}:\n  {==}\n"
                    "def loses_coordinate() -> {V.point_equal(G.restore(T.scaled(C.Pt{3n, 0n})), C.Pt{3n, 0n}) == False{} : Bool}:\n  {==}\n")
                bend(directory, "grid-counter.bend", "--verdict")
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
        proof_roots, law_count = proof_scope(directory)
        for proof_root in proof_roots:
            bend(directory, proof_root, "--verdict")
        print(f"BendTT: all {law_count} unique public laws accepted across {len(proof_roots)} proof roots")
        executable = directory / "cell-transverse-tests"
        build = subprocess.run(["bend", "cell-transverse-tests.bend", "-o", str(executable)], cwd=directory, capture_output=True, text=True, timeout=5)
        assert build.returncode == 0, build.stdout + build.stderr
        result = subprocess.run([str(executable)], cwd=directory, capture_output=True, text=True, timeout=5)
        assert result.returncode == 0 and "cell-transverse-tests: True" in result.stdout, result.stdout + result.stderr
        print("Source-corner transverse fixtures accepted: forward, reversal, degenerate and envelope boundary")
        bend(directory, "side-bridge-tests.bend", "--verdict")
        print("Generated-witness side comparison fixtures accepted")
        bend(directory, "sample-arithmetic-tests.bend", "--verdict")
        print("Production sampled-witness endpoints, interior points and envelopes accepted")
        bend(directory, "grid-scaling-tests.bend", "--verdict")
        print("Production grid filter, exact round-trip and envelope fixtures accepted")
        bend(directory, "scaled-coordinate-tests.bend", "--verdict")
        print("Production scaled coordinate exactness and envelope fixtures accepted")
        bend(directory, "witness-arithmetic-tests.bend", "--verdict")
        print("Production homogeneous side fixtures accepted: denominators 1/64, positive/zero/negative")
        bend(directory, "centroid-tests.bend", "--verdict")
        print("Centroid exactness, bounds and rounding-rejection fixtures accepted")
        bend(directory, "word-squares-tests.bend", "--verdict")
        print("Bounded squared-sum fixtures accepted")
        bend(directory, "coordinate-width-tests.bend", "--verdict")
        print("Guarded production squared-width fixtures accepted")
        bend(directory, "absolute-difference-tests.bend", "--verdict")
        print("Absolute difference, symmetry and coordinate-bound fixtures accepted")
        print(f"Concrete transverse checks accepted: {literal_transverse_checks(directory)}")
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
