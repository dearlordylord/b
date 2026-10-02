import Base
import ./facts.bend as F

# The natural-number algebra needed by the shift-and-add loop invariant.
law double_eq_add:
  for +a: Nat
  {Nat.double(a) == Nat.add(a, a) : Nat}
def double_eq_add(a):
  match a:
    case 0n: {==}
    case 1n+p:
      %Equal.sym(Nat, Nat.add(p, 1n+p), 1n+Nat.add(p, p), F.add_succ(p, p)) : {2n+Nat.double(p) == 1n+_ : Nat}
      Equal.cong(Nat, Nat, z => 2n+z, Nat.double(p), Nat.add(p, p), double_eq_add(p))

law double_mul:
  for +a: Nat
  for +b: Nat
  {Nat.mul(Nat.double(a), b) == Nat.mul(a, Nat.double(b)) : Nat}
def double_mul(a, b):
  match a:
    case 0n: {==}
    case 1n+p:
      %Equal.sym(Nat, Nat.mul(Nat.double(p), b), Nat.mul(p, Nat.double(b)), double_mul(p, b)) : {Nat.add(b, Nat.add(b, _)) == Nat.add(Nat.double(b), Nat.mul(p, Nat.double(b))) : Nat}
      %Equal.sym(Nat, Nat.double(b), Nat.add(b, b), double_eq_add(b)) : {Nat.add(b, Nat.add(b, Nat.mul(p, Nat.double(b)))) == Nat.add(_, Nat.mul(p, Nat.double(b))) : Nat}
      Equal.sym(Nat, Nat.add(Nat.add(b, b), Nat.mul(p, Nat.double(b))), Nat.add(b, Nat.add(b, Nat.mul(p, Nat.double(b)))), F.add_assoc(b, b, Nat.mul(p, Nat.double(b))))
