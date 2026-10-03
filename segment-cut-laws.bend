import Base
import ./segment-cut.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./strict-halfplane.bend as S
import ./halfplane-region.bend as Region

law negative_gap_positive:
  for +a: N.Point
  for +b: N.Point
  for +q: G.Point
  for h: {S.negative(a, b, q) == True{} : Bool}
  {Nat.is_gt(M.negative_gap(a, b, q), 0n) == True{} : Bool}
law crossing_total_positive:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for +q: G.Point
  for h: {S.negative(a, b, q) == True{} : Bool}
  {Nat.is_gt(Nat.add(M.first_weight(a, b, q), M.second_weight(a, b, p)), 0n) == True{} : Bool}
# Closed p and strictly negative q balance the two exact determinant sums.
law crossing_on_line:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for +q: G.Point
  for hp: {Region.edge(a, b, p) == True{} : Bool}
  for hq: {S.negative(a, b, q) == True{} : Bool}
  {M.on_line(a, b, M.point(a, b, p, q)) == True{} : Bool}
law crossing_denominator_positive:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for +q: G.Point
  for hp: {G.positive_denominator(p) == True{} : Bool}
  for hq: {G.positive_denominator(q) == True{} : Bool}
  for h: {S.negative(a, b, q) == True{} : Bool}
  {G.positive_denominator(M.point(a, b, p, q)) == True{} : Bool}
# Both endpoints inside another region imply the constructed segment point is inside.
law crossing_region_preserved:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for +q: G.Point
  for +r: N.Quad
  for hp: {Region.contains(p, r) == True{} : Bool}
  for hq: {Region.contains(q, r) == True{} : Bool}
  {Region.contains(M.point(a, b, p, q), r) == True{} : Bool}
# Actual weights witness segment membership, including positive denominator.
law crossing_in_segment:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for +q: G.Point
  for +hp: {G.positive_denominator(p) == True{} : Bool}
  for +hq: {G.positive_denominator(q) == True{} : Bool}
  for +h: {S.negative(a, b, q) == True{} : Bool}
  M.InSegment(p, q, M.point(a, b, p, q))
