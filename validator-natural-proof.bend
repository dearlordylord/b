import Base
import ./core.bend as C
import ./validation.bend as V
import ./validation-proof.bend as ValidationProof
import ./validator-natural.bend as M
import ./validator-natural-laws.bend as L
import ./source-convexity-laws.bend as Convex
import ./source-convexity-proof.bend as ConvexProof
import ./width-range.bend as Range
import ./width-range-laws.bend as Width
import ./width-range-proof.bend as WidthProof
import ./cell-transverse.bend as TransverseModel
import ./cell-transverse-laws.bend as Transverse
import ./cell-transverse-proof.bend as TransverseProof
import ./boolean-reflection.bend as B
import ./edge-arithmetic-proof.bend as Edge

def L.bounded_cell_arithmetic_exact(lower, upper, hlower, hupper, cell, hsl, hsr, hfl, hfr):
  %Convex.cell_convex_arithmetic_exact(cell, hsl, hsr, hfl, hfr) : {V.cell_valid(cell) == _ && (V.cell_centroid_exact(cell) && (V.cell_endpoints_exact(cell) && (TransverseModel.exact(cell) && (Range.section_width(lower, upper, C.cell_start(cell)) && Range.section_width(lower, upper, C.cell_finish(cell)))))) : Bool}
  %Transverse.source_corners_transverse_exact(cell, hsl, hsr, hfl, hfr) : {V.cell_valid(cell) == V.cell_convex(cell) && (V.cell_centroid_exact(cell) && (V.cell_endpoints_exact(cell) && (_ && (Range.section_width(lower, upper, C.cell_start(cell)) && Range.section_width(lower, upper, C.cell_finish(cell)))))) : Bool}
  %Width.section_width_arithmetic_exact(lower, upper, hlower, hupper, C.cell_start(cell), hsl, hsr) : {V.cell_valid(cell) == V.cell_convex(cell) && (V.cell_centroid_exact(cell) && (V.cell_endpoints_exact(cell) && (V.cell_transverse(cell) && (_ && Range.section_width(lower, upper, C.cell_finish(cell)))))) : Bool}
  %Width.section_width_arithmetic_exact(lower, upper, hlower, hupper, C.cell_finish(cell), hfl, hfr) : {V.cell_valid(cell) == V.cell_convex(cell) && (V.cell_centroid_exact(cell) && (V.cell_endpoints_exact(cell) && (V.cell_transverse(cell) && (V.section_width(C.cell_start(cell)) && _)))) : Bool}
  {==}

def left_bound(+s: C.Section, hs: {M.section_bounded(s) == True{} : Bool}) -> {V.point_bounded(C.boundary_left(s)) == True{} : Bool}:
  Pair.fst({V.point_bounded(C.boundary_left(s)) == True{} : Bool}, {V.point_bounded(C.boundary_right(s)) == True{} : Bool}, B.and_split(V.point_bounded(C.boundary_left(s)), V.point_bounded(C.boundary_right(s)), hs))
def right_bound(+s: C.Section, hs: {M.section_bounded(s) == True{} : Bool}) -> {V.point_bounded(C.boundary_right(s)) == True{} : Bool}:
  Pair.snd({V.point_bounded(C.boundary_left(s)) == True{} : Bool}, {V.point_bounded(C.boundary_right(s)) == True{} : Bool}, B.and_split(V.point_bounded(C.boundary_left(s)), V.point_bounded(C.boundary_right(s)), hs))
def head_fields(+a: Bool, +b: Bool, c: Bool, hs: {a == True{} : Bool} & ({b == True{} : Bool} & {c == True{} : Bool})) -> {a && b == True{} : Bool}:
  match hs:
    case (ha, (hb, hc)): B.and_join(a, b, ha, hb)
def tail_fields(a: Bool, b: Bool, c: Bool, hs: {a == True{} : Bool} & ({b == True{} : Bool} & {c == True{} : Bool})) -> {c == True{} : Bool}:
  match hs:
    case (ha, (hb, hc)): hc
def head_bounds(+h: C.Section, +t: List<&2, C.Section>, hs: {V.sections_bounded(Con{h, t}) == True{} : Bool}) -> {M.section_bounded(h) == True{} : Bool}:
  head_fields(V.point_bounded(C.boundary_left(h)), V.point_bounded(C.boundary_right(h)), V.sections_bounded(t), ValidationProof.sound3(V.point_bounded(C.boundary_left(h)), V.point_bounded(C.boundary_right(h)), V.sections_bounded(t), hs))
def tail_bounds(+h: C.Section, +t: List<&2, C.Section>, hs: {V.sections_bounded(Con{h, t}) == True{} : Bool}) -> {V.sections_bounded(t) == True{} : Bool}:
  tail_fields(V.point_bounded(C.boundary_left(h)), V.point_bounded(C.boundary_right(h)), V.sections_bounded(t), ValidationProof.sound3(V.point_bounded(C.boundary_left(h)), V.point_bounded(C.boundary_right(h)), V.sections_bounded(t), hs))

def L.bounded_cells_arithmetic_exact(lower, upper, hlower, hupper, xs, previous, hp, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      Edge.and_two(V.cell_valid(C.Cell{previous, h}), V.cells_valid(t, h), M.cell_valid(lower, upper, C.Cell{previous, h}), M.cells_valid(t, h, lower, upper), L.bounded_cell_arithmetic_exact(lower, upper, hlower, hupper, C.Cell{previous, h}, left_bound(previous, hp), right_bound(previous, hp), left_bound(h, head_bounds(h, t, hx)), right_bound(h, head_bounds(h, t, hx))), L.bounded_cells_arithmetic_exact(lower, upper, hlower, hupper, t, h, head_bounds(h, t, hx), tail_bounds(h, t, hx)))
def L.bounded_nonempty_arithmetic_exact(lower, upper, hlower, hupper, xs, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      Edge.and_two(V.section_width(h), V.cells_valid(t, h), Range.section_width(lower, upper, h), M.cells_valid(t, h, lower, upper), Width.section_width_arithmetic_exact(lower, upper, hlower, hupper, h, left_bound(h, head_bounds(h, t, hx)), right_bound(h, head_bounds(h, t, hx))), L.bounded_cells_arithmetic_exact(lower, upper, hlower, hupper, t, h, head_bounds(h, t, hx), tail_bounds(h, t, hx)))

def gate_exact(+lower: U32, +upper: U32, +hlower: {lower == 3240000 : U32}, +hupper: {upper == 6760000 : U32}, +xs: List<&2, C.Section>, guard: Bool, h: {V.sections_bounded(xs) == guard : Bool}) -> {V.bounded_valid(guard, xs) == M.bounded_valid(guard, xs, lower, upper) : Bool}:
  match guard:
    case False{}: {==}
    case True{}: L.bounded_nonempty_arithmetic_exact(lower, upper, hlower, hupper, xs, h)
def L.validator_arithmetic_exact(lower, upper, hlower, hupper, xs):
  gate_exact(lower, upper, hlower, hupper, xs, V.sections_bounded(xs), {==})
