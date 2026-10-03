import Base
import ./coordinate-limit.bend as Limit
import ./coordinate-dot-laws.bend as L
import ./coordinate-runtime-laws.bend as Runtime
import ./coordinate-runtime-proof.bend as Existing
import ./word-conversion-proof.bend as Conversion
import ./core.bend as Core
import ./validation.bend as V
import ./word-sum3.bend as M
import ./facts.bend as F
import ./coordinate-sum.bend as S
import ./boolean-reflection.bend as ValidationProof

# The production two-product expression is the shared three-product helper
# with a zero final product. Removing that final addition preserves the word.
def dot_sum_words(+a: U32, +b: U32, +c: U32, +d: U32) -> {U32.add(U32.mul(a, b), U32.mul(c, d)) == M.u32_sum3(a, b, c, d, U32.from_nat(0n), U32.from_nat(0n)) : U32}:
  match a b c d:
    case U32{+aw} U32{+bw} U32{+cw} U32{+dw}:
      Equal.sym(U32, U32{Word.add(32n, Word.add(32n, Word.mul(32n, aw, bw), Word.mul(32n, cw, dw)), Word.zero(32n))}, U32{Word.add(32n, Word.mul(32n, aw, bw), Word.mul(32n, cw, dw))}, Equal.cong(Word(32n), U32, q => U32{q}, Word.add(32n, Word.add(32n, Word.mul(32n, aw, bw), Word.mul(32n, cw, dw)), Word.zero(32n)), Word.add(32n, Word.mul(32n, aw, bw), Word.mul(32n, cw, dw)), Conversion.adc_zero(32n, Word.add(32n, Word.mul(32n, aw, bw), Word.mul(32n, cw, dw)))))

def L.guarded_dot_exact(x, y, z, w, hs):
  Equal.trans(Nat, U32.to_nat(V.dot(Core.Pt{x, y}, Core.Pt{z, w})), U32.to_nat(M.u32_sum3(U32.from_nat(x), U32.from_nat(z), U32.from_nat(y), U32.from_nat(w), U32.from_nat(0n), U32.from_nat(0n))), Nat.add(Nat.mul(x, z), Nat.mul(y, w)), Equal.cong(U32, Nat, q => U32.to_nat(q), V.dot(Core.Pt{x, y}, Core.Pt{z, w}), M.u32_sum3(U32.from_nat(x), U32.from_nat(z), U32.from_nat(y), U32.from_nat(w), U32.from_nat(0n), U32.from_nat(0n)), dot_sum_words(U32.from_nat(x), U32.from_nat(z), U32.from_nat(y), U32.from_nat(w))), Equal.trans(Nat, U32.to_nat(M.u32_sum3(U32.from_nat(x), U32.from_nat(z), U32.from_nat(y), U32.from_nat(w), U32.from_nat(0n), U32.from_nat(0n))), Nat.add(Nat.add(Nat.mul(x, z), Nat.mul(y, w)), 0n), Nat.add(Nat.mul(x, z), Nat.mul(y, w)), Runtime.guarded_runtime_sum(x, z, y, w, 0n, 0n, hs), F.add_zero(Nat.add(Nat.mul(x, z), Nat.mul(y, w)))))

def dot_bounds(+x: Nat, +y: Nat, +z: Nat, +w: Nat,
  hs: ({Nat.is_le(x, Limit.maximum()) == True{} : Bool} & {Nat.is_le(y, Limit.maximum()) == True{} : Bool}) &
      ({Nat.is_le(z, Limit.maximum()) == True{} : Bool} & {Nat.is_le(w, Limit.maximum()) == True{} : Bool})) -> S.Bounds<x, z, y, w, 0n, 0n>:
  match hs:
    case ((hx, hy), (hz, hw)):
      S.Bound{hx, hz, hy, hw, {==}, {==}}

def L.accepted_points_dot(x, y, z, w, ha, hb):
  L.guarded_dot_exact(x, y, z, w, dot_bounds(x, y, z, w, (ValidationProof.and_split(Nat.is_le(x, Limit.maximum()), Nat.is_le(y, Limit.maximum()), ha), ValidationProof.and_split(Nat.is_le(z, Limit.maximum()), Nat.is_le(w, Limit.maximum()), hb))))
