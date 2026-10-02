import Base
import ./word-arithmetic.bend as W
import ./word-range-laws.bend as L
import ./word-shift-proof.bend as Shift
import ./validation-proof.bend as V

law double_comparison:
  for +a: Nat
  for +b: Nat
  {Nat.cmp(Nat.double(a), Nat.double(b)) == Nat.cmp(a, b) : Cmp}
def double_comparison(a, b):
  match a b:
    case 0n 0n: {==}
    case 0n 1n+q: {==}
    case 1n+p 0n: {==}
    case 1n+p 1n+q: double_comparison(p, q)

law even_lt:
  for +a: Nat
  for +b: Nat
  for h: {Nat.is_lt(a, b) == True{} : Bool}
  {Nat.is_lt(Nat.double(a), Nat.double(b)) == True{} : Bool}
def even_lt(a, b, h):
  Equal.trans(Bool, Nat.is_lt(Nat.double(a), Nat.double(b)), Nat.is_lt(a, b), True{}, Equal.cong(Cmp, Bool, c => Cmp.is_lt(c), Nat.cmp(Nat.double(a), Nat.double(b)), Nat.cmp(a, b), double_comparison(a, b)), h)

law odd_lt:
  for +a: Nat
  for +b: Nat
  for h: {Nat.is_lt(a, b) == True{} : Bool}
  {Nat.is_lt(1n+Nat.double(a), Nat.double(b)) == True{} : Bool}
def odd_lt(a, b, h):
  match a b:
    case 0n 0n:
      V.absurd({Nat.is_lt(1n, 0n) == True{} : Bool}, V.false_impossible(h))
    case 0n 1n+q: {==}
    case 1n+p 0n:
      V.absurd({Nat.is_lt(1n+Nat.double(1n+p), 0n) == True{} : Bool}, V.false_impossible(h))
    case 1n+p 1n+q: odd_lt(p, q, h)

def L.word_value_bounded(n, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{False{}, t}:
          even_lt(Word.to_nat(p, t), W.capacity(p), L.word_value_bounded(p, t))
        case WCon{True{}, t}:
          odd_lt(Word.to_nat(p, t), W.capacity(p), L.word_value_bounded(p, t))
