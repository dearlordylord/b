import Base
import ./coordinate-dot-pair-laws.bend as L
import ./coordinate-sum4.bend as S
import ./coordinate-sum4-laws.bend as B
import ./coordinate-sum4-proof.bend as BoundProof
import ./word-sum4.bend as M
import ./word-sum4-laws.bend as Sum
import ./word-sum4-proof.bend as Existing
import ./word-arithmetic.bend as W
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as V
import ./coordinate-runtime-proof.bend as Runtime

law exact_values:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Word(n)
  for +d: Word(n)
  for +e: Word(n)
  for +f: Word(n)
  for +g: Word(n)
  for +h: Word(n)
  for +av: Nat
  for +bv: Nat
  for +cv: Nat
  for +dv: Nat
  for +ev: Nat
  for +fv: Nat
  for +gv: Nat
  for +hv: Nat
  for ha: {Word.to_nat(n, a) == av : Nat}
  for hb: {Word.to_nat(n, b) == bv : Nat}
  for hc: {Word.to_nat(n, c) == cv : Nat}
  for hd: {Word.to_nat(n, d) == dv : Nat}
  for he: {Word.to_nat(n, e) == ev : Nat}
  for hf: {Word.to_nat(n, f) == fv : Nat}
  for hg: {Word.to_nat(n, g) == gv : Nat}
  for hh: {Word.to_nat(n, h) == hv : Nat}
  {M.exact(n, a, b, c, d, e, f, g, h) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
def exact_values(n, a, b, c, d, e, f, g, h, av, bv, cv, dv, ev, fv, gv, hv, ha, hb, hc, hd, he, hf, hg, hh):
  %Equal.sym(Nat, Word.to_nat(n, a), av, ha) : {S.exact(_, Word.to_nat(n, b), Word.to_nat(n, c), Word.to_nat(n, d), Word.to_nat(n, e), Word.to_nat(n, f), Word.to_nat(n, g), Word.to_nat(n, h)) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, b), bv, hb) : {S.exact(av, _, Word.to_nat(n, c), Word.to_nat(n, d), Word.to_nat(n, e), Word.to_nat(n, f), Word.to_nat(n, g), Word.to_nat(n, h)) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, c), cv, hc) : {S.exact(av, bv, _, Word.to_nat(n, d), Word.to_nat(n, e), Word.to_nat(n, f), Word.to_nat(n, g), Word.to_nat(n, h)) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, d), dv, hd) : {S.exact(av, bv, cv, _, Word.to_nat(n, e), Word.to_nat(n, f), Word.to_nat(n, g), Word.to_nat(n, h)) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, e), ev, he) : {S.exact(av, bv, cv, dv, _, Word.to_nat(n, f), Word.to_nat(n, g), Word.to_nat(n, h)) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, f), fv, hf) : {S.exact(av, bv, cv, dv, ev, _, Word.to_nat(n, g), Word.to_nat(n, h)) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, g), gv, hg) : {S.exact(av, bv, cv, dv, ev, fv, _, Word.to_nat(n, h)) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, h), hv, hh) : {S.exact(av, bv, cv, dv, ev, fv, gv, _) == S.exact(av, bv, cv, dv, ev, fv, gv, hv) : Nat}
  {==}

def converted_exact(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +e: Nat, +f: Nat, +g: Nat, +h: Nat, hs: S.Bounds<a, b, c, d, e, f, g, h>) -> {M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n)) == S.exact(a, b, c, d, e, f, g, h) : Nat}:
  match hs:
    case S.Bound{ha, hb, hc, hd, he, hf, hg, hh}:
      exact_values(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n), a, b, c, d, e, f, g, h, V.bounded_conversion(a, 32n, Runtime.coordinate32(a, ha)), V.bounded_conversion(b, 32n, Runtime.coordinate32(b, hb)), V.bounded_conversion(c, 32n, Runtime.coordinate32(c, hc)), V.bounded_conversion(d, 32n, Runtime.coordinate32(d, hd)), V.bounded_conversion(e, 32n, Runtime.coordinate32(e, he)), V.bounded_conversion(f, 32n, Runtime.coordinate32(f, hf)), V.bounded_conversion(g, 32n, Runtime.coordinate32(g, hg)), V.bounded_conversion(h, 32n, Runtime.coordinate32(h, hh)))

