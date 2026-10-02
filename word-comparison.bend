import Base

# Comparison implemented by the real Base bit-word comparator.
def compare(+n: Nat, a: Word(n), b: Word(n)) -> Cmp:
  Word.cmp(n, a, b)
