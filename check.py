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


def barycentric_counter(directory, mutation_source):
    """Confirm a false public selector contract with its premises on the core."""
    q = "N.Q{N.P{1n, 1n}, N.P{5n, 1n}, N.P{5n, 5n}, N.P{1n, 5n}}"
    if "H.weight_total" in mutation_source:
        p = "G.P{1n, 5n, 1n}"
        broken = f"Nat.is_gt(M.total(M.selected({q}, {p})), 0n)"
    else:
        p = ("G.P{4n, 2n, 1n}" if "A.area(b, c, p)" in mutation_source or "False{}" in mutation_source
             else "G.P{2n, 4n, 1n}")
        broken = f"G.equivalent({p}, M.point({q}, M.selected({q}, {p})))"
    (directory / "barycentric-counter.bend").write_text(
        "import Base\nimport ./quad-barycentric.bend as M\nimport ./natural-cover.bend as N\n"
        "import ./homogeneous-geometry.bend as G\nimport ./quad-geometry.bend as Q\nimport ./halfplane-region.bend as Region\n"
        f"def premises() -> {{Q.strict_quad({q}) && G.positive_denominator({p}) && Region.contains({p}, {q}) == True{{}} : Bool}}:\n  {{==}}\n"
        f"def broken_public_contract() -> {{{broken} == False{{}} : Bool}}:\n  {{==}}\n")
    bend(directory, "barycentric-counter.bend", "--verdict")


def strict_halfplane_counter(directory, replacement):
    """Falsify unconditional complement/decoder contracts, including contact."""
    imports = ("import Base\nimport ./strict-halfplane.bend as M\nimport ./natural-cover.bend as N\n"
               "import ./homogeneous-geometry.bend as G\nimport ./halfplane-region.bend as Region\n"
               "import ./sat-arithmetic.bend as Sat\nimport ./topology.bend as T\n")
    if "Cmp.is_gt" in replacement:
        boundary = "Bool.not" in replacement
        point = "G.P{3n, 2n, 1n}" if boundary else "G.P{3n, 1n, 1n}"
        value = "True{}" if boundary else "False{}"
        body = (f"def wrong_negative() -> {{M.negative(N.P{{0n, 2n}}, N.P{{6n, 2n}}, {point}) == {value} : Bool}}:\n  {{==}}\n"
                f"def closed_side() -> {{Region.edge(N.P{{0n, 2n}}, N.P{{6n, 2n}}, {point}) == {value} : Bool}}:\n  {{==}}\n")
    else:
        corners = [(1, 0), (4, 0), (4, 1), (1, 1)]
        omitted = (1 if " || " in replacement or "Q.embed(q)" not in replacement
                   else 2 if "Q.embed(r)" not in replacement else 3)
        corners[omitted] = (corners[omitted][0], 3)
        natural = "N.Q{" + ", ".join(f"N.P{{{x}n, {y}n}}" for x, y in corners) + "}"
        native = "T.Q{" + ", ".join(f"T.P{{{x}, {y}}}" for x, y in corners) + "}"
        body = (f"def reference_rejects() -> {{Sat.separated(T.P{{0, 2}}, T.P{{6, 2}}, {native}) == False{{}} : Bool}}:\n  {{==}}\n"
                f"def mutant_admits() -> {{M.separated(N.P{{0n, 2n}}, N.P{{6n, 2n}}, {natural}) == True{{}} : Bool}}:\n  {{==}}\n")
    (directory / "strict-halfplane-counter.bend").write_text(imports + body)
    bend(directory, "strict-halfplane-counter.bend", "--verdict")


def intersection_counter(directory, original, replacement):
    """Expose a false unconditional decoder equation on strictly convex quads."""
    box = [(5, 5), (15, 5), (15, 15), (5, 15)]
    right = [(16, 10), (17, 9), (18, 10), (17, 11)]
    left = [(2, 10), (3, 9), (4, 10), (3, 11)]
    if original.startswith("Bool.not"):
        operation = "meets"
        if replacement == "Bool.not(outside(q, r))":
            q, r, reference, mutant = right, box, "False{}", "True{}"
        elif " && " in replacement:
            q, r, reference, mutant = box, right, "False{}", "True{}"
        else:
            q, r, reference, mutant = box, box, "True{}", "False{}"
    else:
        operation = "outside"
        q, r = box, (left if "S.separated(d, a, r)" not in replacement and "N.Q{" not in replacement else right)
        reference, mutant = "True{}", "False{}"
    natural = lambda points: "N.Q{" + ", ".join(f"N.P{{{x}n, {y}n}}" for x, y in points) + "}"
    native = lambda points: "T.Q{" + ", ".join(f"T.P{{{x}, {y}}}" for x, y in points) + "}"
    nq, nr, tq, tr = natural(q), natural(r), native(q), native(r)
    (directory / "intersection-counter.bend").write_text(
        "import Base\nimport ./quad-intersection.bend as M\nimport ./natural-cover.bend as N\n"
        "import ./quad-geometry.bend as Q\nimport ./sat-arithmetic.bend as Sat\nimport ./topology.bend as T\n"
        f"def strict_inputs() -> {{Q.strict_quad({nq}) && Q.strict_quad({nr}) == True{{}} : Bool}}:\n  {{==}}\n"
        f"def reference_decision() -> {{Sat.{operation}({tq}, {tr}) == {reference} : Bool}}:\n  {{==}}\n"
        f"def wrong_model_decision() -> {{M.{operation}({nq}, {nr}) == {mutant} : Bool}}:\n  {{==}}\n")
    bend(directory, "intersection-counter.bend", "--verdict")


def segment_cut_counter(directory, original, replacement):
    """Check a false public cut contract while its original premises remain true."""
    a, b = "N.P{0n, 2n}", "N.P{6n, 2n}"
    p, q = "G.P{1n, 4n, 1n}", "G.P{5n, 1n, 1n}"
    if original.startswith("Nat.sub"):
        wrong = f"Nat.is_gt(M.negative_gap({a}, {b}, {q}), 0n)"
    elif original == "negative_gap(a, b, q)":
        p = "G.P{3n, 2n, 1n}"
        wrong = f"Nat.is_gt(Nat.add(M.first_weight({a}, {b}, {q}), M.second_weight({a}, {b}, {p})), 0n)"
    else:
        if replacement.startswith("C.mix"):
            p, q = "G.P{2n, 8n, 2n}", "G.P{15n, 3n, 3n}"
        wrong = f"M.on_line({a}, {b}, M.point({a}, {b}, {p}, {q}))"
    (directory / "segment-cut-counter.bend").write_text(
        "import Base\nimport ./segment-cut.bend as M\nimport ./natural-cover.bend as N\n"
        "import ./homogeneous-geometry.bend as G\nimport ./halfplane-region.bend as Region\nimport ./strict-halfplane.bend as S\n"
        f"def premises() -> {{Region.edge({a}, {b}, {p}) && S.negative({a}, {b}, {q}) && G.positive_denominator({p}) && G.positive_denominator({q}) == True{{}} : Bool}}:\n  {{==}}\n"
        f"def broken_public_contract() -> {{{wrong} == False{{}} : Bool}}:\n  {{==}}\n")
    bend(directory, "segment-cut-counter.bend", "--verdict")


def corner_candidate_counter(directory, original):
    # Refute the public admission equality while strict-q remains true.
    cases = {
        "a": "N.Q{N.P{0n,0n},N.P{1n,0n},N.P{1n,1n},N.P{0n,1n}}",
        "b": "N.Q{N.P{3n,0n},N.P{5n,0n},N.P{5n,1n},N.P{3n,1n}}",
        "c": "N.Q{N.P{3n,3n},N.P{5n,3n},N.P{5n,5n},N.P{3n,5n}}",
        "d": "N.Q{N.P{0n,3n},N.P{1n,3n},N.P{1n,5n},N.P{0n,5n}}",
    }
    corner = next(k for k in cases if f"Q.embed({k})" in original)
    q = "N.Q{N.P{0n,0n},N.P{4n,0n},N.P{4n,4n},N.P{0n,4n}}"
    r = cases[corner]
    (directory / "corner-candidate-counter.bend").write_text(
        "import Base\nimport ./corner-candidate.bend as M\nimport ./natural-cover.bend as N\n"
        "import ./quad-geometry.bend as Q\nimport ./candidate-existence.bend as E\n"
        "import ./intersection-search.bend as S\nimport ./boolean-reflection.bend as B\n"
        f"def box() -> N.Quad:\n  {q}\ndef other() -> N.Quad:\n  {r}\n"
        "def premise() -> {Q.strict_quad(box()) == True{} : Bool}:\n  {==}\n"
        "def candidate_exists() -> {E.any_valid(S.vertices(box()),box(),other()) == True{} : Bool}:\n  {==}\n"
        "def wrong_admission() -> {M.inside_other(box(),other()) == False{} : Bool}:\n  {==}\n"
        "def refutes_public_equality(h:{E.any_valid(S.vertices(box()),box(),other()) == M.inside_other(box(),other()) : Bool}) -> Empty:\n"
        "  B.false_impossible(Equal.sym(Bool,True{},False{},h))\n")
    bend(directory, "corner-candidate-counter.bend", "--verdict")


