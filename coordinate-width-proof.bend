import Base
import ./coordinate-width-laws.bend as L
import ./coordinate-width.bend as Width
import ./coordinate-sum.bend as Guard
import ./absolute-difference.bend as D
import ./absolute-difference-laws.bend as Abs
import ./absolute-difference-proof.bend as Absolute
import ./natural-squares.bend as N
import ./word-squares.bend as S
import ./word-squares-laws.bend as Squares
import ./word-squares-proof.bend as WordProof
import ./coordinate-squares-laws.bend as Bound
import ./coordinate-squares-proof.bend as CoordinateProof
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as Conversion
import ./word-arithmetic.bend as W
import ./validation.bend as V
import ./validation-proof.bend as ValidationProof

# Push max/min selection inside the U32 constructor, retaining its payload.
def payload(+a: Word(32n), +b: Word(32n), +less: Bool) -> Word(32n):
  Word.sub(32n, Bool.pick(Word(32n), less, b, a), Bool.pick(Word(32n), less, a, b))
def choice_constructor(+a: Word(32n), +b: Word(32n), +less: Bool) -> {Absolute.choice(U32{a}, U32{b}, less) == U32{payload(a, b, less)} : U32}:
  match less:
    case False{}: {==}
    case True{}: {==}
def absolute_constructor(+a: Word(32n), +b: Word(32n)) -> {V.absolute_difference(U32{a}, U32{b}) == U32{payload(a, b, U32.is_lt(U32{a}, U32{b}))} : U32}:
  choice_constructor(a, b, U32.is_lt(U32{a}, U32{b}))

def squared(+a: U32, +b: U32) -> U32:
  U32.add(U32.mul(a, a), U32.mul(b, b))

def values(+n: Nat, +a: Word(n), +b: Word(n), +p: Nat, +q: Nat, ha: {Word.to_nat(n, a) == p : Nat}, hb: {Word.to_nat(n, b) == q : Nat}) -> {S.exact(n, a, b) == N.exact(p, q) : Nat}:
  %Equal.sym(Nat, Word.to_nat(n, a), p, ha) : {N.exact(_, Word.to_nat(n, b)) == N.exact(p, q) : Nat}
  %Equal.sym(Nat, Word.to_nat(n, b), q, hb) : {N.exact(p, _) == N.exact(p, q) : Nat}
  {==}
def square_values(+n: Nat, +a: Word(n), +b: Word(n), +p: Nat, +q: Nat, +ha: {Word.to_nat(n, a) == p : Nat}, +hb: {Word.to_nat(n, b) == q : Nat}, total: {Nat.is_lt(N.exact(p, q), W.capacity(n)) == True{} : Bool}) -> {Word.to_nat(n, S.squares(n, a, b)) == N.exact(p, q) : Nat}:
  Equal.trans(Nat, Word.to_nat(n, S.squares(n, a, b)), S.exact(n, a, b), N.exact(p, q), Squares.bounded_squares_exact(n, a, b, Equal.trans(Bool, Nat.is_lt(S.exact(n, a, b), W.capacity(n)), Nat.is_lt(N.exact(p, q), W.capacity(n)), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(z, W.capacity(n)), S.exact(n, a, b), N.exact(p, q), values(n, a, b, p, q, ha, hb)), total)), values(n, a, b, p, q, ha, hb))

def payload_value(+a: Nat, +b: Nat, ha: {Nat.is_le(a, 16000n) == True{} : Bool}, hb: {Nat.is_le(b, 16000n) == True{} : Bool}) -> {Word.to_nat(32n, payload(C.from_nat(a, 32n), C.from_nat(b, 32n), U32.is_lt(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)}))) == D.exact(a, b) : Nat}:
  %absolute_constructor(C.from_nat(a, 32n), C.from_nat(b, 32n)) : {U32.to_nat(_) == D.exact(a, b) : Nat}
  Absolute.converted_absolute(a, b, ha, hb)

