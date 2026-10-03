import Base
import ./coordinate-squares-laws.bend as L
import ./natural-squares.bend as N
import ./coordinate-sum.bend as S
import ./coordinate-sum-laws.bend as Bound
import ./coordinate-sum-proof.bend as Existing
import ./word-arithmetic.bend as W
import ./facts.bend as F

def L.guarded_squares_bound(a, b, ha, hb):
  Equal.trans(Bool, Nat.is_lt(N.exact(a, b), W.capacity(32n)), Nat.is_lt(S.exact(a, a, b, b, 0n, 0n), W.capacity(32n)), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(z, W.capacity(32n)), N.exact(a, b), S.exact(a, a, b, b, 0n, 0n), Equal.sym(Nat, S.exact(a, a, b, b, 0n, 0n), N.exact(a, b), F.add_zero(N.exact(a, b)))), Bound.coordinate_sum32_bound(a, a, b, b, 0n, 0n, S.Bound{ha, ha, hb, hb, {==}, {==}}))
