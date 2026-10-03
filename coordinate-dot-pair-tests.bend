import Base
import ./core.bend as Core
import ./validation.bend as V
import ./coordinate-sum4.bend as S
import ./coordinate-dot-pair-laws.bend as L
import ./coordinate-dot-pair-proof.bend as P

def small_pair_exact() -> {U32.to_nat(U32.add(V.dot(Core.Pt{2n, 4n}, Core.Pt{3n, 5n}), V.dot(Core.Pt{1n, 3n}, Core.Pt{2n, 4n}))) == 40n : Nat}:
  L.guarded_dot_pair(2n, 3n, 4n, 5n, 1n, 2n, 3n, 4n, S.Bound{{==}, {==}, {==}, {==}, {==}, {==}, {==}, {==}})
