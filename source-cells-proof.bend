import Base
import ./source-cells-laws.bend as L
import ./source-cells.bend as S
import ./search-witness.bend as M
import ./core.bend as C
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./grid-scaling-laws.bend as Grid
import ./grid-scaling-proof.bend as GridProof
import ./boolean-reflection.bend as B

def scaled_bound(+width: Nat, +hw: {width == 12n : Nat}, +p: C.Point, hp: {T.point_guard(p) == True{} : Bool}) -> {G.envelope(width, T.scaled(p)) == True{} : Bool}:
  match p:
    case C.Pt{+x, +y}: Grid.accepted_scaled_envelope(width, hw, x, y, hp)

def four_bounds(+width: Nat, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, ha: {G.envelope(width, a) == True{} : Bool}, hb: {G.envelope(width, b) == True{} : Bool}, hc: {G.envelope(width, c) == True{} : Bool}, hd: {G.envelope(width, d) == True{} : Bool}) -> {M.quad_envelope(width, T.Q{a, b, c, d}) == True{} : Bool}:
  B.and_join(G.envelope(width, a), G.envelope(width, b) && (G.envelope(width, c) && (G.envelope(width, d) && True{})), ha, B.and_join(G.envelope(width, b), G.envelope(width, c) && (G.envelope(width, d) && True{}), hb, B.and_join(G.envelope(width, c), G.envelope(width, d) && True{}, hc, B.and_join(G.envelope(width, d), True{}, hd, {==}))))

def section_left(+s: C.Section, hs: {S.section_guard(s) == True{} : Bool}) -> {T.point_guard(C.boundary_left(s)) == True{} : Bool}:
  Pair.fst({T.point_guard(C.boundary_left(s)) == True{} : Bool}, {T.point_guard(C.boundary_right(s)) == True{} : Bool}, B.and_split(T.point_guard(C.boundary_left(s)), T.point_guard(C.boundary_right(s)), hs))
def section_right(+s: C.Section, hs: {S.section_guard(s) == True{} : Bool}) -> {T.point_guard(C.boundary_right(s)) == True{} : Bool}:
  Pair.snd({T.point_guard(C.boundary_left(s)) == True{} : Bool}, {T.point_guard(C.boundary_right(s)) == True{} : Bool}, B.and_split(T.point_guard(C.boundary_left(s)), T.point_guard(C.boundary_right(s)), hs))

def L.raw_cell_envelope(width, hw, a, b, ha, hb):
  four_bounds(width, T.scaled(C.boundary_left(a)), T.scaled(C.boundary_left(b)), T.scaled(C.boundary_right(b)), T.scaled(C.boundary_right(a)), scaled_bound(width, hw, C.boundary_left(a), section_left(a, ha)), scaled_bound(width, hw, C.boundary_left(b), section_left(b, hb)), scaled_bound(width, hw, C.boundary_right(b), section_right(b, hb)), scaled_bound(width, hw, C.boundary_right(a), section_right(a, ha)))

def quad_fields(+a: Bool, +b: Bool, +c: Bool, +d: Bool, h: {a && (b && (c && (d && True{}))) == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})):
  match a b c d:
    case False{} _ _ _: B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} False{} _ _: B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} False{} _: B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} True{} False{}: B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} True{} True{}: ({==}, ({==}, ({==}, {==})))

def reversed_fields(+width: Nat, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, hs: {G.envelope(width, a) == True{} : Bool} & ({G.envelope(width, b) == True{} : Bool} & ({G.envelope(width, c) == True{} : Bool} & {G.envelope(width, d) == True{} : Bool}))) -> {M.quad_envelope(width, T.reverse(T.Q{a, b, c, d})) == True{} : Bool}:
  match hs:
    case (ha, (hb, (hc, hd))): four_bounds(width, d, c, b, a, hd, hc, hb, ha)
