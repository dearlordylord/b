import Base
import ./core.bend as Core
import ./artwork.bend as Artwork

# Finite exact checks of the concrete artwork, distinct from generic proofs.
# All coordinates are bounded before conversion to U32. A determinant side
# has at most three products of coordinates <= 16000: at most 768,000,000.
# Squared distances and expanded dot comparisons also remain below 2^32.
def point_bounded(p: Core.Point) -> Bool:
  match p:
    case Core.Pt{x, y}:
      Nat.is_le(x, 16000n) && Nat.is_le(y, 16000n)

def sections_bounded(sections: List<&2, Core.Section>) -> Bool:
  match sections:
    case Nil{}:
      True{}
    case Con{+h, t}:
      point_bounded(Core.boundary_left(h)) && point_bounded(Core.boundary_right(h)) && sections_bounded(t)

def point_equal(a: Core.Point, b: Core.Point) -> Bool:
  match a b:
    case Core.Pt{x, y} Core.Pt{z, w}:
      Nat.is_eq(x, z) && Nat.is_eq(y, w)

def determinant_positive(a: Core.Point, b: Core.Point, c: Core.Point) -> Bool:
  match a b c:
    case Core.Pt{ax, ay} Core.Pt{bx, by} Core.Pt{cx, cy}:
      +x = U32.from_nat(ax)
      +y = U32.from_nat(ay)
      +u = U32.from_nat(bx)
      +v = U32.from_nat(by)
      +r = U32.from_nat(cx)
      +s = U32.from_nat(cy)
      U32.is_gt((x * v + u * s + r * y : U32), (y * u + v * r + s * x : U32))

def positive_quad(+a: Core.Point, +b: Core.Point, +c: Core.Point, +d: Core.Point) -> Bool:
  determinant_positive(a, b, c) && determinant_positive(b, c, d) && determinant_positive(c, d, a) && determinant_positive(d, a, b)

def convex_quad(+a: Core.Point, +b: Core.Point, +c: Core.Point, +d: Core.Point) -> Bool:
  positive_quad(a, b, c, d) || positive_quad(d, c, b, a)

def cell_convex(+cell: Core.Cell) -> Bool:
  +a = Core.cell_start(cell)
  +b = Core.cell_finish(cell)
  convex_quad(Core.boundary_left(a), Core.boundary_left(b), Core.boundary_right(b), Core.boundary_right(a))

def absolute_difference(+a: U32, +b: U32) -> U32:
  U32.sub(U32.max(a, b), U32.min(a, b))

def width_squared(a: Core.Point, b: Core.Point) -> U32:
  match a b:
    case Core.Pt{x, y} Core.Pt{z, w}:
      +dx = absolute_difference(U32.from_nat(x), U32.from_nat(z))
      +dy = absolute_difference(U32.from_nat(y), U32.from_nat(w))
      (dx * dx + dy * dy : U32)

def width_in_range(+n: U32) -> Bool:
  U32.is_le(3240000, n) && U32.is_le(n, 6760000)

def section_width(+s: Core.Section) -> Bool:
  width_in_range(width_squared(Core.boundary_left(s), Core.boundary_right(s)))

def point_four(p: Core.Point) -> Core.Point:
  match p:
    case Core.Pt{x, y}:
      Core.Pt{Nat.mul(4n, x), Nat.mul(4n, y)}

def cell_centroid_exact(+cell: Core.Cell) -> Bool:
  +a = Core.cell_start(cell)
  +b = Core.cell_finish(cell)
  point_equal(point_four(Core.cell_center(cell)), Core.point_add(Core.point_add(Core.boundary_left(a), Core.boundary_right(a)), Core.point_add(Core.boundary_left(b), Core.boundary_right(b))))

def cell_endpoints_exact(+cell: Core.Cell) -> Bool:
  +s = Core.seam(cell)
  +a = Core.cell_start(cell)
  point_equal(Core.seam_start(s), Core.boundary_left(a)) && point_equal(Core.seam_end(s), Core.boundary_right(a))

def dot(a: Core.Point, b: Core.Point) -> U32:
  match a b:
    case Core.Pt{x, y} Core.Pt{z, w}:
      (U32.from_nat(x) * U32.from_nat(z) + U32.from_nat(y) * U32.from_nat(w) : U32)

# The quadratic derivative is a nonnegative blend of its endpoint tangent
# vectors. Both project strictly forward across this section, so no reversal.
def transverse_points(+left: Core.Point, +control: Core.Point, +right: Core.Point) -> Bool:
  U32.is_gt((dot(control, right) + dot(left, left) : U32), (dot(control, left) + dot(left, right) : U32)) && U32.is_gt((dot(right, right) + dot(control, left) : U32), (dot(right, left) + dot(control, right) : U32))

def cell_transverse(+cell: Core.Cell) -> Bool:
  +s = Core.seam(cell)
  transverse_points(Core.seam_start(s), Core.seam_control(s), Core.seam_end(s))

def cell_valid(+cell: Core.Cell) -> Bool:
  cell_convex(cell) && cell_centroid_exact(cell) && cell_endpoints_exact(cell) && cell_transverse(cell) && section_width(Core.cell_start(cell)) && section_width(Core.cell_finish(cell))

def cells_valid(sections: List<&2, Core.Section>, previous: Core.Section) -> Bool:
  match sections:
    case Nil{}:
      True{}
    case Con{+h, t}:
      cell_valid(Core.Cell{previous, h}) && cells_valid(t, h)

def nonempty_valid(sections: List<&2, Core.Section>) -> Bool:
  match sections:
    case Nil{}:
      False{}
    case Con{+h, t}:
      section_width(h) && cells_valid(t, h)

# This branch is the guard on every U32 geometric calculation above.
def bounded_valid(bounded: Bool, sections: List<&2, Core.Section>) -> Bool:
  match bounded:
    case False{}:
      False{}
    case True{}:
      nonempty_valid(sections)

def validate(+sections: List<&2, Core.Section>) -> Bool:
  bounded_valid(sections_bounded(sections), sections)

def section_count(sections: List<&2, Core.Section>) -> Nat:
  match sections:
    case Nil{}:
      0n
    case Con{h, t}:
      Nat.add(1n, section_count(t))

def expected_artwork(+sections: List<&2, Core.Section>) -> Bool:
  Nat.is_eq(section_count(sections), 33n) && validate(sections)

def artwork_valid() -> Bool:
  expected_artwork(Artwork.upper()) && expected_artwork(Artwork.lower()) && expected_artwork(Artwork.stem())
