import Base
import ./word-sum4.bend as S
import ./word-arithmetic.bend as W

law sum4_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Word(n)
  for +d: Word(n)
  for +e: Word(n)
  for +f: Word(n)
  for +g: Word(n)
  for +h: Word(n)
  for +total: {Nat.is_lt(S.exact(n, a, b, c, d, e, f, g, h), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, S.sum4(n, a, b, c, d, e, f, g, h)) == S.exact(n, a, b, c, d, e, f, g, h) : Nat}
