import Base
import ./word-arithmetic.bend as W
import ./word-range-proof.bend as Range
import ./boolean-reflection.bend as V
import ./arithmetic-product-proof.bend as A
import ./facts.bend as F

law capacity_positive:
  for +n: Nat
  {Nat.is_lt(0n, W.capacity(n)) == True{} : Bool}
def positive_double(+a: Nat, h: {Nat.is_lt(0n, a) == True{} : Bool}) -> {Nat.is_lt(0n, Nat.double(a)) == True{} : Bool}:
  match a:
    case 0n: V.absurd({False{} == True{} : Bool}, V.false_impossible(h))
    case 1n+p: {==}
def capacity_positive(n):
  match n:
    case 0n: {==}
    case 1n+p: positive_double(W.capacity(p), capacity_positive(p))

# Increasing width strictly increases unsigned capacity.
law capacity_grows:
  for +n: Nat
  for +k: Nat
  {Nat.is_lt(W.capacity(n), W.capacity(Nat.add(n, 1n+k))) == True{} : Bool}
def capacity_grows(n, k):
  match n:
    case 0n: Range.odd_lt(0n, W.capacity(k), capacity_positive(k))
    case 1n+p:
      Range.even_lt(W.capacity(p), W.capacity(Nat.add(p, 1n+k)), capacity_grows(p, k))

law double_product:
  for +a: Nat
  for +b: Nat
  {Nat.double(Nat.mul(a, b)) == Nat.mul(Nat.double(a), b) : Nat}
def double_product(a, b):
  %Equal.sym(Nat, Nat.double(a), Nat.add(a, a), A.double_eq_add(a)) : {Nat.double(Nat.mul(a, b)) == Nat.mul(_, b) : Nat}
  Equal.trans(Nat, Nat.double(Nat.mul(a, b)), Nat.add(Nat.mul(a, b), Nat.mul(a, b)), Nat.mul(Nat.add(a, a), b), A.double_eq_add(Nat.mul(a, b)), Equal.sym(Nat, Nat.mul(Nat.add(a, a), b), Nat.add(Nat.mul(a, b), Nat.mul(a, b)), F.add_mul(a, a, b)))

# Bit widths add under multiplication of capacities: 2^(n+m) = 2^n * 2^m.
law capacity_product:
  for +n: Nat
  for +m: Nat
  {W.capacity(Nat.add(n, m)) == Nat.mul(W.capacity(n), W.capacity(m)) : Nat}
def capacity_product(n, m):
  match n:
    case 0n: Equal.sym(Nat, Nat.add(W.capacity(m), 0n), W.capacity(m), F.add_zero(W.capacity(m)))
    case 1n+p:
      Equal.trans(Nat, Nat.double(W.capacity(Nat.add(p, m))), Nat.double(Nat.mul(W.capacity(p), W.capacity(m))), Nat.mul(Nat.double(W.capacity(p)), W.capacity(m)), Equal.cong(Nat, Nat, x => Nat.double(x), W.capacity(Nat.add(p, m)), Nat.mul(W.capacity(p), W.capacity(m)), capacity_product(p, m)), double_product(W.capacity(p), W.capacity(m)))
