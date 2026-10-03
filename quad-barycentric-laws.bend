import Base
import ./quad-barycentric.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-hull.bend as H
import ./triangle-coordinate.bend as C
import ./halfplane-region.bend as Region
import ./topology.bend as T
import ./sample-arithmetic.bend as S
import ./search-witness.bend as Search

# The unused fourth corner has zero weight; no geometry premise is required.
law abc_point_reconstruction:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for d: N.Point
  for +p: G.Point
  {M.point(N.Q{a, b, c, d}, M.abc(a, b, c, p)) == C.reconstruct(a, b, c, p) : G.Point}
# The unused second corner has zero weight, preserving A,C,D order.
law acd_point_reconstruction:
  for +a: N.Point
  for b: N.Point
  for +c: N.Point
  for +d: N.Point
  for +p: G.Point
  {M.point(N.Q{a, b, c, d}, M.acd(a, c, d, p)) == C.reconstruct(a, c, d, p) : G.Point}
# The actual selector yields nonzero weights representing the same valid point.
law selected_weights_valid:
  for +q: N.Quad
  for +p: G.Point
  for +hq: {Q.strict_quad(q) == True{} : Bool}
  for +hp: {G.positive_denominator(p) == True{} : Bool}
  for h: {Region.contains(p, q) == True{} : Bool}
  {Nat.is_gt(M.total(M.selected(q, p)), 0n) == True{} : Bool} & {G.equivalent(p, M.point(q, M.selected(q, p))) == True{} : Bool}
# Membership is an explicit four-weight witness, not a renamed inside predicate.
law region_point_in_hull:
  for +q: N.Quad
  for +p: G.Point
  for +hq: {Q.strict_quad(q) == True{} : Bool}
  for +hp: {G.positive_denominator(p) == True{} : Bool}
  for h: {Region.contains(p, q) == True{} : Bool}
  H.InHull(q, p)
# Both directions, with strict corner orientation and a valid rational domain.
law region_hull_characterization:
  for +q: N.Quad
  for +p: G.Point
  for +hq: {Q.strict_quad(q) == True{} : Bool}
  for +hp: {G.positive_denominator(p) == True{} : Bool}
  ({Region.contains(p, q) == True{} : Bool} -> H.InHull(q, p)) & (H.InHull(q, p) -> {Region.contains(p, q) == True{} : Bool})
# Bounded native inside/convexity judgments feed the same geometric witness.
# The arithmetic envelope alone does not imply a positive denominator.
law production_region_point_in_hull:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +w: T.Witness
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for henv: {S.envelope(width, w) == True{} : Bool}
  for hstrict: {T.strictly_convex(q) == True{} : Bool}
  for +hp: {G.positive_denominator(Region.decode_witness(w)) == True{} : Bool}
  for h: {T.inside(w, q) == True{} : Bool}
  H.InHull(N.decode_quad(q), Region.decode_witness(w))

# A shared half-plane witness becomes a shared point of all three convex hulls.
law common_region_in_hulls:
  for +a: N.Quad
  for +b: N.Quad
  for +c: N.Quad
  for ha: {Q.strict_quad(a) == True{} : Bool}
  for hb: {Q.strict_quad(b) == True{} : Bool}
  for hc: {Q.strict_quad(c) == True{} : Bool}
  for common: Region.CommonPoint(a, b, c)
  M.CommonHull(a, b, c)
# Soundness of an accepted native triple search, with explicit convexity.
# This does not assert that the finite search finds every common point.
law production_triangle_hull_witness:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for hsa: {T.strictly_convex(a) == True{} : Bool}
  for hsb: {T.strictly_convex(b) == True{} : Bool}
  for hsc: {T.strictly_convex(c) == True{} : Bool}
  for accepted: {T.triangle_witness(a, b, c) == True{} : Bool}
  M.CommonHull(N.decode_quad(a), N.decode_quad(b), N.decode_quad(c))
