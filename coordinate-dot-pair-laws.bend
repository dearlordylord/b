import Base
import ./coordinate-sum4.bend as S
import ./core.bend as Core
import ./validation.bend as V

law guarded_dot_pair:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for +g: Nat
  for +h: Nat
  for +hs: S.Bounds<a, b, c, d, e, f, g, h>
  {U32.to_nat(U32.add(V.dot(Core.Pt{a, c}, Core.Pt{b, d}), V.dot(Core.Pt{e, g}, Core.Pt{f, h}))) == S.exact(a, b, c, d, e, f, g, h) : Nat}
