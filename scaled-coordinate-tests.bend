import Base
import ./core.bend as C
import ./topology.bend as T
import ./scaled-coordinate.bend as M
import ./scaled-coordinate-laws.bend as L
import ./scaled-coordinate-proof.bend as P
import ./word-arithmetic.bend as W

def divisible_pair() -> {M.values(T.scaled(C.Pt{12n, 20n})) == (3n, 5n) : Nat & Nat}:
  L.topology_scaled_exact(12n, 20n, {==}, {==})
def rounded_pair() -> {M.values(T.scaled(C.Pt{3n, 7n})) == (0n, 1n) : Nat & Nat}:
  L.topology_scaled_exact(3n, 7n, {==}, {==})
def scaled_bound() -> {Nat.is_le(Nat.div(12n, 4n), W.capacity(12n)) == True{} : Bool}:
  L.scaled_coordinate_bound(12n, {==}, 12n, {==})
