import Base
import ./word-arithmetic.bend as W
import ./word-shift.bend as S
import ./word-shift-laws.bend as L
import ./word-range-laws.bend as R
import ./word-range-proof.bend as P
def range_0() -> {Nat.is_lt(Word.to_nat(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def range_1() -> {Nat.is_lt(Word.to_nat(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def range_2() -> {Nat.is_lt(Word.to_nat(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def range_3() -> {Nat.is_lt(Word.to_nat(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def range_4() -> {Nat.is_lt(Word.to_nat(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def range_5() -> {Nat.is_lt(Word.to_nat(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def range_6() -> {Nat.is_lt(Word.to_nat(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def range_7() -> {Nat.is_lt(Word.to_nat(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}), W.capacity(3n)) == True{} : Bool}:
  R.word_value_bounded(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def exact_0() -> {Word.to_nat(3n, Word.shl(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 0n : Nat}:
  L.bounded_shift(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def exact_1() -> {Word.to_nat(3n, Word.shl(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})) == 2n : Nat}:
  L.bounded_shift(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, {==})
def exact_2() -> {Word.to_nat(3n, Word.shl(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 4n : Nat}:
  L.bounded_shift(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def exact_3() -> {Word.to_nat(3n, Word.shl(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})) == 6n : Nat}:
  L.bounded_shift(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, {==})
def retained_high_bit() -> {W.carry_value(3n, S.shift(3n, False{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})) == 14n : Nat}:
  {==}
def shift_overflow() -> {W.overflow(3n, S.shift(3n, False{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})) == True{} : Bool}:
  {==}
