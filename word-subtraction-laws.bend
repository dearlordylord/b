import Base
import ./word-arithmetic.bend as W
import ./word-subtraction.bend as S

law subtraction_low_agrees:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  {W.low(n, S.carry(n, a, b, c)) == Word.adc(n, a, b, True{}, c) : Word(n)}

law subtraction_carry_characterization:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  {W.overflow(n, S.carry(n, a, b, c)) == S.carry_from_comparison(Word.cmp(n, a, b), c) : Bool}

# Word subtraction wraps when a < b; this exact law requires a >= b.
law ordered_subtraction:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for h: {Nat.is_ge(Word.to_nat(n, a), Word.to_nat(n, b)) == True{} : Bool}
  {Word.to_nat(n, S.subtract(n, a, b)) == Nat.sub(Word.to_nat(n, a), Word.to_nat(n, b)) : Nat}

law ordered_u32_subtraction:
  for +x: Word(32n)
  for +y: Word(32n)
  for h: {Nat.is_ge(Word.to_nat(32n, x), Word.to_nat(32n, y)) == True{} : Bool}
  {U32.to_nat(U32.sub(U32{x}, U32{y})) == Nat.sub(Word.to_nat(32n, x), Word.to_nat(32n, y)) : Nat}
