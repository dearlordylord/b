import Base
import ./core.bend as C
import ./coordinate-sum.bend as S

def determinant_positive(a: C.Point, b: C.Point, c: C.Point) -> Bool:
  match a b c:
    case C.Pt{+ax, +ay} C.Pt{+bx, +by} C.Pt{+cx, +cy}:
      Nat.is_gt(S.exact(ax, by, bx, cy, cx, ay), S.exact(ay, bx, by, cx, cy, ax))
def positive_quad(+a: C.Point, +b: C.Point, +c: C.Point, +d: C.Point) -> Bool:
  determinant_positive(a, b, c) && determinant_positive(b, c, d) && determinant_positive(c, d, a) && determinant_positive(d, a, b)
def convex_quad(+a: C.Point, +b: C.Point, +c: C.Point, +d: C.Point) -> Bool:
  positive_quad(a, b, c, d) || positive_quad(d, c, b, a)
def cell_convex(+cell: C.Cell) -> Bool:
  +a = C.cell_start(cell)
  +b = C.cell_finish(cell)
  convex_quad(C.boundary_left(a), C.boundary_left(b), C.boundary_right(b), C.boundary_right(a))
