import Base
import ./word-squares.bend as S
import ./word-arithmetic.bend as W

law bounded_squares_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +total: {Nat.is_lt(S.exact(n, a, b), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, S.squares(n, a, b)) == S.exact(n, a, b) : Nat}
