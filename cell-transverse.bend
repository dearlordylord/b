import Base
import ./core.bend as C
import ./centroid.bend as M
import ./coordinate-transverse.bend as T

def points(+left: C.Point, +control: C.Point, +right: C.Point) -> Bool:
  match left, control, right:
    case C.Pt{lx, ly}, C.Pt{cx, cy}, C.Pt{rx, ry}:
      T.exact(lx, ly, cx, cy, rx, ry)

def exact(+cell: C.Cell) -> Bool:
  points(C.boundary_left(C.cell_start(cell)), M.center(cell), C.boundary_right(C.cell_start(cell)))
