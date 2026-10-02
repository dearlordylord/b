import Base
import ./word-arithmetic.bend as W
import ./word-shift.bend as S
import ./word-shift-laws.bend as L
import ./word-proof.bend as WordProof
import ./word-value-proof.bend as Value
import ./word-bounds-proof.bend as Bounds
import ./word-conversion-proof.bend as Conversion
import ./facts.bend as F

def L.shift_low_agrees(n, c, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{b, t}:
          WordProof.lift_low(p, c, S.shift(p, b, t), Word.shl.put(p, b, t), L.shift_low_agrees(p, b, t))

def L.shift_value(n, c, w):
  match n:
    case 0n:
      Equal.sym(Nat, Nat.add(W.bit_value(c), 0n), W.bit_value(c), F.add_zero(W.bit_value(c)))
    case 1n+p:
      match w:
        case WCon{False{}, t}:
          Value.lift_value(p, c, S.shift(p, False{}, t), Nat.double(Word.to_nat(p, t)), L.shift_value(p, False{}, t))
        case WCon{True{}, t}:
          Value.lift_value(p, c, S.shift(p, True{}, t), 1n+Nat.double(Word.to_nat(p, t)), L.shift_value(p, True{}, t))

law shift_put_zero:
  for +n: Nat
  for +w: Word(n)
  {Word.shl.put(n, False{}, w) == Word.shl(n, w) : Word(n)}
def shift_put_zero(n, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{b, t}: {==}

def L.bounded_shift(n, w, h):
  %shift_put_zero(n, w) : {Word.to_nat(n, _) == Nat.double(Word.to_nat(n, w)) : Nat}
  %L.shift_low_agrees(n, False{}, w) : {Word.to_nat(n, _) == Nat.double(Word.to_nat(n, w)) : Nat}
  %Value.false_carry(n, S.shift(n, False{}, w), Bounds.result_bound(n, S.shift(n, False{}, w), Nat.double(Word.to_nat(n, w)), L.shift_value(n, False{}, w), h)) : {_ == Nat.double(Word.to_nat(n, w)) : Nat}
  L.shift_value(n, False{}, w)
