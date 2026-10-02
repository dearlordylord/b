import Base

def complement(+n: Nat, w: Word(n)) -> Word(n):
  Word.not(n, w)
def maximum(n: Nat) -> Nat:
  match n:
    case 0n: 0n
    case 1n+p: 1n+Nat.double(maximum(p))
