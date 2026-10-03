import Base
import ./core.bend as C
import ./validation.bend as V
import ./source-convexity.bend as Convex
import ./width-range.bend as Width
import ./cell-transverse.bend as Transverse

# The reused checks below already use Nat exclusively. Word geometry is
# replaced with its separately proved natural reference predicates.
def section_bounded(+s: C.Section) -> Bool:
  V.point_bounded(C.boundary_left(s)) && V.point_bounded(C.boundary_right(s))
def cell_valid(+lower: U32, +upper: U32, +cell: C.Cell) -> Bool:
  Convex.cell_convex(cell) && (V.cell_centroid_exact(cell) && (V.cell_endpoints_exact(cell) && (Transverse.exact(cell) && (Width.section_width(lower, upper, C.cell_start(cell)) && Width.section_width(lower, upper, C.cell_finish(cell))))))
def cells_valid(xs: List<&2, C.Section>, previous: C.Section, +lower: U32, +upper: U32) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{+h, t}: cell_valid(lower, upper, C.Cell{previous, h}) && cells_valid(t, h, lower, upper)
def nonempty_valid(xs: List<&2, C.Section>, +lower: U32, +upper: U32) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{+h, t}: Width.section_width(lower, upper, h) && cells_valid(t, h, lower, upper)
def bounded_valid(bounded: Bool, xs: List<&2, C.Section>, lower: U32, upper: U32) -> Bool:
  match bounded:
    case False{}: False{}
    case True{}: nonempty_valid(xs, lower, upper)
def validate(+xs: List<&2, C.Section>, lower: U32, upper: U32) -> Bool:
  bounded_valid(V.sections_bounded(xs), xs, lower, upper)
