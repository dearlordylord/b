import Base
import ./core.bend as Core
import ./validation.bend as V
import ./coordinate-sum.bend as S
import ./coordinate-dot-laws.bend as L
import ./coordinate-dot-proof.bend as P

def small_dot_exact() -> {U32.to_nat(V.dot(Core.Pt{3n, 4n}, Core.Pt{2n, 5n})) == 26n : Nat}:
  L.accepted_points_dot(3n, 4n, 2n, 5n, {==}, {==})
def zero_dot_exact() -> {U32.to_nat(V.dot(Core.Pt{0n, 0n}, Core.Pt{7n, 9n})) == 0n : Nat}:
  L.guarded_dot_exact(0n, 0n, 7n, 9n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}})
