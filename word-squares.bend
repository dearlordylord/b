import Base
import ./natural-squares.bend as N

def squares(+n: Nat, +a: Word(n), +b: Word(n)) -> Word(n):
  Word.add(n, Word.mul(n, a, a), Word.mul(n, b, b))
def exact(+n: Nat, a: Word(n), b: Word(n)) -> Nat:
  N.exact(Word.to_nat(n, a), Word.to_nat(n, b))
