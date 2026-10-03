import Base
import ./quad-barycentric.bend as M
import ./quad-barycentric-laws.bend as L
import ./quad-barycentric-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-hull.bend as H
import ./quad-hull-laws.bend as HL
import ./halfplane-region.bend as Region
import ./topology.bend as T
import ./sample-arithmetic.bend as S

def square() -> N.Quad:
  N.Q{N.P{1n, 1n}, N.P{5n, 1n}, N.P{5n, 5n}, N.P{1n, 5n}}
def skew() -> N.Quad:
  N.Q{N.P{1n, 1n}, N.P{6n, 1n}, N.P{5n, 4n}, N.P{1n, 5n}}
def abc_weights() -> {M.selected(square(), G.P{4n, 2n, 1n}) == M.W{4n, 8n, 4n, 0n} : M.Weights}:
  {==}
def acd_weights() -> {M.selected(square(), G.P{2n, 4n, 1n}) == M.W{4n, 0n, 4n, 8n} : M.Weights}:
  {==}
def abc_point() -> {M.point(square(), M.selected(square(), G.P{4n, 2n, 1n})) == G.P{64n, 32n, 16n} : G.Point}:
  {==}
def acd_point() -> {M.point(square(), M.selected(square(), G.P{2n, 4n, 1n})) == G.P{32n, 64n, 16n} : G.Point}:
  {==}
def diagonal_closed_choice() -> {M.selected(square(), G.P{3n, 3n, 1n}) == M.W{8n, 0n, 8n, 0n} : M.Weights}:
  {==}
def fractional_weights() -> {M.selected(square(), G.P{8n, 4n, 2n}) == M.W{8n, 16n, 8n, 0n} : M.Weights}:
  {==}
def vertex_zero_weights() -> {M.selected(square(), G.P{5n, 1n, 1n}) == M.W{0n, 16n, 0n, 0n} : M.Weights}:
  {==}
def skew_abc_area() -> {M.point(skew(), M.selected(skew(), G.P{4n, 2n, 1n})) == G.P{60n, 30n, 15n} : G.Point}:
  {==}
def skew_acd_area() -> {M.point(skew(), M.selected(skew(), G.P{2n, 4n, 1n})) == G.P{32n, 64n, 16n} : G.Point}:
  {==}
def abc_member() -> H.InHull(square(), G.P{4n, 2n, 1n}):
  L.region_point_in_hull(square(), G.P{4n, 2n, 1n}, {==}, {==}, {==})
def acd_member() -> H.InHull(square(), G.P{2n, 4n, 1n}):
  L.region_point_in_hull(square(), G.P{2n, 4n, 1n}, {==}, {==}, {==})
def forward(+q: N.Quad, +p: G.Point, hs: ({Region.contains(p, q) == True{} : Bool} -> H.InHull(q, p)) & (H.InHull(q, p) -> {Region.contains(p, q) == True{} : Bool}), inside: {Region.contains(p, q) == True{} : Bool}) -> H.InHull(q, p):
  match hs:
    case (to_hull, to_region): to_hull(inside)
def backward(+q: N.Quad, +p: G.Point, hs: ({Region.contains(p, q) == True{} : Bool} -> H.InHull(q, p)) & (H.InHull(q, p) -> {Region.contains(p, q) == True{} : Bool}), member: H.InHull(q, p)) -> {Region.contains(p, q) == True{} : Bool}:
  match hs:
    case (to_hull, to_region): to_region(member)
def characterization_forward() -> H.InHull(square(), G.P{8n, 4n, 2n}):
  forward(square(), G.P{8n, 4n, 2n}, L.region_hull_characterization(square(), G.P{8n, 4n, 2n}, {==}, {==}), {==})
def characterization_backward() -> {Region.contains(G.P{4n, 2n, 1n}, square()) == True{} : Bool}:
  backward(square(), G.P{4n, 2n, 1n}, L.region_hull_characterization(square(), G.P{4n, 2n, 1n}, {==}, {==}), abc_member())
def production_member() -> H.InHull(square(), G.P{4n, 2n, 1n}):
  L.production_region_point_in_hull(12n, {==}, T.Q{T.P{1, 1}, T.P{5, 1}, T.P{5, 5}, T.P{1, 5}}, T.W{4, 2, 1}, {==}, {==}, {==}, {==}, {==})
def zero_denominator_domain() -> {S.envelope(12n, T.W{0, 0, 0}) == True{} : Bool} & {G.positive_denominator(G.P{0n, 0n, 0n}) == False{} : Bool}:
  ({==}, {==})
def outside_domain() -> {Region.contains(G.P{6n, 6n, 1n}, square()) == False{} : Bool} & {G.equivalent(G.P{6n, 6n, 1n}, M.point(square(), M.selected(square(), G.P{6n, 6n, 1n}))) == False{} : Bool}:
  ({==}, {==})
def flat_quad_domain() -> {Q.strict_quad(N.Q{N.P{1n, 1n}, N.P{2n, 1n}, N.P{3n, 1n}, N.P{4n, 1n}}) == False{} : Bool} & {M.total(M.selected(N.Q{N.P{1n, 1n}, N.P{2n, 1n}, N.P{3n, 1n}, N.P{4n, 1n}}, G.P{2n, 1n, 1n})) == 0n : Nat}:
  ({==}, {==})

def shifted_x() -> N.Quad:
  N.Q{N.P{2n, 1n}, N.P{6n, 1n}, N.P{6n, 5n}, N.P{2n, 5n}}
def shifted_y() -> N.Quad:
  N.Q{N.P{1n, 2n}, N.P{5n, 2n}, N.P{5n, 6n}, N.P{1n, 6n}}
def common_hull_member() -> M.CommonHull(square(), shifted_x(), shifted_y()):
  L.common_region_in_hulls(square(), shifted_x(), shifted_y(), {==}, {==}, {==}, (G.P{4n, 3n, 1n}, ({==}, {==})))
def native_triple_hull_member() -> M.CommonHull(square(), shifted_x(), shifted_y()):
  L.production_triangle_hull_witness(12n, {==}, T.Q{T.P{1, 1}, T.P{5, 1}, T.P{5, 5}, T.P{1, 5}}, T.Q{T.P{2, 1}, T.P{6, 1}, T.P{6, 5}, T.P{2, 5}}, T.Q{T.P{1, 2}, T.P{5, 2}, T.P{5, 6}, T.P{1, 6}}, {==}, {==}, {==}, {==}, {==}, {==}, {==})
