import Base
import ./word-arithmetic.bend as W
import ./word-range-laws.bend as R
import ./word-range-proof.bend as P
import ./order-facts.bend as O
import ./capacity-facts.bend as Capacity
import ./arithmetic-product-proof.bend as A
import ./facts.bend as F

def threshold_value() -> {Word.to_nat(14n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{True{}, WCon{False{}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}}}}}}}}}}}}) == 16000n : Nat}:
  {==}
def threshold_lt() -> {Nat.is_lt(16000n, W.capacity(14n)) == True{} : Bool}:
  R.word_value_bounded(14n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WCon{True{}, WCon{False{}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}}}}}}}}}}}})

law coordinate14:
  for +a: Nat
  for h: {Nat.is_le(a, 16000n) == True{} : Bool}
  {Nat.is_le(a, W.capacity(14n)) == True{} : Bool}
def coordinate14(a, h):
  O.le_trans(a, 16000n, W.capacity(14n), h, O.le_of_lt(16000n, W.capacity(14n), threshold_lt()))

law product_from_width:
  for +n: Nat
  for +a: Nat
  for +b: Nat
  for ha: {Nat.is_le(a, W.capacity(n)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(n)) == True{} : Bool}
  {Nat.is_le(Nat.mul(a, b), W.capacity(Nat.add(n, n))) == True{} : Bool}
def product_from_width(n, a, b, ha, hb):
  %Equal.sym(Nat, W.capacity(Nat.add(n, n)), Nat.mul(W.capacity(n), W.capacity(n)), Capacity.capacity_product(n, n)) : {Nat.is_le(Nat.mul(a, b), _) == True{} : Bool}
  O.mul_le_mul(a, b, W.capacity(n), W.capacity(n), ha, hb)

law fourfold:
  for +a: Nat
  {Nat.double(Nat.double(a)) == Nat.add(Nat.add(Nat.add(a, a), a), a) : Nat}
def fourfold(a):
  Equal.trans(Nat, Nat.double(Nat.double(a)), Nat.add(Nat.double(a), Nat.double(a)), Nat.add(Nat.add(Nat.add(a, a), a), a), A.double_eq_add(Nat.double(a)), Equal.trans(Nat, Nat.add(Nat.double(a), Nat.double(a)), Nat.add(Nat.add(a, a), Nat.add(a, a)), Nat.add(Nat.add(Nat.add(a, a), a), a), Equal.trans(Nat, Nat.add(Nat.double(a), Nat.double(a)), Nat.add(Nat.add(a, a), Nat.double(a)), Nat.add(Nat.add(a, a), Nat.add(a, a)), Equal.cong(Nat, Nat, z => Nat.add(z, Nat.double(a)), Nat.double(a), Nat.add(a, a), A.double_eq_add(a)), Equal.cong(Nat, Nat, z => Nat.add(Nat.add(a, a), z), Nat.double(a), Nat.add(a, a), A.double_eq_add(a))), Equal.sym(Nat, Nat.add(Nat.add(Nat.add(a, a), a), a), Nat.add(Nat.add(a, a), Nat.add(a, a)), F.add_assoc(Nat.add(a, a), a, a))))

law triple_le_fourfold:
  for +a: Nat
  {Nat.is_le(Nat.add(Nat.add(a, a), a), Nat.double(Nat.double(a))) == True{} : Bool}
def triple_le_fourfold(a):
  %Equal.sym(Nat, Nat.double(Nat.double(a)), Nat.add(Nat.add(Nat.add(a, a), a), a), fourfold(a)) : {Nat.is_le(Nat.add(Nat.add(a, a), a), _) == True{} : Bool}
  O.le_add_right(Nat.add(Nat.add(a, a), a), a)
