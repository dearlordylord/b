import Base
import ./word-division4.bend as D
import ./word-division4-laws.bend as L
import ./word-conversion.bend as C
import ./word-division4-proof.bend as P
def quotient_0() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}})) == 0n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def remainder_0() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def quotient_1() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}})) == 0n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def remainder_1() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def quotient_2() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}})) == 0n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def remainder_2() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def quotient_3() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}})) == 0n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def remainder_3() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}})
def quotient_4() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})) == 1n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def remainder_4() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def quotient_5() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})) == 1n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def remainder_5() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def quotient_6() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}})) == 1n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def remainder_6() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def quotient_7() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}})) == 1n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def remainder_7() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}})
def quotient_8() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}})) == 2n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def remainder_8() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def quotient_9() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}})) == 2n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def remainder_9() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def quotient_10() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}})) == 2n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def remainder_10() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def quotient_11() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}})) == 2n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def remainder_11() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}})
def quotient_12() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}})) == 3n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def remainder_12() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def quotient_13() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}})) == 3n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def remainder_13() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def quotient_14() -> {Word.to_nat(4n, D.quotient(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}})) == 3n : Nat}:
  L.quotient4_value(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def remainder_14() -> {U32.is_lt(D.remainder(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{False{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def quotient_15() -> {Word.to_nat(4n, D.quotient(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}})) == 3n : Nat}:
  L.quotient4_value(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def remainder_15() -> {U32.is_lt(D.remainder(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}}), 4) == True{} : Bool}:
  L.remainder4_bound(4n, WCon{True{}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}})
def u32_0() -> {U32.to_nat(U32.div(U32{C.from_nat(0n, 32n)}, 4)) == 0n : Nat}:
  L.u32_division4_value(C.from_nat(0n, 32n))
def u32_1() -> {U32.to_nat(U32.div(U32{C.from_nat(1n, 32n)}, 4)) == 0n : Nat}:
  L.u32_division4_value(C.from_nat(1n, 32n))
def u32_3() -> {U32.to_nat(U32.div(U32{C.from_nat(3n, 32n)}, 4)) == 0n : Nat}:
  L.u32_division4_value(C.from_nat(3n, 32n))
def u32_4() -> {U32.to_nat(U32.div(U32{C.from_nat(4n, 32n)}, 4)) == 1n : Nat}:
  L.u32_division4_value(C.from_nat(4n, 32n))
def u32_7() -> {U32.to_nat(U32.div(U32{C.from_nat(7n, 32n)}, 4)) == 1n : Nat}:
  L.u32_division4_value(C.from_nat(7n, 32n))
def u32_8() -> {U32.to_nat(U32.div(U32{C.from_nat(8n, 32n)}, 4)) == 2n : Nat}:
  L.u32_division4_value(C.from_nat(8n, 32n))
def u32_15() -> {U32.to_nat(U32.div(U32{C.from_nat(15n, 32n)}, 4)) == 3n : Nat}:
  L.u32_division4_value(C.from_nat(15n, 32n))
def u32_16() -> {U32.to_nat(U32.div(U32{C.from_nat(16n, 32n)}, 4)) == 4n : Nat}:
  L.u32_division4_value(C.from_nat(16n, 32n))
