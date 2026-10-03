import Base
import ./inside-arithmetic-laws.bend as L
import ./inside-arithmetic.bend as M
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./sample-arithmetic.bend as S
import ./side-bridge.bend as Side
import ./side-bridge-laws.bend as SideLaw
import ./side-bridge-proof.bend as SideProof
import ./source-cells-proof.bend as Cells
import ./search-witness.bend as Search
import ./search-witness-laws.bend as SearchLaw
import ./search-witness-proof.bend as SearchProof
import ./word-comparison-laws.bend as Compare
import ./word-conversion-laws.bend as Conversion

def nonnegative_exact(+x: Cmp) -> {T.nonnegative(x) == Bool.not(Cmp.is_lt(x)) : Bool}:
  match x:
    case LT{}: {==}
    case EQ{}: {==}
    case GT{}: {==}
def edge_exact(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Point, +b: T.Point, +w: T.Witness, ha: {G.envelope(width, a) == True{} : Bool}, hb: {G.envelope(width, b) == True{} : Bool}, henv: {S.envelope(width, w) == True{} : Bool}) -> {T.nonnegative(T.side(a, b, w)) == M.edge(a, b, w) : Bool}:
  Equal.trans(Bool, T.nonnegative(T.side(a, b, w)), T.nonnegative(Side.exact(a, b, w)), M.edge(a, b, w), Equal.cong(Cmp, Bool, x => T.nonnegative(x), T.side(a, b, w), Side.exact(a, b, w), SideLaw.accepted_side_exact(width, hw, a, b, w, ha, hb, henv)), nonnegative_exact(Side.exact(a, b, w)))

def inside_bounds(+width: Nat, +hw: {width == 12n : Nat}, +w: T.Witness, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, +ha: {G.envelope(width, a) == True{} : Bool}, +hb: {G.envelope(width, b) == True{} : Bool}, +hc: {G.envelope(width, c) == True{} : Bool}, +hd: {G.envelope(width, d) == True{} : Bool}, +henv: {S.envelope(width, w) == True{} : Bool}) -> {T.inside(w, T.Q{a, b, c, d}) == M.inside(w, T.Q{a, b, c, d}) : Bool}:
  %edge_exact(width, hw, a, b, w, ha, hb, henv) : {T.inside(w, T.Q{a, b, c, d}) == _ && M.edge(b, c, w) && M.edge(c, d, w) && M.edge(d, a, w) : Bool}
  %edge_exact(width, hw, b, c, w, hb, hc, henv) : {T.inside(w, T.Q{a, b, c, d}) == T.nonnegative(T.side(a, b, w)) && _ && M.edge(c, d, w) && M.edge(d, a, w) : Bool}
  %edge_exact(width, hw, c, d, w, hc, hd, henv) : {T.inside(w, T.Q{a, b, c, d}) == T.nonnegative(T.side(a, b, w)) && T.nonnegative(T.side(b, c, w)) && _ && M.edge(d, a, w) : Bool}
  %edge_exact(width, hw, d, a, w, hd, ha, henv) : {T.inside(w, T.Q{a, b, c, d}) == T.nonnegative(T.side(a, b, w)) && T.nonnegative(T.side(b, c, w)) && T.nonnegative(T.side(c, d, w)) && _ : Bool}
  {==}
def inside_fields(+width: Nat, +hw: {width == 12n : Nat}, +w: T.Witness, +a: T.Point, +b: T.Point, +c: T.Point, +d: T.Point, hs: {G.envelope(width, a) == True{} : Bool} & ({G.envelope(width, b) == True{} : Bool} & ({G.envelope(width, c) == True{} : Bool} & {G.envelope(width, d) == True{} : Bool})), +henv: {S.envelope(width, w) == True{} : Bool}) -> {T.inside(w, T.Q{a, b, c, d}) == M.inside(w, T.Q{a, b, c, d}) : Bool}:
  match hs:
    case (ha, (hb, (hc, hd))): inside_bounds(width, hw, w, a, b, c, d, ha, hb, hc, hd, henv)
def L.inside_arithmetic_exact(width, hw, w, q, hq, henv):
  match q:
    case T.Q{+a, +b, +c, +d}: inside_fields(width, hw, w, a, b, c, d, Cells.quad_fields(G.envelope(width, a), G.envelope(width, b), G.envelope(width, c), G.envelope(width, d), hq), henv)

def L.common_arithmetic_exact(width, hw, w, a, b, c, ha, hb, hc, henv):
  %L.inside_arithmetic_exact(width, hw, w, a, ha, henv) : {T.common(w, a, b, c) == _ && M.inside(w, b) && M.inside(w, c) : Bool}
  %L.inside_arithmetic_exact(width, hw, w, b, hb, henv) : {T.common(w, a, b, c) == T.inside(w, a) && _ && M.inside(w, c) : Bool}
  %L.inside_arithmetic_exact(width, hw, w, c, hc, henv) : {T.common(w, a, b, c) == T.inside(w, a) && T.inside(w, b) && _ : Bool}
  {==}

def positive_exact(+d: U32) -> {U32.is_gt(d, 0) == Nat.is_gt(U32.to_nat(d), 0n) : Bool}:
  match d:
    case U32{+dw}:
      %Conversion.zero_word_value(32n) : {U32.is_gt(U32{dw}, 0) == Nat.is_gt(Word.to_nat(32n, dw), _) : Bool}
      Compare.u32_greater_exact(dw, Word.zero(32n))
def natural_ready(+width: Nat, +hw: {width == 12n : Nat}, +a: T.Quad, +b: T.Quad, +c: T.Quad, +ha: {Search.quad_envelope(width, a) == True{} : Bool}, +hb: {Search.quad_envelope(width, b) == True{} : Bool}, +hc: {Search.quad_envelope(width, c) == True{} : Bool}, found: Search.Ready(width, a, b, c)) -> M.Ready(width, a, b, c):
  match found:
    case (+w, (+henv, (hcommon, positive))):
      (w, (henv, (Equal.trans(Bool, M.common(w, a, b, c), T.common(w, a, b, c), True{}, Equal.sym(Bool, T.common(w, a, b, c), M.common(w, a, b, c), L.common_arithmetic_exact(width, hw, w, a, b, c, ha, hb, hc, henv)), hcommon), Equal.trans(Bool, Nat.is_gt(U32.to_nat(Search.denominator(w)), 0n), U32.is_gt(Search.denominator(w), 0), True{}, Equal.sym(Bool, U32.is_gt(Search.denominator(w), 0), Nat.is_gt(U32.to_nat(Search.denominator(w)), 0n), positive_exact(Search.denominator(w))), positive))))
def L.triangle_witness_natural(width, hw, a, b, c, ha, hb, hc, accepted):
  natural_ready(width, hw, a, b, c, ha, hb, hc, SearchLaw.triangle_witness_ready(width, hw, a, b, c, ha, hb, hc, accepted))
