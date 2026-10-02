import Base
import ./word-arithmetic.bend as W
def value_0() -> {W.carry_value(2n, W.add_carry(2n, WCon{False{}, WCon{False{}, WNil{}}}, WCon{False{}, WCon{False{}, WNil{}}}, False{})) == 0n : Nat}:
  {==}
def carry_0() -> {W.overflow(2n, W.add_carry(2n, WCon{False{}, WCon{False{}, WNil{}}}, WCon{False{}, WCon{False{}, WNil{}}}, False{})) == False{} : Bool}:
  {==}
def value_1() -> {W.carry_value(2n, W.add_carry(2n, WCon{True{}, WCon{False{}, WNil{}}}, WCon{False{}, WCon{True{}, WNil{}}}, False{})) == 3n : Nat}:
  {==}
def carry_1() -> {W.overflow(2n, W.add_carry(2n, WCon{True{}, WCon{False{}, WNil{}}}, WCon{False{}, WCon{True{}, WNil{}}}, False{})) == False{} : Bool}:
  {==}
def value_2() -> {W.carry_value(2n, W.add_carry(2n, WCon{True{}, WCon{True{}, WNil{}}}, WCon{True{}, WCon{False{}, WNil{}}}, False{})) == 4n : Nat}:
  {==}
def carry_2() -> {W.overflow(2n, W.add_carry(2n, WCon{True{}, WCon{True{}, WNil{}}}, WCon{True{}, WCon{False{}, WNil{}}}, False{})) == True{} : Bool}:
  {==}
def value_3() -> {W.carry_value(2n, W.add_carry(2n, WCon{True{}, WCon{True{}, WNil{}}}, WCon{True{}, WCon{True{}, WNil{}}}, True{})) == 7n : Nat}:
  {==}
def carry_3() -> {W.overflow(2n, W.add_carry(2n, WCon{True{}, WCon{True{}, WNil{}}}, WCon{True{}, WCon{True{}, WNil{}}}, True{})) == True{} : Bool}:
  {==}
