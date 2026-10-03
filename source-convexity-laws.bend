import Base
import ./core.bend as C
import ./validation.bend as V
import ./source-convexity.bend as M

law positive_quad_arithmetic_exact:
  for +a: C.Point
  for +b: C.Point
  for +c: C.Point
  for +d: C.Point
  for +ha: {V.point_bounded(a) == True{} : Bool}
  for +hb: {V.point_bounded(b) == True{} : Bool}
  for +hc: {V.point_bounded(c) == True{} : Bool}
  for +hd: {V.point_bounded(d) == True{} : Bool}
  {V.positive_quad(a, b, c, d) == M.positive_quad(a, b, c, d) : Bool}

law convex_quad_arithmetic_exact:
  for +a: C.Point
  for +b: C.Point
  for +c: C.Point
  for +d: C.Point
  for +ha: {V.point_bounded(a) == True{} : Bool}
  for +hb: {V.point_bounded(b) == True{} : Bool}
  for +hc: {V.point_bounded(c) == True{} : Bool}
  for +hd: {V.point_bounded(d) == True{} : Bool}
  {V.convex_quad(a, b, c, d) == M.convex_quad(a, b, c, d) : Bool}

law cell_convex_arithmetic_exact:
  for +cell: C.Cell
  for +hsl: {V.point_bounded(C.boundary_left(C.cell_start(cell))) == True{} : Bool}
  for +hsr: {V.point_bounded(C.boundary_right(C.cell_start(cell))) == True{} : Bool}
  for +hfl: {V.point_bounded(C.boundary_left(C.cell_finish(cell))) == True{} : Bool}
  for +hfr: {V.point_bounded(C.boundary_right(C.cell_finish(cell))) == True{} : Bool}
  {V.cell_convex(cell) == M.cell_convex(cell) : Bool}
