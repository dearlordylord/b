import Base
import ./sat-arithmetic-laws.bend as L
import ./sat-arithmetic.bend as M
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./side-bridge.bend as Side
import ./side-bridge-laws.bend as SideLaw
import ./side-bridge-proof.bend as SideProof
import ./sample-arithmetic.bend as S
import ./source-cells-proof.bend as Cells
import ./search-witness.bend as Search

def negative_cmp_exact(+x: Cmp) -> {T.negative(x) == Cmp.is_lt(x) : Bool}:
  match x:
    case LT{}: {==}
    case EQ{}: {==}
    case GT{}: {==}
def L.negative_vertex_exact(width, hw, a, b, p, ha, hb, hp):
  Equal.trans(Bool, T.negative(T.side(a, b, T.witness(p))), T.negative(M.vertex(a, b, p)), M.negative(a, b, p), Equal.cong(Cmp, Bool, x => T.negative(x), T.side(a, b, T.witness(p)), M.vertex(a, b, p), SideLaw.vertex_side_exact(width, hw, a, b, p, ha, hb, hp)), negative_cmp_exact(M.vertex(a, b, p)))

def positive_cmp_exact(+x: Cmp) -> {T.positive(x) == Cmp.is_gt(x) : Bool}:
  match x:
    case LT{}: {==}
    case EQ{}: {==}
    case GT{}: {==}
def L.positive_vertex_exact(width, hw, a, b, p, ha, hb, hp):
  Equal.trans(Bool, T.positive(T.side(a, b, T.witness(p))), T.positive(M.vertex(a, b, p)), M.positive(a, b, p), Equal.cong(Cmp, Bool, x => T.positive(x), T.side(a, b, T.witness(p)), M.vertex(a, b, p), SideLaw.vertex_side_exact(width, hw, a, b, p, ha, hb, hp)), positive_cmp_exact(M.vertex(a, b, p)))


def and_four(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +p: Bool, +q: Bool, +r: Bool, +t: Bool, ha: {a == p : Bool}, hb: {b == q : Bool}, hc: {c == r : Bool}, hd: {d == t : Bool}) -> {a && b && c && d == p && q && r && t : Bool}:
  %ha : {a && b && c && d == _ && q && r && t : Bool}
  %hb : {a && b && c && d == a && _ && r && t : Bool}
  %hc : {a && b && c && d == a && b && _ && t : Bool}
  %hd : {a && b && c && d == a && b && c && _ : Bool}
  {==}

def or_four(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +p: Bool, +q: Bool, +r: Bool, +t: Bool, ha: {a == p : Bool}, hb: {b == q : Bool}, hc: {c == r : Bool}, hd: {d == t : Bool}) -> {a || b || c || d == p || q || r || t : Bool}:
  %ha : {a || b || c || d == _ || q || r || t : Bool}
  %hb : {a || b || c || d == a || _ || r || t : Bool}
  %hc : {a || b || c || d == a || b || _ || t : Bool}
  %hd : {a || b || c || d == a || b || c || _ : Bool}
  {==}

def separated_fields(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Point, +b: T.Point, +p: T.Point, +q: T.Point, +r: T.Point, +t: T.Point, +ha: {G.envelope(width, a) == True{} : Bool}, +hb: {G.envelope(width, b) == True{} : Bool}, hs: {G.envelope(width, p) == True{} : Bool} & ({G.envelope(width, q) == True{} : Bool} & ({G.envelope(width, r) == True{} : Bool} & {G.envelope(width, t) == True{} : Bool}))) -> {T.separated(a, b, T.Q{p, q, r, t}) == M.separated(a, b, T.Q{p, q, r, t}) : Bool}:
  match hs:
    case (hp, (hq, (hr, ht))):
      and_four(T.negative(T.side(a, b, T.witness(p))), T.negative(T.side(a, b, T.witness(q))), T.negative(T.side(a, b, T.witness(r))), T.negative(T.side(a, b, T.witness(t))), M.negative(a, b, p), M.negative(a, b, q), M.negative(a, b, r), M.negative(a, b, t), L.negative_vertex_exact(width, hw, a, b, p, ha, hb, hp), L.negative_vertex_exact(width, hw, a, b, q, ha, hb, hq), L.negative_vertex_exact(width, hw, a, b, r, ha, hb, hr), L.negative_vertex_exact(width, hw, a, b, t, ha, hb, ht))
def L.separated_arithmetic_exact(width, hw, a, b, q, ha, hb, hq):
  match q:
    case T.Q{+p, +q, +r, +t}: separated_fields(width, hw, a, b, p, q, r, t, ha, hb, Cells.quad_fields(G.envelope(width, p), G.envelope(width, q), G.envelope(width, r), G.envelope(width, t), hq))

