import Base
import ./quad-intersection.bend as M
import ./quad-intersection-laws.bend as L
import ./quad-intersection-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-hull.bend as H
import ./halfplane-region.bend as Region
import ./quad-barycentric-laws.bend as Bary
import ./topology.bend as T

def box(+x: Nat, +y: Nat, +u: Nat, +v: Nat) -> N.Quad:
  N.Q{N.P{x, y}, N.P{u, y}, N.P{u, v}, N.P{x, v}}
def native_box(+x: U32, +y: U32, +u: U32, +v: U32) -> T.Quad:
  T.Q{T.P{x, y}, T.P{u, y}, T.P{u, v}, T.P{x, v}}
def q() -> N.Quad: box(5n, 5n, 15n, 15n)
def overlap() -> N.Quad: box(10n, 10n, 20n, 20n)
def diamond() -> N.Quad:
  N.Q{N.P{16n, 10n}, N.P{17n, 9n}, N.P{18n, 10n}, N.P{17n, 11n}}
def native_q() -> T.Quad: native_box(5, 5, 15, 15)
def native_diamond() -> T.Quad:
  T.Q{T.P{16, 10}, T.P{17, 9}, T.P{18, 10}, T.P{17, 11}}
def common_at(+q: N.Quad, +r: N.Quad, +p: G.Point, hq: {Q.strict_quad(q) == True{} : Bool}, hr: {Q.strict_quad(r) == True{} : Bool}, +hp: {G.positive_denominator(p) == True{} : Bool}, iq: {Region.contains(p, q) == True{} : Bool}, ir: {Region.contains(p, r) == True{} : Bool}) -> M.CommonPoint(q, r):
  (p, (Bary.region_point_in_hull(q, p, hq, hp, iq), Bary.region_point_in_hull(r, p, hr, hp, ir)))
def only_first_quad_separates() -> {M.outside(q(), diamond()) == True{} : Bool} & {M.outside(diamond(), q()) == False{} : Bool}:
  ({==}, {==})
def only_second_quad_separates() -> {M.outside(diamond(), q()) == False{} : Bool} & {M.outside(q(), diamond()) == True{} : Bool}:
  ({==}, {==})
def decoded_outside() -> {T.outside(native_q(), native_diamond()) == M.outside(q(), diamond()) : Bool}:
  {==}
def decoded_meets() -> {M.meets(q(), diamond()) == False{} : Bool}:
  {==}
def overlap_meets() -> {M.meets(q(), overlap()) == True{} : Bool}:
  L.common_hull_meets(q(), overlap(), {==}, {==}, common_at(q(), overlap(), G.P{12n, 12n, 1n}, {==}, {==}, {==}, {==}, {==}))
def unreduced_fraction_meets() -> {M.meets(q(), overlap()) == True{} : Bool}:
  L.common_hull_meets(q(), overlap(), {==}, {==}, common_at(q(), overlap(), G.P{24n, 24n, 2n}, {==}, {==}, {==}, {==}, {==}))
def edge_contact_meets() -> {M.meets(q(), box(15n, 5n, 25n, 15n)) == True{} : Bool}:
  L.common_hull_meets(q(), box(15n, 5n, 25n, 15n), {==}, {==}, common_at(q(), box(15n, 5n, 25n, 15n), G.P{15n, 10n, 1n}, {==}, {==}, {==}, {==}, {==}))
def corner_contact_meets() -> {M.meets(q(), box(15n, 15n, 25n, 25n)) == True{} : Bool}:
  L.common_hull_meets(q(), box(15n, 15n, 25n, 25n), {==}, {==}, common_at(q(), box(15n, 15n, 25n, 25n), G.P{15n, 15n, 1n}, {==}, {==}, {==}, {==}, {==}))
def reversed_order() -> {M.meets(q(), diamond()) == M.meets(diamond(), q()) : Bool}:
  L.meets_symmetric(q(), diamond())
def native_overlap_meets() -> {T.meets(native_q(), native_box(10, 10, 20, 20)) == True{} : Bool}:
  L.production_common_hull_meets(12n, {==}, native_q(), native_box(10, 10, 20, 20), {==}, {==}, {==}, {==}, common_at(q(), overlap(), G.P{12n, 12n, 1n}, {==}, {==}, {==}, {==}, {==}))
def native_edge_contact_meets() -> {T.meets(native_q(), native_box(15, 5, 25, 15)) == True{} : Bool}:
  L.production_common_hull_meets(12n, {==}, native_q(), native_box(15, 5, 25, 15), {==}, {==}, {==}, {==}, common_at(q(), box(15n, 5n, 25n, 15n), G.P{15n, 10n, 1n}, {==}, {==}, {==}, {==}, {==}))
def native_corner_contact_meets() -> {T.meets(native_q(), native_box(15, 15, 25, 25)) == True{} : Bool}:
  L.production_common_hull_meets(12n, {==}, native_q(), native_box(15, 15, 25, 25), {==}, {==}, {==}, {==}, common_at(q(), box(15n, 15n, 25n, 25n), G.P{15n, 15n, 1n}, {==}, {==}, {==}, {==}, {==}))
def rejection_excludes() -> M.CommonPoint(q(), diamond()) -> Empty:
  L.rejected_meets_excludes(q(), diamond(), {==}, {==}, {==})
def native_rejection_excludes() -> M.CommonPoint(q(), diamond()) -> Empty:
  L.production_rejected_meets_excludes(12n, {==}, native_q(), native_diamond(), {==}, {==}, {==}, {==}, {==})
def native_order_symmetry() -> {T.meets(native_q(), native_diamond()) == T.meets(native_diamond(), native_q()) : Bool}:
  L.production_meets_symmetric(native_q(), native_diamond())
def hull_region_defeats_sides() -> {M.outside(q(), overlap()) == False{} : Bool}:
  L.hull_region_not_outside(q(), overlap(), G.P{12n, 12n, 1n}, {==}, Bary.region_point_in_hull(overlap(), G.P{12n, 12n, 1n}, {==}, {==}, {==}))
def same_quad_meets() -> {M.meets(q(), q()) == True{} : Bool}:
  L.common_hull_meets(q(), q(), {==}, {==}, common_at(q(), q(), G.P{10n, 10n, 1n}, {==}, {==}, {==}, {==}, {==}))
def invalid_projective_origin() -> {Region.contains(G.P{0n, 0n, 0n}, q()) && Region.contains(G.P{0n, 0n, 0n}, diamond()) == True{} : Bool} & {G.positive_denominator(G.P{0n, 0n, 0n}) == False{} : Bool}:
  ({==}, {==})
