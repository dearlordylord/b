import Base
import ./word-arithmetic.bend as W
import ./word-subtraction.bend as S
import ./word-subtraction-laws.bend as L
import ./word-conversion.bend as C
import ./word-subtraction-proof.bend as P
def difference_0_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_1_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 1n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_1_1() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_2_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 2n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_2_1() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 1n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_2_2() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_3_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 3n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_3_1() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 2n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_3_2() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 1n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_3_3() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_4_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 4n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_4_1() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 3n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_4_2() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 2n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_4_3() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 1n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_4_4() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, {==})
def difference_5_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 5n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_5_1() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 4n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_5_2() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 3n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_5_3() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 2n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_5_4() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})) == 1n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, {==})
def difference_5_5() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, {==})
def difference_6_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 6n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_6_1() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 5n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_6_2() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 4n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_6_3() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 3n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_6_4() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})) == 2n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, {==})
def difference_6_5() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})) == 1n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, {==})
def difference_6_6() -> {Word.to_nat(3n, S.subtract(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, {==})
def difference_7_0() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 7n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_7_1() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 6n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def difference_7_2() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 5n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_7_3() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 4n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def difference_7_4() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})) == 3n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, {==})
def difference_7_5() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})) == 2n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, {==})
def difference_7_6() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})) == 1n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, {==})
def difference_7_7() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})) == 0n : Nat}:
  L.ordered_subtraction(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, {==})
def borrow_0() -> {W.overflow(3n, S.carry(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, True{})) == False{} : Bool}:
  L.subtraction_carry_characterization(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, True{})
def borrow_1() -> {W.overflow(3n, S.carry(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, True{})) == True{} : Bool}:
  L.subtraction_carry_characterization(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, True{})
def borrow_2() -> {W.overflow(3n, S.carry(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, True{})) == True{} : Bool}:
  L.subtraction_carry_characterization(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, True{})
def borrow_3() -> {W.overflow(3n, S.carry(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, False{})) == False{} : Bool}:
  L.subtraction_carry_characterization(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, False{})
def u32_difference() -> {U32.to_nat(U32.sub(U32{C.from_nat(7n, 32n)}, U32{C.from_nat(3n, 32n)})) == 4n : Nat}:
  L.ordered_u32_subtraction(C.from_nat(7n, 32n), C.from_nat(3n, 32n), {==})
def negative_difference_excluded() -> {Nat.is_ge(1n, 7n) == False{} : Bool}:
  {==}
def wrapping_difference() -> {Word.to_nat(3n, S.subtract(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})) == 2n : Nat}:
  {==}
