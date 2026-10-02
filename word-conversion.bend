import Base

# Width-polymorphic counterpart of Base U32.from_nat.
def from_nat(k: Nat, +n: Nat) -> Word(n):
  match k:
    case 0n: Word.zero(n)
    case 1n+p: Word.inc(n, from_nat(p, n))
