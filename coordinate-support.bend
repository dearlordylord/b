import Base
import ./coordinate-sum.bend as S
import ./coordinate-facts.bend as F
import ./capacity-facts.bend as Capacity
import ./order-facts.bend as O
import ./word-arithmetic.bend as W
import ./word-comparison-laws.bend as Compare
import ./word-comparison-proof.bend as ComparisonProof

def coordinate32(+a: Nat, h: {Nat.is_le(a, 16000n) == True{} : Bool}) -> {Nat.is_lt(a, W.capacity(32n)) == True{} : Bool}:
  O.lt_of_le_of_lt(a, W.capacity(14n), W.capacity(32n), F.coordinate14(a, h), Capacity.capacity_grows(14n, 17n))

def greater_values(+x: U32, +y: U32, +xv: Nat, +yv: Nat, hx: {U32.to_nat(x) == xv : Nat}, hy: {U32.to_nat(y) == yv : Nat}) -> {U32.is_gt(x, y) == Nat.is_gt(xv, yv) : Bool}:
  match x y:
    case U32{+xw} U32{+yw}:
      %hx : {U32.is_gt(U32{xw}, U32{yw}) == Nat.is_gt(_, yv) : Bool}
      %hy : {U32.is_gt(U32{xw}, U32{yw}) == Nat.is_gt(Word.to_nat(32n, xw), _) : Bool}
      Compare.u32_greater_exact(xw, yw)

def bounds_from_pairs(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat,
  pairs: ({Nat.is_le(ax, 16000n) == True{} : Bool} & {Nat.is_le(ay, 16000n) == True{} : Bool}) &
  ({Nat.is_le(bx, 16000n) == True{} : Bool} & {Nat.is_le(by, 16000n) == True{} : Bool}) &
  ({Nat.is_le(cx, 16000n) == True{} : Bool} & {Nat.is_le(cy, 16000n) == True{} : Bool})) -> S.Bounds<ax, ay, bx, by, cx, cy>:
  match pairs:
    case ((hax, hay), ((hbx, hby), (hcx, hcy))):
      S.Bound{hax, hay, hbx, hby, hcx, hcy}
