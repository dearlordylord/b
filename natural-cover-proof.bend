import Base
import ./coordinate-limit.bend as Limit
import ./core.bend as C
import ./topology.bend as T
import ./natural-cover.bend as M
import ./natural-cover-laws.bend as L
import ./grid-scaling-proof.bend as GridProof
import ./scaled-coordinate-laws.bend as Scale
import ./scaled-coordinate-proof.bend as ScaleProof
import ./source-cells.bend as SourceModel
import ./source-cells-laws.bend as Source
import ./source-cells-proof.bend as SourceProof
import ./sat-arithmetic-laws.bend as Sat
import ./sat-arithmetic.bend as SatModel
import ./sat-arithmetic-proof.bend as SatProof

def scaled_fields(+x: Nat, +y: Nat, hs: {Nat.is_le(x, Limit.maximum()) == True{} : Bool} & ({Nat.is_le(y, Limit.maximum()) == True{} : Bool} & ({Nat.is_eq(Nat.mod(x, 4n), 0n) == True{} : Bool} & {Nat.is_eq(Nat.mod(y, 4n), 0n) == True{} : Bool}))) -> {M.decode_point(T.scaled(C.Pt{x, y})) == M.scaled(C.Pt{x, y}) : M.Point}:
  match hs:
    case (hx, (hy, (gx, gy))):
      Equal.trans(M.Point, M.decode_point(T.scaled(C.Pt{x, y})), M.P{Nat.div(x, 4n), U32.to_nat(U32.div(U32.from_nat(y), 4))}, M.P{Nat.div(x, 4n), Nat.div(y, 4n)}, Equal.cong(Nat, M.Point, n => M.P{n, U32.to_nat(U32.div(U32.from_nat(y), 4))}, U32.to_nat(U32.div(U32.from_nat(x), 4)), Nat.div(x, 4n), Scale.scaled_coordinate_exact(x, hx)), Equal.cong(Nat, M.Point, n => M.P{Nat.div(x, 4n), n}, U32.to_nat(U32.div(U32.from_nat(y), 4)), Nat.div(y, 4n), Scale.scaled_coordinate_exact(y, hy)))
def L.scaled_point_decoded(p, hp):
  match p:
    case C.Pt{+x, +y}: scaled_fields(x, y, GridProof.guard_fields(Nat.is_le(x, Limit.maximum()), Nat.is_le(y, Limit.maximum()), Nat.is_eq(Nat.mod(x, 4n), 0n), Nat.is_eq(Nat.mod(y, 4n), 0n), hp))
def quad_exact(+a: M.Point, +b: M.Point, +c: M.Point, +d: M.Point, +p: M.Point, +q: M.Point, +r: M.Point, +s: M.Point, ha: {a == p : M.Point}, hb: {b == q : M.Point}, hc: {c == r : M.Point}, hd: {d == s : M.Point}) -> {M.Q{a, b, c, d} == M.Q{p, q, r, s} : M.Quad}:
  %ha : {M.Q{a, b, c, d} == M.Q{_, q, r, s} : M.Quad}
  %hb : {M.Q{a, b, c, d} == M.Q{a, _, r, s} : M.Quad}
  %hc : {M.Q{a, b, c, d} == M.Q{a, b, _, s} : M.Quad}
  %hd : {M.Q{a, b, c, d} == M.Q{a, b, c, _} : M.Quad}
  {==}
def L.raw_cell_decoded(a, b, ha, hb):
  quad_exact(M.decode_point(T.scaled(C.boundary_left(a))), M.decode_point(T.scaled(C.boundary_left(b))), M.decode_point(T.scaled(C.boundary_right(b))), M.decode_point(T.scaled(C.boundary_right(a))), M.scaled(C.boundary_left(a)), M.scaled(C.boundary_left(b)), M.scaled(C.boundary_right(b)), M.scaled(C.boundary_right(a)), L.scaled_point_decoded(C.boundary_left(a), SourceProof.section_left(a, ha)), L.scaled_point_decoded(C.boundary_left(b), SourceProof.section_left(b, hb)), L.scaled_point_decoded(C.boundary_right(b), SourceProof.section_right(b, hb)), L.scaled_point_decoded(C.boundary_right(a), SourceProof.section_right(a, ha)))
