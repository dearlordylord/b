import Base
import ./coordinate-limit.bend as Limit
import ./capacity-facts.bend as Capacity
import ./order-facts.bend as O
import ./coordinate-support.bend as Coordinate
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as Conversion
import ./grid-scaling.bend as G
import ./word-comparison-laws.bend as Compare
import ./word-comparison-proof.bend as ComparisonProof
import ./sample-arithmetic.bend as M
import ./sample-arithmetic-laws.bend as L
import ./sample-word-proof.bend as WordProof
import ./topology.bend as T
import ./word-arithmetic.bend as W
import ./boolean-reflection.bend as B

def sixty_four_value() -> {Word.to_nat(32n, M.sixty_four()) == 64n : Nat}:
  {==}

def L.guarded_sample_exact(width, hw, x, y, u, v, n, hs):
  match hs:
    case M.Bound{hx, hy, hu, hv, +hn}:
      Equal.trans(Nat & (Nat & Nat), M.values(T.sample(T.P{U32{x}, U32{y}}, T.P{U32{u}, U32{v}}, U32{n})), (M.numerator(Word.to_nat(32n, x), Word.to_nat(32n, u), Word.to_nat(32n, n)), (Word.to_nat(32n, M.word_sample(32n, y, v, n, M.sixty_four())), 64n)), (M.numerator(Word.to_nat(32n, x), Word.to_nat(32n, u), Word.to_nat(32n, n)), (M.numerator(Word.to_nat(32n, y), Word.to_nat(32n, v), Word.to_nat(32n, n)), 64n)), Equal.cong(Nat, Nat & (Nat & Nat), z => (z, (Word.to_nat(32n, M.word_sample(32n, y, v, n, M.sixty_four())), 64n)), Word.to_nat(32n, M.word_sample(32n, x, u, n, M.sixty_four())), M.numerator(Word.to_nat(32n, x), Word.to_nat(32n, u), Word.to_nat(32n, n)), L.word_sample_exact(32n, {==}, width, hw, x, u, n, M.sixty_four(), sixty_four_value(), hx, hu, hn)), Equal.cong(Nat, Nat & (Nat & Nat), z => (M.numerator(Word.to_nat(32n, x), Word.to_nat(32n, u), Word.to_nat(32n, n)), (z, 64n)), Word.to_nat(32n, M.word_sample(32n, y, v, n, M.sixty_four())), M.numerator(Word.to_nat(32n, y), Word.to_nat(32n, v), Word.to_nat(32n, n)), L.word_sample_exact(32n, {==}, width, hw, y, v, n, M.sixty_four(), sixty_four_value(), hy, hv, hn)))

def model_envelope(+width: Nat, +x: Nat, +y: Nat, +u: Nat, +v: Nat, +n: Nat, hs: M.Bounds<width, x, y, u, v, n>) -> {M.values_envelope(width, (M.numerator(x, u, n), (M.numerator(y, v, n), 64n))) == True{} : Bool}:
  match hs:
    case M.Bound{hx, hy, hu, hv, +hn}:
      B.and_join(Nat.is_le(M.numerator(x, u, n), W.capacity(Nat.add(width, 6n))), Nat.is_le(M.numerator(y, v, n), W.capacity(Nat.add(width, 6n))) && Nat.is_le(64n, W.capacity(6n)), L.sample_numerator_bound(width, x, u, n, hx, hu, hn), B.and_join(Nat.is_le(M.numerator(y, v, n), W.capacity(Nat.add(width, 6n))), Nat.is_le(64n, W.capacity(6n)), L.sample_numerator_bound(width, y, v, n, hy, hv, hn), {==}))

def L.guarded_sample_envelope(width, hw, x, y, u, v, n, hs):
  %Equal.sym(Nat & (Nat & Nat), M.values(T.sample(T.P{U32{x}, U32{y}}, T.P{U32{u}, U32{v}}, U32{n})), (M.numerator(Word.to_nat(32n, x), Word.to_nat(32n, u), Word.to_nat(32n, n)), (M.numerator(Word.to_nat(32n, y), Word.to_nat(32n, v), Word.to_nat(32n, n)), 64n)), L.guarded_sample_exact(width, hw, x, y, u, v, n, hs)) : {M.values_envelope(width, _) == True{} : Bool}
  model_envelope(width, Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, u), Word.to_nat(32n, v), Word.to_nat(32n, n), hs)

def weight_bound(+n: Word(32n), h: {U32.is_le(U32{n}, 64) == True{} : Bool}) -> {Nat.is_le(Word.to_nat(32n, n), 64n) == True{} : Bool}:
  %Compare.u32_less_equal_exact(n, M.sixty_four()) : {_ == True{} : Bool}
  h

def source_bounds(+width: Nat, +x: Word(32n), +y: Word(32n), +u: Word(32n), +v: Word(32n), +n: Word(32n), hs: ({Nat.is_le(Word.to_nat(32n, x), W.capacity(width)) == True{} : Bool} & {Nat.is_le(Word.to_nat(32n, y), W.capacity(width)) == True{} : Bool}) & ({Nat.is_le(Word.to_nat(32n, u), W.capacity(width)) == True{} : Bool} & {Nat.is_le(Word.to_nat(32n, v), W.capacity(width)) == True{} : Bool}), hn: {U32.is_le(U32{n}, 64) == True{} : Bool}) -> M.Bounds<width, Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, u), Word.to_nat(32n, v), Word.to_nat(32n, n)>:
  match hs:
    case ((hx, hy), (hu, hv)): M.Bound{hx, hy, hu, hv, weight_bound(n, hn)}

