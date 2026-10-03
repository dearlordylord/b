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
