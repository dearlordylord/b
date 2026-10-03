import Base
import ./coordinate-transverse.bend as T
import ./coordinate-sum.bend as S
import ./core.bend as Core
import ./validation.bend as V

law guarded_transverse_exact:
  for +lx: Nat
  for +ly: Nat
  for +cx: Nat
  for +cy: Nat
  for +rx: Nat
  for +ry: Nat
  for hs: S.Bounds<lx, ly, cx, cy, rx, ry>
  {V.transverse_points(Core.Pt{lx, ly}, Core.Pt{cx, cy}, Core.Pt{rx, ry}) == T.exact(lx, ly, cx, cy, rx, ry) : Bool}

law accepted_points_transverse:
  for +lx: Nat
  for +ly: Nat
  for +cx: Nat
  for +cy: Nat
  for +rx: Nat
  for +ry: Nat
  for hleft: {V.point_bounded(Core.Pt{lx, ly}) == True{} : Bool}
  for hcontrol: {V.point_bounded(Core.Pt{cx, cy}) == True{} : Bool}
  for hright: {V.point_bounded(Core.Pt{rx, ry}) == True{} : Bool}
  {V.transverse_points(Core.Pt{lx, ly}, Core.Pt{cx, cy}, Core.Pt{rx, ry}) == T.exact(lx, ly, cx, cy, rx, ry) : Bool}
