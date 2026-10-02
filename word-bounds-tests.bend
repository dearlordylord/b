import Base
import ./word-arithmetic.bend as W
import ./word-bounds-laws.bend as B
import ./word-bounds-proof.bend as P
def capacity_0() -> {W.capacity(0n) == 1n : Nat}:
  {==}
def capacity_1() -> {W.capacity(1n) == 2n : Nat}:
  {==}
def capacity_2() -> {W.capacity(2n) == 4n : Nat}:
  {==}
def capacity_3() -> {W.capacity(3n) == 8n : Nat}:
  {==}
def capacity_4() -> {W.capacity(4n) == 16n : Nat}:
  {==}
def exact_0() -> {Word.to_nat(1n, Word.adc(1n, WCon{False{}, WNil{}}, WCon{False{}, WNil{}}, False{}, False{})) == 0n : Nat}:
  B.bounded_addition_exact(1n, WCon{False{}, WNil{}}, WCon{False{}, WNil{}}, False{}, {==})
def exact_1() -> {Word.to_nat(1n, Word.adc(1n, WCon{True{}, WNil{}}, WCon{False{}, WNil{}}, False{}, False{})) == 1n : Nat}:
  B.bounded_addition_exact(1n, WCon{True{}, WNil{}}, WCon{False{}, WNil{}}, False{}, {==})
def exact_2() -> {Word.to_nat(2n, Word.adc(2n, WCon{True{}, WCon{False{}, WNil{}}}, WCon{True{}, WCon{False{}, WNil{}}}, False{}, True{})) == 3n : Nat}:
  B.bounded_addition_exact(2n, WCon{True{}, WCon{False{}, WNil{}}}, WCon{True{}, WCon{False{}, WNil{}}}, True{}, {==})
def exact_3() -> {Word.to_nat(3n, Word.adc(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, False{}, True{})) == 7n : Nat}:
  B.bounded_addition_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, True{}, {==})
def exact_4() -> {Word.to_nat(4n, Word.adc(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}}, False{}, True{})) == 15n : Nat}:
  B.bounded_addition_exact(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}}, True{}, {==})
def exact_capacity_is_not_strict() -> {Nat.is_lt(4n, W.capacity(2n)) == False{} : Bool}:
  {==}
