import Base
import ./word-arithmetic.bend as W
import ./word-sum3.bend as S

# The final exact bound implies all product and partial-sum bounds.
law sum3_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Word(n)
  for +d: Word(n)
  for +e: Word(n)
  for +f: Word(n)
  for h: {Nat.is_lt(S.exact(n, a, b, c, d, e, f), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, S.sum3(n, a, b, c, d, e, f)) == S.exact(n, a, b, c, d, e, f) : Nat}

law u32_sum3_exact:
  for +a: Word(32n)
  for +b: Word(32n)
  for +c: Word(32n)
  for +d: Word(32n)
  for +e: Word(32n)
  for +f: Word(32n)
  for h: {Nat.is_lt(S.exact(32n, a, b, c, d, e, f), W.capacity(32n)) == True{} : Bool}
  {U32.to_nat(S.u32_sum3(U32{a}, U32{b}, U32{c}, U32{d}, U32{e}, U32{f})) == S.exact(32n, a, b, c, d, e, f) : Nat}
