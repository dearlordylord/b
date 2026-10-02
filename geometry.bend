import Base
import ./facts.bend as F

# Homogeneous numerator of Q(t), t=u/(u+v), with no division or rounding.
def bezier_numerator(start: Nat, control: Nat, end: Nat, +u: Nat, +v: Nat) -> Nat:
  Nat.add(Nat.add(Nat.mul(Nat.mul(v, v), start),
    Nat.mul(Nat.mul(2n, Nat.mul(u, v)), control)), Nat.mul(Nat.mul(u, u), end))

# Same point as a nonnegative combination of a cell's four corners.
def cell_numerator(l0: Nat, l1: Nat, r0: Nat, r1: Nat, +u: Nat, +v: Nat) -> Nat:
  Nat.add(Nat.add(Nat.mul(F.qa(u, v), l0), Nat.mul(F.qb(u, v), l1)),
    Nat.add(Nat.mul(F.qc(u, v), r0), Nat.mul(F.qb(u, v), r1)))

def cell_denominator(+u: Nat, +v: Nat) -> Nat:
  F.weight_total(u, v)
