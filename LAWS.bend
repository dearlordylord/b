import Base
import ./core.bend as C
import ./geometry.bend as G

# Approved: every seam starts on its tube's left boundary.
law seam_attaches_left:
  for +cell: C.Cell
  {C.seam_start(C.seam(cell)) == C.boundary_left(C.cell_start(cell)) : C.Point}

# Approved: every seam ends on the opposite boundary of the same section.
law seam_attaches_right:
  for +cell: C.Cell
  {C.seam_end(C.seam(cell)) == C.boundary_right(C.cell_start(cell)) : C.Point}

# Approved: SVG serialization uses the exact shared boundary coordinates.
law svg_uses_boundaries:
  for +cell: C.Cell
  {C.seam_data(C.seam(cell)) ==
    "M" ++ C.point_svg(C.boundary_left(C.cell_start(cell))) ++
    " Q" ++ C.point_svg(C.cell_center(cell)) ++ " " ++
    C.point_svg(C.boundary_right(C.cell_start(cell))) : String}

# Approved: the whole quadratic seam is a nonnegative combination of cell
# corners, not just its endpoints. Apply to both coordinate axes. The exact
# centroid premise is checked for every rendered seam by the artwork validator.
law seam_inside_cell_coordinate:
  for +l0: Nat
  for +l1: Nat
  for +r0: Nat
  for +r1: Nat
  for +control: Nat
  for +u: Nat
  for +v: Nat
  for h: {Nat.mul(4n, control) == Nat.add(Nat.add(l0, l1), Nat.add(r0, r1)) : Nat}
  {Nat.mul(4n, G.bezier_numerator(l0, control, r0, u, v)) ==
    G.cell_numerator(l0, l1, r0, r1, u, v) : Nat}

# The four corner weights have the exact quadratic denominator. Their Nat
# type makes each weight nonnegative. For u+v>0 this is a convex combination.
law corner_weights_normalize:
  for +u: Nat
  for +v: Nat
  {G.cell_denominator(u, v) == Nat.mul(4n, Nat.mul(Nat.add(u, v), Nat.add(u, v))) : Nat}
