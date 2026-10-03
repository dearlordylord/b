import Base
import ./triangle-coordinate.bend as M
import ./triangle-area.bend as A
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-diagonal.bend as D

# Each coordinate-weighted positive cycle has one shared part and the
# triangle's positive determinant sum times the point coordinate.
law positive_coordinate_cycle:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  for +axis: Bool
  {M.positive_weighted(a, b, c, p, axis) == Nat.add(Nat.mul(A.positive(a, b, Q.embed(c)), M.point_coordinate(p, axis)), M.common(a, b, c, p, axis)) : Nat}
# The negative cycle has exactly the same shared part, so cancellation applies.
law negative_coordinate_cycle:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  for +axis: Bool
  {M.negative_weighted(a, b, c, p, axis) == Nat.add(Nat.mul(A.negative(a, b, Q.embed(c)), M.point_coordinate(p, axis)), M.common(a, b, c, p, axis)) : Nat}
# Closed triangle membership makes Nat area subtraction exact. A strict turn
# fixes the positive triangle orientation; zero coordinate values are allowed.
law weighted_coordinate_exact:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  for +axis: Bool
  for +ht: {Q.turn(a, b, c) == True{} : Bool}
  for h: {D.triangle(a, b, c, p) == True{} : Bool}
  {M.weighted(a, b, c, p, axis) == Nat.mul(M.point_coordinate(p, axis), A.triangle_area(a, b, c)) : Nat}
# Both reconstructed coordinates and the weight sum are the original
# homogeneous point multiplied by the same directed triangle area.
law reconstructed_point_exact:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  for +ht: {Q.turn(a, b, c) == True{} : Bool}
  for +h: {D.triangle(a, b, c, p) == True{} : Bool}
  {M.reconstruct(a, b, c, p) == M.scaled(p, A.triangle_area(a, b, c)) : G.Point}
# For a valid rational point, reconstruction has a positive denominator and
# represents the same point. Algebraic cross-product equality alone is weaker.
law reconstructed_point_valid:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  for +ht: {Q.turn(a, b, c) == True{} : Bool}
  for +h: {D.triangle(a, b, c, p) == True{} : Bool}
  for hp: {G.positive_denominator(p) == True{} : Bool}
  {G.positive_denominator(M.reconstruct(a, b, c, p)) == True{} : Bool} & {G.equivalent(p, M.reconstruct(a, b, c, p)) == True{} : Bool}
