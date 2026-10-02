import Base
import ./word-comparison.bend as C

law word_comparison_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  {C.compare(n, a, b) == Nat.cmp(Word.to_nat(n, a), Word.to_nat(n, b)) : Cmp}

# The 32-bit payloads cover every possible U32 constructor value.
law u32_comparison_exact:
  for +x: Word(32n)
  for +y: Word(32n)
  {U32.cmp(U32{x}, U32{y}) == Nat.cmp(Word.to_nat(32n, x), Word.to_nat(32n, y)) : Cmp}

law u32_equality_exact:
  for +x: Word(32n)
  for +y: Word(32n)
  {U32.is_eq(U32{x}, U32{y}) == Nat.is_eq(Word.to_nat(32n, x), Word.to_nat(32n, y)) : Bool}

law u32_greater_exact:
  for +x: Word(32n)
  for +y: Word(32n)
  {U32.is_gt(U32{x}, U32{y}) == Nat.is_gt(Word.to_nat(32n, x), Word.to_nat(32n, y)) : Bool}

law u32_less_equal_exact:
  for +x: Word(32n)
  for +y: Word(32n)
  {U32.is_le(U32{x}, U32{y}) == Nat.is_le(Word.to_nat(32n, x), Word.to_nat(32n, y)) : Bool}