def orientation_decoded(q: T.Quad) -> {SatModel.orientation(q) == M.orientation(M.decode_quad(q)) : Bool}:
  match q:
    case T.Q{T.P{ax, ay}, T.P{bx, by}, T.P{cx, cy}, d}: {==}
def L.raw_orientation_exact(width, hw, a, b, ha, hb):
  Equal.trans(Bool, T.orientation(T.raw_cell(a, b)), SatModel.orientation(T.raw_cell(a, b)), M.orientation(M.raw_cell(a, b)), Sat.orientation_arithmetic_exact(width, hw, T.raw_cell(a, b), Source.raw_cell_envelope(width, hw, a, b, ha, hb)), Equal.trans(Bool, SatModel.orientation(T.raw_cell(a, b)), M.orientation(M.decode_quad(T.raw_cell(a, b))), M.orientation(M.raw_cell(a, b)), orientation_decoded(T.raw_cell(a, b)), Equal.cong(M.Quad, Bool, q => M.orientation(q), M.decode_quad(T.raw_cell(a, b)), M.raw_cell(a, b), L.raw_cell_decoded(a, b, ha, hb))))
def reverse_decoded(q: T.Quad) -> {M.decode_quad(T.reverse(q)) == M.reverse(M.decode_quad(q)) : M.Quad}:
  match q:
    case T.Q{a, b, c, d}: {==}
def orient_decoded(sign: Bool, +q: T.Quad) -> {M.decode_quad(T.orient(sign, q)) == M.orient(sign, M.decode_quad(q)) : M.Quad}:
  match sign:
    case False{}: reverse_decoded(q)
    case True{}: {==}
def oriented_raw(+sign: Bool, +a: C.Section, +b: C.Section, ha: {SourceModel.section_guard(a) == True{} : Bool}, hb: {SourceModel.section_guard(b) == True{} : Bool}) -> {M.decode_quad(T.orient(sign, T.raw_cell(a, b))) == M.orient(sign, M.raw_cell(a, b)) : M.Quad}:
  Equal.trans(M.Quad, M.decode_quad(T.orient(sign, T.raw_cell(a, b))), M.orient(sign, M.decode_quad(T.raw_cell(a, b))), M.orient(sign, M.raw_cell(a, b)), orient_decoded(sign, T.raw_cell(a, b)), Equal.cong(M.Quad, M.Quad, q => M.orient(sign, q), M.decode_quad(T.raw_cell(a, b)), M.raw_cell(a, b), L.raw_cell_decoded(a, b, ha, hb)))
def cons_exact(+a: M.Quad, +b: M.Quad, +xs: List<&2, M.Quad>, +ys: List<&2, M.Quad>, head: {a == b : M.Quad}, tail: {xs == ys : List<&2, M.Quad>}) -> {Con{a, xs} == Con{b, ys} : List<&2, M.Quad>}:
  %head : {Con{a, xs} == Con{_, ys} : List<&2, M.Quad>}
  %tail : {Con{a, xs} == Con{a, _} : List<&2, M.Quad>}
  {==}
def L.cells_walk_decoded(width, hw, xs, previous, hp, sign, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      cons_exact(M.decode_quad(T.orient(sign, T.raw_cell(previous, h))), M.orient(sign, M.raw_cell(previous, h)), M.decode_cells(T.cells_walk(t, h, sign)), M.cells_walk(t, h, sign), oriented_raw(sign, previous, h, hp, SourceProof.section_head(h, t, hx)), L.cells_walk_decoded(width, hw, t, h, SourceProof.section_head(h, t, hx), sign, SourceProof.section_tail(h, t, hx)))
def L.cells_tail_decoded(width, hw, xs, previous, hp, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      %L.raw_orientation_exact(width, hw, previous, h, hp, SourceProof.section_head(h, t, hx)) : {M.decode_cells(T.cells_tail(Con{h, t}, previous)) == M.cells_walk(Con{h, t}, previous, _) : List<&2, M.Quad>}
      L.cells_walk_decoded(width, hw, Con{h, t}, previous, hp, T.orientation(T.raw_cell(previous, h)), hx)
def L.cells_decoded(width, hw, xs, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}: L.cells_tail_decoded(width, hw, t, h, SourceProof.section_head(h, t, hx), SourceProof.section_tail(h, t, hx))
