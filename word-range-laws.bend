import Base
import ./word-arithmetic.bend as W

# Every unsigned word lies strictly below its width's capacity.
law word_value_bounded:
  for +n: Nat
  for +w: Word(n)
  {Nat.is_lt(Word.to_nat(n, w), W.capacity(n)) == True{} : Bool}
