import Base
import ./coordinate-runtime-laws.bend as L
import ./coordinate-runtime-proof.bend as P
import ./coordinate-sum.bend as S
import ./core.bend as Core
import ./validation.bend as V
import ./word-sum3.bend as M

def small_sum_exact() -> {U32.to_nat(M.u32_sum3(U32.from_nat(3n), U32.from_nat(4n), U32.from_nat(1n), U32.from_nat(7n), U32.from_nat(0n), U32.from_nat(16n))) == 19n : Nat}:
  L.guarded_runtime_sum(3n, 4n, 1n, 7n, 0n, 16n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}})
def positive_triangle_exact() -> {V.determinant_positive(Core.Pt{1n, 1n}, Core.Pt{3n, 1n}, Core.Pt{1n, 3n}) == True{} : Bool}:
  L.guarded_determinant(1n, 1n, 3n, 1n, 1n, 3n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}})
def reversed_triangle_exact() -> {V.determinant_positive(Core.Pt{1n, 1n}, Core.Pt{1n, 3n}, Core.Pt{3n, 1n}) == False{} : Bool}:
  L.guarded_determinant(1n, 1n, 1n, 3n, 3n, 1n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}})
def collinear_triangle_exact() -> {V.determinant_positive(Core.Pt{1n, 1n}, Core.Pt{2n, 2n}, Core.Pt{3n, 3n}) == False{} : Bool}:
  L.guarded_determinant(1n, 1n, 2n, 2n, 3n, 3n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}})

def accepted_points_exact() -> {V.determinant_positive(Core.Pt{1n, 1n}, Core.Pt{3n, 1n}, Core.Pt{1n, 3n}) == True{} : Bool}:
  L.accepted_points_determinant(1n, 1n, 3n, 1n, 1n, 3n, {==}, {==}, {==})
