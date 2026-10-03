import Base
import ./quad-intersection.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-hull.bend as H
import ./halfplane-region.bend as Region
import ./topology.bend as T
import ./sat-arithmetic.bend as Sat
import ./search-witness.bend as Search

# Both native-coordinate references compose exactly the geometric side tests.
law outside_decoded:
  for +q: T.Quad
  for +r: T.Quad
  {Sat.outside(q, r) == M.outside(N.decode_quad(q), N.decode_quad(r)) : Bool}
law meets_decoded:
  for +q: T.Quad
  for +r: T.Quad
  {Sat.meets(q, r) == M.meets(N.decode_quad(q), N.decode_quad(r)) : Bool}
# Input order cannot change the unordered pair's intersection decision.
law meets_symmetric:
  for +q: N.Quad
  for +r: N.Quad
  {M.meets(q, r) == M.meets(r, q) : Bool}
# This Boolean composition symmetry holds even outside arithmetic envelopes.
law production_meets_symmetric:
  for +q: T.Quad
  for +r: T.Quad
  {T.meets(q, r) == T.meets(r, q) : Bool}
# A point inside one region and belonging to the other's hull defeats every side.
law hull_region_not_outside:
  for +q: N.Quad
  for +r: N.Quad
  for +p: G.Point
  for h: {Region.contains(p, q) == True{} : Bool}
  for member: H.InHull(r, p)
  {M.outside(q, r) == False{} : Bool}
# A genuine common hull point cannot be rejected by the global SAT predicate.
law common_hull_meets:
  for +q: N.Quad
  for +r: N.Quad
  for hq: {Q.strict_quad(q) == True{} : Bool}
  for hr: {Q.strict_quad(r) == True{} : Bool}
  for common: M.CommonPoint(q, r)
  {M.meets(q, r) == True{} : Bool}
# Contrapositive as an explicit checked impossibility function.
law rejected_meets_excludes:
  for +q: N.Quad
  for +r: N.Quad
  for +hq: {Q.strict_quad(q) == True{} : Bool}
  for +hr: {Q.strict_quad(r) == True{} : Bool}
  for h: {M.meets(q, r) == False{} : Bool}
  M.CommonPoint(q, r) -> Empty
# Honest bounded native arithmetic bridge.
law production_meets_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +r: T.Quad
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for hr: {Search.quad_envelope(width, r) == True{} : Bool}
  {T.meets(q, r) == M.meets(N.decode_quad(q), N.decode_quad(r)) : Bool}
# A native rejection cannot discard a common point under explicit convexity.
law production_common_hull_meets:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +r: T.Quad
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hr: {Search.quad_envelope(width, r) == True{} : Bool}
  for hsq: {T.strictly_convex(q) == True{} : Bool}
  for hsr: {T.strictly_convex(r) == True{} : Bool}
  for common: M.CommonPoint(N.decode_quad(q), N.decode_quad(r))
  {T.meets(q, r) == True{} : Bool}
law production_rejected_meets_excludes:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +r: T.Quad
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hr: {Search.quad_envelope(width, r) == True{} : Bool}
  for +hsq: {T.strictly_convex(q) == True{} : Bool}
  for +hsr: {T.strictly_convex(r) == True{} : Bool}
  for h: {T.meets(q, r) == False{} : Bool}
  M.CommonPoint(N.decode_quad(q), N.decode_quad(r)) -> Empty
