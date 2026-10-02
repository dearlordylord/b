import Base
import ./word-arithmetic.bend as W
import ./word-conversion.bend as C

law zero_word_value:
  for +n: Nat
  {Word.to_nat(n, Word.zero(n)) == 0n : Nat}

law increment_agrees:
  for +n: Nat
  for +w: Word(n)
  {Word.inc(n, w) == Word.adc(n, w, Word.zero(n), False{}, True{}) : Word(n)}

# Conversion preserves every natural number strictly within word capacity.
law bounded_conversion:
  for +k: Nat
  for +n: Nat
  for h: {Nat.is_lt(k, W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, C.from_nat(k, n)) == k : Nat}

# Connect the generic converter to the actual Base primitive used by geometry.
law u32_conversion_agrees:
  for +k: Nat
  {U32.from_nat(k) == U32{C.from_nat(k, 32n)} : U32}

# Exact round trip through the actual U32 conversion, under the capacity bound.
law bounded_u32_conversion:
  for +k: Nat
  for h: {Nat.is_lt(k, W.capacity(32n)) == True{} : Bool}
  {U32.to_nat(U32.from_nat(k)) == k : Nat}
