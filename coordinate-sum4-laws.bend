import Base
import ./coordinate-sum4.bend as S
import ./word-arithmetic.bend as W

law coordinate_sum4_bound:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for +g: Nat
  for +h: Nat
  for hs: S.Bounds<a, b, c, d, e, f, g, h>
  {Nat.is_lt(S.exact(a, b, c, d, e, f, g, h), W.capacity(32n)) == True{} : Bool}
