import Base

# Shared three-product sum used by the orientation determinant.
def sum3(+n: Nat, a: Word(n), b: Word(n), c: Word(n), d: Word(n), e: Word(n), f: Word(n)) -> Word(n):
  Word.add(n, Word.add(n, Word.mul(n, a, b), Word.mul(n, c, d)), Word.mul(n, e, f))
def exact(+n: Nat, a: Word(n), b: Word(n), c: Word(n), d: Word(n), e: Word(n), f: Word(n)) -> Nat:
  Nat.add(Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)))
def u32_sum3(a: U32, b: U32, c: U32, d: U32, e: U32, f: U32) -> U32:
  match a b c d e f:
    case U32{aw} U32{bw} U32{cw} U32{dw} U32{ew} U32{fw}:
      U32{sum3(32n, aw, bw, cw, dw, ew, fw)}
