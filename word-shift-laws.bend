import Base
import ./word-arithmetic.bend as W
import ./word-shift.bend as S

law shift_low_agrees:
  for +n: Nat
  for +c: Bool
  for +w: Word(n)
  {W.low(n, S.shift(n, c, w)) == Word.shl.put(n, c, w) : Word(n)}

law shift_value:
  for +n: Nat
  for +c: Bool
  for +w: Word(n)
  {W.carry_value(n, S.shift(n, c, w)) == Nat.add(W.bit_value(c), Nat.double(Word.to_nat(n, w))) : Nat}

# A bounded double cannot lose a high bit.
law bounded_shift:
  for +n: Nat
  for +w: Word(n)
  for h: {Nat.is_lt(Nat.double(Word.to_nat(n, w)), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, Word.shl(n, w)) == Nat.double(Word.to_nat(n, w)) : Nat}
