import Base
import ./absolute-difference-laws.bend as L
import ./absolute-difference-proof.bend as P
import ./absolute-difference.bend as D
import ./word-conversion.bend as C
import ./validation.bend as V

def increasing_exact() -> {U32.to_nat(V.absolute_difference(U32{C.from_nat(2n, 32n)}, U32{C.from_nat(7n, 32n)})) == 5n : Nat}:
  L.u32_absolute_exact(C.from_nat(2n, 32n), C.from_nat(7n, 32n))
def decreasing_exact() -> {U32.to_nat(V.absolute_difference(U32.from_nat(7n), U32.from_nat(2n))) == 5n : Nat}:
  L.guarded_coordinate_absolute(7n, 2n, {==}, {==})
def equal_exact() -> {U32.to_nat(V.absolute_difference(U32.from_nat(3n), U32.from_nat(3n))) == 0n : Nat}:
  L.guarded_coordinate_absolute(3n, 3n, {==}, {==})
def reversed_model_exact() -> {D.exact(2n, 7n) == D.exact(7n, 2n) : Nat}:
  L.natural_absolute_symmetric(2n, 7n)
def model_bound_exact() -> {Nat.is_le(D.exact(2n, 7n), 10n) == True{} : Bool}:
  L.natural_absolute_bounded(2n, 7n, 10n, {==}, {==})
