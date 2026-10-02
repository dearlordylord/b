import Base
import ./exact-arithmetic.bend as A
import ./arithmetic-laws.bend as L
import ./facts.bend as F

law sum_swap_tail:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  {Nat.add(Nat.add(a, b), c) == Nat.add(Nat.add(a, c), b) : Nat}
def sum_swap_tail(a, b, c):
  %Equal.sym(Nat, Nat.add(Nat.add(a, b), c), Nat.add(a, Nat.add(b, c)), F.add_assoc(a, b, c)) : {_ == Nat.add(Nat.add(a, c), b) : Nat}
  %Equal.sym(Nat, Nat.add(Nat.add(a, c), b), Nat.add(a, Nat.add(c, b)), F.add_assoc(a, c, b)) : {Nat.add(a, Nat.add(b, c)) == _ : Nat}
  Equal.cong(Nat, Nat, z => Nat.add(a, z), Nat.add(b, c), Nat.add(c, b), F.add_comm(b, c))

def L.edge_reversal_left(ax, ay, bx, by, x, y, d):
  %Equal.sym(Nat, Nat.mul(ax, by), Nat.mul(by, ax), F.mul_comm(ax, by)) : {Nat.add(Nat.add(Nat.mul(_, d), Nat.mul(bx, y)), Nat.mul(x, ay)) == A.right(bx, by, ax, ay, x, y, d) : Nat}
  %Equal.sym(Nat, Nat.mul(bx, y), Nat.mul(y, bx), F.mul_comm(bx, y)) : {Nat.add(Nat.add(Nat.mul(Nat.mul(by, ax), d), _), Nat.mul(x, ay)) == A.right(bx, by, ax, ay, x, y, d) : Nat}
  %Equal.sym(Nat, Nat.mul(x, ay), Nat.mul(ay, x), F.mul_comm(x, ay)) : {Nat.add(Nat.add(Nat.mul(Nat.mul(by, ax), d), Nat.mul(y, bx)), _) == A.right(bx, by, ax, ay, x, y, d) : Nat}
  sum_swap_tail(Nat.mul(Nat.mul(by, ax), d), Nat.mul(y, bx), Nat.mul(ay, x))

def L.edge_reversal_right(ax, ay, bx, by, x, y, d):
  L.edge_reversal_left(ay, ax, by, bx, y, x, d)
