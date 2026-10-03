import Base
import ./sample-arithmetic.bend as M
import ./sample-arithmetic-laws.bend as L
import ./word-arithmetic.bend as W
import ./capacity-facts.bend as Capacity
import ./order-facts.bend as O
import ./facts.bend as F

def L.sample_weight_partition(n, h):
  O.sub_add_cancel(64n, n, h)

def numerator_limit(+limit: Nat, +a: Nat, +b: Nat, +n: Nat, ha: {Nat.is_le(a, limit) == True{} : Bool}, hb: {Nat.is_le(b, limit) == True{} : Bool}, hn: {Nat.is_le(n, 64n) == True{} : Bool}) -> {Nat.is_le(M.numerator(a, b, n), Nat.mul(limit, 64n)) == True{} : Bool}:
  %Equal.cong(Nat, Nat, k => Nat.mul(limit, k), Nat.add(Nat.sub(64n, n), n), 64n, L.sample_weight_partition(n, hn)) : {Nat.is_le(M.numerator(a, b, n), _) == True{} : Bool}
  %Equal.sym(Nat, Nat.mul(limit, Nat.add(Nat.sub(64n, n), n)), Nat.add(Nat.mul(limit, Nat.sub(64n, n)), Nat.mul(limit, n)), F.mul_add(limit, Nat.sub(64n, n), n)) : {Nat.is_le(M.numerator(a, b, n), _) == True{} : Bool}
  O.add_le_add(Nat.mul(a, Nat.sub(64n, n)), Nat.mul(b, n), Nat.mul(limit, Nat.sub(64n, n)), Nat.mul(limit, n), O.mul_le_mul_right(a, limit, Nat.sub(64n, n), ha), O.mul_le_mul_right(b, limit, n, hb))

def L.sample_numerator_bound(width, a, b, n, ha, hb, hn):
  %Equal.sym(Nat, W.capacity(Nat.add(width, 6n)), Nat.mul(W.capacity(width), W.capacity(6n)), Capacity.capacity_product(width, 6n)) : {Nat.is_le(M.numerator(a, b, n), _) == True{} : Bool}
  numerator_limit(W.capacity(width), a, b, n, ha, hb, hn)
