import Base
import ./word-arithmetic.bend as W

# A set high carry contributes exactly one full word capacity.
law high_carry_value:
  for +n: Nat
  for +w: Word(n)
  {W.extended_value(n, True{}, w) == Nat.add(W.capacity(n), Word.to_nat(n, w)) : Nat}

# A strict bound on the exact input sum rules out overflow, at every width.
law bounded_addition_carry:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  for h: {Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)), W.capacity(n)) == True{} : Bool}
  {W.overflow(n, W.add_carry(n, a, b, c)) == False{} : Bool}

# Standard addition is exact whenever the mathematical sum fits the word.
law bounded_addition_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  for h: {Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, Word.adc(n, a, b, False{}, c)) == Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)) : Nat}
