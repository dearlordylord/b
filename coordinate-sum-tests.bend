import Base
import ./word-arithmetic.bend as W
import ./coordinate-sum.bend as S
import ./coordinate-sum-laws.bend as L
import ./coordinate-sum-proof.bend as P

def small_coordinates_fit() -> {Nat.is_lt(S.exact(3n, 4n, 1n, 7n, 0n, 16n), W.capacity(32n)) == True{} : Bool}:
  L.coordinate_sum32_bound(3n, 4n, 1n, 7n, 0n, 16n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}})
def zero_coordinates_fit() -> {Nat.is_lt(S.exact(0n, 0n, 0n, 0n, 0n, 0n), W.capacity(32n)) == True{} : Bool}:
  L.coordinate_sum32_bound(0n, 0n, 0n, 0n, 0n, 0n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}})
