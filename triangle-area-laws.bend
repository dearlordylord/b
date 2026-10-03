import Base
import ./triangle-area.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q
import ./quad-diagonal.bend as D

law area_reconstruct:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for h: {Region.edge(a, b, p) == True{} : Bool}
  {Nat.add(M.area(a, b, p), M.negative(a, b, p)) == M.positive(a, b, p) : Nat}
law triangle_area_positive:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for h: {Q.turn(a, b, c) == True{} : Bool}
  {Nat.is_gt(M.triangle_area(a, b, c), 0n) == True{} : Bool}
law positive_area_cycle:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  {M.positive_total(a, b, c, p) == Nat.add(Nat.mul(M.positive(a, b, Q.embed(c)), C.denominator(p)), M.common(a, b, c, p)) : Nat}
law negative_area_cycle:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  {M.negative_total(a, b, c, p) == Nat.add(Nat.mul(M.negative(a, b, Q.embed(c)), C.denominator(p)), M.common(a, b, c, p)) : Nat}
law triangle_weights_total:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  for +ht: {Q.turn(a, b, c) == True{} : Bool}
  for h: {D.triangle(a, b, c, p) == True{} : Bool}
  {M.weights_total(a, b, c, p) == Nat.mul(C.denominator(p), M.triangle_area(a, b, c)) : Nat}
law triangle_weights_positive:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +p: G.Point
  for +ht: {Q.turn(a, b, c) == True{} : Bool}
  for h: {D.triangle(a, b, c, p) == True{} : Bool}
  for hp: {G.positive_denominator(p) == True{} : Bool}
  {Nat.is_gt(M.weights_total(a, b, c, p), 0n) == True{} : Bool}