def converted_width(+x: Nat, +y: Nat, +z: Nat, +w: Nat, +hx: {Nat.is_le(x, 16000n) == True{} : Bool}, +hy: {Nat.is_le(y, 16000n) == True{} : Bool}, +hz: {Nat.is_le(z, 16000n) == True{} : Bool}, +hw: {Nat.is_le(w, 16000n) == True{} : Bool}) -> {U32.to_nat(squared(V.absolute_difference(U32{C.from_nat(x, 32n)}, U32{C.from_nat(z, 32n)}), V.absolute_difference(U32{C.from_nat(y, 32n)}, U32{C.from_nat(w, 32n)}))) == Width.exact(x, y, z, w) : Nat}:
  %Equal.sym(U32, V.absolute_difference(U32{C.from_nat(x, 32n)}, U32{C.from_nat(z, 32n)}), U32{payload(C.from_nat(x, 32n), C.from_nat(z, 32n), U32.is_lt(U32{C.from_nat(x, 32n)}, U32{C.from_nat(z, 32n)}))}, absolute_constructor(C.from_nat(x, 32n), C.from_nat(z, 32n))) : {U32.to_nat(squared(_, V.absolute_difference(U32{C.from_nat(y, 32n)}, U32{C.from_nat(w, 32n)}))) == Width.exact(x, y, z, w) : Nat}
  %Equal.sym(U32, V.absolute_difference(U32{C.from_nat(y, 32n)}, U32{C.from_nat(w, 32n)}), U32{payload(C.from_nat(y, 32n), C.from_nat(w, 32n), U32.is_lt(U32{C.from_nat(y, 32n)}, U32{C.from_nat(w, 32n)}))}, absolute_constructor(C.from_nat(y, 32n), C.from_nat(w, 32n))) : {U32.to_nat(squared(U32{payload(C.from_nat(x, 32n), C.from_nat(z, 32n), U32.is_lt(U32{C.from_nat(x, 32n)}, U32{C.from_nat(z, 32n)}))}, _)) == Width.exact(x, y, z, w) : Nat}
  square_values(32n, payload(C.from_nat(x, 32n), C.from_nat(z, 32n), U32.is_lt(U32{C.from_nat(x, 32n)}, U32{C.from_nat(z, 32n)})), payload(C.from_nat(y, 32n), C.from_nat(w, 32n), U32.is_lt(U32{C.from_nat(y, 32n)}, U32{C.from_nat(w, 32n)})), D.exact(x, z), D.exact(y, w), payload_value(x, z, hx, hz), payload_value(y, w, hy, hw), Bound.guarded_squares_bound(D.exact(x, z), D.exact(y, w), Abs.natural_absolute_bounded(x, z, 16000n, hx, hz), Abs.natural_absolute_bounded(y, w, 16000n, hy, hw)))

def source_width(+x: Nat, +y: Nat, +z: Nat, +w: Nat, +hx: {Nat.is_le(x, 16000n) == True{} : Bool}, +hy: {Nat.is_le(y, 16000n) == True{} : Bool}, +hz: {Nat.is_le(z, 16000n) == True{} : Bool}, +hw: {Nat.is_le(w, 16000n) == True{} : Bool}) -> {U32.to_nat(squared(V.absolute_difference(U32.from_nat(x), U32.from_nat(z)), V.absolute_difference(U32.from_nat(y), U32.from_nat(w)))) == Width.exact(x, y, z, w) : Nat}:
  %Equal.sym(U32, U32.from_nat(x), U32{C.from_nat(x, 32n)}, Conversion.u32_conversion_agrees(x)) : {U32.to_nat(squared(V.absolute_difference(_, U32.from_nat(z)), V.absolute_difference(U32.from_nat(y), U32.from_nat(w)))) == Width.exact(x, y, z, w) : Nat}
  %Equal.sym(U32, U32.from_nat(y), U32{C.from_nat(y, 32n)}, Conversion.u32_conversion_agrees(y)) : {U32.to_nat(squared(V.absolute_difference(U32{C.from_nat(x, 32n)}, U32.from_nat(z)), V.absolute_difference(_, U32.from_nat(w)))) == Width.exact(x, y, z, w) : Nat}
  %Equal.sym(U32, U32.from_nat(z), U32{C.from_nat(z, 32n)}, Conversion.u32_conversion_agrees(z)) : {U32.to_nat(squared(V.absolute_difference(U32{C.from_nat(x, 32n)}, _), V.absolute_difference(U32{C.from_nat(y, 32n)}, U32.from_nat(w)))) == Width.exact(x, y, z, w) : Nat}
  %Equal.sym(U32, U32.from_nat(w), U32{C.from_nat(w, 32n)}, Conversion.u32_conversion_agrees(w)) : {U32.to_nat(squared(V.absolute_difference(U32{C.from_nat(x, 32n)}, U32{C.from_nat(z, 32n)}), V.absolute_difference(U32{C.from_nat(y, 32n)}, _))) == Width.exact(x, y, z, w) : Nat}
  converted_width(x, y, z, w, hx, hy, hz, hw)

def L.guarded_width_exact(x, y, z, w, hs):
  match hs:
    case Guard.Bound{+hx, +hy, +hz, +hw, _, _}:
      source_width(x, y, z, w, hx, hy, hz, hw)

def source_bounds(+x: Nat, +y: Nat, +z: Nat, +w: Nat,
  pairs: ({Nat.is_le(x, 16000n) == True{} : Bool} & {Nat.is_le(y, 16000n) == True{} : Bool}) & ({Nat.is_le(z, 16000n) == True{} : Bool} & {Nat.is_le(w, 16000n) == True{} : Bool})) -> Guard.Bounds<x, y, z, w, 0n, 0n>:
  match pairs:
    case ((hx, hy), (hz, hw)):
      Guard.Bound{hx, hy, hz, hw, {==}, {==}}

def L.accepted_points_width(x, y, z, w, ha, hb):
  L.guarded_width_exact(x, y, z, w, source_bounds(x, y, z, w, (ValidationProof.and_split(Nat.is_le(x, 16000n), Nat.is_le(y, 16000n), ha), ValidationProof.and_split(Nat.is_le(z, 16000n), Nat.is_le(w, 16000n), hb))))
