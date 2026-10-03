import Base
import ./coordinate-limit.bend as Limit
import ./core.bend as C
import ./validation.bend as V
import ./boolean-reflection.bend as B
import ./centroid.bend as Center
import ./centroid-model-laws.bend as Centroid
import ./centroid-model-proof.bend as MeanProof

def source_bound(+limit: Nat, hl: {limit == Limit.maximum() : Nat}, +x: Nat, h: {Nat.is_le(x, Limit.maximum()) == True{} : Bool}) -> {Nat.is_le(x, limit) == True{} : Bool}:
  %Equal.sym(Nat, limit, Limit.maximum(), hl) : {Nat.is_le(x, _) == True{} : Bool}
  h

def control_bounds(+limit: Nat, +hl: {limit == Limit.maximum() : Nat}, +x0: Nat, +y0: Nat, +x1: Nat, +y1: Nat, +x2: Nat, +y2: Nat, +x3: Nat, +y3: Nat, hx0: {Nat.is_le(x0, Limit.maximum()) == True{} : Bool}, hy0: {Nat.is_le(y0, Limit.maximum()) == True{} : Bool}, hx1: {Nat.is_le(x1, Limit.maximum()) == True{} : Bool}, hy1: {Nat.is_le(y1, Limit.maximum()) == True{} : Bool}, hx2: {Nat.is_le(x2, Limit.maximum()) == True{} : Bool}, hy2: {Nat.is_le(y2, Limit.maximum()) == True{} : Bool}, hx3: {Nat.is_le(x3, Limit.maximum()) == True{} : Bool}, hy3: {Nat.is_le(y3, Limit.maximum()) == True{} : Bool}) -> {V.point_bounded(C.Pt{Center.mean(x0, x1, x2, x3), Center.mean(y0, y1, y2, y3)}) == True{} : Bool}:
  %hl : {Nat.is_le(Center.mean(x0, x1, x2, x3), _) && Nat.is_le(Center.mean(y0, y1, y2, y3), Limit.maximum()) == True{} : Bool}
  %hl : {Nat.is_le(Center.mean(x0, x1, x2, x3), limit) && Nat.is_le(Center.mean(y0, y1, y2, y3), _) == True{} : Bool}
  B.and_join(Nat.is_le(Center.mean(x0, x1, x2, x3), limit), Nat.is_le(Center.mean(y0, y1, y2, y3), limit), Centroid.mean_four_bounded(x0, x1, x2, x3, limit, source_bound(limit, hl, x0, hx0), source_bound(limit, hl, x1, hx1), source_bound(limit, hl, x2, hx2), source_bound(limit, hl, x3, hx3)), Centroid.mean_four_bounded(y0, y1, y2, y3, limit, source_bound(limit, hl, y0, hy0), source_bound(limit, hl, y1, hy1), source_bound(limit, hl, y2, hy2), source_bound(limit, hl, y3, hy3)))

def paired_control(+limit: Nat, +hl: {limit == Limit.maximum() : Nat}, +x0: Nat, +y0: Nat, +x1: Nat, +y1: Nat, +x2: Nat, +y2: Nat, +x3: Nat, +y3: Nat, hs: ({Nat.is_le(x0, Limit.maximum()) == True{} : Bool} & {Nat.is_le(y0, Limit.maximum()) == True{} : Bool}) & (({Nat.is_le(x1, Limit.maximum()) == True{} : Bool} & {Nat.is_le(y1, Limit.maximum()) == True{} : Bool}) & (({Nat.is_le(x2, Limit.maximum()) == True{} : Bool} & {Nat.is_le(y2, Limit.maximum()) == True{} : Bool}) & ({Nat.is_le(x3, Limit.maximum()) == True{} : Bool} & {Nat.is_le(y3, Limit.maximum()) == True{} : Bool})))) -> {V.point_bounded(C.Pt{Center.mean(x0, x1, x2, x3), Center.mean(y0, y1, y2, y3)}) == True{} : Bool}:
  match hs:
    case ((hx0, hy0), ((hx1, hy1), ((hx2, hy2), (hx3, hy3)))):
      control_bounds(limit, hl, x0, y0, x1, y1, x2, y2, x3, y3, hx0, hy0, hx1, hy1, hx2, hy2, hx3, hy3)

def bounded_center(+limit: Nat, +hlimit: {limit == Limit.maximum() : Nat}, +cell: C.Cell, h0: {V.point_bounded(C.boundary_left(C.cell_start(cell))) == True{} : Bool}, h1: {V.point_bounded(C.boundary_right(C.cell_start(cell))) == True{} : Bool}, h2: {V.point_bounded(C.boundary_left(C.cell_finish(cell))) == True{} : Bool}, h3: {V.point_bounded(C.boundary_right(C.cell_finish(cell))) == True{} : Bool}) -> {V.point_bounded(C.cell_center(cell)) == True{} : Bool}:
  match cell:
    case C.Cell{C.Section{C.Pt{+x0, +y0}, C.Pt{+x1, +y1}}, C.Section{C.Pt{+x2, +y2}, C.Pt{+x3, +y3}}}:
      paired_control(limit, hlimit, x0, y0, x1, y1, x2, y2, x3, y3, (B.and_split(Nat.is_le(x0, Limit.maximum()), Nat.is_le(y0, Limit.maximum()), h0), (B.and_split(Nat.is_le(x1, Limit.maximum()), Nat.is_le(y1, Limit.maximum()), h1), (B.and_split(Nat.is_le(x2, Limit.maximum()), Nat.is_le(y2, Limit.maximum()), h2), B.and_split(Nat.is_le(x3, Limit.maximum()), Nat.is_le(y3, Limit.maximum()), h3)))))
