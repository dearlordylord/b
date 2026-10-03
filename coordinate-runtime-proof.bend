import Base
import ./coordinate-runtime-laws.bend as L
import ./coordinate-sum.bend as S
import ./coordinate-sum-laws.bend as B
import ./coordinate-sum-proof.bend as Existing
import ./coordinate-facts.bend as F
import ./capacity-facts.bend as Capacity
import ./order-facts.bend as O
import ./word-arithmetic.bend as W
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as V
import ./word-sum3.bend as M
import ./word-sum3-laws.bend as A
import ./word-sum3-proof.bend as SumProof
import ./word-comparison-laws.bend as Compare
import ./word-comparison-proof.bend as ComparisonProof
import ./validation-proof.bend as ValidationProof

def coordinate32(+a: Nat, h: {Nat.is_le(a, 16000n) == True{} : Bool}) -> {Nat.is_lt(a, W.capacity(32n)) == True{} : Bool}:
  O.lt_of_le_of_lt(a, W.capacity(14n), W.capacity(32n), F.coordinate14(a, h), Capacity.capacity_grows(14n, 17n))

law exact_values:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Word(n)
  for +d: Word(n)
  for +e: Word(n)
  for +f: Word(n)
  for +av: Nat
  for +bv: Nat
  for +cv: Nat
  for +dv: Nat
  for +ev: Nat
  for +fv: Nat
  for ha: {Word.to_nat(n, a) == av : Nat}
  for hb: {Word.to_nat(n, b) == bv : Nat}
  for hc: {Word.to_nat(n, c) == cv : Nat}
  for hd: {Word.to_nat(n, d) == dv : Nat}
  for he: {Word.to_nat(n, e) == ev : Nat}
  for hf: {Word.to_nat(n, f) == fv : Nat}
  {M.exact(n, a, b, c, d, e, f) == S.exact(av, bv, cv, dv, ev, fv) : Nat}
def exact_values(n, a, b, c, d, e, f, av, bv, cv, dv, ev, fv, ha, hb, hc, hd, he, hf):
  %Equal.sym(Nat, Word.to_nat(n, a), av, ha) : {S.exact(_, Word.to_nat(n, b), Word.to_nat(n, c), Word.to_nat(n, d), Word.to_nat(n, e), Word.to_nat(n, f)) == S.exact(av, bv, cv, dv, ev, fv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, b), bv, hb) : {S.exact(av, _, Word.to_nat(n, c), Word.to_nat(n, d), Word.to_nat(n, e), Word.to_nat(n, f)) == S.exact(av, bv, cv, dv, ev, fv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, c), cv, hc) : {S.exact(av, bv, _, Word.to_nat(n, d), Word.to_nat(n, e), Word.to_nat(n, f)) == S.exact(av, bv, cv, dv, ev, fv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, d), dv, hd) : {S.exact(av, bv, cv, _, Word.to_nat(n, e), Word.to_nat(n, f)) == S.exact(av, bv, cv, dv, ev, fv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, e), ev, he) : {S.exact(av, bv, cv, dv, _, Word.to_nat(n, f)) == S.exact(av, bv, cv, dv, ev, fv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, f), fv, hf) : {S.exact(av, bv, cv, dv, ev, _) == S.exact(av, bv, cv, dv, ev, fv) : Nat}
  {==}

def converted_exact(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +e: Nat, +f: Nat, hs: S.Bounds<a, b, c, d, e, f>) -> {M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n)) == S.exact(a, b, c, d, e, f) : Nat}:
  match hs:
    case S.Bound{ha, hb, hc, hd, he, hf}:
      exact_values(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), a, b, c, d, e, f, V.bounded_conversion(a, 32n, coordinate32(a, ha)), V.bounded_conversion(b, 32n, coordinate32(b, hb)), V.bounded_conversion(c, 32n, coordinate32(c, hc)), V.bounded_conversion(d, 32n, coordinate32(d, hd)), V.bounded_conversion(e, 32n, coordinate32(e, he)), V.bounded_conversion(f, 32n, coordinate32(f, hf)))

def converted_sum(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +e: Nat, +f: Nat, +hs: S.Bounds<a, b, c, d, e, f>) -> {U32.to_nat(M.u32_sum3(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}, U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)}, U32{C.from_nat(e, 32n)}, U32{C.from_nat(f, 32n)})) == S.exact(a, b, c, d, e, f) : Nat}:
  Equal.trans(Nat, U32.to_nat(M.u32_sum3(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}, U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)}, U32{C.from_nat(e, 32n)}, U32{C.from_nat(f, 32n)})), M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n)), S.exact(a, b, c, d, e, f), A.u32_sum3_exact(C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), Equal.trans(Bool, Nat.is_lt(M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n)), W.capacity(32n)), Nat.is_lt(S.exact(a, b, c, d, e, f), W.capacity(32n)), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(z, W.capacity(32n)), M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n)), S.exact(a, b, c, d, e, f), converted_exact(a, b, c, d, e, f, hs)), B.coordinate_sum32_bound(a, b, c, d, e, f, hs))), converted_exact(a, b, c, d, e, f, hs))

