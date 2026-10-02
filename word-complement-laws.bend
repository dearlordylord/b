import Base
import ./word-arithmetic.bend as W
import ./word-complement.bend as C

law maximum_capacity:
  for +n: Nat
  {1n+C.maximum(n) == W.capacity(n) : Nat}

# A value and its bitwise complement sum to the representable maximum.
law complement_value:
  for +n: Nat
  for +w: Word(n)
  {Nat.add(Word.to_nat(n, w), Word.to_nat(n, C.complement(n, w))) == C.maximum(n) : Nat}
