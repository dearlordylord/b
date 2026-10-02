import Base
import ./word-arithmetic.bend as W

# Each full-adder cell conserves the exact natural-number value.
law full_adder_value:
  for +a: Bool
  for +b: Bool
  for +c: Bool
  {W.bit_total(Bool.full_add(a, b, c)) == Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), W.bit_value(c)) : Nat}

# The retained-carry adder computes exactly the standard library's low word.
# This connects the model to the arithmetic used by U32.add.
law low_word_agrees:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  {W.low(n, W.add_carry(n, a, b, c)) == Word.adc(n, a, b, False{}, c) : Word(n)}

# The entire returned word AND carry preserve the exact input sum.
law whole_word_value:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  {W.carry_value(n, W.add_carry(n, a, b, c)) == Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)) : Nat}

# With a zero high carry, positional interpretation is the ordinary value.
law zero_carry_value:
  for +n: Nat
  for +w: Word(n)
  {W.extended_value(n, False{}, w) == Word.to_nat(n, w) : Nat}

# A checked zero carry establishes exact (not modular) standard word addition.
law addition_without_overflow:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  for h: {W.overflow(n, W.add_carry(n, a, b, c)) == False{} : Bool}
  {Word.to_nat(n, Word.adc(n, a, b, False{}, c)) == Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)) : Nat}
