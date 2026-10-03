import Base
import ./core.bend as C
import ./coordinate-width.bend as Width

# Decode literal word thresholds into mathematical Nat values. No word
# arithmetic or native comparisons are used by this interval predicate.
def in_range(+lower: U32, +upper: U32, +n: Nat) -> Bool:
  Nat.is_le(U32.to_nat(lower), n) && Nat.is_le(n, U32.to_nat(upper))
def width(a: C.Point, b: C.Point) -> Nat:
  match a b:
    case C.Pt{x, y} C.Pt{z, w}: Width.exact(x, y, z, w)
def section_width(+lower: U32, +upper: U32, +s: C.Section) -> Bool:
  in_range(lower, upper, width(C.boundary_left(s), C.boundary_right(s)))
