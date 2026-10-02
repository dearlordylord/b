import Base
import ./exact-arithmetic.bend as A

# Swapping the edge endpoints exchanges the two determinant sums.
# This is the arithmetic foundation for reversing a closed half-plane.
law edge_reversal_left:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +x: Nat
  for +y: Nat
  for +d: Nat
  {A.left(ax, ay, bx, by, x, y, d) == A.right(bx, by, ax, ay, x, y, d) : Nat}

law edge_reversal_right:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +x: Nat
  for +y: Nat
  for +d: Nat
  {A.right(ax, ay, bx, by, x, y, d) == A.left(bx, by, ax, ay, x, y, d) : Nat}
