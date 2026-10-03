import Base

# Exact nonnegative distance between two natural coordinates.
def choice(+a: Nat, +b: Nat, less: Bool) -> Nat:
  Bool.pick(Nat, less, Nat.sub(b, a), Nat.sub(a, b))
def exact(+a: Nat, +b: Nat) -> Nat:
  choice(a, b, Nat.is_lt(a, b))