def converted_pair(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +e: Nat, +f: Nat, +g: Nat, +h: Nat, +hs: S.Bounds<a, b, c, d, e, f, g, h>) -> {Word.to_nat(32n, M.sum4(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n))) == S.exact(a, b, c, d, e, f, g, h) : Nat}:
  Equal.trans(Nat, Word.to_nat(32n, M.sum4(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n))), M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n)), S.exact(a, b, c, d, e, f, g, h), Sum.sum4_exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n), Equal.trans(Bool, Nat.is_lt(M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n)), W.capacity(32n)), Nat.is_lt(S.exact(a, b, c, d, e, f, g, h), W.capacity(32n)), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(z, W.capacity(32n)), M.exact(32n, C.from_nat(a, 32n), C.from_nat(b, 32n), C.from_nat(c, 32n), C.from_nat(d, 32n), C.from_nat(e, 32n), C.from_nat(f, 32n), C.from_nat(g, 32n), C.from_nat(h, 32n)), S.exact(a, b, c, d, e, f, g, h), converted_exact(a, b, c, d, e, f, g, h, hs)), B.coordinate_sum4_bound(a, b, c, d, e, f, g, h, hs))), converted_exact(a, b, c, d, e, f, g, h, hs))

def L.guarded_dot_pair(a, b, c, d, e, f, g, h, hs):
  %Equal.sym(U32, U32.from_nat(a), U32{C.from_nat(a, 32n)}, V.u32_conversion_agrees(a)) : {U32.to_nat(U32.add(U32.add(U32.mul(_, U32.from_nat(b)), U32.mul(U32.from_nat(c), U32.from_nat(d))), U32.add(U32.mul(U32.from_nat(e), U32.from_nat(f)), U32.mul(U32.from_nat(g), U32.from_nat(h))))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  %Equal.sym(U32, U32.from_nat(b), U32{C.from_nat(b, 32n)}, V.u32_conversion_agrees(b)) : {U32.to_nat(U32.add(U32.add(U32.mul(U32{C.from_nat(a, 32n)}, _), U32.mul(U32.from_nat(c), U32.from_nat(d))), U32.add(U32.mul(U32.from_nat(e), U32.from_nat(f)), U32.mul(U32.from_nat(g), U32.from_nat(h))))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  %Equal.sym(U32, U32.from_nat(c), U32{C.from_nat(c, 32n)}, V.u32_conversion_agrees(c)) : {U32.to_nat(U32.add(U32.add(U32.mul(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}), U32.mul(_, U32.from_nat(d))), U32.add(U32.mul(U32.from_nat(e), U32.from_nat(f)), U32.mul(U32.from_nat(g), U32.from_nat(h))))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  %Equal.sym(U32, U32.from_nat(d), U32{C.from_nat(d, 32n)}, V.u32_conversion_agrees(d)) : {U32.to_nat(U32.add(U32.add(U32.mul(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}), U32.mul(U32{C.from_nat(c, 32n)}, _)), U32.add(U32.mul(U32.from_nat(e), U32.from_nat(f)), U32.mul(U32.from_nat(g), U32.from_nat(h))))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  %Equal.sym(U32, U32.from_nat(e), U32{C.from_nat(e, 32n)}, V.u32_conversion_agrees(e)) : {U32.to_nat(U32.add(U32.add(U32.mul(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}), U32.mul(U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)})), U32.add(U32.mul(_, U32.from_nat(f)), U32.mul(U32.from_nat(g), U32.from_nat(h))))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  %Equal.sym(U32, U32.from_nat(f), U32{C.from_nat(f, 32n)}, V.u32_conversion_agrees(f)) : {U32.to_nat(U32.add(U32.add(U32.mul(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}), U32.mul(U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)})), U32.add(U32.mul(U32{C.from_nat(e, 32n)}, _), U32.mul(U32.from_nat(g), U32.from_nat(h))))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  %Equal.sym(U32, U32.from_nat(g), U32{C.from_nat(g, 32n)}, V.u32_conversion_agrees(g)) : {U32.to_nat(U32.add(U32.add(U32.mul(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}), U32.mul(U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)})), U32.add(U32.mul(U32{C.from_nat(e, 32n)}, U32{C.from_nat(f, 32n)}), U32.mul(_, U32.from_nat(h))))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  %Equal.sym(U32, U32.from_nat(h), U32{C.from_nat(h, 32n)}, V.u32_conversion_agrees(h)) : {U32.to_nat(U32.add(U32.add(U32.mul(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}), U32.mul(U32{C.from_nat(c, 32n)}, U32{C.from_nat(d, 32n)})), U32.add(U32.mul(U32{C.from_nat(e, 32n)}, U32{C.from_nat(f, 32n)}), U32.mul(U32{C.from_nat(g, 32n)}, _)))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
  converted_pair(a, b, c, d, e, f, g, h, hs)
