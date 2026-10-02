import Base
import ./word-arithmetic.bend as W
import ./word-comparison.bend as C
import ./word-comparison-laws.bend as L
import ./word-multiplication-proof.bend as Arithmetic

# More significant bits decide unequal values; the low bit breaks a tie.
law bit_comparison:
  for +x: Nat
  for +y: Nat
  for +a: Bool
  for +b: Bool
  {Word.cmp.fin(a, b, Nat.cmp(x, y)) == Nat.cmp(Nat.add(W.bit_value(a), Nat.double(x)), Nat.add(W.bit_value(b), Nat.double(y))) : Cmp}
def bit_comparison(x, y, a, b):
  match x y:
    case 0n 0n:
      match a b:
        case False{} False{}: {==}
        case False{} True{}: {==}
        case True{} False{}: {==}
        case True{} True{}: {==}
    case 0n 1n+q:
      match a b:
        case False{} False{}: {==}
        case False{} True{}: {==}
        case True{} False{}: {==}
        case True{} True{}: {==}
    case 1n+p 0n:
      match a b:
        case False{} False{}: {==}
        case False{} True{}: {==}
        case True{} False{}: {==}
        case True{} True{}: {==}
    case 1n+p 1n+q:
      match a b:
        case False{} False{}: bit_comparison(p, q, False{}, False{})
        case False{} True{}: bit_comparison(p, q, False{}, True{})
        case True{} False{}: bit_comparison(p, q, True{}, False{})
        case True{} True{}: bit_comparison(p, q, True{}, True{})

def L.word_comparison_exact(n, a, b):
  match n:
    case 0n: {==}
    case 1n+p:
      match a b:
        case WCon{False{}, at} WCon{False{}, bt}:
          Equal.trans(Cmp, Word.cmp.fin(False{}, False{}, C.compare(p, at, bt)), Word.cmp.fin(False{}, False{}, Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt))), Nat.cmp(Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, bt)))), Equal.cong(Cmp, Cmp, c => Word.cmp.fin(False{}, False{}, c), C.compare(p, at, bt), Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt)), L.word_comparison_exact(p, at, bt)), bit_comparison(Word.to_nat(p, at), Word.to_nat(p, bt), False{}, False{}))
        case WCon{False{}, at} WCon{True{}, bt}:
          Equal.trans(Cmp, Word.cmp.fin(False{}, True{}, C.compare(p, at, bt)), Word.cmp.fin(False{}, True{}, Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt))), Nat.cmp(Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, bt)))), Equal.cong(Cmp, Cmp, c => Word.cmp.fin(False{}, True{}, c), C.compare(p, at, bt), Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt)), L.word_comparison_exact(p, at, bt)), bit_comparison(Word.to_nat(p, at), Word.to_nat(p, bt), False{}, True{}))
        case WCon{True{}, at} WCon{False{}, bt}:
          Equal.trans(Cmp, Word.cmp.fin(True{}, False{}, C.compare(p, at, bt)), Word.cmp.fin(True{}, False{}, Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt))), Nat.cmp(Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, bt)))), Equal.cong(Cmp, Cmp, c => Word.cmp.fin(True{}, False{}, c), C.compare(p, at, bt), Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt)), L.word_comparison_exact(p, at, bt)), bit_comparison(Word.to_nat(p, at), Word.to_nat(p, bt), True{}, False{}))
        case WCon{True{}, at} WCon{True{}, bt}:
          Equal.trans(Cmp, Word.cmp.fin(True{}, True{}, C.compare(p, at, bt)), Word.cmp.fin(True{}, True{}, Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt))), Nat.cmp(Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, bt)))), Equal.cong(Cmp, Cmp, c => Word.cmp.fin(True{}, True{}, c), C.compare(p, at, bt), Nat.cmp(Word.to_nat(p, at), Word.to_nat(p, bt)), L.word_comparison_exact(p, at, bt)), bit_comparison(Word.to_nat(p, at), Word.to_nat(p, bt), True{}, True{}))

def L.u32_comparison_exact(x, y):
  L.word_comparison_exact(32n, x, y)

def L.u32_equality_exact(x, y):
  Equal.cong(Cmp, Bool, c => Cmp.is_eq(c), U32.cmp(U32{x}, U32{y}), Nat.cmp(Word.to_nat(32n, x), Word.to_nat(32n, y)), L.u32_comparison_exact(x, y))

def L.u32_greater_exact(x, y):
  Equal.cong(Cmp, Bool, c => Cmp.is_gt(c), U32.cmp(U32{x}, U32{y}), Nat.cmp(Word.to_nat(32n, x), Word.to_nat(32n, y)), L.u32_comparison_exact(x, y))

def L.u32_less_equal_exact(x, y):
  Equal.cong(Cmp, Bool, c => Cmp.is_le(c), U32.cmp(U32{x}, U32{y}), Nat.cmp(Word.to_nat(32n, x), Word.to_nat(32n, y)), L.u32_comparison_exact(x, y))
