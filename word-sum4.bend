import Base

def sum4(+n: Nat, a: Word(n), b: Word(n), c: Word(n), d: Word(n), e: Word(n), f: Word(n), g: Word(n), h: Word(n)) -> Word(n):
  Word.add(n, Word.add(n, Word.mul(n, a, b), Word.mul(n, c, d)), Word.add(n, Word.mul(n, e, f), Word.mul(n, g, h)))
def exact(+n: Nat, a: Word(n), b: Word(n), c: Word(n), d: Word(n), e: Word(n), f: Word(n), g: Word(n), h: Word(n)) -> Nat:
  Nat.add(Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.add(Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), Nat.mul(Word.to_nat(n, g), Word.to_nat(n, h))))
