import Base
import ./coordinate-limit.bend as Limit
import ./word-arithmetic.bend as W
import ./coordinate-sum.bend as S
import ./coordinate-sum-laws.bend as L
import ./coordinate-facts.bend as C
import ./capacity-facts.bend as Capacity
import ./order-facts.bend as O

law sum_width_bound:
  for +width: Nat
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}
  for hc: {Nat.is_le(c, W.capacity(width)) == True{} : Bool}
  for hd: {Nat.is_le(d, W.capacity(width)) == True{} : Bool}
  for he: {Nat.is_le(e, W.capacity(width)) == True{} : Bool}
  for hf: {Nat.is_le(f, W.capacity(width)) == True{} : Bool}
  {Nat.is_le(S.exact(a, b, c, d, e, f), W.capacity(2n+Nat.add(width, width))) == True{} : Bool}
def sum_width_bound(width, a, b, c, d, e, f, ha, hb, hc, hd, he, hf):
  O.le_trans(S.exact(a, b, c, d, e, f), Nat.add(Nat.add(W.capacity(Nat.add(width, width)), W.capacity(Nat.add(width, width))), W.capacity(Nat.add(width, width))), W.capacity(2n+Nat.add(width, width)), O.add_le_add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.mul(e, f), Nat.add(W.capacity(Nat.add(width, width)), W.capacity(Nat.add(width, width))), W.capacity(Nat.add(width, width)), O.add_le_add(Nat.mul(a, b), Nat.mul(c, d), W.capacity(Nat.add(width, width)), W.capacity(Nat.add(width, width)), C.product_from_width(width, a, b, ha, hb), C.product_from_width(width, c, d, hc, hd)), C.product_from_width(width, e, f, he, hf)), C.triple_le_fourfold(W.capacity(Nat.add(width, width))))

law sum_width_fits:
  for +width: Nat
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}
  for hc: {Nat.is_le(c, W.capacity(width)) == True{} : Bool}
  for hd: {Nat.is_le(d, W.capacity(width)) == True{} : Bool}
  for he: {Nat.is_le(e, W.capacity(width)) == True{} : Bool}
  for hf: {Nat.is_le(f, W.capacity(width)) == True{} : Bool}
  {Nat.is_lt(S.exact(a, b, c, d, e, f), W.capacity(Nat.add(2n+Nat.add(width, width), 2n))) == True{} : Bool}
def sum_width_fits(width, a, b, c, d, e, f, ha, hb, hc, hd, he, hf):
  O.lt_of_le_of_lt(S.exact(a, b, c, d, e, f), W.capacity(2n+Nat.add(width, width)), W.capacity(Nat.add(2n+Nat.add(width, width), 2n)), sum_width_bound(width, a, b, c, d, e, f, ha, hb, hc, hd, he, hf), Capacity.capacity_grows(2n+Nat.add(width, width), 1n))

def coordinate_width(+width: Nat, +a: Nat, hw: {width == 14n : Nat}, h: {Nat.is_le(a, Limit.maximum()) == True{} : Bool}) -> {Nat.is_le(a, W.capacity(width)) == True{} : Bool}:
  %Equal.sym(Nat, width, 14n, hw) : {Nat.is_le(a, W.capacity(_)) == True{} : Bool}
  C.coordinate14(a, h)

law final_width:
  for +width: Nat
  for hw: {width == 14n : Nat}
  {Nat.add(2n+Nat.add(width, width), 2n) == 32n : Nat}
def final_width(width, hw):
  Equal.cong(Nat, Nat, n => Nat.add(2n+Nat.add(n, n), 2n), width, 14n, hw)

def L.guarded_sum32_bound(width, hw, a, b, c, d, e, f, hs):
  match hs:
    case S.Bound{ha, hb, hc, hd, he, hf}:
      %final_width(width, hw) : {Nat.is_lt(S.exact(a, b, c, d, e, f), W.capacity(_)) == True{} : Bool}
      sum_width_fits(width, a, b, c, d, e, f, coordinate_width(width, a, hw, ha), coordinate_width(width, b, hw, hb), coordinate_width(width, c, hw, hc), coordinate_width(width, d, hw, hd), coordinate_width(width, e, hw, he), coordinate_width(width, f, hw, hf))

def L.coordinate_sum32_bound(a, b, c, d, e, f, hs):
  L.guarded_sum32_bound(14n, {==}, a, b, c, d, e, f, hs)
