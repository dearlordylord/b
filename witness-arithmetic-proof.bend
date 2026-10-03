import Base
import ./witness-arithmetic.bend as M
import ./witness-arithmetic-laws.bend as L
import ./homogeneous.bend as H
import ./homogeneous-laws.bend as Homogeneous
import ./homogeneous-word-proof.bend as WordProof
import ./homogeneous-bound-proof.bend as BoundProof
import ./word-arithmetic.bend as W
import ./word-comparison-laws.bend as Compare
import ./word-comparison-proof.bend as ComparisonProof
import ./order-facts.bend as O
import ./capacity-facts.bend as Capacity
import ./topology.bend as T

law pair_width:
  for +width: Nat
  for hw: {width == 12n : Nat}
  {Nat.add(Nat.add(width, width), 8n) == 32n : Nat}
def pair_width(width, hw):
  Equal.cong(Nat, Nat, n => Nat.add(Nat.add(n, n), 8n), width, 12n, hw)
law sum_width:
  for +width: Nat
  for hw: {width == 12n : Nat}
  {2n+Nat.add(Nat.add(width, width), 6n) == 32n : Nat}
def sum_width(width, hw):
  Equal.cong(Nat, Nat, n => 2n+Nat.add(Nat.add(n, n), 6n), width, 12n, hw)

def pair_bound(+width: Nat, hw: {width == 12n : Nat}, +a: Nat, +b: Nat, ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}, hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}) -> {Nat.is_lt(Nat.mul(a, b), W.capacity(32n)) == True{} : Bool}:
  %pair_width(width, hw) : {Nat.is_lt(Nat.mul(a, b), W.capacity(_)) == True{} : Bool}
  O.lt_of_le_of_lt(Nat.mul(a, b), W.capacity(Nat.add(width, width)), W.capacity(Nat.add(Nat.add(width, width), 8n)), BoundProof.product_widths(width, width, a, b, ha, hb), Capacity.capacity_grows(Nat.add(width, width), 7n))

def sum_bound(+width: Nat, hw: {width == 12n : Nat}, +a: Nat, +b: Nat, +d: Nat, +c: Nat, +y: Nat, +x: Nat, +e: Nat, hs: H.Bounds<width, a, b, d, c, y, x, e>) -> {Nat.is_lt(H.exact(a, b, d, c, y, x, e), W.capacity(32n)) == True{} : Bool}:
  %sum_width(width, hw) : {Nat.is_lt(H.exact(a, b, d, c, y, x, e), W.capacity(_)) == True{} : Bool}
  Homogeneous.homogeneous_sum_bound(width, a, b, d, c, y, x, e, hs)

def pair_at_width(+n: Nat, hn: {n == 32n : Nat}, +width: Nat, hw: {width == 12n : Nat}, +a: Nat, +b: Nat, ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}, hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}) -> {Nat.is_lt(Nat.mul(a, b), W.capacity(n)) == True{} : Bool}:
  %Equal.sym(Nat, n, 32n, hn) : {Nat.is_lt(Nat.mul(a, b), W.capacity(_)) == True{} : Bool}
  pair_bound(width, hw, a, b, ha, hb)
def sum_at_width(+n: Nat, hn: {n == 32n : Nat}, +width: Nat, hw: {width == 12n : Nat}, +a: Nat, +b: Nat, +d: Nat, +c: Nat, +y: Nat, +x: Nat, +e: Nat, hs: H.Bounds<width, a, b, d, c, y, x, e>) -> {Nat.is_lt(H.exact(a, b, d, c, y, x, e), W.capacity(n)) == True{} : Bool}:
  %Equal.sym(Nat, n, 32n, hn) : {Nat.is_lt(H.exact(a, b, d, c, y, x, e), W.capacity(_)) == True{} : Bool}
  sum_bound(width, hw, a, b, d, c, y, x, e, hs)

def half_exact(+n: Nat, +hn: {n == 32n : Nat}, +width: Nat, +hw: {width == 12n : Nat}, +a: Word(n), +b: Word(n), +d: Word(n), +c: Word(n), +y: Word(n), +x: Word(n), +e: Word(n), hs: H.Bounds<width, Word.to_nat(n, a), Word.to_nat(n, b), Word.to_nat(n, d), Word.to_nat(n, c), Word.to_nat(n, y), Word.to_nat(n, x), Word.to_nat(n, e)>) -> {Word.to_nat(n, H.word_sum(n, a, b, d, c, y, x, e)) == H.word_exact(n, a, b, d, c, y, x, e) : Nat}:
  match hs:
    case H.Bound{+ha, +hb, hd, hc, hy, hx, he}:
      Homogeneous.word_homogeneous_exact(n, a, b, d, c, y, x, e, pair_at_width(n, hn, width, hw, Word.to_nat(n, a), Word.to_nat(n, b), ha, hb), sum_at_width(n, hn, width, hw, Word.to_nat(n, a), Word.to_nat(n, b), Word.to_nat(n, d), Word.to_nat(n, c), Word.to_nat(n, y), Word.to_nat(n, x), Word.to_nat(n, e), H.Bound{ha, hb, hd, hc, hy, hx, he}))

def cmp_values(+a: U32, +b: U32, +x: Nat, +y: Nat, ha: {U32.to_nat(a) == x : Nat}, hb: {U32.to_nat(b) == y : Nat}) -> {U32.cmp(a, b) == Nat.cmp(x, y) : Cmp}:
  match a b:
    case U32{+av} U32{+bv}:
      Equal.trans(Cmp, U32.cmp(U32{av}, U32{bv}), Nat.cmp(Word.to_nat(32n, av), Word.to_nat(32n, bv)), Nat.cmp(x, y), Compare.u32_comparison_exact(av, bv), Equal.trans(Cmp, Nat.cmp(Word.to_nat(32n, av), Word.to_nat(32n, bv)), Nat.cmp(x, Word.to_nat(32n, bv)), Nat.cmp(x, y), Equal.cong(Nat, Cmp, z => Nat.cmp(z, Word.to_nat(32n, bv)), Word.to_nat(32n, av), x, ha), Equal.cong(Nat, Cmp, z => Nat.cmp(x, z), Word.to_nat(32n, bv), y, hb)))

def L.guarded_side_exact(width, hw, ax, ay, bx, by, x, y, d, hs):
  match hs:
    case M.Bound{+hax, +hay, +hbx, +hby, +hx, +hy, +hd}:
      cmp_values(U32{H.word_sum(32n, ax, by, d, bx, y, x, ay)}, U32{H.word_sum(32n, ay, bx, d, by, x, y, ax)}, H.word_exact(32n, ax, by, d, bx, y, x, ay), H.word_exact(32n, ay, bx, d, by, x, y, ax), half_exact(32n, {==}, width, hw, ax, by, d, bx, y, x, ay, H.Bound{hax, hby, hd, hbx, hy, hx, hay}), half_exact(32n, {==}, width, hw, ay, bx, d, by, x, y, ax, H.Bound{hay, hbx, hd, hby, hx, hy, hax}))
