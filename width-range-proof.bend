import Base
import ./core.bend as C
import ./validation.bend as V
import ./width-range.bend as M
import ./width-range-laws.bend as L
import ./coordinate-width-laws.bend as Width
import ./coordinate-width-proof.bend as WidthProof
import ./word-comparison-laws.bend as Compare
import ./word-comparison-proof.bend as CompareProof
import ./edge-arithmetic-proof.bend as Edge

def interval_exact(+lo: U32, +hi: U32, +n: U32) -> {U32.is_le(lo, n) && U32.is_le(n, hi) == Nat.is_le(U32.to_nat(lo), U32.to_nat(n)) && Nat.is_le(U32.to_nat(n), U32.to_nat(hi)) : Bool}:
  match lo hi n:
    case U32{+l} U32{+h} U32{+w}:
      Edge.and_two(U32.is_le(U32{l}, U32{w}), U32.is_le(U32{w}, U32{h}), Nat.is_le(Word.to_nat(32n, l), Word.to_nat(32n, w)), Nat.is_le(Word.to_nat(32n, w), Word.to_nat(32n, h)), Compare.u32_less_equal_exact(l, w), Compare.u32_less_equal_exact(w, h))
def L.width_in_range_arithmetic_exact(lower, upper, hlower, hupper, n):
  %hlower : {U32.is_le(_, n) && U32.is_le(n, 6760000) == M.in_range(lower, upper, U32.to_nat(n)) : Bool}
  %hupper : {U32.is_le(lower, n) && U32.is_le(n, _) == M.in_range(lower, upper, U32.to_nat(n)) : Bool}
  interval_exact(lower, upper, n)
def accepted_width(+a: C.Point, +b: C.Point, ha: {V.point_bounded(a) == True{} : Bool}, hb: {V.point_bounded(b) == True{} : Bool}) -> {U32.to_nat(V.width_squared(a, b)) == M.width(a, b) : Nat}:
  match a b:
    case C.Pt{x, y} C.Pt{z, w}: Width.accepted_points_width(x, y, z, w, ha, hb)
def L.accepted_width_range(lower, upper, hlower, hupper, a, b, ha, hb):
  Equal.trans(Bool, V.width_in_range(V.width_squared(a, b)), M.in_range(lower, upper, U32.to_nat(V.width_squared(a, b))), M.in_range(lower, upper, M.width(a, b)), L.width_in_range_arithmetic_exact(lower, upper, hlower, hupper, V.width_squared(a, b)), Equal.cong(Nat, Bool, n => M.in_range(lower, upper, n), U32.to_nat(V.width_squared(a, b)), M.width(a, b), accepted_width(a, b, ha, hb)))
def L.section_width_arithmetic_exact(lower, upper, hlower, hupper, s, hl, hr):
  match s:
    case C.Section{a, b}: L.accepted_width_range(lower, upper, hlower, hupper, a, b, hl, hr)
