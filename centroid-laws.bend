import Base
import ./centroid.bend as M
import ./core.bend as C
import ./validation.bend as V

law bounded_cell_center:
  for +cell: C.Cell
  for h0: {V.point_bounded(C.boundary_left(C.cell_start(cell))) == True{} : Bool}
  for h1: {V.point_bounded(C.boundary_right(C.cell_start(cell))) == True{} : Bool}
  for h2: {V.point_bounded(C.boundary_left(C.cell_finish(cell))) == True{} : Bool}
  for h3: {V.point_bounded(C.boundary_right(C.cell_finish(cell))) == True{} : Bool}
  {V.point_bounded(C.cell_center(cell)) == True{} : Bool}

# Acceptance proves an exact average, rather than a rounded control.
law validated_centroid_mean:
  for +cell: C.Cell
  for accepted: {V.cell_centroid_exact(cell) == True{} : Bool}
  {V.point_four(C.cell_center(cell)) == C.point_add(C.point_add(C.boundary_left(C.cell_start(cell)), C.boundary_right(C.cell_start(cell))), C.point_add(C.boundary_left(C.cell_finish(cell)), C.boundary_right(C.cell_finish(cell)))) : C.Point}