def clip_weights_counter(directory):
    (directory / "clip-weights-counter.bend").write_text(
        "import Base\nimport ./clip-weights.bend as M\nimport ./homogeneous-geometry.bend as G\n"
        "import ./homogeneous-combination.bend as C\nimport ./boolean-reflection.bend as B\n"
        "def p() -> G.Point: G.P{2n,4n,2n}\ndef q() -> G.Point: G.P{15n,3n,3n}\n"
        "def premises() -> {Nat.is_le(3n,8n) && Nat.is_gt(5n,0n) && Nat.is_gt(2n,0n) && G.positive_denominator(p()) && G.positive_denominator(q()) == True{} : Bool}:\n  {==}\n"
        "def invalid_public_equivalence() -> {G.equivalent(C.join(p(),q(),4n,1n),M.rebase(p(),q(),4n,1n,2n,3n)) == False{} : Bool}:\n  {==}\n"
        "def refutes_public_valid(h:{G.positive_denominator(M.rebase(p(),q(),4n,1n,2n,3n)) == True{} : Bool} & {G.equivalent(C.join(p(),q(),4n,1n),M.rebase(p(),q(),4n,1n,2n,3n)) == True{} : Bool}) -> Empty:\n"
        "  match h:\n    case (positive,equivalent): B.false_impossible(equivalent)\n")
    bend(directory, "clip-weights-counter.bend", "--verdict")


def clip_halfplane_counter(directory, original, replacement):
    p = "G.P{1n,4n,1n}"
    k, l = "1n", "1n"
    constant = replacement == "True{}"
    if constant:
        l = "3n"
    elif original == "Nat.mul(l,Cut.first_weight(a,b,q))":
        p, l = "G.P{3n,2n,1n}", "0n"
    elif original == "Nat.mul(k,Cut.second_weight(a,b,p))":
        k, l = "2n", "4n"
    prelude = (
        "import Base\nimport ./clip-halfplane.bend as M\nimport ./natural-cover.bend as N\n"
        "import ./homogeneous-geometry.bend as G\nimport ./homogeneous-combination.bend as C\n"
        "import ./halfplane-region.bend as Region\nimport ./strict-halfplane.bend as S\n"
        "import ./segment-cut.bend as Cut\nimport ./triangle-coordinate.bend as Scale\n"
        "import ./boolean-reflection.bend as B\n"
        "def a() -> N.Point: N.P{0n,2n}\ndef b() -> N.Point: N.P{6n,2n}\n"
        f"def p() -> G.Point: {p}\ndef q() -> G.Point: G.P{{5n,1n,1n}}\n"
        f"def k() -> Nat: {k}\ndef l() -> Nat: {l}\n"
        "def endpoint_premises() -> {Region.edge(a(),b(),p()) && S.negative(a(),b(),q()) == True{} : Bool}:\n  {==}\n")
    if constant:
        body = (
            "def old_point_outside() -> {Region.edge(a(),b(),C.join(p(),q(),k(),l())) == False{} : Bool}:\n  {==}\n"
            "def wrong_acceptance() -> {M.balance(a(),b(),p(),q(),k(),l()) == True{} : Bool}:\n  {==}\n"
            "def refutes_public_classifier(h:{M.balance(a(),b(),p(),q(),k(),l()) == Region.edge(a(),b(),C.join(p(),q(),k(),l())) : Bool}) -> Empty:\n"
            "  B.false_impossible(Equal.sym(Bool,True{},False{},h))\n")
    else:
        prelude += "def original_point_closed() -> {Region.edge(a(),b(),C.join(p(),q(),k(),l())) == True{} : Bool}:\n  {==}\n"
        if original.startswith("W.rebase"):
            body = (
                "def wrong_same_point() -> {G.equivalent(C.join(p(),q(),k(),l()),M.rebased(a(),b(),p(),q(),k(),l())) == False{} : Bool}:\n  {==}\n"
                "def refutes_public_exact(h:{M.rebased(a(),b(),p(),q(),k(),l()) == Scale.scaled(C.join(p(),q(),k(),l()),Cut.second_weight(a(),b(),p())) : G.Point}) -> Empty:\n"
                "  B.false_impossible(Equal.cong(G.Point,Bool,x => G.equivalent(C.join(p(),q(),k(),l()),x),M.rebased(a(),b(),p(),q(),k(),l()),Scale.scaled(C.join(p(),q(),k(),l()),Cut.second_weight(a(),b(),p())),h))\n")
        else:
            body = (
                "def wrong_balance() -> {M.balance(a(),b(),p(),q(),k(),l()) == False{} : Bool}:\n  {==}\n"
                "def refutes_public_classifier(h:{M.balance(a(),b(),p(),q(),k(),l()) == Region.edge(a(),b(),C.join(p(),q(),k(),l())) : Bool}) -> Empty:\n"
                "  B.false_impossible(h)\n")
    (directory / "clip-halfplane-counter.bend").write_text(prelude + body)
    bend(directory, "clip-halfplane-counter.bend", "--verdict")


def segment_provenance_counter(directory, original):
    """Refute the exact public equality at literals; these laws have no premises."""
    if original.startswith("compose(p,q,k,l,m,n,Cut.first"):
        endpoints = "def p() -> G.Point: G.P{0n,3n,1n}\ndef q() -> G.Point: G.P{1n,0n,1n}\n"
        actual = "M.cut_on_source(a(),b(),p(),q(),1n,0n,0n,1n)"
        expected = "Cut.point(a(),b(),C.join(p(),q(),1n,0n),C.join(p(),q(),0n,1n))"
    else:
        endpoints = "def p() -> G.Point: G.P{1n,4n,2n}\ndef q() -> G.Point: G.P{5n,1n,3n}\n"
        actual = "M.compose(p(),q(),2n,1n,1n,3n,2n,1n)"
        expected = "C.join(C.join(p(),q(),2n,1n),C.join(p(),q(),1n,3n),2n,1n)"
    (directory / "segment-provenance-counter.bend").write_text(
        "import Base\nimport ./segment-provenance.bend as M\n"
        "import ./homogeneous-geometry.bend as G\nimport ./homogeneous-combination.bend as C\n"
        "import ./natural-cover.bend as N\nimport ./segment-cut.bend as Cut\n"
        "import ./boolean-reflection.bend as B\n"
        + endpoints +
        "def a() -> N.Point: N.P{0n,1n}\ndef b() -> N.Point: N.P{1n,1n}\n"
        f"def broken_public_equality() -> {{G.equivalent({actual},{expected}) == False{{}} : Bool}}:\n  {{==}}\n"
        f"def refutes_public_equality(h:{{{actual} == {expected} : G.Point}}) -> Empty:\n"
        f"  B.false_impossible(Equal.cong(G.Point,Bool,x => G.equivalent(x,{expected}),{actual},{expected},h))\n")
    bend(directory, "segment-provenance-counter.bend", "--verdict")


def segment_proportional_counter(directory, original):
    """Refute a literal of the exact classifier/reporting public law."""
    if original.startswith("G.equivalent"):
        premise = "def ratio_premise() -> {M.proportional(1n,2n,2n,4n) == True{} : Bool}:\n  {==}\n"
        actual = "M.same_point(p(),q(),1n,2n,2n,4n)"
        expected = "G.equivalent(C.join(p(),q(),1n,2n),C.join(p(),q(),2n,4n))"
        refute = "B.false_impossible(h)"
    else:
        premise = ""
        actual = "M.proportional(1n,2n,2n,3n)"
        expected = "Nat.is_eq(Nat.mul(1n,3n),Nat.mul(2n,2n))"
        refute = "B.false_impossible(Equal.sym(Bool,True{},False{},h))"
    (directory / "segment-proportional-counter.bend").write_text(
        "import Base\nimport ./segment-proportional.bend as M\n"
        "import ./homogeneous-geometry.bend as G\nimport ./homogeneous-combination.bend as C\n"
        "import ./boolean-reflection.bend as B\n"
        "def p() -> G.Point: G.P{0n,1n,1n}\ndef q() -> G.Point: G.P{1n,0n,1n}\n"
        + premise +
        f"def refutes_public_exact(h:{{{actual} == {expected} : Bool}}) -> Empty:\n  {refute}\n")
    bend(directory, "segment-proportional-counter.bend", "--verdict")


def segment_boundary_counter(directory, replacement):
    """Refute the exact boundary law with both endpoint premises checked."""
    constant = replacement == "True{}"
    l = "1n" if constant else "2n"
    refute = "B.false_impossible(Equal.sym(Bool,True{},False{},h))" if constant else "B.false_impossible(h)"
    (directory / "segment-boundary-counter.bend").write_text(
        "import Base\nimport ./segment-boundary.bend as M\n"
        "import ./natural-cover.bend as N\nimport ./homogeneous-geometry.bend as G\n"
        "import ./homogeneous-combination.bend as C\nimport ./segment-cut.bend as Cut\n"
        "import ./halfplane-region.bend as Region\nimport ./strict-halfplane.bend as S\n"
        "import ./boolean-reflection.bend as B\n"
        "def a() -> N.Point: N.P{0n,1n}\ndef b() -> N.Point: N.P{1n,1n}\n"
        "def p() -> G.Point: G.P{0n,3n,1n}\ndef q() -> G.Point: G.P{1n,0n,1n}\n"
        "def premises() -> {Region.edge(a(),b(),p()) && S.negative(a(),b(),q()) == True{} : Bool}:\n  {==}\n"
        f"def wrong_ratio() -> {{M.ratio(a(),b(),p(),q(),1n,{l}) == {'True' if constant else 'False'}{{}} : Bool}}:\n  {{==}}\n"
        f"def boundary_condition() -> {{Cut.on_line(a(),b(),C.join(p(),q(),1n,{l})) == {'False' if constant else 'True'}{{}} : Bool}}:\n  {{==}}\n"
        f"def refutes_public_exact(h:{{M.ratio(a(),b(),p(),q(),1n,{l}) == Cut.on_line(a(),b(),C.join(p(),q(),1n,{l})) : Bool}}) -> Empty:\n  {refute}\n")
    bend(directory, "segment-boundary-counter.bend", "--verdict")


