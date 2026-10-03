import Base
import ./word-squares.bend as S
import ./word-squares-laws.bend as L
import ./word-squares-proof.bend as P
import ./coordinate-squares-laws.bend as B
import ./coordinate-squares-proof.bend as BoundProof
import ./natural-squares.bend as N
import ./word-conversion.bend as C
import ./word-arithmetic.bend as W

def bounded_pair_exact() -> {Word.to_nat(4n, S.squares(4n, C.from_nat(2n, 4n), C.from_nat(3n, 4n))) == 13n : Nat}:
  L.bounded_squares_exact(4n, C.from_nat(2n, 4n), C.from_nat(3n, 4n), {==})
def zero_pair_exact() -> {Word.to_nat(1n, S.squares(1n, C.from_nat(0n, 1n), C.from_nat(0n, 1n))) == 0n : Nat}:
  L.bounded_squares_exact(1n, C.from_nat(0n, 1n), C.from_nat(0n, 1n), {==})
def coordinates_fit() -> {Nat.is_lt(N.exact(3n, 4n), W.capacity(32n)) == True{} : Bool}:
  B.guarded_squares_bound(3n, 4n, {==}, {==})
