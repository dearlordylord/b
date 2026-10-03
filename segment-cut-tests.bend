import Base
import ./segment-cut.bend as M
import ./segment-cut-laws.bend as L
import ./segment-cut-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S

def a() -> N.Point: N.P{0n, 2n}
def b() -> N.Point: N.P{6n, 2n}
def p() -> G.Point: G.P{1n, 4n, 1n}
def q() -> G.Point: G.P{5n, 1n, 1n}
def box() -> N.Quad: N.Q{N.P{0n, 0n}, N.P{6n, 0n}, N.P{6n, 5n}, N.P{0n, 5n}}
def first_gap() -> {M.first_weight(a(), b(), q()) == 6n : Nat}: {==}
def second_gap() -> {M.second_weight(a(), b(), p()) == 12n : Nat}: {==}
def asymmetric_crossing() -> {M.point(a(), b(), p(), q()) == G.P{66n, 36n, 18n} : G.Point}: {==}
def exact_line() -> {M.on_line(a(), b(), M.point(a(), b(), p(), q())) == True{} : Bool}:
  L.crossing_on_line(a(), b(), p(), q(), {==}, {==})
def valid_denominator() -> {G.positive_denominator(M.point(a(), b(), p(), q())) == True{} : Bool}:
  L.crossing_denominator_positive(a(), b(), p(), q(), {==}, {==}, {==})
def containing_region() -> {Region.contains(M.point(a(), b(), p(), q()), box()) == True{} : Bool}:
  L.crossing_region_preserved(a(), b(), p(), q(), box(), {==}, {==})
def actual_segment_member() -> M.InSegment(p(), q(), M.point(a(), b(), p(), q())):
  L.crossing_in_segment(a(), b(), p(), q(), {==}, {==}, {==})
def unequal_denominator_point() -> {M.point(a(), b(), G.P{2n, 8n, 2n}, G.P{15n, 3n, 3n}) == G.P{396n, 216n, 108n} : G.Point}: {==}
def unequal_denominator_line() -> {M.on_line(a(), b(), M.point(a(), b(), G.P{2n, 8n, 2n}, G.P{15n, 3n, 3n})) == True{} : Bool}:
  L.crossing_on_line(a(), b(), G.P{2n, 8n, 2n}, G.P{15n, 3n, 3n}, {==}, {==})
def boundary_endpoint() -> {M.point(a(), b(), G.P{3n, 2n, 1n}, q()) == G.P{18n, 12n, 6n} : G.Point}: {==}
def boundary_member() -> M.InSegment(G.P{3n, 2n, 1n}, q(), M.point(a(), b(), G.P{3n, 2n, 1n}, q())):
  L.crossing_in_segment(a(), b(), G.P{3n, 2n, 1n}, q(), {==}, {==}, {==})
def reversed_orientation() -> {M.point(b(), a(), q(), p()) == G.P{66n, 36n, 18n} : G.Point}: {==}
def same_side_not_crossing() -> {S.negative(a(), b(), G.P{5n, 3n, 1n}) == False{} : Bool} & {M.on_line(a(), b(), M.point(a(), b(), p(), G.P{5n, 3n, 1n})) == False{} : Bool}:
  ({==}, {==})
def invalid_endpoint_domain() -> {G.positive_denominator(M.point(a(), b(), G.P{0n, 0n, 0n}, q())) == False{} : Bool} & {M.on_line(a(), b(), M.point(a(), b(), G.P{0n, 0n, 0n}, q())) == True{} : Bool}:
  ({==}, {==})