def L.accepted_sample_exact(width, hw, p, q, n, hp, hq, hn):
  match p q n:
    case T.P{U32{+x}, U32{+y}} T.P{U32{+u}, U32{+v}} U32{+nw}:
      L.guarded_sample_exact(width, hw, x, y, u, v, nw, source_bounds(width, x, y, u, v, nw, (B.and_split(Nat.is_le(Word.to_nat(32n, x), W.capacity(width)), Nat.is_le(Word.to_nat(32n, y), W.capacity(width)), hp), B.and_split(Nat.is_le(Word.to_nat(32n, u), W.capacity(width)), Nat.is_le(Word.to_nat(32n, v), W.capacity(width)), hq)), hn))

def L.accepted_sample_envelope(width, hw, p, q, n, hp, hq, hn):
  match p q n:
    case T.P{U32{+x}, U32{+y}} T.P{U32{+u}, U32{+v}} U32{+nw}:
      L.guarded_sample_envelope(width, hw, x, y, u, v, nw, source_bounds(width, x, y, u, v, nw, (B.and_split(Nat.is_le(Word.to_nat(32n, x), W.capacity(width)), Nat.is_le(Word.to_nat(32n, y), W.capacity(width)), hp), B.and_split(Nat.is_le(Word.to_nat(32n, u), W.capacity(width)), Nat.is_le(Word.to_nat(32n, v), W.capacity(width)), hq)), hn))

def L.vertex_witness_exact(p):
  match p:
    case T.P{x, y}: {==}

def enlarged_bound(+width: Nat, +x: Nat, h: {Nat.is_le(x, W.capacity(width)) == True{} : Bool}) -> {Nat.is_le(x, W.capacity(Nat.add(width, 6n))) == True{} : Bool}:
  O.le_trans(x, W.capacity(width), W.capacity(Nat.add(width, 6n)), h, O.le_of_lt(W.capacity(width), W.capacity(Nat.add(width, 6n)), Capacity.capacity_grows(width, 5n)))

def vertex_envelope(+width: Nat, +x: U32, +y: U32, hs: {Nat.is_le(U32.to_nat(x), W.capacity(width)) == True{} : Bool} & {Nat.is_le(U32.to_nat(y), W.capacity(width)) == True{} : Bool}) -> {M.envelope(width, T.witness(T.P{x, y})) == True{} : Bool}:
  match hs:
    case (hx, hy):
      B.and_join(Nat.is_le(U32.to_nat(x), W.capacity(Nat.add(width, 6n))), Nat.is_le(U32.to_nat(y), W.capacity(Nat.add(width, 6n))) && Nat.is_le(1n, W.capacity(6n)), enlarged_bound(width, U32.to_nat(x), hx), B.and_join(Nat.is_le(U32.to_nat(y), W.capacity(Nat.add(width, 6n))), Nat.is_le(1n, W.capacity(6n)), enlarged_bound(width, U32.to_nat(y), hy), {==}))
def L.vertex_witness_envelope(width, p, hp):
  match p:
    case T.P{+x, +y}: vertex_envelope(width, x, y, B.and_split(Nat.is_le(U32.to_nat(x), W.capacity(width)), Nat.is_le(U32.to_nat(y), W.capacity(width)), hp))

def natural_weight_guard(+n: Nat, +hn: {Nat.is_le(n, 64n) == True{} : Bool}) -> {U32.is_le(U32.from_nat(n), 64) == True{} : Bool}:
  %Equal.sym(U32, U32.from_nat(n), U32{C.from_nat(n, 32n)}, Conversion.u32_conversion_agrees(n)) : {U32.is_le(_, 64) == True{} : Bool}
  %Equal.sym(Bool, U32.is_le(U32{C.from_nat(n, 32n)}, U32{M.sixty_four()}), Nat.is_le(Word.to_nat(32n, C.from_nat(n, 32n)), Word.to_nat(32n, M.sixty_four())), Compare.u32_less_equal_exact(C.from_nat(n, 32n), M.sixty_four())) : {_ == True{} : Bool}
  %Equal.sym(Nat, Word.to_nat(32n, C.from_nat(n, 32n)), n, Conversion.bounded_conversion(n, 32n, Coordinate.coordinate32(n, O.le_trans(n, 64n, Limit.maximum(), hn, {==})))) : {Nat.is_le(_, 64n) == True{} : Bool}
  hn

def successor_bound(+n: Nat, hn: {Nat.is_le(n, 63n) == True{} : Bool}) -> {Nat.is_le(1n+n, 64n) == True{} : Bool}:
  hn
def L.search_weight_guard(fuel, n, hf, hn):
  natural_weight_guard(1n+n, successor_bound(n, O.le_trans(n, fuel, 63n, hn, hf)))
