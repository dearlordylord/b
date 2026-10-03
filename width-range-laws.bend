import Base
import ./core.bend as C
import ./validation.bend as V
import ./width-range.bend as M

law width_in_range_arithmetic_exact:
  for +lower: U32
  for +upper: U32
  for +hlower: {lower == 3240000 : U32}
  for +hupper: {upper == 6760000 : U32}
  for +n: U32
  {V.width_in_range(n) == M.in_range(lower, upper, U32.to_nat(n)) : Bool}

law accepted_width_range:
  for +lower: U32
  for +upper: U32
  for +hlower: {lower == 3240000 : U32}
  for +hupper: {upper == 6760000 : U32}
  for +a: C.Point
  for +b: C.Point
  for ha: {V.point_bounded(a) == True{} : Bool}
  for hb: {V.point_bounded(b) == True{} : Bool}
  {V.width_in_range(V.width_squared(a, b)) == M.in_range(lower, upper, M.width(a, b)) : Bool}

law section_width_arithmetic_exact:
  for +lower: U32
  for +upper: U32
  for +hlower: {lower == 3240000 : U32}
  for +hupper: {upper == 6760000 : U32}
  for +s: C.Section
  for hl: {V.point_bounded(C.boundary_left(s)) == True{} : Bool}
  for hr: {V.point_bounded(C.boundary_right(s)) == True{} : Bool}
  {V.section_width(s) == M.section_width(lower, upper, s) : Bool}
