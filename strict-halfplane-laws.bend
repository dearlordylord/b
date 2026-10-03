import Base
import ./strict-halfplane.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./quad-hull.bend as Hull
import ./halfplane-region.bend as Region
import ./topology.bend as T
import ./sat-arithmetic.bend as Sat
import ./grid-scaling.bend as Grid
import ./search-witness.bend as Search

# Strict negativity is the exact complement of the closed left half-plane.
law negative_closed_complement:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  {M.negative(a, b, p) == Bool.not(Region.edge(a, b, p)) : Bool}
# A nonzero nonnegative weighted sum of two strictly negative points stays negative.
# No fraction-validity premise is needed for this homogeneous algebraic claim.
law negative_weighted_join:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for +q: G.Point
  for +k: Nat
  for +l: Nat
  for hp: {M.negative(a, b, p) == True{} : Bool}
  for hq: {M.negative(a, b, q) == True{} : Bool}
  for hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}
  {M.negative(a, b, C.join(p, q, k, l)) == True{} : Bool}
# Zero pairs are allowed, but the total four-corner weight must be nonzero.
law separated_weighted_quad:
  for +a: N.Point
  for +b: N.Point
  for +q: N.Quad
  for +k: Nat
  for +l: Nat
  for +m: Nat
  for +n: Nat
  for hs: {M.separated(a, b, q) == True{} : Bool}
  for hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}
  {M.negative(a, b, Hull.weighted(q, k, l, m, n)) == True{} : Bool}
# Actual rational hull membership includes the positive denominator and weight total.
law separated_hull_point:
  for +a: N.Point
  for +b: N.Point
  for +q: N.Quad
  for +p: G.Point
  for hs: {M.separated(a, b, q) == True{} : Bool}
  for member: Hull.InHull(q, p)
  {M.negative(a, b, p) == True{} : Bool}
# A closed-side point cannot belong to a hull strictly separated by that side.
law separated_region_exclusion:
  for +a: N.Point
  for +b: N.Point
  for +q: N.Quad
  for +p: G.Point
  for hs: {M.separated(a, b, q) == True{} : Bool}
  for hp: {Region.edge(a, b, p) == True{} : Bool}
  Hull.InHull(q, p) -> Empty

# The exact native-coordinate reference tests these same four strict sides.
law separated_decoded:
  for +a: T.Point
  for +b: T.Point
  for +q: T.Quad
  {Sat.separated(a, b, q) == M.separated(N.decode_point(a), N.decode_point(b), N.decode_quad(q)) : Bool}
# The production U32 test agrees under its proved arithmetic envelope.
law production_separated_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +q: T.Quad
  for ha: {Grid.envelope(width, a) == True{} : Bool}
  for hb: {Grid.envelope(width, b) == True{} : Bool}
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  {T.separated(a, b, q) == M.separated(N.decode_point(a), N.decode_point(b), N.decode_quad(q)) : Bool}
# A true bounded production separator excludes every hull point on its closed side.
law production_separated_region_exclusion:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +q: T.Quad
  for +p: G.Point
  for ha: {Grid.envelope(width, a) == True{} : Bool}
  for hb: {Grid.envelope(width, b) == True{} : Bool}
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for hs: {T.separated(a, b, q) == True{} : Bool}
  for hp: {Region.edge(N.decode_point(a), N.decode_point(b), p) == True{} : Bool}
  Hull.InHull(N.decode_quad(q), p) -> Empty
