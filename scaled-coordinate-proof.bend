import Base
import ./coordinate-limit.bend as Limit
import ./scaled-coordinate.bend as M
import ./topology.bend as T
import ./core.bend as Core
import ./scaled-coordinate-laws.bend as L
import ./word-arithmetic.bend as W
import ./coordinate-facts.bend as Coordinates
import ./coordinate-support.bend as Support
import ./division-order-proof.bend as Order
import ./centroid-model-proof.bend as Quarter
import ./word-division4-laws.bend as Division
import ./word-division4-proof.bend as DivisionProof
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as Conversion

law source_width:
  for +width: Nat
  for hw: {width == 12n : Nat}
  {2n+width == 14n : Nat}
def source_width(width, hw):
  Equal.cong(Nat, Nat, n => 2n+n, width, 12n, hw)

def divided_envelope(+width: Nat, +x: Nat, h: {Nat.is_le(x, W.capacity(2n+width)) == True{} : Bool}) -> {Nat.is_le(Nat.div(x, 4n), W.capacity(width)) == True{} : Bool}:
  %Quarter.quarter_four(W.capacity(width)) : {Nat.is_le(Nat.div(x, 4n), _) == True{} : Bool}
  Order.div_le_div(x, W.capacity(2n+width), 3n, h)

def source_envelope(+width: Nat, hw: {width == 12n : Nat}, +x: Nat, h: {Nat.is_le(x, Limit.maximum()) == True{} : Bool}) -> {Nat.is_le(x, W.capacity(2n+width)) == True{} : Bool}:
  %Equal.sym(Nat, 2n+width, 14n, source_width(width, hw)) : {Nat.is_le(x, W.capacity(_)) == True{} : Bool}
  Coordinates.coordinate14(x, h)

def L.scaled_coordinate_bound(width, hw, x, h):
  divided_envelope(width, x, source_envelope(width, hw, x, h))

def L.scaled_coordinate_exact(x, h):
  %Equal.sym(U32, U32.from_nat(x), U32{C.from_nat(x, 32n)}, Conversion.u32_conversion_agrees(x)) : {U32.to_nat(U32.div(_, 4)) == Nat.div(x, 4n) : Nat}
  Equal.trans(Nat, U32.to_nat(U32.div(U32{C.from_nat(x, 32n)}, 4)), Nat.div(Word.to_nat(32n, C.from_nat(x, 32n)), 4n), Nat.div(x, 4n), Division.u32_division4_value(C.from_nat(x, 32n)), Equal.cong(Nat, Nat, z => Nat.div(z, 4n), Word.to_nat(32n, C.from_nat(x, 32n)), x, Conversion.bounded_conversion(x, 32n, Support.coordinate32(x, h))))

def L.topology_scaled_exact(x, y, hx, hy):
  Equal.trans(Nat & Nat, M.values(T.scaled(Core.Pt{x, y})), (Nat.div(x, 4n), U32.to_nat(U32.div(U32.from_nat(y), 4))), (Nat.div(x, 4n), Nat.div(y, 4n)), Equal.cong(Nat, Nat & Nat, z => (z, U32.to_nat(U32.div(U32.from_nat(y), 4))), U32.to_nat(U32.div(U32.from_nat(x), 4)), Nat.div(x, 4n), L.scaled_coordinate_exact(x, hx)), Equal.cong(Nat, Nat & Nat, z => (Nat.div(x, 4n), z), U32.to_nat(U32.div(U32.from_nat(y), 4)), Nat.div(y, 4n), L.scaled_coordinate_exact(y, hy)))
