import Base
import ./witness-arithmetic.bend as M
import ./topology.bend as T

# Width12 safely envelopes production coordinates<=4000 and numerators<=256000.
# The denominator bound includes both production cases, 1 and 64.
law guarded_side_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +ax: Word(32n)
  for +ay: Word(32n)
  for +bx: Word(32n)
  for +by: Word(32n)
  for +x: Word(32n)
  for +y: Word(32n)
  for +d: Word(32n)
  for hs: M.Bounds<width, Word.to_nat(32n, ax), Word.to_nat(32n, ay), Word.to_nat(32n, bx), Word.to_nat(32n, by), Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, d)>
  {T.side(T.P{U32{ax}, U32{ay}}, T.P{U32{bx}, U32{by}}, T.W{U32{x}, U32{y}, U32{d}}) == M.exact_side(Word.to_nat(32n, ax), Word.to_nat(32n, ay), Word.to_nat(32n, bx), Word.to_nat(32n, by), Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, d)) : Cmp}
