import Base
import ./core.bend as C
import ./validation.bend as V
import ./cell-transverse.bend as M

# Only source corners are guarded; the control bound follows from averaging.
law source_corners_transverse_exact:
  for +cell: C.Cell
  for +h0: {V.point_bounded(C.boundary_left(C.cell_start(cell))) == True{} : Bool}
  for +h1: {V.point_bounded(C.boundary_right(C.cell_start(cell))) == True{} : Bool}
  for h2: {V.point_bounded(C.boundary_left(C.cell_finish(cell))) == True{} : Bool}
  for h3: {V.point_bounded(C.boundary_right(C.cell_finish(cell))) == True{} : Bool}
  {V.cell_transverse(cell) == M.exact(cell) : Bool}
