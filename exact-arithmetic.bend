import Base

# Exact homogeneous orientation model. The determinant is represented by
# two nonnegative sums, avoiding truncated subtraction and fixed-width wrap.
def product3(a: Nat, b: Nat, d: Nat) -> Nat:
  Nat.mul(Nat.mul(a, b), d)
def cyclic_sum(ax: Nat, by: Nat, bx: Nat, y: Nat, x: Nat, ay: Nat, d: Nat) -> Nat:
  Nat.add(Nat.add(product3(ax, by, d), Nat.mul(bx, y)), Nat.mul(x, ay))
def left(ax: Nat, ay: Nat, bx: Nat, by: Nat, x: Nat, y: Nat, d: Nat) -> Nat:
  cyclic_sum(ax, by, bx, y, x, ay, d)
def right(ax: Nat, ay: Nat, bx: Nat, by: Nat, x: Nat, y: Nat, d: Nat) -> Nat:
  cyclic_sum(ay, bx, by, x, y, ax, d)
def orientation(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat) -> Cmp:
  Nat.cmp(left(ax, ay, bx, by, x, y, d), right(ax, ay, bx, by, x, y, d))
