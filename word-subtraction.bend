import Base
import ./word-arithmetic.bend as W

def carry(+n: Nat, a: Word(n), b: Word(n), c: Bool) -> W.Carry<n>:
  W.add_carry(n, a, Word.not(n, b), c)
def carry_from_comparison(t: Cmp, c: Bool) -> Bool:
  match t:
    case LT{}: False{}
    case EQ{}: c
    case GT{}: True{}
def subtract(+n: Nat, a: Word(n), b: Word(n)) -> Word(n):
  Word.sub(n, a, b)
