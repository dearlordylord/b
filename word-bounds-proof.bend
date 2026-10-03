import Base
import ./word-arithmetic.bend as W
import ./word-laws.bend as L
import ./word-bounds-laws.bend as B
import ./word-value-proof.bend as P
import ./facts.bend as F
import ./boolean-reflection.bend as V

def B.high_carry_value(n, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{False{}, t}:
          %Equal.sym(Nat, W.extended_value(p, True{}, t), Nat.add(W.capacity(p), Word.to_nat(p, t)), B.high_carry_value(p, t)) : {Nat.double(_) == Nat.add(Nat.double(W.capacity(p)), Nat.double(Word.to_nat(p, t))) : Nat}
          P.double_add(W.capacity(p), Word.to_nat(p, t))
        case WCon{True{}, t}:
          %Equal.sym(Nat, W.extended_value(p, True{}, t), Nat.add(W.capacity(p), Word.to_nat(p, t)), B.high_carry_value(p, t)) : {1n+Nat.double(_) == Nat.add(Nat.double(W.capacity(p)), 1n+Nat.double(Word.to_nat(p, t))) : Nat}
          %Equal.sym(Nat, Nat.add(Nat.double(W.capacity(p)), 1n+Nat.double(Word.to_nat(p, t))), 1n+Nat.add(Nat.double(W.capacity(p)), Nat.double(Word.to_nat(p, t))), F.add_succ(Nat.double(W.capacity(p)), Nat.double(Word.to_nat(p, t)))) : {1n+Nat.double(Nat.add(W.capacity(p), Word.to_nat(p, t))) == _ : Nat}
          Equal.cong(Nat, Nat, z => 1n+z, Nat.double(Nat.add(W.capacity(p), Word.to_nat(p, t))), Nat.add(Nat.double(W.capacity(p)), Nat.double(Word.to_nat(p, t))), P.double_add(W.capacity(p), Word.to_nat(p, t)))

law not_lt_added:
  for +a: Nat
  for +b: Nat
  {Nat.is_lt(Nat.add(a, b), a) == False{} : Bool}
def not_lt_added(a, b):
  match a:
    case 0n:
      match b:
        case 0n: {==}
        case 1n+p: {==}
    case 1n+p: not_lt_added(p, b)

law high_not_lt:
  for +n: Nat
  for +w: Word(n)
  {Nat.is_lt(W.extended_value(n, True{}, w), W.capacity(n)) == False{} : Bool}
def high_not_lt(n, w):
  %Equal.sym(Nat, W.extended_value(n, True{}, w), Nat.add(W.capacity(n), Word.to_nat(n, w)), B.high_carry_value(n, w)) : {Nat.is_lt(_, W.capacity(n)) == False{} : Bool}
  not_lt_added(W.capacity(n), Word.to_nat(n, w))

law result_bound:
  for +n: Nat
  for +r: W.Carry<n>
  for +v: Nat
  for e: {W.carry_value(n, r) == v : Nat}
  for h: {Nat.is_lt(v, W.capacity(n)) == True{} : Bool}
  {W.overflow(n, r) == False{} : Bool}
def result_bound(n, r, v, e, h):
  match r:
    case W.Carry{False{}, w}: {==}
    case W.Carry{True{}, w}:
      V.absurd({True{} == False{} : Bool}, V.false_impossible(Equal.trans(Bool, False{}, Nat.is_lt(W.extended_value(n, True{}, w), W.capacity(n)), True{}, Equal.sym(Bool, Nat.is_lt(W.extended_value(n, True{}, w), W.capacity(n)), False{}, high_not_lt(n, w)), Equal.trans(Bool, Nat.is_lt(W.extended_value(n, True{}, w), W.capacity(n)), Nat.is_lt(v, W.capacity(n)), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(z, W.capacity(n)), W.extended_value(n, True{}, w), v, e), h))))

def B.bounded_addition_carry(n, a, b, c, h):
  result_bound(n, W.add_carry(n, a, b, c), Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)), L.whole_word_value(n, a, b, c), h)

def B.bounded_addition_exact(n, a, b, c, h):
  L.addition_without_overflow(n, a, b, c, B.bounded_addition_carry(n, a, b, c, h))
