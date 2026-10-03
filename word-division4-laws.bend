import Base
import ./word-division4.bend as D

# The real Base division loop returns the bit quotient and two-bit remainder.
law division4_loop_bits:
  for +n: Nat
  for +w: Word(n)
  {U32.divmod.go(n, w, 4) == (D.quotient(n, w), D.remainder(n, w)) : Word(n) & U32}

law u32_division4_bits:
  for +w: Word(32n)
  {U32.div(U32{w}, 4) == U32{D.quotient(32n, w)} : U32}

law remainder4_bound:
  for +n: Nat
  for +w: Word(n)
  {U32.is_lt(D.remainder(n, w), 4) == True{} : Bool}

# Two doubles are exact multiplication by four.
law division4_partition:
  for +n: Nat
  for +w: Word(n)
  {Word.to_nat(n, w) == Nat.add(Nat.double(Nat.double(Word.to_nat(n, D.quotient(n, w)))), U32.to_nat(D.remainder(n, w))) : Nat}

law quotient4_value:
  for +n: Nat
  for +w: Word(n)
  {Word.to_nat(n, D.quotient(n, w)) == Nat.div(Word.to_nat(n, w), 4n) : Nat}

law u32_division4_value:
  for +w: Word(32n)
  {U32.to_nat(U32.div(U32{w}, 4)) == Nat.div(Word.to_nat(32n, w), 4n) : Nat}
