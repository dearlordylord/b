import Base
import ./core.bend as Core
import ./validation.bend as V
import ./coordinate-sum.bend as S

law guarded_dot_exact:
  for +x: Nat
  for +y: Nat
  for +z: Nat
  for +w: Nat
  for +hs: S.Bounds<x, z, y, w, 0n, 0n>
  {U32.to_nat(V.dot(Core.Pt{x, y}, Core.Pt{z, w})) == Nat.add(Nat.mul(x, z), Nat.mul(y, w)) : Nat}

law accepted_points_dot:
  for +x: Nat
  for +y: Nat
  for +z: Nat
  for +w: Nat
  for ha: {V.point_bounded(Core.Pt{x, y}) == True{} : Bool}
  for hb: {V.point_bounded(Core.Pt{z, w}) == True{} : Bool}
  {U32.to_nat(V.dot(Core.Pt{x, y}, Core.Pt{z, w})) == Nat.add(Nat.mul(x, z), Nat.mul(y, w)) : Nat}
