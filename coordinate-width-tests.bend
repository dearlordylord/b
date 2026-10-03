import Base
import ./core.bend as Core
import ./validation.bend as V
import ./coordinate-width-laws.bend as L
import ./coordinate-width-proof.bend as P

def diagonal_exact() -> {U32.to_nat(V.width_squared(Core.Pt{1n, 2n}, Core.Pt{4n, 6n})) == 25n : Nat}:
  L.accepted_points_width(1n, 2n, 4n, 6n, {==}, {==})
def reversed_exact() -> {U32.to_nat(V.width_squared(Core.Pt{4n, 6n}, Core.Pt{1n, 2n})) == 25n : Nat}:
  L.accepted_points_width(4n, 6n, 1n, 2n, {==}, {==})
def zero_exact() -> {U32.to_nat(V.width_squared(Core.Pt{2n, 3n}, Core.Pt{2n, 3n})) == 0n : Nat}:
  L.accepted_points_width(2n, 3n, 2n, 3n, {==}, {==})
