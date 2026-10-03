import Base
import ./word-arithmetic.bend as W
import ./topology.bend as T
import ./word-conversion.bend as C

def numerator(+a: Nat, b: Nat, +n: Nat) -> Nat:
  Nat.add(Nat.mul(a, Nat.sub(64n, n)), Nat.mul(b, n))
def word_sample(+bits: Nat, a: Word(bits), b: Word(bits), +n: Word(bits), sixty_four: Word(bits)) -> Word(bits):
  Word.add(bits, Word.mul(bits, a, Word.sub(bits, sixty_four, n)), Word.mul(bits, b, n))
def values(witness: T.Witness) -> Nat & (Nat & Nat):
  match witness:
    case T.W{x, y, d}: (U32.to_nat(x), (U32.to_nat(y), U32.to_nat(d)))
def values_envelope(+width: Nat, coordinates: Nat & (Nat & Nat)) -> Bool:
  match coordinates:
    case (x, (y, d)): Nat.is_le(x, W.capacity(Nat.add(width, 6n))) && (Nat.is_le(y, W.capacity(Nat.add(width, 6n))) && Nat.is_le(d, W.capacity(6n)))
def envelope(width: Nat, witness: T.Witness) -> Bool:
  values_envelope(width, values(witness))
def sixty_four() -> Word(32n):
  C.from_nat(64n, 32n)
type Bounds<-width: Nat, -x: Nat, -y: Nat, -u: Nat, -v: Nat, -n: Nat> is Data:
  Bound{hx: {Nat.is_le(x, W.capacity(width)) == True{} : Bool}, hy: {Nat.is_le(y, W.capacity(width)) == True{} : Bool}, hu: {Nat.is_le(u, W.capacity(width)) == True{} : Bool}, hv: {Nat.is_le(v, W.capacity(width)) == True{} : Bool}, hn: {Nat.is_le(n, 64n) == True{} : Bool}}

def exact_sample(p: T.Point, q: T.Point, +n: U32) -> Nat & (Nat & Nat):
  match p q:
    case T.P{x, y} T.P{u, v}: (numerator(U32.to_nat(x), U32.to_nat(u), U32.to_nat(n)), (numerator(U32.to_nat(y), U32.to_nat(v), U32.to_nat(n)), 64n))

def vertex_values(p: T.Point) -> Nat & (Nat & Nat):
  match p:
    case T.P{x, y}: (U32.to_nat(x), (U32.to_nat(y), 1n))
