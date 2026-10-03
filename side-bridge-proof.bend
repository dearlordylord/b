import Base
import ./side-bridge.bend as M
import ./side-bridge-laws.bend as L
import ./grid-scaling.bend as G
import ./sample-arithmetic.bend as S
import ./sample-arithmetic-laws.bend as Sample
import ./sample-production-proof.bend as SampleProof
import ./witness-arithmetic.bend as A
import ./witness-arithmetic-laws.bend as Arithmetic
import ./witness-arithmetic-proof.bend as ArithmeticProof
import ./topology.bend as T
import ./word-arithmetic.bend as W
import ./boolean-reflection.bend as B

def witness_tail(+width: Nat, +x: Nat, +y: Nat, +d: Nat, hs: {Nat.is_le(x, W.capacity(Nat.add(width, 6n))) == True{} : Bool} & {Nat.is_le(y, W.capacity(Nat.add(width, 6n))) && Nat.is_le(d, W.capacity(6n)) == True{} : Bool}) -> {Nat.is_le(x, W.capacity(Nat.add(width, 6n))) == True{} : Bool} & ({Nat.is_le(y, W.capacity(Nat.add(width, 6n))) == True{} : Bool} & {Nat.is_le(d, W.capacity(6n)) == True{} : Bool}):
  match hs:
    case (hx, tail): (hx, B.and_split(Nat.is_le(y, W.capacity(Nat.add(width, 6n))), Nat.is_le(d, W.capacity(6n)), tail))
def witness_fields(+width: Nat, +x: Nat, +y: Nat, +d: Nat, h: {Nat.is_le(x, W.capacity(Nat.add(width, 6n))) && (Nat.is_le(y, W.capacity(Nat.add(width, 6n))) && Nat.is_le(d, W.capacity(6n))) == True{} : Bool}) -> {Nat.is_le(x, W.capacity(Nat.add(width, 6n))) == True{} : Bool} & ({Nat.is_le(y, W.capacity(Nat.add(width, 6n))) == True{} : Bool} & {Nat.is_le(d, W.capacity(6n)) == True{} : Bool}):
  witness_tail(width, x, y, d, B.and_split(Nat.is_le(x, W.capacity(Nat.add(width, 6n))), Nat.is_le(y, W.capacity(Nat.add(width, 6n))) && Nat.is_le(d, W.capacity(6n)), h))

def fields(+width: Nat, +ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat, hs: ({Nat.is_le(ax, W.capacity(width)) == True{} : Bool} & {Nat.is_le(ay, W.capacity(width)) == True{} : Bool}) & (({Nat.is_le(bx, W.capacity(width)) == True{} : Bool} & {Nat.is_le(by, W.capacity(width)) == True{} : Bool}) & ({Nat.is_le(x, W.capacity(Nat.add(width, 6n))) == True{} : Bool} & ({Nat.is_le(y, W.capacity(Nat.add(width, 6n))) == True{} : Bool} & {Nat.is_le(d, W.capacity(6n)) == True{} : Bool})))) -> A.Bounds<width, ax, ay, bx, by, x, y, d>:
  match hs:
    case ((hax, hay), ((hbx, hby), (hx, (hy, hd)))): A.Bound{hax, hay, hbx, hby, hx, hy, hd}

def L.accepted_side_exact(width, hw, a, b, w, ha, hb, hwitness):
  match a b w:
    case T.P{U32{+ax}, U32{+ay}} T.P{U32{+bx}, U32{+by}} T.W{U32{+x}, U32{+y}, U32{+d}}:
      Arithmetic.guarded_side_exact(width, hw, ax, ay, bx, by, x, y, d, fields(width, Word.to_nat(32n, ax), Word.to_nat(32n, ay), Word.to_nat(32n, bx), Word.to_nat(32n, by), Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, d), (B.and_split(Nat.is_le(Word.to_nat(32n, ax), W.capacity(width)), Nat.is_le(Word.to_nat(32n, ay), W.capacity(width)), ha), (B.and_split(Nat.is_le(Word.to_nat(32n, bx), W.capacity(width)), Nat.is_le(Word.to_nat(32n, by), W.capacity(width)), hb), witness_fields(width, Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, d), hwitness)))))

def L.sampled_side_exact(width, hw, a, b, p, q, n, ha, hb, hp, hq, hn):
  Equal.trans(Cmp, T.side(a, b, T.sample(p, q, n)), M.exact(a, b, T.sample(p, q, n)), M.from_values(a, b, S.exact_sample(p, q, n)), L.accepted_side_exact(width, hw, a, b, T.sample(p, q, n), ha, hb, Sample.accepted_sample_envelope(width, hw, p, q, n, hp, hq, hn)), Equal.cong(Nat & (Nat & Nat), Cmp, coordinates => M.from_values(a, b, coordinates), S.values(T.sample(p, q, n)), S.exact_sample(p, q, n), Sample.accepted_sample_exact(width, hw, p, q, n, hp, hq, hn)))

def L.vertex_side_exact(width, hw, a, b, p, ha, hb, hp):
  Equal.trans(Cmp, T.side(a, b, T.witness(p)), M.exact(a, b, T.witness(p)), M.from_values(a, b, S.vertex_values(p)), L.accepted_side_exact(width, hw, a, b, T.witness(p), ha, hb, Sample.vertex_witness_envelope(width, p, hp)), Equal.cong(Nat & (Nat & Nat), Cmp, coordinates => M.from_values(a, b, coordinates), S.values(T.witness(p)), S.vertex_values(p), Sample.vertex_witness_exact(p)))
