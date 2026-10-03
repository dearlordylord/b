import Base
import ./word-arithmetic.bend as W
import ./word-sum3.bend as S

def exact(a: Nat, b: Nat, d: Nat, c: Nat, y: Nat, x: Nat, e: Nat) -> Nat:
  Nat.add(Nat.add(Nat.mul(Nat.mul(a, b), d), Nat.mul(c, y)), Nat.mul(x, e))

type Bounds<-width: Nat, -a: Nat, -b: Nat, -d: Nat, -c: Nat, -y: Nat, -x: Nat, -e: Nat> is Data:
  Bound{ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}, hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}, hd: {Nat.is_le(d, W.capacity(6n)) == True{} : Bool}, hc: {Nat.is_le(c, W.capacity(width)) == True{} : Bool}, hy: {Nat.is_le(y, W.capacity(Nat.add(width, 6n))) == True{} : Bool}, hx: {Nat.is_le(x, W.capacity(Nat.add(width, 6n))) == True{} : Bool}, he: {Nat.is_le(e, W.capacity(width)) == True{} : Bool}}

def word_sum(+n: Nat, a: Word(n), b: Word(n), d: Word(n), c: Word(n), y: Word(n), x: Word(n), e: Word(n)) -> Word(n):
  S.sum3(n, Word.mul(n, a, b), d, c, y, x, e)
def word_exact(+n: Nat, a: Word(n), b: Word(n), d: Word(n), c: Word(n), y: Word(n), x: Word(n), e: Word(n)) -> Nat:
  exact(Word.to_nat(n, a), Word.to_nat(n, b), Word.to_nat(n, d), Word.to_nat(n, c), Word.to_nat(n, y), Word.to_nat(n, x), Word.to_nat(n, e))
