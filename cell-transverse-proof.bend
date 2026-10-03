import Base
import ./coordinate-limit.bend as Limit
import ./validation.bend as V
import ./cell-transverse-laws.bend as L
import ./cell-transverse.bend as M
import ./centroid.bend as Center
import ./centroid-model-laws.bend as Model
import ./core.bend as C
import ./coordinate-transverse-laws.bend as T
import ./coordinate-transverse-proof.bend as TransverseProof
import ./centroid-bounds-proof.bend as Bounds

def points(+left: C.Point, +control: C.Point, +right: C.Point, hleft: {V.point_bounded(left) == True{} : Bool}, hcontrol: {V.point_bounded(control) == True{} : Bool}, hright: {V.point_bounded(right) == True{} : Bool}) -> {V.transverse_points(left, control, right) == M.points(left, control, right) : Bool}:
  match left, control, right:
    case C.Pt{+lx, +ly}, C.Pt{+cx, +cy}, C.Pt{+rx, +ry}:
      T.accepted_points_transverse(lx, ly, cx, cy, rx, ry, hleft, hcontrol, hright)


def source_exact(+limit: Nat, +hlimit: {limit == Limit.maximum() : Nat}, +cell: C.Cell, +h0: {V.point_bounded(C.boundary_left(C.cell_start(cell))) == True{} : Bool}, +h1: {V.point_bounded(C.boundary_right(C.cell_start(cell))) == True{} : Bool}, h2: {V.point_bounded(C.boundary_left(C.cell_finish(cell))) == True{} : Bool}, h3: {V.point_bounded(C.boundary_right(C.cell_finish(cell))) == True{} : Bool}) -> {V.cell_transverse(cell) == M.points(C.boundary_left(C.cell_start(cell)), Center.center(cell), C.boundary_right(C.cell_start(cell))) : Bool}:
  %Model.cell_center_model(cell) : {V.cell_transverse(cell) == M.points(C.boundary_left(C.cell_start(cell)), _, C.boundary_right(C.cell_start(cell))) : Bool}
  points(C.boundary_left(C.cell_start(cell)), C.cell_center(cell), C.boundary_right(C.cell_start(cell)), h0, Bounds.bounded_center(limit, hlimit, cell, h0, h1, h2, h3), h1)

def L.source_corners_transverse_exact(cell, h0, h1, h2, h3):
  source_exact(Limit.maximum(), {==}, cell, h0, h1, h2, h3)