def strictly_convex_bounds(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, +ha: {G.envelope(width, a) == True{} : Bool}, +hb: {G.envelope(width, b) == True{} : Bool}, +hc: {G.envelope(width, c) == True{} : Bool}, +hd: {G.envelope(width, d) == True{} : Bool}) -> {T.strictly_convex(T.Q{a, b, c, d}) == M.strictly_convex(T.Q{a, b, c, d}) : Bool}:
  and_four(T.positive(T.side(a, b, T.witness(c))), T.positive(T.side(b, c, T.witness(d))), T.positive(T.side(c, d, T.witness(a))), T.positive(T.side(d, a, T.witness(b))), M.positive(a, b, c), M.positive(b, c, d), M.positive(c, d, a), M.positive(d, a, b), L.positive_vertex_exact(width, hw, a, b, c, ha, hb, hc), L.positive_vertex_exact(width, hw, b, c, d, hb, hc, hd), L.positive_vertex_exact(width, hw, c, d, a, hc, hd, ha), L.positive_vertex_exact(width, hw, d, a, b, hd, ha, hb))
def strictly_convex_fields(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, hs: {G.envelope(width, a) == True{} : Bool} & ({G.envelope(width, b) == True{} : Bool} & ({G.envelope(width, c) == True{} : Bool} & {G.envelope(width, d) == True{} : Bool}))) -> {T.strictly_convex(T.Q{a, b, c, d}) == M.strictly_convex(T.Q{a, b, c, d}) : Bool}:
  match hs:
    case (ha, (hb, (hc, hd))): strictly_convex_bounds(width, hw, a, b, c, d, ha, hb, hc, hd)
def L.strictly_convex_arithmetic_exact(width, hw, q, hq):
  match q:
    case T.Q{+a, +b, +c, +d}: strictly_convex_fields(width, hw, a, b, c, d, Cells.quad_fields(G.envelope(width, a), G.envelope(width, b), G.envelope(width, c), G.envelope(width, d), hq))

def orientation_fields(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, hs: {G.envelope(width, a) == True{} : Bool} & ({G.envelope(width, b) == True{} : Bool} & ({G.envelope(width, c) == True{} : Bool} & {G.envelope(width, d) == True{} : Bool}))) -> {T.orientation(T.Q{a, b, c, d}) == M.orientation(T.Q{a, b, c, d}) : Bool}:
  match hs:
    case (ha, (hb, (hc, hd))):
      L.positive_vertex_exact(width, hw, a, b, c, ha, hb, hc)
def L.orientation_arithmetic_exact(width, hw, q, hq):
  match q:
    case T.Q{+a, +b, +c, +d}: orientation_fields(width, hw, a, b, c, d, Cells.quad_fields(G.envelope(width, a), G.envelope(width, b), G.envelope(width, c), G.envelope(width, d), hq))

def outside_bounds(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, +ha: {G.envelope(width, a) == True{} : Bool}, +hb: {G.envelope(width, b) == True{} : Bool}, +hc: {G.envelope(width, c) == True{} : Bool}, +hd: {G.envelope(width, d) == True{} : Bool}, +r: T.Quad, +hr: {Search.quad_envelope(width, r) == True{} : Bool}) -> {T.outside(T.Q{a, b, c, d}, r) == M.outside(T.Q{a, b, c, d}, r) : Bool}:
  or_four(T.separated(a, b, r), T.separated(b, c, r), T.separated(c, d, r), T.separated(d, a, r), M.separated(a, b, r), M.separated(b, c, r), M.separated(c, d, r), M.separated(d, a, r), L.separated_arithmetic_exact(width, hw, a, b, r, ha, hb, hr), L.separated_arithmetic_exact(width, hw, b, c, r, hb, hc, hr), L.separated_arithmetic_exact(width, hw, c, d, r, hc, hd, hr), L.separated_arithmetic_exact(width, hw, d, a, r, hd, ha, hr))
def outside_fields(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, hs: {G.envelope(width, a) == True{} : Bool} & ({G.envelope(width, b) == True{} : Bool} & ({G.envelope(width, c) == True{} : Bool} & {G.envelope(width, d) == True{} : Bool})), +r: T.Quad, +hr: {Search.quad_envelope(width, r) == True{} : Bool}) -> {T.outside(T.Q{a, b, c, d}, r) == M.outside(T.Q{a, b, c, d}, r) : Bool}:
  match hs:
    case (ha, (hb, (hc, hd))): outside_bounds(width, hw, a, b, c, d, ha, hb, hc, hd, r, hr)
def L.outside_arithmetic_exact(width, hw, q, r, hq, hr):
  match q:
    case T.Q{+a, +b, +c, +d}: outside_fields(width, hw, a, b, c, d, Cells.quad_fields(G.envelope(width, a), G.envelope(width, b), G.envelope(width, c), G.envelope(width, d), hq), r, hr)

def L.meets_arithmetic_exact(width, hw, q, r, hq, hr):
  %L.outside_arithmetic_exact(width, hw, q, r, hq, hr) : {T.meets(q, r) == Bool.not(_ || M.outside(r, q)) : Bool}
  %L.outside_arithmetic_exact(width, hw, r, q, hr, hq) : {T.meets(q, r) == Bool.not(T.outside(q, r) || _) : Bool}
  {==}
