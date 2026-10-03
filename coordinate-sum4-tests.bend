import Base
import ./coordinate-sum4.bend as S
import ./coordinate-sum4-laws.bend as L
import ./coordinate-sum4-proof.bend as P
import ./word-arithmetic.bend as W

def small_four_products_fit() -> {Nat.is_lt(S.exact(3n, 4n, 1n, 7n, 2n, 5n, 1n, 9n), W.capacity(32n)) == True{} : Bool}:
  L.coordinate_sum4_bound(3n, 4n, 1n, 7n, 2n, 5n, 1n, 9n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}, {==}, {==}})
def zero_four_products_fit() -> {Nat.is_lt(S.exact(0n, 0n, 0n, 0n, 0n, 0n, 0n, 0n), W.capacity(32n)) == True{} : Bool}:
  L.coordinate_sum4_bound(0n, 0n, 0n, 0n, 0n, 0n, 0n, 0n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}, {==}, {==}})
