import Base
import ./homogeneous.bend as H
import ./word-arithmetic.bend as W

# Point coordinates <= 2^width; numerator <= 64*2^width; denominator <=64.
# At width=12 this is a strict 32-bit bound, including d=64.
law homogeneous_sum_bound:
  for +width: Nat
  for +a: Nat
  for +b: Nat
  for +d: Nat
  for +c: Nat
  for +y: Nat
  for +x: Nat
  for +e: Nat
  for hs: H.Bounds<width, a, b, d, c, y, x, e>
  {Nat.is_lt(H.exact(a, b, d, c, y, x, e), W.capacity(2n+Nat.add(Nat.add(width, width), 6n))) == True{} : Bool}

# Both the first multiplication and the complete sum must fit; all remaining
# intermediate bounds follow from the complete nonnegative sum.
law word_homogeneous_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +d: Word(n)
  for +c: Word(n)
  for +y: Word(n)
  for +x: Word(n)
  for +e: Word(n)
  for +hp: {Nat.is_lt(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), W.capacity(n)) == True{} : Bool}
  for h: {Nat.is_lt(H.word_exact(n, a, b, d, c, y, x, e), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, H.word_sum(n, a, b, d, c, y, x, e)) == H.word_exact(n, a, b, d, c, y, x, e) : Nat}
