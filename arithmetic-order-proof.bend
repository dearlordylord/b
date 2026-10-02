import Base
import ./validation-proof.bend as V

# Supporting order facts for deriving bounds on intermediates from total sums.
law not_lt_zero:
  for +a: Nat
  {Nat.is_lt(a, 0n) == False{} : Bool}
def not_lt_zero(a):
  match a:
    case 0n: {==}
    case 1n+p: {==}

law summand_bound:
  for +a: Nat
  for +b: Nat
  for +limit: Nat
  for h: {Nat.is_lt(Nat.add(a, b), limit) == True{} : Bool}
  {Nat.is_lt(a, limit) == True{} : Bool}
def summand_bound(a, b, limit, h):
  match a limit:
    case 0n 0n:
      V.absurd({Nat.is_lt(0n, 0n) == True{} : Bool}, V.false_impossible(Equal.trans(Bool, False{}, Nat.is_lt(b, 0n), True{}, Equal.sym(Bool, Nat.is_lt(b, 0n), False{}, not_lt_zero(b)), h)))
    case 0n 1n+p: {==}
    case 1n+a 0n:
      V.absurd({Nat.is_lt(1n+a, 0n) == True{} : Bool}, V.false_impossible(h))
    case 1n+a 1n+p:
      summand_bound(a, b, p, h)
