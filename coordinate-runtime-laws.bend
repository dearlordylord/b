import Base
import ./coordinate-sum.bend as S
import ./word-sum3.bend as M
import ./core.bend as Core
import ./validation.bend as Validation

# Coordinate guards suffice: no separate word-level overflow premise.
law guarded_runtime_sum:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for +hs: S.Bounds<a, b, c, d, e, f>
  {U32.to_nat(M.u32_sum3(U32.from_nat(a), U32.from_nat(b), U32.from_nat(c), U32.from_nat(d), U32.from_nat(e), U32.from_nat(f))) == S.exact(a, b, c, d, e, f) : Nat}

# The production orientation predicate agrees with the exact determinant.
law guarded_determinant:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +cx: Nat
  for +cy: Nat
  for hs: S.Bounds<ax, ay, bx, by, cx, cy>
  {Validation.determinant_positive(Core.Pt{ax, ay}, Core.Pt{bx, by}, Core.Pt{cx, cy}) == Nat.is_gt(S.exact(ax, by, bx, cy, cx, ay), S.exact(ay, bx, by, cx, cy, ax)) : Bool}

# Connect the mathematical guards to the actual production point filter.
law accepted_points_determinant:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +cx: Nat
  for +cy: Nat
  for ha: {Validation.point_bounded(Core.Pt{ax, ay}) == True{} : Bool}
  for hb: {Validation.point_bounded(Core.Pt{bx, by}) == True{} : Bool}
  for hc: {Validation.point_bounded(Core.Pt{cx, cy}) == True{} : Bool}
  {Validation.determinant_positive(Core.Pt{ax, ay}, Core.Pt{bx, by}, Core.Pt{cx, cy}) == Nat.is_gt(S.exact(ax, by, bx, cy, cx, ay), S.exact(ay, bx, by, cx, cy, ax)) : Bool}