def interval_clip_counter(directory, original, replacement):
    """Refute a literal public table/report law, with retained-point premises where relevant."""
    prelude = (
        "import Base\nimport ./interval-clip.bend as M\nimport ./natural-cover.bend as N\n"
        "import ./homogeneous-geometry.bend as G\nimport ./homogeneous-combination.bend as C\n"
        "import ./segment-cut.bend as Cut\nimport ./halfplane-region.bend as Region\n"
        "import ./boolean-reflection.bend as B\n"
        "def a() -> N.Point: N.P{0n,1n}\ndef b() -> N.Point: N.P{1n,1n}\n"
        "def box() -> N.Quad: N.Q{N.P{0n,0n},N.P{3n,0n},N.P{3n,3n},N.P{0n,3n}}\n"
        "def membership(result:M.ClipResult,-r:G.Point) -> Type:\n  match result:\n    case M.Gone{}: Empty\n    case M.Span{p,q}: Cut.InSegment(p,q,r)\n")
    extra = ""
    if original.startswith("case Gone{}: False"):
        actual, expected = "M.present(M.Gone{})", "False{}"
        proof = "B.false_impossible(Equal.sym(Bool,True{},False{},h))"
        kind = "Bool"
    elif original.startswith("Region.contains"):
        prelude += "def p() -> G.Point: G.P{0n,3n,1n}\ndef q() -> G.Point: G.P{1n,0n,1n}\n"
        actual = "M.in_region(box(),M.Span{p(),q()})"
        expected = "Region.contains(p(),box()) && Region.contains(q(),box())"
        if replacement == "True{}":
            actual = "M.in_region(box(),M.Span{G.P{0n,4n,1n},q()})"
            expected = "Region.contains(G.P{0n,4n,1n},box()) && Region.contains(q(),box())"
            proof = "B.false_impossible(Equal.sym(Bool,True{},False{},h))"
        else:
            proof = "B.false_impossible(h)"
            extra = (
                "def preservation_premises() -> {Region.contains(p(),box()) && Region.contains(q(),box()) == True{} : Bool}:\n  {==}\n"
                "def refutes_region_preservation(h:{M.in_region(box(),M.clip(a(),b(),p(),q())) == True{} : Bool}) -> Empty:\n  B.false_impossible(h)\n")
        kind = "Bool"
    elif original.startswith("(G.positive_denominator"):
        prelude += "def p() -> G.Point: G.P{0n,1n,0n}\ndef q() -> G.Point: G.P{0n,3n,1n}\n"
        actual = "M.closed_valid(a(),b(),M.Span{p(),q()})"
        expected = "(G.positive_denominator(p()) && G.positive_denominator(q())) && (Region.edge(a(),b(),p()) && Region.edge(a(),b(),q()))"
        kind = "Bool"
        proof = "B.false_impossible(Equal.sym(Bool,True{},False{},h))"
    else:
        p, q, cp, cq = "G.P{0n,3n,1n}", "G.P{1n,0n,1n}", "True{}", "False{}"
        expected = "M.Span{p(),Cut.point(a(),b(),p(),q())}"
        reporter = "x => M.closed_valid(a(),b(),x)"
        flipped = False
        if original.startswith("case True{} True"):
            q, cp, cq = "G.P{1n,2n,1n}", "True{}", "True{}"
            expected, reporter = "M.Span{p(),q()}", "x => M.present(x)"
            extra = (
                "def retained_premises() -> {(G.positive_denominator(p()) && G.positive_denominator(q())) && (Nat.is_gt(Nat.add(1n,1n),0n) && Region.edge(a(),b(),C.join(p(),q(),1n,1n))) == True{} : Bool}:\n  {==}\n"
                "def refutes_retained_present(h:{M.present(M.clip(a(),b(),p(),q())) == True{} : Bool}) -> Empty:\n  B.false_impossible(h)\n"
                "def refutes_retained_member(h:membership(M.clip(a(),b(),p(),q()),C.join(p(),q(),1n,1n))) -> Empty:\n  h\n")
        elif original.startswith("case False{} False"):
            p, cp, cq = "G.P{0n,0n,1n}", "False{}", "False{}"
            expected, reporter, flipped = "M.Gone{}", "x => M.present(x)", True
            extra = (
                "def refutes_present_exact(h:{M.present(M.clip(a(),b(),p(),q())) == Region.edge(a(),b(),p()) || Region.edge(a(),b(),q()) : Bool}) -> Empty:\n"
                "  B.false_impossible(Equal.sym(Bool,True{},False{},h))\n")
        elif original.startswith("case False{} True"):
            p, q, cp, cq = "G.P{1n,0n,1n}", "G.P{0n,3n,1n}", "False{}", "True{}"
            expected = "M.Span{q(),Cut.point(a(),b(),q(),p())}"
        prelude += f"def p() -> G.Point: {p}\ndef q() -> G.Point: {q}\n"
        prelude += f"def actual_flags() -> {{Region.edge(a(),b(),p()) == {cp} : Bool}} & {{Region.edge(a(),b(),q()) == {cq} : Bool}}:\n  ({{==}},{{==}})\n"
        if original.startswith("choose("):
            actual = "M.clip(a(),b(),p(),q())"
        else:
            actual = f"M.choose(a(),b(),p(),q(),{cp},{cq})"
        reflected = f"Equal.cong(M.ClipResult,Bool,{reporter},{actual},{expected},h)"
        proof = (f"B.false_impossible(Equal.sym(Bool,True{{}},False{{}},{reflected}))" if flipped
                 else f"B.false_impossible({reflected})")
        kind = "M.ClipResult"
        if original.startswith("case True{} False"):
            extra += (
                "def valid_endpoint_premises() -> {G.positive_denominator(p()) && G.positive_denominator(q()) == True{} : Bool}:\n  {==}\n"
                "def refutes_closed_valid(h:{M.closed_valid(a(),b(),M.clip(a(),b(),p(),q())) == True{} : Bool}) -> Empty:\n  B.false_impossible(h)\n")
            if "G.P{1n,0n,0n}" in replacement:
                extra += (
                    "def preservation_premises() -> {Region.contains(p(),box()) && Region.contains(q(),box()) == True{} : Bool}:\n  {==}\n"
                    "def retained_premises() -> {Nat.is_gt(Nat.add(1n,1n),0n) && Region.edge(a(),b(),C.join(p(),q(),1n,1n)) == True{} : Bool}:\n  {==}\n"
                    "def refutes_region_preservation(h:{M.in_region(box(),M.clip(a(),b(),p(),q())) == True{} : Bool}) -> Empty:\n  B.false_impossible(h)\n"
                    "def refutes_retained_member(member:membership(M.clip(a(),b(),p(),q()),C.join(p(),q(),1n,1n))) -> Empty:\n"
                    "  match member:\n    case (k,(l,(ht,(hp,(hq,(hr,equivalent)))))): B.false_impossible(hq)\n")
    (directory / "interval-clip-counter.bend").write_text(
        prelude + extra + f"def refutes_public_exact(h:{{{actual} == {expected} : {kind}}}) -> Empty:\n  {proof}\n")
    bend(directory, "interval-clip-counter.bend", "--verdict")


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
        ('interval-clip.bend', 'case True{} True{}: Span{p,q}', 'case True{} True{}: Gone{}', 'choose_exact'),
        ('interval-clip.bend', 'case False{} False{}: Gone{}', 'case False{} False{}: Span{p,q}', 'choose_exact'),
        ('interval-clip.bend', 'case True{} False{}: Span{p,Cut.point(a,b,p,q)}', 'case True{} False{}: Span{p,q}', 'choose_exact'),
        ('interval-clip.bend', 'case False{} True{}: Span{q,Cut.point(a,b,q,p)}', 'case False{} True{}: Span{q,Cut.point(a,b,p,q)}', 'choose_exact'),
        ('interval-clip.bend', 'choose(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q))', 'choose(a,b,p,q,Region.edge(a,b,p),True{})', 'clip_exact'),
        ('interval-clip.bend', 'case Gone{}: False{}', 'case Gone{}: True{}', 'present_report_exact'),
        ('interval-clip.bend', '(G.positive_denominator(p) && G.positive_denominator(q)) && (Region.edge(a,b,p) && Region.edge(a,b,q))', 'True{}', 'closed_report_exact'),
        ('interval-clip.bend', '(G.positive_denominator(p) && G.positive_denominator(q)) && (Region.edge(a,b,p) && Region.edge(a,b,q))', 'Region.edge(a,b,p) && Region.edge(a,b,q)', 'closed_report_exact'),
        ('interval-clip.bend', 'Region.contains(p,r) && Region.contains(q,r)', 'True{}', 'region_report_exact'),
        ('interval-clip.bend', 'Region.contains(p,r) && Region.contains(q,r)', 'False{}', 'region_report_exact'),
        ('interval-clip.bend', 'case True{} False{}: Span{p,Cut.point(a,b,p,q)}', 'case True{} False{}: Span{p,G.P{1n,0n,0n}}', 'choose_exact'),
        ('segment-boundary.bend', 'P.proportional(k,l,Cut.first_weight(a,b,q),Cut.second_weight(a,b,p))', 'True{}', 'ratio_on_line_exact'),
        ('segment-boundary.bend', 'P.proportional(k,l,Cut.first_weight(a,b,q),Cut.second_weight(a,b,p))', 'P.proportional(k,l,Cut.second_weight(a,b,p),Cut.first_weight(a,b,q))', 'ratio_on_line_exact'),
        ('segment-boundary.bend', 'Cut.first_weight(a,b,q)', 'Cut.second_weight(a,b,q)', 'ratio_on_line_exact'),
        ('segment-proportional.bend', 'Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v))', 'True{}', 'proportional_exact'),
        ('segment-proportional.bend', 'Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v))', 'Nat.is_le(Nat.mul(k,w),Nat.mul(l,v))', 'proportional_exact'),
        ('segment-proportional.bend', 'G.equivalent(C.join(p,q,k,l),C.join(p,q,v,w))', 'G.equivalent(C.join(p,q,k,l),C.join(p,q,w,v))', 'same_point_exact'),
        ('segment-provenance.bend', 'Nat.add(Nat.mul(k,v),Nat.mul(m,w))', 'Nat.mul(k,v)', 'compose_exact'),
        ('segment-provenance.bend', 'Nat.add(Nat.mul(l,v),Nat.mul(n,w))', 'Nat.mul(l,v)', 'compose_exact'),
        ('segment-provenance.bend', 'compose(p,q,k,l,m,n,Cut.first_weight(a,b,C.join(p,q,m,n)),Cut.second_weight(a,b,C.join(p,q,k,l)))', 'compose(p,q,k,l,m,n,Cut.second_weight(a,b,C.join(p,q,k,l)),Cut.first_weight(a,b,C.join(p,q,m,n)))', 'source_cut_exact'),
        ('clip-halfplane.bend', 'Nat.is_le(Nat.mul(l,Cut.first_weight(a,b,q)),Nat.mul(k,Cut.second_weight(a,b,p)))', 'True{}', 'closed_join_balance_exact'),
        ('clip-halfplane.bend', 'Nat.is_le(Nat.mul(l,Cut.first_weight(a,b,q)),Nat.mul(k,Cut.second_weight(a,b,p)))', 'Nat.is_le(Nat.mul(k,Cut.second_weight(a,b,p)),Nat.mul(l,Cut.first_weight(a,b,q)))', 'closed_join_balance_exact'),
        ('clip-halfplane.bend', 'Nat.mul(l,Cut.first_weight(a,b,q))', 'Nat.add(l,Cut.first_weight(a,b,q))', 'closed_join_balance_exact'),
        ('clip-halfplane.bend', 'Nat.mul(k,Cut.second_weight(a,b,p))', 'Nat.add(k,Cut.second_weight(a,b,p))', 'closed_join_balance_exact'),
        ('clip-halfplane.bend', 'W.rebase(p,q,k,l,Cut.second_weight(a,b,p),Cut.first_weight(a,b,q))', 'W.rebase(p,q,k,l,Cut.first_weight(a,b,q),Cut.second_weight(a,b,p))', 'halfplane_rebase_exact'),
        ('clip-halfplane.bend', 'W.rebase(p,q,k,l,Cut.second_weight(a,b,p),Cut.first_weight(a,b,q))', 'W.rebase(p,q,k,0n,Cut.second_weight(a,b,p),Cut.first_weight(a,b,q))', 'halfplane_rebase_exact'),
        ('clip-weights.bend', 'Nat.sub(Nat.mul(k,w),Nat.mul(l,v))', 'Nat.sub(Nat.mul(l,v),Nat.mul(k,w))', 'retained_reconstruct'),
        ('clip-weights.bend', 'Nat.mul(k,w)', 'Nat.add(k,w)', 'retained_reconstruct'),
        ('clip-weights.bend', 'Nat.mul(l,v)', 'Nat.add(l,v)', 'retained_reconstruct'),
        ('clip-weights.bend', 'C.join(p,q,v,w)', 'C.join(p,q,w,v)', 'rebase_exact'),
        ('clip-weights.bend', 'retained(k,l,w,v),l)', 'retained(k,l,w,v),0n)', 'rebase_exact'),
        ('corner-candidate.bend', 'Region.contains(Q.embed(a),r)', 'False{}', 'corner_admissions'),
        ('corner-candidate.bend', 'Region.contains(Q.embed(b),r)', 'False{}', 'corner_admissions'),
        ('corner-candidate.bend', 'Region.contains(Q.embed(c),r)', 'False{}', 'corner_admissions'),
        ('corner-candidate.bend', 'Region.contains(Q.embed(d),r)', 'False{}', 'corner_admissions'),
        ('corner-candidate.bend', 'Region.contains(Q.embed(a),r) ||', 'Region.contains(Q.embed(a),r) &&', 'corner_admissions'),
        ('candidate-existence.bend', 'S.admit(h,q,r) || any_valid(t,q,r)', 'S.admit(h,q,r) && any_valid(t,q,r)', 'scan_found_exact'),
        ('candidate-existence.bend', 'S.admit(h,q,r) || any_valid(t,q,r)', 'any_valid(t,q,r)', 'scan_found_exact'),
        ('candidate-existence.bend', 'case S.Hit{p}: True{}', 'case S.Hit{p}: False{}', 'choice_found'),
        ('candidate-existence.bend', 'case S.Miss{}: False{}', 'case S.Miss{}: True{}', 'scan_found_exact'),
        ('intersection-search.bend', 'case True{}: Hit{p}', 'case True{}: Miss{}', 'choice_sound'),
        ('intersection-search.bend', 'case False{}: fallback', 'case False{}: Hit{p}', 'choice_sound'),
        ('intersection-search.bend', 'G.positive_denominator(p) && Region.contains(p, q) && Region.contains(p, r)', 'Region.contains(p, q) && Region.contains(p, r)', 'find_hit_common_hull'),
        ('intersection-search.bend', '[Q.embed(a), Q.embed(b), Q.embed(c), Q.embed(d)]', '[Q.embed(a), Q.embed(b), Q.embed(c)]', 'vertices_exact'),
        ('intersection-search.bend', '[E{a, b}, E{b, c}, E{c, d}, E{d, a}]', '[E{a, b}, E{b, c}, E{c, d}]', 'edges_exact'),
        ('intersection-search.bend', 'case False{} True{}: [Cut.point(a, b, q, p)]', 'case False{} True{}: [Cut.point(a, b, p, q)]', 'cut_branch_exact'),
        ('intersection-search.bend', 'List.append(&2, G.Point, edge_cut(line, h), row(line, t))', 'row(line, t)', 'row_exact'),
        ('intersection-search.bend', 'List.append(&2, G.Point, row(h, segments), pairs(t, segments))', 'pairs(t, segments)', 'pairs_exact'),
        ('intersection-search.bend', 'List.append(&2, G.Point, vertices(q), List.append(&2, G.Point, vertices(r), pairs(edges(q), edges(r))))', 'List.append(&2, G.Point, vertices(q), pairs(edges(q), edges(r)))', 'candidates_layout'),
        ('intersection-search.bend', 'scan(candidates(q, r), q, r)', 'Miss{}', 'find_hit_sound'),
        ('segment-cut.bend', 'Nat.sub(A.negative(a, b, p), A.positive(a, b, p))', 'Nat.sub(A.positive(a, b, p), A.negative(a, b, p))', 'negative_gap_positive'),
        ('segment-cut.bend', 'negative_gap(a, b, q)', 'A.area(a, b, q)', 'crossing_total_positive'),
        ('segment-cut.bend', 'C.join(p, q, first_weight(a, b, q), second_weight(a, b, p))', 'C.join(p, q, second_weight(a, b, p), first_weight(a, b, q))', 'cut_crossing_equal'),
        ('segment-cut.bend', 'C.join(p, q, first_weight(a, b, q), second_weight(a, b, p))', 'C.join(p, q, first_weight(a, b, q), 0n)', 'cut_crossing_equal'),
        ('segment-cut.bend', 'Cmp.is_eq(G.side(ax, ay, bx, by, p))', 'Cmp.is_lt(G.side(ax, ay, bx, by, p))', 'cut_on_line_equation'),
        ('segment-cut.bend', 'C.join(p, q, first_weight(a, b, q), second_weight(a, b, p))', 'C.mix(p, q, first_weight(a, b, q), second_weight(a, b, p))', 'cut_crossing_equal'),
    ]
    controls += [
        ('quad-intersection.bend', 'S.separated(a, b, r) || S.separated(b, c, r) || S.separated(c, d, r) || S.separated(d, a, r)', 'S.separated(a, b, r) || S.separated(b, c, r) || S.separated(c, d, r)', 'outside_decoded'),
        ('quad-intersection.bend', 'S.separated(a, b, r) || S.separated(b, c, r) || S.separated(c, d, r) || S.separated(d, a, r)', 'S.separated(a, b, r) || S.separated(c, d, r) || S.separated(d, a, r)', 'outside_decoded'),
        ('quad-intersection.bend', 'S.separated(a, b, r) || S.separated(b, c, r) || S.separated(c, d, r) || S.separated(d, a, r)', 'S.separated(a, b, N.Q{a, b, c, d}) || S.separated(b, c, N.Q{a, b, c, d}) || S.separated(c, d, N.Q{a, b, c, d}) || S.separated(d, a, N.Q{a, b, c, d})', 'outside_decoded'),
        ('quad-intersection.bend', 'Bool.not(outside(q, r) || outside(r, q))', 'Bool.not(outside(q, r))', 'meets_decoded'),
        ('quad-intersection.bend', 'Bool.not(outside(q, r) || outside(r, q))', 'Bool.not(outside(q, r) && outside(r, q))', 'meets_decoded'),
        ('quad-intersection.bend', 'Bool.not(outside(q, r) || outside(r, q))', 'outside(q, r) || outside(r, q)', 'meets_decoded'),
    ]
    controls += [
        ('strict-halfplane.bend', 'Cmp.is_lt(G.side(ax, ay, bx, by, p))', 'Cmp.is_gt(G.side(ax, ay, bx, by, p))', 'negative_closed_complement'),
        ('strict-halfplane.bend', 'Cmp.is_lt(G.side(ax, ay, bx, by, p))', 'Bool.not(Cmp.is_gt(G.side(ax, ay, bx, by, p)))', 'negative_closed_complement'),
        ('strict-halfplane.bend', 'negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(q)) && negative(a, b, Q.embed(r)) && negative(a, b, Q.embed(s))', 'negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(q)) && negative(a, b, Q.embed(r))', 'separated_weighted_quad'),
        ('strict-halfplane.bend', 'negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(q)) && negative(a, b, Q.embed(r)) && negative(a, b, Q.embed(s))', 'negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(r)) && negative(a, b, Q.embed(s))', 'separated_weighted_quad'),
        ('strict-halfplane.bend', 'negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(q)) && negative(a, b, Q.embed(r)) && negative(a, b, Q.embed(s))', 'negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(q)) && negative(a, b, Q.embed(s))', 'separated_weighted_quad'),
        ('strict-halfplane.bend', 'negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(q)) && negative(a, b, Q.embed(r)) && negative(a, b, Q.embed(s))', 'negative(a, b, Q.embed(p)) || negative(a, b, Q.embed(q)) || negative(a, b, Q.embed(r)) || negative(a, b, Q.embed(s))', 'separated_weighted_quad'),
    ]
    controls += [
        ('quad-barycentric.bend', 'W{A.area(b, c, p), A.area(c, a, p), A.area(a, b, p), 0n}', 'W{A.area(b, c, p), A.area(c, a, p), A.area(a, b, p), 1n}', 'bary_abc_fields'),
        ('quad-barycentric.bend', 'W{A.area(c, d, p), 0n, A.area(d, a, p), A.area(a, c, p)}', 'W{A.area(c, d, p), 0n, A.area(a, c, p), A.area(d, a, p)}', 'bary_acd_fields'),
        ('quad-barycentric.bend', 'case N.Q{a, b, c, d} False{}: abc(a, b, c, p)', 'case N.Q{a, b, c, d} False{}: acd(a, c, d, p)', 'bary_selected_abc'),
        ('quad-barycentric.bend', 'case N.Q{a, b, c, d} True{}: acd(a, c, d, p)', 'case N.Q{a, b, c, d} True{}: abc(a, b, c, p)', 'bary_selected_acd'),
        ('quad-barycentric.bend', 'case W{k, l, m, n}: H.weight_total(k, l, m, n)', 'case W{k, l, m, n}: H.weight_total(k, l, m, 0n)', 'bary_acd_valid'),
        ('quad-barycentric.bend', 'case W{k, l, m, n}: H.weighted(q, k, l, m, n)', 'case W{k, l, m, n}: H.weighted(q, k, l, m, 0n)', 'bary_acd_fields'),
    ]
    controls += [
        ('triangle-coordinate.bend', 'def corner_coordinate(p: N.Point, axis: Bool) -> Nat:\n  match p:\n    case N.P{x, y}: Bool.pick(Nat, axis, y, x)', 'def corner_coordinate(p: N.Point, axis: Bool) -> Nat:\n  match p:\n    case N.P{x, y}: Bool.pick(Nat, axis, x, y)', 'coord_x_positive_fields'),
        ('triangle-coordinate.bend', 'Nat.mul(corner_coordinate(c, axis), A.negative(a, b, p))', 'Nat.mul(corner_coordinate(a, axis), A.negative(a, b, p))', 'coord_x_negative_fields'),
        ('triangle-coordinate.bend', 'Nat.mul(corner_coordinate(c, axis), A.area(a, b, p))', 'Nat.mul(corner_coordinate(a, axis), A.area(a, b, p))', 'coord_sum_reconstruct'),
        ('triangle-coordinate.bend', 'G.P{weighted(a, b, c, p, False{}), weighted(a, b, c, p, True{}), A.weights_total(a, b, c, p)}', 'G.P{weighted(a, b, c, p, True{}), weighted(a, b, c, p, False{}), A.weights_total(a, b, c, p)}', 'coord_reconstruct_fields'),
        ('triangle-coordinate.bend', 'G.P{weighted(a, b, c, p, False{}), weighted(a, b, c, p, True{}), A.weights_total(a, b, c, p)}', 'G.P{weighted(a, b, c, p, False{}), weighted(a, b, c, p, True{}), 0n}', 'coord_reconstruct_fields'),
    ]
    controls += [
        ('triangle-area.bend', 'Nat.sub(positive(a, b, p), negative(a, b, p))', 'Nat.sub(negative(a, b, p), positive(a, b, p))', 'area_reconstruct'),
        ('triangle-area.bend', '), area(a, b, p))', '), area(b, a, p))', 'area_sum_reconstruct'),
        ('triangle-area.bend', 'area(a, b, Q.embed(c))', 'area(b, a, Q.embed(c))', 'triangle_area_positive'),
        ('triangle-area.bend', 'Nat.add(Nat.mul(Nat.add(Nat.add(cx, ax), bx), y), Nat.mul(Nat.add(Nat.add(cy, ay), by), x))', 'Nat.mul(Nat.add(Nat.add(cx, ax), bx), y)', 'area_positive_cycle_fields'),
        ('quad-diagonal.bend', 'Region.edge(b, c, p)', 'Region.edge(c, b, p)', 'diagonal_split_choice'),
        ('quad-diagonal.bend', 'case N.Q{a, b, c, d}: Region.edge(a, c, p)', 'case N.Q{a, b, c, d}: Region.edge(c, a, p)', 'diagonal_split_choice'),
        ('quad-diagonal.bend', 'case N.Q{a, b, c, d}: triangle(a, c, d, p)', 'case N.Q{a, b, c, d}: triangle(a, d, c, p)', 'diagonal_split_choice'),
        ('quad-diagonal.bend', 'Q.turn(a, c, d)', 'Q.turn(a, d, c)', 'diagonal_strict_fields'),
        ('quad-hull.bend', 'Q.embed(d), m, n)', 'Q.embed(d), m, 0n)', 'quad_weighted_fields'),
        ('quad-hull.bend', 'm, n), 1n, 1n)', 'm, n), 1n, 0n)', 'quad_weighted_fields'),
        ('quad-hull.bend', 'Q.embed(b), k, l)', 'Q.embed(b), l, k)', 'quad_weighted_fields'),
        ('quad-hull.bend', 'Nat.add(Nat.add(k, l), Nat.add(m, n))', 'Nat.add(Nat.add(k, l), m)', 'denominator_sum'),
        ('quad-hull.bend', 'Nat.is_gt(weight_total(k, l, m, n), 0n)', 'True{}', 'hull_point_inside'),
        ('quad-hull.bend', 'G.positive_denominator(p)', 'True{}', 'hull_point_positive'),
        ('quad-geometry.bend', 'G.P{x, y, 1n}', 'G.P{x, y, 2n}', 'cyclic_fields'),
        ('quad-geometry.bend', '&& turn(d, a, b)', '&& True{}', 'strict_quad_corners_inside'),
        ('quad-geometry.bend', 'Cmp.is_gt(side(a, b, c))', 'Cmp.is_lt(side(a, b, c))', 'edge_turn'),
        ('homogeneous-combination.bend', 'Nat.mul(u, l)', 'Nat.mul(u, k)', 'weighted_fields'),
        ('homogeneous-combination.bend', 'Nat.add(Nat.mul(y, k), Nat.mul(v, l))', 'Nat.mul(y, k)', 'weighted_fields'),
        ('homogeneous-combination.bend', 'Nat.add(Nat.mul(d, k), Nat.mul(e, l))', 'Nat.mul(d, k)', 'weighted_fields'),
        ('homogeneous-combination.bend', 'Nat.mul(l, d))', 'Nat.mul(l, e))', 'mixture_denominator_exact'),
        ('halfplane-region.bend', 'H.P{U32.to_nat(x), U32.to_nat(y), U32.to_nat(d)}', 'H.P{U32.to_nat(y), U32.to_nat(x), U32.to_nat(d)}', 'edge_values'),
        ('halfplane-region.bend', '&& edge(d, a, p)', '&& True{}', 'inside_halfplanes_decoded'),
        ('halfplane-region.bend', '&& contains(p, c)', '&& True{}', 'common_halfplanes_decoded'),
        ('homogeneous-geometry.bend', 'Nat.mul(d, 1n+k)}', 'd}', 'scaled_side'),
        ('homogeneous-geometry.bend', 'Nat.is_gt(d, 0n)', 'True{}', 'denominator_scale'),
        ('homogeneous-geometry.bend', '&& Nat.is_eq(Nat.mul(y, e), Nat.mul(v, d))', '&& True{}', 'equivalent_scaled'),
        ('natural-cover.bend', 'Nat.div(x, 4n), Nat.div(y, 4n)', 'Nat.div(x, 3n), Nat.div(y, 4n)', 'scaled_fields'),
        ('natural-cover.bend', 'scaled(C.boundary_left(b)), scaled(C.boundary_right(b))', 'scaled(C.boundary_right(b)), scaled(C.boundary_left(b))', 'raw_cell_decoded'),
        ('natural-cover.bend', 'Cmp.is_gt(Side.exact_side(ax, ay, bx, by, cx, cy, 1n))', 'Cmp.is_lt(Side.exact_side(ax, ay, bx, by, cx, cy, 1n))', 'orientation_decoded'),
        ('natural-cover.bend', 'Con{orient(sign, raw_cell(previous, h)), cells_walk(t, h, sign)}', 'Con{orient(sign, raw_cell(previous, h)), []}', 'cells_walk_decoded'),
        ('natural-cover.bend', 'def cells_tail(xs: List<&2, C.Section>, +first: C.Section) -> List<&2, Quad>:\n  match xs:\n    case Nil{}: Nil{}', 'def cells_tail(xs: List<&2, C.Section>, +first: C.Section) -> List<&2, Quad>:\n  match xs:\n    case Nil{}: [raw_cell(first, first)]', 'cells_tail_decoded'),
        ('natural-cover.bend', 'def cells(xs: List<&2, C.Section>) -> List<&2, Quad>:\n  match xs:\n    case Nil{}: Nil{}', 'def cells(xs: List<&2, C.Section>) -> List<&2, Quad>:\n  match xs:\n    case Nil{}: [Q{P{0n, 0n}, P{0n, 0n}, P{0n, 0n}, P{0n, 0n}}]', 'cells_decoded'),
        ('source-inspection.bend', 'case True{}: Counts.inspect_cells(T.cells(a), T.cells(b), T.cells(c))', 'case True{}: Counts.inspect_cells(T.cells(a), T.cells(b), [])', 'source_accepted_fields'),
        ('source-inspection.bend', 'case False{}: T.Counts{0n, 0n, 0n, 0n, False{}, False{}, False{}, False{}}', 'case False{}: T.Counts{0n, 0n, 0n, 0n, True{}, False{}, False{}, False{}}', 'source_gate_exact'),
        ('source-inspection.bend', 'T.counts_valid(inspect(a, b, c))', 'False{}', 'source_valid_arithmetic_exact'),
        ('count-arithmetic.bend', 'def fourth(xs: List<&2, T.Quad>) -> T.CliqueCounts:\n  match xs:\n    case Nil{}: T.empty_counts()', 'def fourth(xs: List<&2, T.Quad>) -> T.CliqueCounts:\n  match xs:\n    case Nil{}: T.fourth_step(True{})', 'fourth_arithmetic_exact'),
        ('count-arithmetic.bend', 'T.third_step(Search.triangle_witness(a, b, h), fourth(Cover.neighbors(h, t)))', 'T.third_step(True{}, fourth(Cover.neighbors(h, t)))', 'third_arithmetic_exact'),
        ('count-arithmetic.bend', 'T.CC{1n, 0n, 0n, True{}, True{}}', 'T.CC{0n, 0n, 0n, True{}, True{}}', 'second_arithmetic_exact'),
        ('count-arithmetic.bend', 'T.sum_counts(second(Cover.neighbors(h, t), h), first(t))', 'T.sum_counts(second(Cover.neighbors(h, t), h), T.empty_counts())', 'first_arithmetic_exact'),
        ('count-arithmetic.bend', 'T.assemble(List.length(&2, T.Quad, all), first(all), Cover.connected(a, b, c), Cover.ribbons(a, b, c))', 'T.assemble(0n, first(all), Cover.connected(a, b, c), Cover.ribbons(a, b, c))', 'inspect_cells_arithmetic_exact'),
        ('search-arithmetic.bend', 'S.numerator(U32.to_nat(y), U32.to_nat(v), n), 64n', 'S.numerator(U32.to_nat(y), U32.to_nat(v), n), 63n', 'word_sample_values'),
        ('search-arithmetic.bend', 'inside_coords(x, y, d, a) && inside_coords(x, y, d, b) && inside_coords(x, y, d, c)', 'inside_coords(x, y, d, a) && inside_coords(x, y, d, b) && True{}', 'common_coords_values'),
        ('search-arithmetic.bend', 'case Zero{}: False{}', 'case Zero{}: True{}', 'segment_search_arithmetic_exact'),
        ('search-arithmetic.bend', 'def pair_search(xs: List<&2, T.Point>, +p: T.Point, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:\n  match xs:\n    case Nil{}: False{}', 'def pair_search(xs: List<&2, T.Point>, +p: T.Point, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:\n  match xs:\n    case Nil{}: True{}', 'pair_search_arithmetic_exact'),
        ('search-arithmetic.bend', 'def all_pairs(xs: List<&2, T.Point>, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:\n  match xs:\n    case Nil{}: False{}', 'def all_pairs(xs: List<&2, T.Point>, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:\n  match xs:\n    case Nil{}: True{}', 'all_pairs_arithmetic_exact'),
        ('search-arithmetic.bend', 'def vertex_search(xs: List<&2, T.Point>, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:\n  match xs:\n    case Nil{}: False{}', 'def vertex_search(xs: List<&2, T.Point>, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:\n  match xs:\n    case Nil{}: True{}', 'vertex_search_arithmetic_exact'),
        ('search-arithmetic.bend', 'vertex_search(xs, a, b, c) || all_pairs(xs, a, b, c)', 'vertex_search(xs, a, b, c) && all_pairs(xs, a, b, c)', 'triangle_search_arithmetic_exact'),
        ('search-arithmetic.bend', 'List.append(&2, T.Point, T.vertices(b), T.vertices(c))', 'List.append(&2, T.Point, T.vertices(b), [])', 'triangle_witness_arithmetic_exact'),
        ('cover-arithmetic.bend', 'T.keep(Sat.meets(q, h), h, neighbors(q, t))', 'T.keep(False{}, h, neighbors(q, t))', 'neighbors_arithmetic_exact'),
        ('cover-arithmetic.bend', 'T.connected_edges(overlaps(a, b), overlaps(a, c), overlaps(b, c))', 'T.connected_edges(overlaps(a, b), False{}, overlaps(b, c))', 'connected_arithmetic_exact'),
        ('cover-arithmetic.bend', 'ribbon(a) && ribbon(b) && ribbon(c)', 'ribbon(a) && ribbon(b) && True{}', 'ribbons_arithmetic_exact'),
        ('cover-arithmetic.bend', 'case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}: connected', 'case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}: witnessed', 'assembled_connected'),
        ('cover-arithmetic.bend', 'case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}: ribbons', 'case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}: no_five', 'assembled_ribbons'),
        ('cover-arithmetic.bend', 'Bool.not(Sat.meets(q, h)) && disjoint_all(q, t)', 'True{} && disjoint_all(q, t)', 'disjoint_all_arithmetic_exact'),
        ('cover-arithmetic.bend', 'case Con{h, t}: disjoint_all(q, t)', 'case Con{h, t}: disjoint_all(q, Con{h, t})', 'disjoint_nonadjacent_arithmetic_exact'),
        ('cover-arithmetic.bend', 'Sat.meets(q, h) || overlaps_one(q, t)', 'Sat.meets(q, h) || False{}', 'overlaps_one_arithmetic_exact'),
        ('cover-arithmetic.bend', 'overlaps_one(h, ys) || overlaps(t, ys)', 'False{} || overlaps(t, ys)', 'overlaps_arithmetic_exact'),
        ('cover-arithmetic.bend', 'case Con{h, t}: Edge.shared_edge(q, h)', 'case Con{h, t}: True{}', 'adjacent_arithmetic_exact'),
        ('cover-arithmetic.bend', 'Sat.strictly_convex(h) && adjacent(h, t)', 'True{} && adjacent(h, t)', 'ribbon_walk_arithmetic_exact'),
        ('cover-arithmetic.bend', 'Bool.not(List.is_empty(&2, T.Quad, xs)) && ribbon_walk(xs)', 'True{} && ribbon_walk(xs)', 'ribbon_arithmetic_exact'),
        ('validator-natural.bend', 'Transverse.exact(cell) &&', 'True{} &&', 'bounded_cell_arithmetic_exact'),
        ('validator-natural.bend', 'cell_valid(lower, upper, C.Cell{previous, h}) && cells_valid(t, h, lower, upper)', 'cell_valid(lower, upper, C.Cell{previous, h}) && True{}', 'bounded_cells_arithmetic_exact'),
        ('validator-natural.bend', 'Width.section_width(lower, upper, h) && cells_valid(t, h, lower, upper)', 'True{} && cells_valid(t, h, lower, upper)', 'bounded_nonempty_arithmetic_exact'),
        ('validator-natural.bend', 'case False{}: False{}', 'case False{}: True{}', 'gate_exact'),
        ('validation.bend', 'U32.is_le(3240000, n)', 'U32.is_gt(3240000, n)', 'width_in_range_arithmetic_exact'),
        ('validation.bend', 'U32.is_le(n, 6760000)', 'U32.is_le(n, 6760001)', 'width_in_range_arithmetic_exact'),
        ('validation.bend', 'width_in_range(width_squared(Core.boundary_left(s), Core.boundary_right(s)))', 'width_in_range(width_squared(Core.boundary_left(s), Core.boundary_left(s)))', 'section_width_arithmetic_exact'),
        ('validation.bend', 'determinant_positive(d, a, b)', 'True{}', 'positive_quad_arithmetic_exact'),
        ('validation.bend', 'positive_quad(a, b, c, d) || positive_quad(d, c, b, a)', 'positive_quad(a, b, c, d) || False{}', 'convex_quad_arithmetic_exact'),
        ('validation.bend', 'convex_quad(Core.boundary_left(a), Core.boundary_left(b), Core.boundary_right(b), Core.boundary_right(a))', 'convex_quad(Core.boundary_left(a), Core.boundary_right(b), Core.boundary_left(b), Core.boundary_right(a))', 'cell_convex_arithmetic_exact'),
        ('topology.bend', 'U32.is_eq(x, u) && U32.is_eq(y, v)', 'U32.is_eq(x, u) || U32.is_eq(y, v)', 'point_equal_arithmetic_exact'),
        ('topology.bend', '(point_equal(a, p) && point_equal(b, s))', 'False{}', 'reverse_edge_arithmetic_exact'),
        ('topology.bend', 'reverse_edge(d, a, r)', 'False{}', 'shared_edge_arithmetic_exact'),
        ('topology.bend', 'negative(side(a, b, witness(s)))', 'True{}', 'separated_fields'),
        ('topology.bend', 'separated(d, a, r)', 'False{}', 'outside_bounds'),
        ('topology.bend', 'Bool.not(outside(q, r) || outside(r, q))', 'outside(q, r) || outside(r, q)', 'meets_arithmetic_exact'),
        ('topology.bend', 'positive(side(d, a, witness(b)))', 'True{}', 'strictly_convex_bounds'),
        ('topology.bend', 'case Q{a, b, c, d}: positive(side(a, b, witness(c)))', 'case Q{a, b, c, d}: negative(side(a, b, witness(c)))', 'orientation_fields'),
        ("topology.bend", "def negative(c: Cmp) -> Bool:\n  match c:\n    case LT{}: True{}\n    case EQ{}: False{}\n    case GT{}: False{}", "def negative(c: Cmp) -> Bool:\n  match c:\n    case LT{}: True{}\n    case EQ{}: True{}\n    case GT{}: False{}", "negative_cmp_exact"),
        ("topology.bend", "def positive(c: Cmp) -> Bool:\n  match c:\n    case LT{}: False{}\n    case EQ{}: False{}\n    case GT{}: True{}", "def positive(c: Cmp) -> Bool:\n  match c:\n    case LT{}: False{}\n    case EQ{}: True{}\n    case GT{}: True{}", "positive_cmp_exact"),
        ("topology.bend", "def nonnegative(c: Cmp) -> Bool:\n  match c:\n    case LT{}: False{}\n    case EQ{}: True{}\n    case GT{}: True{}", "def nonnegative(c: Cmp) -> Bool:\n  match c:\n    case LT{}: False{}\n    case EQ{}: False{}\n    case GT{}: True{}", "nonnegative_exact"),
        ("topology.bend", "nonnegative(side(d, a, w))", "True{}", "inside_bounds"),
        ("topology.bend", "inside(w, a) && inside(w, b) && inside(w, c)", "inside(w, a) && inside(w, b) && True{}", "common_arithmetic_exact"),
        ("inside-arithmetic.bend", "Nat.is_gt(U32.to_nat(Search.denominator(w)), 0n)", "Nat.is_gt(0n, U32.to_nat(Search.denominator(w)))", "natural_ready"),
        ("source-cells.bend", "M.quad_envelope(width, h) && envelope(width, t)", "M.quad_envelope(width, h) && List.is_empty(&2, T.Quad, t)", "walk_bound"),
        ("source-cells.bend", "M.quad_envelope(width, h) && envelope(width, t)", "True{} && envelope(width, t)", "walk_bound"),
        ("topology.bend", "keep(meets(q, h), h, neighbors(q, t))", "keep(meets(q, h), q, neighbors(q, t))", "neighbors_envelope"),
        ("topology.bend", "Q{scaled(Core.boundary_left(a)), scaled(Core.boundary_left(b)), scaled(Core.boundary_right(b)), scaled(Core.boundary_right(a))}", "Q{scaled(Core.point_add(Core.boundary_left(a), Core.boundary_left(a))), scaled(Core.boundary_left(b)), scaled(Core.boundary_right(b)), scaled(Core.boundary_right(a))}", "raw_cell_envelope"),
        ("topology.bend", "def reverse(q: Quad) -> Quad:\n  match q:\n    case Q{a, b, c, d}: Q{d, c, b, a}", "def double_point(p: Point) -> Point:\n  match p:\n    case P{+x, y}: P{(x + x : U32), y}\ndef reverse(q: Quad) -> Quad:\n  match q:\n    case Q{a, b, c, d}: Q{double_point(d), c, b, a}", "reversed_fields"),
        ("source-cells.bend", "M.quad_envelope(width, h) && envelope(width, t)", "M.quad_envelope(width, h) && Bool.not(envelope(width, t))", "walk_bound"),
        ("topology.bend", 'def segment_search(fuel: Nat, +p: Point, +q: Point, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match fuel:\n    case Zero{}: False{}', 'def segment_search(fuel: Nat, +p: Point, +q: Point, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match fuel:\n    case Zero{}: True{}', "segment_search_hit"),
        ("topology.bend", 'def pair_search(xs: List<&2, Point>, +p: Point, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match xs:\n    case Nil{}: False{}', 'def pair_search(xs: List<&2, Point>, +p: Point, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match xs:\n    case Nil{}: True{}', "pair_search_hit"),
        ("topology.bend", 'def all_pairs(xs: List<&2, Point>, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match xs:\n    case Nil{}: False{}', 'def all_pairs(xs: List<&2, Point>, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match xs:\n    case Nil{}: True{}', "all_pairs_hit"),
        ("topology.bend", 'def vertex_search(xs: List<&2, Point>, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match xs:\n    case Nil{}: False{}', 'def vertex_search(xs: List<&2, Point>, +a: Quad, +b: Quad, +c: Quad) -> Bool:\n  match xs:\n    case Nil{}: True{}', "vertex_search_hit"),
        ("topology.bend", "vertex_search(points, a, b, c) || all_pairs(points, a, b, c)", "True{}", "triangle_search_ready"),
        ("topology.bend", "triangle_search(List.append(&2, Point, vertices(a), List.append(&2, Point, vertices(b), vertices(c))), a, b, c)", "True{}", "triangle_witness_ready"),
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
            elif file == "interval-clip.bend":
                proof_root = "INTERVAL_CLIP_PROOF.bend"
            elif file == "segment-boundary.bend":
                proof_root = "SEGMENT_BOUNDARY_PROOF.bend"
            elif file == "segment-proportional.bend":
                proof_root = "SEGMENT_PROPORTIONAL_PROOF.bend"
            elif file == "segment-provenance.bend":
                proof_root = "SEGMENT_PROVENANCE_PROOF.bend"
            elif file == "clip-halfplane.bend":
                proof_root = "CLIP_HALFPLANE_PROOF.bend"
            elif file == "clip-weights.bend":
                proof_root = "CLIP_WEIGHTS_PROOF.bend"
            elif file == "corner-candidate.bend":
                proof_root = "CORNER_CANDIDATE_PROOF.bend"
            elif file == "candidate-existence.bend":
                proof_root = "CANDIDATE_EXISTENCE_PROOF.bend"
            elif file == "intersection-search.bend":
                proof_root = "INTERSECTION_SEARCH_PROOF.bend"
            elif file == "segment-cut.bend":
                proof_root = "SEGMENT_CUT_PROOF.bend"
            elif file == "quad-intersection.bend":
                proof_root = "QUAD_INTERSECTION_PROOF.bend"
            elif file == "strict-halfplane.bend":
                proof_root = "STRICT_HALFPLANE_PROOF.bend"
            elif file == "quad-barycentric.bend":
                proof_root = "QUAD_BARYCENTRIC_PROOF.bend"
            elif law in {"coord_x_positive_fields", "coord_x_negative_fields", "coord_sum_reconstruct", "coord_reconstruct_fields"}:
                proof_root = "TRIANGLE_COORDINATE_PROOF.bend"
            elif law in {"area_reconstruct", "area_sum_reconstruct", "triangle_area_positive", "area_positive_cycle_fields"}:
                proof_root = "TRIANGLE_AREA_PROOF.bend"
            elif law in {"diagonal_split_choice", "diagonal_strict_fields"}:
                proof_root = "QUAD_DIAGONAL_PROOF.bend"
            elif law in {"quad_weighted_fields", "denominator_sum", "hull_point_inside", "hull_point_positive"}:
                proof_root = "QUAD_HULL_PROOF.bend"
            elif law in {"cyclic_fields", "strict_quad_corners_inside", "edge_turn"}:
                proof_root = "QUAD_GEOMETRY_PROOF.bend"
            elif law in {"weighted_fields", "mixture_denominator_exact"}:
                proof_root = "HOMOGENEOUS_COMBINATION_PROOF.bend"
            elif law in {"edge_values", "inside_halfplanes_decoded", "common_halfplanes_decoded"}:
                proof_root = "HALFPLANE_REGION_PROOF.bend"
            elif law in {"scaled_side", "denominator_scale", "equivalent_scaled"}:
                proof_root = "HOMOGENEOUS_GEOMETRY_PROOF.bend"
            elif law in {"scaled_fields", "raw_cell_decoded", "orientation_decoded", "cells_walk_decoded", "cells_tail_decoded", "cells_decoded"}:
                proof_root = "NATURAL_COVER_PROOF.bend"
            elif law in {"source_accepted_fields", "source_gate_exact", "source_valid_arithmetic_exact"}:
                proof_root = "SOURCE_INSPECTION_PROOF.bend"
            elif law in {"fourth_arithmetic_exact", "third_arithmetic_exact", "second_arithmetic_exact", "first_arithmetic_exact", "inspect_cells_arithmetic_exact"}:
                proof_root = "COUNT_ARITHMETIC_PROOF.bend"
            elif law in {"word_sample_values", "common_coords_values", "segment_search_arithmetic_exact", "pair_search_arithmetic_exact", "all_pairs_arithmetic_exact", "vertex_search_arithmetic_exact", "triangle_search_arithmetic_exact", "triangle_witness_arithmetic_exact"}:
                proof_root = "SEARCH_ARITHMETIC_PROOF.bend"
            elif law in {"disjoint_all_arithmetic_exact", "disjoint_nonadjacent_arithmetic_exact", "overlaps_one_arithmetic_exact", "overlaps_arithmetic_exact", "adjacent_arithmetic_exact", "ribbon_walk_arithmetic_exact", "ribbon_arithmetic_exact", "neighbors_arithmetic_exact", "connected_arithmetic_exact", "ribbons_arithmetic_exact", "assembled_connected", "assembled_ribbons"}:
                proof_root = "COVER_ARITHMETIC_PROOF.bend"
            elif law in {"bounded_cell_arithmetic_exact", "bounded_cells_arithmetic_exact", "bounded_nonempty_arithmetic_exact", "gate_exact"}:
                proof_root = "VALIDATOR_NATURAL_PROOF.bend"
            elif law in {"width_in_range_arithmetic_exact", "section_width_arithmetic_exact"}:
                proof_root = "WIDTH_RANGE_PROOF.bend"
            elif law in {"positive_quad_arithmetic_exact", "convex_quad_arithmetic_exact", "cell_convex_arithmetic_exact"}:
                proof_root = "SOURCE_CONVEXITY_PROOF.bend"
            elif law in {"point_equal_arithmetic_exact", "reverse_edge_arithmetic_exact", "shared_edge_arithmetic_exact"}:
                proof_root = "EDGE_ARITHMETIC_PROOF.bend"
            elif law in {"negative_cmp_exact", "positive_cmp_exact", "separated_fields", "outside_bounds", "meets_arithmetic_exact", "strictly_convex_bounds", "orientation_fields"}:
                proof_root = "SAT_ARITHMETIC_PROOF.bend"
            elif law in {"nonnegative_exact", "inside_bounds", "common_arithmetic_exact", "natural_ready"}:
                proof_root = "INSIDE_ARITHMETIC_PROOF.bend"
            elif law in {"raw_cell_envelope", "reversed_fields", "walk_bound", "neighbors_envelope"}:
                proof_root = "SOURCE_CELLS_PROOF.bend"
            elif law in {"segment_search_hit", "pair_search_hit", "all_pairs_hit", "vertex_search_hit", "triangle_search_ready", "triangle_witness_ready"}:
                proof_root = "SEARCH_WITNESS_PROOF.bend"
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
            if file == "interval-clip.bend":
                interval_clip_counter(directory, old, new)
            if file == "segment-boundary.bend":
                segment_boundary_counter(directory, new)
            if file == "segment-proportional.bend":
                segment_proportional_counter(directory, old)
            if file == "segment-provenance.bend":
                segment_provenance_counter(directory, old)
            if file == "clip-halfplane.bend":
                clip_halfplane_counter(directory, old, new)
            if file == "clip-weights.bend":
                clip_weights_counter(directory)
            if file == "corner-candidate.bend":
                corner_candidate_counter(directory, old)
            if file == "segment-cut.bend":
                segment_cut_counter(directory, old, new)
            if file == "quad-intersection.bend":
                intersection_counter(directory, old, new)
            if file == "strict-halfplane.bend":
                strict_halfplane_counter(directory, new)
            if file == "quad-barycentric.bend":
                barycentric_counter(directory, old)
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
        bend(directory, "interval-clip-raw-tests.bend", "--verdict")
        bend(directory, "interval-clip-valid-tests.bend", "--verdict")
        bend(directory, "interval-clip-member-tests.bend", "--verdict")
        bend(directory, "interval-clip-boundary-tests.bend", "--verdict")
        print("Interval clipping fixtures accepted: all decisions, validity, region preservation, forward/reverse membership and zero-gap endpoints")
        bend(directory, "segment-boundary-raw-tests.bend", "--verdict")
        bend(directory, "segment-boundary-tests.bend", "--verdict")
        bend(directory, "segment-boundary-witness-tests.bend", "--verdict")
        print("Boundary coefficient fixtures accepted: exact line classification, rejection, direct-cut equivalence, region transport and zero-gap endpoint")
        bend(directory, "segment-proportional-raw-tests.bend", "--verdict")
        bend(directory, "segment-proportional-tests.bend", "--verdict")
        print("Proportional segment fixtures accepted: exact ratio, unequal denominators, zero weights, validity guards and inside/outside membership")
        bend(directory, "segment-provenance-raw-tests.bend", "--verdict")
        bend(directory, "segment-provenance-tests.bend", "--verdict")
        bend(directory, "segment-provenance-cut-tests.bend", "--verdict")
        print("Source-segment provenance fixtures accepted: exact coefficients, unequal denominators, zero weights, actual cuts and validity")
        bend(directory, "clip-halfplane-tests.bend", "--verdict")
        bend(directory, "clip-halfplane-boundary-tests.bend", "--verdict")
        bend(directory, "clip-halfplane-guard-tests.bend", "--verdict")
        print("Geometric one-sided clipping fixtures accepted: derived balance, equality, positive/zero gaps, actual membership and rejected outside/zero-scale cases")
        bend(directory, "clip-weights-tests.bend", "--verdict")
        bend(directory, "clip-weights-guard-tests.bend", "--verdict")
        print("Retained-segment rebase fixtures accepted: unequal denominators, interior/boundary/endpoint membership, saturation and zero-scale rejection")
        bend(directory, "corner-candidate-tests.bend", "--verdict")
        bend(directory, "corner-candidate-b-tests.bend", "--verdict")
        bend(directory, "corner-candidate-c-tests.bend", "--verdict")
        bend(directory, "corner-candidate-d-tests.bend", "--verdict")
        bend(directory, "corner-right-contained-tests.bend", "--verdict")
        bend(directory, "corner-crossing-tests.bend", "--verdict")
        print("Corner completeness fixtures accepted: all four corners, second-quad containment and crossings without contained vertices")
        bend(directory, "candidate-existence-tests.bend", "--verdict")
        print("Candidate existence fixtures accepted: actual witness, empty list, appended hit and invalid denominator")
        bend(directory, "intersection-search-tests.bend", "--verdict")
        print("Exact intersection search fixtures accepted: first hit, denominator validity, exterior skip, reversed cut, disjoint boxes and vertex contact")
        bend(directory, "segment-cut-tests.bend", "--verdict")
        bend(directory, "segment-cut-witness-tests.bend", "--verdict")
        print("Exact segment cut fixtures accepted: unequal gaps, unequal denominators, boundary endpoint, containment and valid membership")
        bend(directory, "quad-intersection-tests.bend", "--verdict")
        bend(directory, "quad-intersection-common-tests.bend", "--verdict")
        bend(directory, "quad-intersection-native-tests.bend", "--verdict")
        bend(directory, "quad-intersection-native-contact-tests.bend", "--verdict")
        print("Global intersection fixtures accepted: one-sided separation, common points, edge/corner contact, native rejection and symmetry")
        bend(directory, "strict-halfplane-tests.bend", "--verdict")
        print("Strict separation fixtures accepted: contact, zero pairs, alternate fractions, hull exclusion and native bridge")
        bend(directory, "quad-barycentric-tests.bend", "--verdict")
        print("Barycentric hull fixtures accepted: both branches, distinct areas, fractions, bidirectional membership and native triple witness")
        bend(directory, "triangle-coordinate-tests.bend", "--verdict")
        print("Exact triangle coordinate reconstruction, fraction validity and guard fixtures accepted")
        bend(directory, "triangle-area-tests.bend", "--verdict")
        print("Triangle area fixtures accepted: interior, vertex, fraction, outside saturation and zero denominator")
        bend(directory, "quad-diagonal-tests.bend", "--verdict")
        print("Quad diagonal fixtures accepted: both branches, closed boundary, fractions and typed splits")
        bend(directory, "quad-hull-tests.bend", "--verdict")
        print("Quad hull fixtures accepted: four weights, zero pairs, positivity and alternate fraction witness")
        bend(directory, "quad-geometry-tests.bend", "--verdict")
        print("Quad geometry fixtures accepted: corners, orientation, missing fourth turn and collinearity")
        bend(directory, "homogeneous-combination-tests.bend", "--verdict")
        print("Homogeneous combination fixtures accepted: unequal denominators, boundary, zero weights and affine mean")
        executable = directory / "search-witness-tests"
        # Match regenerate.sh: keep C emission and native compilation bounded
        # separately, avoiding Bend's default optimizer on this large fixture.
        if sys.platform.startswith("linux"):
            source = directory / "search-witness-tests.c"
            build = subprocess.run(["bend", "search-witness-tests.bend", "-o", str(source)], cwd=directory, capture_output=True, text=True, timeout=5)
            assert build.returncode == 0, build.stdout + build.stderr
            build = subprocess.run(["clang", "-O1", "-pthread", str(source), "-lm", "-o", str(executable)], cwd=directory, capture_output=True, text=True, timeout=5)
        else:
            build = subprocess.run(["bend", "search-witness-tests.bend", "-o", str(executable)], cwd=directory, capture_output=True, text=True, timeout=5)
        assert build.returncode == 0, build.stdout + build.stderr
        result = subprocess.run([str(executable)], cwd=directory, capture_output=True, text=True, timeout=5)
        assert result.returncode == 0 and "search-witness-tests: True" in result.stdout, result.stdout + result.stderr
        print("Native search witness fixtures accepted: empty search, weights 1/63, vertices, pairs, triangles and disjoint cells")
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