def L.guarded_runtime_sum(a, b, c, d, e, f, hs):
  %Equal.sym(U32, U32.from_nat(a), U32{C.from_nat(a, 32n)}, V.u32_conversion_agrees(a)) : {U32.to_nat(M.u32_sum3(_, U32.from_nat(b), U32.from_nat(c), U32.from_nat(d), U32.from_nat(e), U32.from_nat(f))) == S.exact(a, b, c, d, e, f) : Nat}
  %Equal.sym(U32, U32.from_nat(b), U32{C.from_nat(b, 32n)}, V.u32_conversion_agrees(b)) : {U32.to_nat(M.u32_sum3(U32{C.from_nat(a, 32n)}, _, U32.from_nat(c), U32.from_nat(d), U32.from_nat(e), U32.from_nat(f))) == S.exact(a, b, c, d, e, f) : Nat}
  %Equal.sym(U32, U32.from_nat(c), U32{C.from_nat(c, 32n)}, V.u32_conversion_agrees(c)) : {U32.to_nat(M.u32_sum3(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}, _, U32.from_nat(d), U32.from_nat(e), U32.from_nat(f))) == S.exact(a, b, c, d, e, f) : Nat}
  %Equal.sym(U32, U32.from_nat(d), U32{C.from_nat(d, 32n)}, V.u32_conversion_agrees(d)) : {U32.to_nat(M.u32_sum3(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}, U32{C.from_nat(c, 32n)}, _, U32.from_nat(e), U32.from_nat(f))) == S.exact(a, b, c, d, e, f) : Nat}
  %Equal.sym(U32, U32.from_nat(e), U32{C.from_nat(e, 32n)}, V.u32_conversion_agrees(e)) : {U32.to_nat(M.u32_sum3(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}, U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)}, _, U32.from_nat(f))) == S.exact(a, b, c, d, e, f) : Nat}
  %Equal.sym(U32, U32.from_nat(f), U32{C.from_nat(f, 32n)}, V.u32_conversion_agrees(f)) : {U32.to_nat(M.u32_sum3(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}, U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)}, U32{C.from_nat(e, 32n)}, _)) == S.exact(a, b, c, d, e, f) : Nat}
  converted_sum(a, b, c, d, e, f, hs)

def greater_values(+x: U32, +y: U32, +xv: Nat, +yv: Nat, hx: {U32.to_nat(x) == xv : Nat}, hy: {U32.to_nat(y) == yv : Nat}) -> {U32.is_gt(x, y) == Nat.is_gt(xv, yv) : Bool}:
  match x y:
    case U32{+xw} U32{+yw}:
      %hx : {U32.is_gt(U32{xw}, U32{yw}) == Nat.is_gt(_, yv) : Bool}
      %hy : {U32.is_gt(U32{xw}, U32{yw}) == Nat.is_gt(Word.to_nat(32n, xw), _) : Bool}
      Compare.u32_greater_exact(xw, yw)

def L.guarded_determinant(ax, ay, bx, by, cx, cy, hs):
  match hs:
    case S.Bound{+hax, +hay, +hbx, +hby, +hcx, +hcy}:
      greater_values(M.u32_sum3(U32.from_nat(ax), U32.from_nat(by), U32.from_nat(bx), U32.from_nat(cy), U32.from_nat(cx), U32.from_nat(ay)), M.u32_sum3(U32.from_nat(ay), U32.from_nat(bx), U32.from_nat(by), U32.from_nat(cx), U32.from_nat(cy), U32.from_nat(ax)), S.exact(ax, by, bx, cy, cx, ay), S.exact(ay, bx, by, cx, cy, ax), L.guarded_runtime_sum(ax, by, bx, cy, cx, ay, S.Bound{hax, hby, hbx, hcy, hcx, hay}), L.guarded_runtime_sum(ay, bx, by, cx, cy, ax, S.Bound{hay, hbx, hby, hcx, hcy, hax}))

def bounds_from_pairs(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat,
  pairs: ({Nat.is_le(ax, 16000n) == True{} : Bool} & {Nat.is_le(ay, 16000n) == True{} : Bool}) &
  ({Nat.is_le(bx, 16000n) == True{} : Bool} & {Nat.is_le(by, 16000n) == True{} : Bool}) &
  ({Nat.is_le(cx, 16000n) == True{} : Bool} & {Nat.is_le(cy, 16000n) == True{} : Bool})) -> S.Bounds<ax, ay, bx, by, cx, cy>:
  match pairs:
    case ((hax, hay), ((hbx, hby), (hcx, hcy))):
      S.Bound{hax, hay, hbx, hby, hcx, hcy}

def L.accepted_points_determinant(ax, ay, bx, by, cx, cy, ha, hb, hc):
  L.guarded_determinant(ax, ay, bx, by, cx, cy, bounds_from_pairs(ax, ay, bx, by, cx, cy, (ValidationProof.and_split(Nat.is_le(ax, 16000n), Nat.is_le(ay, 16000n), ha), (ValidationProof.and_split(Nat.is_le(bx, 16000n), Nat.is_le(by, 16000n), hb), ValidationProof.and_split(Nat.is_le(cx, 16000n), Nat.is_le(cy, 16000n), hc)))))
