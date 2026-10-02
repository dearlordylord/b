import Base
import ./word-arithmetic.bend as W
import ./word-multiplication.bend as M
import ./word-multiplication-laws.bend as L
import ./word-conversion.bend as C
import ./word-multiplication-proof.bend as P
def product_0() -> {Word.to_nat(1n, M.multiply(1n, WCon{False{}, WNil{}}, WCon{True{}, WNil{}})) == 0n : Nat}:
  L.bounded_multiplication(1n, WCon{False{}, WNil{}}, WCon{True{}, WNil{}}, {==})
def product_1() -> {Word.to_nat(3n, M.multiply(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})) == 7n : Nat}:
  L.bounded_multiplication(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, {==})
def product_2() -> {Word.to_nat(3n, M.multiply(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 7n : Nat}:
  L.bounded_multiplication(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def product_3() -> {Word.to_nat(4n, M.multiply(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})) == 15n : Nat}:
  L.bounded_multiplication(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}}, {==})
def product_4() -> {Word.to_nat(4n, M.multiply(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}})) == 0n : Nat}:
  L.bounded_multiplication(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}}, {==})
def product_5() -> {Word.to_nat(4n, M.multiply(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}})) == 14n : Nat}:
  L.bounded_multiplication(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}}, {==})
def loop_with_accumulator() -> {Word.to_nat(3n, M.loop(2n, 3n, WCon{False{}, WCon{True{}, WNil{}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 7n : Nat}:
  L.loop_exact(2n, 3n, WCon{False{}, WCon{True{}, WNil{}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def u32_multiplication() -> {U32.to_nat(U32.mul(U32{C.from_nat(3n, 32n)}, U32{C.from_nat(4n, 32n)})) == 12n : Nat}:
  L.bounded_u32_multiplication(C.from_nat(3n, 32n), C.from_nat(4n, 32n), {==})
def u32_addition() -> {U32.to_nat(U32.add(U32{C.from_nat(3n, 32n)}, U32{C.from_nat(4n, 32n)})) == 7n : Nat}:
  L.bounded_u32_addition(C.from_nat(3n, 32n), C.from_nat(4n, 32n), {==})
def overflowing_product_excluded() -> {Nat.is_lt(Nat.mul(4n, 4n), W.capacity(4n)) == False{} : Bool}:
  {==}
