import Base

# The implementation is the actual Base shift-and-add algorithm.
def loop(+m: Nat, +n: Nat, a: Word(m), b: Word(n), acc: Word(n)) -> Word(n):
  Word.mul.go(n, m, a, b, acc)
def multiply(+n: Nat, a: Word(n), b: Word(n)) -> Word(n):
  Word.mul(n, a, b)
def total(+m: Nat, +n: Nat, a: Word(m), b: Word(n), acc: Word(n)) -> Nat:
  Nat.add(Nat.mul(Word.to_nat(m, a), Word.to_nat(n, b)), Word.to_nat(n, acc))
