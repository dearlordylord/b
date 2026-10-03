import Base
import ./coordinate-sum4.bend as S
import ./coordinate-sum4-laws.bend as L
import ./coordinate-dot-proof.bend as Existing
import ./coordinate-sum-proof.bend as Three
import ./coordinate-facts.bend as C
import ./capacity-facts.bend as Capacity
import ./order-facts.bend as O
import ./word-arithmetic.bend as W
import ./arithmetic-product-proof.bend as A

law paired_double:
  for +a: Nat
  {Nat.add(Nat.add(a, a), Nat.add(a, a)) == Nat.double(Nat.double(a)) : Nat}
def paired_double(a):
  Equal.trans(Nat, Nat.add(Nat.add(a, a), Nat.add(a, a)), Nat.double(Nat.add(a, a)), Nat.double(Nat.double(a)), Equal.sym(Nat, Nat.double(Nat.add(a, a)), Nat.add(Nat.add(a, a), Nat.add(a, a)), A.double_eq_add(Nat.add(a, a))), Equal.cong(Nat, Nat, x => Nat.double(x), Nat.add(a, a), Nat.double(a), Equal.sym(Nat, Nat.double(a), Nat.add(a, a), A.double_eq_add(a))))

law width_bound:
  for +width: Nat
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for +g: Nat
  for +h: Nat
  for ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}
  for hc: {Nat.is_le(c, W.capacity(width)) == True{} : Bool}
  for hd: {Nat.is_le(d, W.capacity(width)) == True{} : Bool}
  for he: {Nat.is_le(e, W.capacity(width)) == True{} : Bool}
  for hf: {Nat.is_le(f, W.capacity(width)) == True{} : Bool}
  for hg: {Nat.is_le(g, W.capacity(width)) == True{} : Bool}
  for hh: {Nat.is_le(h, W.capacity(width)) == True{} : Bool}
  {Nat.is_le(S.exact(a, b, c, d, e, f, g, h), W.capacity(2n+Nat.add(width, width))) == True{} : Bool}
def width_bound(width, a, b, c, d, e, f, g, h, ha, hb, hc, hd, he, hf, hg, hh):
  %paired_double(W.capacity(Nat.add(width, width))) : {Nat.is_le(S.exact(a, b, c, d, e, f, g, h), _) == True{} : Bool}
  O.add_le_add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.add(Nat.mul(e, f), Nat.mul(g, h)), Nat.add(W.capacity(Nat.add(width, width)), W.capacity(Nat.add(width, width))), Nat.add(W.capacity(Nat.add(width, width)), W.capacity(Nat.add(width, width))), O.add_le_add(Nat.mul(a, b), Nat.mul(c, d), W.capacity(Nat.add(width, width)), W.capacity(Nat.add(width, width)), C.product_from_width(width, a, b, ha, hb), C.product_from_width(width, c, d, hc, hd)), O.add_le_add(Nat.mul(e, f), Nat.mul(g, h), W.capacity(Nat.add(width, width)), W.capacity(Nat.add(width, width)), C.product_from_width(width, e, f, he, hf), C.product_from_width(width, g, h, hg, hh)))

law width_fits:
  for +width: Nat
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for +g: Nat
  for +h: Nat
  for ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}
  for hc: {Nat.is_le(c, W.capacity(width)) == True{} : Bool}
  for hd: {Nat.is_le(d, W.capacity(width)) == True{} : Bool}
  for he: {Nat.is_le(e, W.capacity(width)) == True{} : Bool}
  for hf: {Nat.is_le(f, W.capacity(width)) == True{} : Bool}
  for hg: {Nat.is_le(g, W.capacity(width)) == True{} : Bool}
  for hh: {Nat.is_le(h, W.capacity(width)) == True{} : Bool}
  {Nat.is_lt(S.exact(a, b, c, d, e, f, g, h), W.capacity(Nat.add(2n+Nat.add(width, width), 2n))) == True{} : Bool}
def width_fits(width, a, b, c, d, e, f, g, h, ha, hb, hc, hd, he, hf, hg, hh):
  O.lt_of_le_of_lt(S.exact(a, b, c, d, e, f, g, h), W.capacity(2n+Nat.add(width, width)), W.capacity(Nat.add(2n+Nat.add(width, width), 2n)), width_bound(width, a, b, c, d, e, f, g, h, ha, hb, hc, hd, he, hf, hg, hh), Capacity.capacity_grows(2n+Nat.add(width, width), 1n))

def guarded_width(+width: Nat, +hw: {width == 14n : Nat}, +a: Nat, +b: Nat, +c: Nat, +d: Nat, +e: Nat, +f: Nat, +g: Nat, +h: Nat, hs: S.Bounds<a, b, c, d, e, f, g, h>) -> {Nat.is_lt(S.exact(a, b, c, d, e, f, g, h), W.capacity(32n)) == True{} : Bool}:
  match hs:
    case S.Bound{ha, hb, hc, hd, he, hf, hg, hh}:
      %Three.final_width(width, hw) : {Nat.is_lt(S.exact(a, b, c, d, e, f, g, h), W.capacity(_)) == True{} : Bool}
      width_fits(width, a, b, c, d, e, f, g, h, Three.coordinate_width(width, a, hw, ha), Three.coordinate_width(width, b, hw, hb), Three.coordinate_width(width, c, hw, hc), Three.coordinate_width(width, d, hw, hd), Three.coordinate_width(width, e, hw, he), Three.coordinate_width(width, f, hw, hf), Three.coordinate_width(width, g, hw, hg), Three.coordinate_width(width, h, hw, hh))

def L.coordinate_sum4_bound(a, b, c, d, e, f, g, h, hs):
  guarded_width(14n, {==}, a, b, c, d, e, f, g, h, hs)
