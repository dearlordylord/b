import Base
import ./coordinate-width.bend as M
import ./coordinate-sum.bend as S
import ./core.bend as Core
import ./validation.bend as V

law guarded_width_exact:
  for +x: Nat
  for +y: Nat
  for +z: Nat
  for +w: Nat
  for hs: S.Bounds<x, y, z, w, 0n, 0n>
  {U32.to_nat(V.width_squared(Core.Pt{x, y}, Core.Pt{z, w})) == M.exact(x, y, z, w) : Nat}

law accepted_points_width:
  for +x: Nat
  for +y: Nat
  for +z: Nat
  for +w: Nat
  for ha: {V.point_bounded(Core.Pt{x, y}) == True{} : Bool}
  for hb: {V.point_bounded(Core.Pt{z, w}) == True{} : Bool}
  {U32.to_nat(V.width_squared(Core.Pt{x, y}, Core.Pt{z, w})) == M.exact(x, y, z, w) : Nat}
