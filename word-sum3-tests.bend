import Base
import ./word-arithmetic.bend as W
import ./word-sum3.bend as S
import ./word-sum3-laws.bend as L
import ./word-conversion.bend as C
import ./word-sum3-proof.bend as P
def sum_0() -> {Word.to_nat(3n, S.sum3(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 6n : Nat}:
  L.sum3_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def sum_1() -> {Word.to_nat(4n, S.sum3(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})) == 15n : Nat}:
  L.sum3_exact(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}}, {==})
def sum_2() -> {Word.to_nat(1n, S.sum3(1n, WCon{False{}, WNil{}}, WCon{True{}, WNil{}}, WCon{False{}, WNil{}}, WCon{True{}, WNil{}}, WCon{True{}, WNil{}}, WCon{True{}, WNil{}})) == 1n : Nat}:
  L.sum3_exact(1n, WCon{False{}, WNil{}}, WCon{True{}, WNil{}}, WCon{False{}, WNil{}}, WCon{True{}, WNil{}}, WCon{True{}, WNil{}}, WCon{True{}, WNil{}}, {==})
def actual_u32_sum() -> {U32.to_nat(S.u32_sum3(U32{C.from_nat(2n, 32n)}, U32{C.from_nat(3n, 32n)}, U32{C.from_nat(1n, 32n)}, U32{C.from_nat(2n, 32n)}, U32{C.from_nat(3n, 32n)}, U32{C.from_nat(1n, 32n)})) == 11n : Nat}:
  L.u32_sum3_exact(C.from_nat(2n, 32n), C.from_nat(3n, 32n), C.from_nat(1n, 32n), C.from_nat(2n, 32n), C.from_nat(3n, 32n), C.from_nat(1n, 32n), {==})
def exact_capacity_excluded() -> {Nat.is_lt(16n, W.capacity(4n)) == False{} : Bool}:
  {==}
