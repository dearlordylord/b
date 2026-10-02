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