def reversed_bound(+width: Nat, +q: T.Quad, hq: {M.quad_envelope(width, q) == True{} : Bool}) -> {M.quad_envelope(width, T.reverse(q)) == True{} : Bool}:
  match q:
    case T.Q{+a, +b, +c, +d}: reversed_fields(width, a, b, c, d, quad_fields(G.envelope(width, a), G.envelope(width, b), G.envelope(width, c), G.envelope(width, d), hq))
def L.oriented_envelope(width, sign, q, hq):
  match sign:
    case False{}: reversed_bound(width, q, hq)
    case True{}: hq

def three_fields(+a: Bool, +b: Bool, +c: Bool, h: {a && b && c == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & {c == True{} : Bool}):
  match a b c:
    case False{} _ _: B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & {c == True{} : Bool}), B.false_impossible(h))
    case True{} False{} _: B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & {c == True{} : Bool}), B.false_impossible(h))
    case True{} True{} False{}: B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & {c == True{} : Bool}), B.false_impossible(h))
    case True{} True{} True{}: ({==}, ({==}, {==}))

def section_head_fields(+h: C.Section, -t: List<&2, C.Section>, hs: {T.point_guard(C.boundary_left(h)) == True{} : Bool} & ({T.point_guard(C.boundary_right(h)) == True{} : Bool} & {T.sections_guard(t) == True{} : Bool})) -> {S.section_guard(h) == True{} : Bool}:
  match hs:
    case (hl, (hr, ht)): B.and_join(T.point_guard(C.boundary_left(h)), T.point_guard(C.boundary_right(h)), hl, hr)
def section_tail_fields(-h: C.Section, +t: List<&2, C.Section>, hs: {T.point_guard(C.boundary_left(h)) == True{} : Bool} & ({T.point_guard(C.boundary_right(h)) == True{} : Bool} & {T.sections_guard(t) == True{} : Bool})) -> {T.sections_guard(t) == True{} : Bool}:
  match hs:
    case (hl, (hr, ht)): ht

def section_head(+h: C.Section, +t: List<&2, C.Section>, hx: {T.sections_guard(Con{h, t}) == True{} : Bool}) -> {S.section_guard(h) == True{} : Bool}:
  section_head_fields(h, t, three_fields(T.point_guard(C.boundary_left(h)), T.point_guard(C.boundary_right(h)), T.sections_guard(t), hx))
def section_tail(+h: C.Section, +t: List<&2, C.Section>, hx: {T.sections_guard(Con{h, t}) == True{} : Bool}) -> {T.sections_guard(t) == True{} : Bool}:
  section_tail_fields(h, t, three_fields(T.point_guard(C.boundary_left(h)), T.point_guard(C.boundary_right(h)), T.sections_guard(t), hx))

def walk_bound(+width: Nat, +hw: {width == 12n : Nat}, xs: List<&2, C.Section>, +previous: C.Section, +sign: Bool, +hp: {S.section_guard(previous) == True{} : Bool}, +hx: {T.sections_guard(xs) == True{} : Bool}) -> {S.envelope(width, T.cells_walk(xs, previous, sign)) == True{} : Bool}:
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      B.and_join(M.quad_envelope(width, T.orient(sign, T.raw_cell(previous, h))), S.envelope(width, T.cells_walk(t, h, sign)), L.oriented_envelope(width, sign, T.raw_cell(previous, h), L.raw_cell_envelope(width, hw, previous, h, hp, section_head(h, t, hx))), walk_bound(width, hw, t, h, sign, section_head(h, t, hx), section_tail(h, t, hx)))
def tail_bound(+width: Nat, +hw: {width == 12n : Nat}, +xs: List<&2, C.Section>, +first: C.Section, +hf: {S.section_guard(first) == True{} : Bool}, +hx: {T.sections_guard(xs) == True{} : Bool}) -> {S.envelope(width, T.cells_tail(xs, first)) == True{} : Bool}:
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}: walk_bound(width, hw, Con{h, t}, first, T.orientation(T.raw_cell(first, h)), hf, hx)
def L.cells_envelope(width, hw, xs, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}: tail_bound(width, hw, t, h, section_head(h, t, hx), section_tail(h, t, hx))
