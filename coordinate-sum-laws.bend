import Base
import ./word-arithmetic.bend as W
import ./coordinate-sum.bend as S

# Width is explicit to avoid normalizing enormous closed unary products.
# The equality fixes it to the actual 14-bit coordinate envelope.
law guarded_sum32_bound:
  for +width: Nat
  for +hw: {width == 14n : Nat}
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for hs: S.Bounds<a, b, c, d, e, f>
  {Nat.is_lt(S.exact(a, b, c, d, e, f), W.capacity(32n)) == True{} : Bool}

# The source-level guard alone guarantees the 32-bit determinant sums fit.
law coordinate_sum32_bound:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +e: Nat
  for +f: Nat
  for hs: S.Bounds<a, b, c, d, e, f>
  {Nat.is_lt(S.exact(a, b, c, d, e, f), W.capacity(32n)) == True{} : Bool}
