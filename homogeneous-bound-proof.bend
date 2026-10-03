import Base
import ./homogeneous.bend as H
import ./homogeneous-laws.bend as L
import ./word-arithmetic.bend as W
import ./order-facts.bend as O
import ./capacity-facts.bend as Capacity
import ./coordinate-facts.bend as C
import ./facts.bend as F

law lt_add_positive:
  for +a: Nat
  for +b: Nat
  for hb: {Nat.is_lt(0n, b) == True{} : Bool}
  {Nat.is_lt(a, Nat.add(a, b)) == True{} : Bool}
def lt_add_positive(a, b, hb):
  match a:
    case 0n: hb
    case 1n+p: lt_add_positive(p, b, hb)

law triple_lt_fourfold:
  for +a: Nat
  for ha: {Nat.is_lt(0n, a) == True{} : Bool}
  {Nat.is_lt(Nat.add(Nat.add(a, a), a), Nat.double(Nat.double(a))) == True{} : Bool}
def triple_lt_fourfold(a, ha):
  %Equal.sym(Nat, Nat.double(Nat.double(a)), Nat.add(Nat.add(Nat.add(a, a), a), a), C.fourfold(a)) : {Nat.is_lt(Nat.add(Nat.add(a, a), a), _) == True{} : Bool}
  lt_add_positive(Nat.add(Nat.add(a, a), a), a, ha)

law product_widths:
  for +n: Nat
  for +m: Nat
  for +a: Nat
  for +b: Nat
  for ha: {Nat.is_le(a, W.capacity(n)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(m)) == True{} : Bool}
  {Nat.is_le(Nat.mul(a, b), W.capacity(Nat.add(n, m))) == True{} : Bool}
def product_widths(n, m, a, b, ha, hb):
  %Equal.sym(Nat, W.capacity(Nat.add(n, m)), Nat.mul(W.capacity(n), W.capacity(m)), Capacity.capacity_product(n, m)) : {Nat.is_le(Nat.mul(a, b), _) == True{} : Bool}
  O.mul_le_mul(a, b, W.capacity(n), W.capacity(m), ha, hb)

law sum_three_bound:
  for +n: Nat
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for ha: {Nat.is_le(a, W.capacity(n)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(n)) == True{} : Bool}
  for hc: {Nat.is_le(c, W.capacity(n)) == True{} : Bool}
  {Nat.is_lt(Nat.add(Nat.add(a, b), c), W.capacity(2n+n)) == True{} : Bool}
def sum_three_bound(n, a, b, c, ha, hb, hc):
  O.lt_of_le_of_lt(Nat.add(Nat.add(a, b), c), Nat.add(Nat.add(W.capacity(n), W.capacity(n)), W.capacity(n)), W.capacity(2n+n), O.add_le_add(Nat.add(a, b), c, Nat.add(W.capacity(n), W.capacity(n)), W.capacity(n), O.add_le_add(a, b, W.capacity(n), W.capacity(n), ha, hb), hc), triple_lt_fourfold(W.capacity(n), Capacity.capacity_positive(n)))

law mixed_width:
  for +n: Nat
  {Nat.add(n, Nat.add(n, 6n)) == Nat.add(Nat.add(n, n), 6n) : Nat}
def mixed_width(n):
  Equal.sym(Nat, Nat.add(Nat.add(n, n), 6n), Nat.add(n, Nat.add(n, 6n)), F.add_assoc(n, n, 6n))

law reverse_width:
  for +n: Nat
  {Nat.add(Nat.add(n, 6n), n) == Nat.add(Nat.add(n, n), 6n) : Nat}
def reverse_width(n):
  Equal.trans(Nat, Nat.add(Nat.add(n, 6n), n), Nat.add(n, Nat.add(n, 6n)), Nat.add(Nat.add(n, n), 6n), F.add_comm(Nat.add(n, 6n), n), mixed_width(n))

def right_product(+n: Nat, +a: Nat, +b: Nat, ha: {Nat.is_le(a, W.capacity(n)) == True{} : Bool}, hb: {Nat.is_le(b, W.capacity(Nat.add(n, 6n))) == True{} : Bool}) -> {Nat.is_le(Nat.mul(a, b), W.capacity(Nat.add(Nat.add(n, n), 6n))) == True{} : Bool}:
  %mixed_width(n) : {Nat.is_le(Nat.mul(a, b), W.capacity(_)) == True{} : Bool}
  product_widths(n, Nat.add(n, 6n), a, b, ha, hb)
def left_product(+n: Nat, +a: Nat, +b: Nat, ha: {Nat.is_le(a, W.capacity(Nat.add(n, 6n))) == True{} : Bool}, hb: {Nat.is_le(b, W.capacity(n)) == True{} : Bool}) -> {Nat.is_le(Nat.mul(a, b), W.capacity(Nat.add(Nat.add(n, n), 6n))) == True{} : Bool}:
  %reverse_width(n) : {Nat.is_le(Nat.mul(a, b), W.capacity(_)) == True{} : Bool}
  product_widths(Nat.add(n, 6n), n, a, b, ha, hb)

def L.homogeneous_sum_bound(width, a, b, d, c, y, x, e, hs):
  match hs:
    case H.Bound{ha, hb, hd, hc, hy, hx, he}:
      sum_three_bound(Nat.add(Nat.add(width, width), 6n), Nat.mul(Nat.mul(a, b), d), Nat.mul(c, y), Nat.mul(x, e), product_widths(Nat.add(width, width), 6n, Nat.mul(a, b), d, product_widths(width, width, a, b, ha, hb), hd), right_product(width, c, y, hc, hy), left_product(width, x, e, hx, he))
