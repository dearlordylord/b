import Base
import ./homogeneous.bend as H
import ./homogeneous-laws.bend as Homogeneous
import ./word-arithmetic.bend as W
import ./topology.bend as T
import ./witness-arithmetic.bend as M
import ./witness-arithmetic-laws.bend as L
import ./witness-arithmetic-proof.bend as P
import ./word-conversion.bend as C

def denominator64_positive() -> {T.side(T.P{1, 1}, T.P{2, 3}, T.W{0, 0, 64}) == GT{} : Cmp}:
  L.guarded_side_exact(12n, {==}, C.from_nat(1n, 32n), C.from_nat(1n, 32n), C.from_nat(2n, 32n), C.from_nat(3n, 32n), C.from_nat(0n, 32n), C.from_nat(0n, 32n), C.from_nat(64n, 32n), M.Bound{{==}, {==}, {==}, {==}, {==}, {==}, {==}})
def endpoint_zero() -> {T.side(T.P{1, 1}, T.P{2, 3}, T.W{2, 3, 1}) == EQ{} : Cmp}:
  L.guarded_side_exact(12n, {==}, C.from_nat(1n, 32n), C.from_nat(1n, 32n), C.from_nat(2n, 32n), C.from_nat(3n, 32n), C.from_nat(2n, 32n), C.from_nat(3n, 32n), C.from_nat(1n, 32n), M.Bound{{==}, {==}, {==}, {==}, {==}, {==}, {==}})
def denominator1_negative() -> {T.side(T.P{1, 1}, T.P{2, 3}, T.W{1, 0, 1}) == LT{} : Cmp}:
  L.guarded_side_exact(12n, {==}, C.from_nat(1n, 32n), C.from_nat(1n, 32n), C.from_nat(2n, 32n), C.from_nat(3n, 32n), C.from_nat(1n, 32n), C.from_nat(0n, 32n), C.from_nat(1n, 32n), M.Bound{{==}, {==}, {==}, {==}, {==}, {==}, {==}})

# All envelope limits attained together: 192 < 256 at width0.
def envelope_boundaries() -> {Nat.is_lt(H.exact(1n, 1n, 64n, 1n, 64n, 64n, 1n), W.capacity(8n)) == True{} : Bool}:
  Homogeneous.homogeneous_sum_bound(0n, 1n, 1n, 64n, 1n, 64n, 64n, 1n, H.Bound{{==}, {==}, {==}, {==}, {==}, {==}, {==}})
