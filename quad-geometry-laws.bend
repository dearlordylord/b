import Base
import ./quad-geometry.bend as M
import ./natural-cover.bend as N
import ./topology.bend as T
import ./sat-arithmetic.bend as Sat
import ./search-witness.bend as Search

law triangle_cyclic_side:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  {M.side(a, b, c) == M.side(b, c, a) : Cmp}
law side_at_start_zero:
  for +a: N.Point
  for +b: N.Point
  {M.side(a, b, a) == EQ{} : Cmp}
law side_at_finish_zero:
  for +a: N.Point
  for +b: N.Point
  {M.side(a, b, b) == EQ{} : Cmp}
law strict_quad_corners_inside:
  for +q: N.Quad
  for h: {M.strict_quad(q) == True{} : Bool}
  {M.corners_inside(q) == True{} : Bool}
law strict_quad_decoded:
  for +q: T.Quad
  {Sat.strictly_convex(q) == M.strict_quad(N.decode_quad(q)) : Bool}
law production_corners_inside:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for h: {T.strictly_convex(q) == True{} : Bool}
  {M.corners_inside(N.decode_quad(q)) == True{} : Bool}
