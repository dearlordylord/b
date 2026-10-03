import Base
import ./quad-hull.bend as M
import ./natural-cover.bend as N
import ./quad-geometry.bend as Q
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./topology.bend as T
import ./search-witness.bend as Search

# Independent polynomial reference for a four-corner weighted mean.
def coordinate(a: Nat, b: Nat, c: Nat, d: Nat, +k: Nat, +l: Nat, +m: Nat, +n: Nat) -> Nat:
  Nat.add(Nat.add(Nat.mul(a, k), Nat.mul(b, l)), Nat.add(Nat.mul(c, m), Nat.mul(d, n)))
def point(q: N.Quad, +k: Nat, +l: Nat, +m: Nat, +n: Nat) -> G.Point:
  match q:
    case N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}:
      G.P{coordinate(ax, bx, cx, dx, k, l, m, n), coordinate(ay, by, cy, dy, k, l, m, n), M.weight_total(k, l, m, n)}
law weighted_quad_point_exact:
  for +q: N.Quad
  for +k: Nat
  for +l: Nat
  for +m: Nat
  for +n: Nat
  {M.weighted(q, k, l, m, n) == point(q, k, l, m, n) : G.Point}
law weighted_quad_denominator_exact:
  for +q: N.Quad
  for +k: Nat
  for +l: Nat
  for +m: Nat
  for +n: Nat
  {C.denominator(M.weighted(q, k, l, m, n)) == M.weight_total(k, l, m, n) : Nat}
law weighted_quad_positive:
  for +q: N.Quad
  for +k: Nat
  for +l: Nat
  for +m: Nat
  for +n: Nat
  for hw: {Nat.is_gt(M.weight_total(k, l, m, n), 0n) == True{} : Bool}
  {G.positive_denominator(M.weighted(q, k, l, m, n)) == True{} : Bool}
law weighted_quad_inside:
  for +q: N.Quad
  for +k: Nat
  for +l: Nat
  for +m: Nat
  for +n: Nat
  for h: {Q.corners_inside(q) == True{} : Bool}
  {Region.contains(M.weighted(q, k, l, m, n), q) == True{} : Bool}
law hull_point_inside:
  for +q: N.Quad
  for +p: G.Point
  for h: {Q.corners_inside(q) == True{} : Bool}
  for member: M.InHull(q, p)
  {Region.contains(p, q) == True{} : Bool}
law production_hull_point_inside:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +p: G.Point
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for h: {T.strictly_convex(q) == True{} : Bool}
  for member: M.InHull(N.decode_quad(q), p)
  {Region.contains(p, N.decode_quad(q)) == True{} : Bool}
law hull_point_positive:
  for +q: N.Quad
  for +p: G.Point
  for member: M.InHull(q, p)
  {G.positive_denominator(p) == True{} : Bool}
