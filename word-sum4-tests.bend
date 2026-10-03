import Base
import ./word-sum4.bend as S
import ./word-sum4-laws.bend as L
import ./word-sum4-proof.bend as P
import ./word-conversion.bend as C

def four_units_exact() -> {Word.to_nat(3n, S.sum4(3n, C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n))) == 4n : Nat}:
  L.sum4_exact(3n, C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), C.from_nat(1n, 3n), {==})
