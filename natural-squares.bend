import Base

def exact(+a: Nat, +b: Nat) -> Nat:
  Nat.add(Nat.mul(a, a), Nat.mul(b, b))
