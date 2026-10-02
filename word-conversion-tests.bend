import Base
import ./word-arithmetic.bend as W
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as L
import ./word-conversion-proof.bend as P
def bounded_0() -> {Word.to_nat(3n, C.from_nat(0n, 3n)) == 0n : Nat}:
  L.bounded_conversion(0n, 3n, {==})
def bounded_1() -> {Word.to_nat(3n, C.from_nat(1n, 3n)) == 1n : Nat}:
  L.bounded_conversion(1n, 3n, {==})
def bounded_2() -> {Word.to_nat(3n, C.from_nat(3n, 3n)) == 3n : Nat}:
  L.bounded_conversion(3n, 3n, {==})
def bounded_3() -> {Word.to_nat(3n, C.from_nat(7n, 3n)) == 7n : Nat}:
  L.bounded_conversion(7n, 3n, {==})
def u32_0() -> {U32.to_nat(U32.from_nat(0n)) == 0n : Nat}:
  L.bounded_u32_conversion(0n, {==})
def u32_1() -> {U32.to_nat(U32.from_nat(1n)) == 1n : Nat}:
  L.bounded_u32_conversion(1n, {==})
def u32_2() -> {U32.to_nat(U32.from_nat(16n)) == 16n : Nat}:
  L.bounded_u32_conversion(16n, {==})
def capacity_is_excluded() -> {Nat.is_lt(8n, W.capacity(3n)) == False{} : Bool}:
  {==}
def at_capacity_wraps() -> {Word.to_nat(3n, C.from_nat(8n, 3n)) == 0n : Nat}:
  {==}
