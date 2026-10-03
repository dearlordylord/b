import Base
import ./grid-scaling.bend as G
import ./topology.bend as T
import ./sample-arithmetic.bend as M
import ./word-arithmetic.bend as W

law sample_weight_partition:
  for +n: Nat
  for h: {Nat.is_le(n, 64n) == True{} : Bool}
  {Nat.add(Nat.sub(64n, n), n) == 64n : Nat}

law sample_numerator_bound:
  for +width: Nat
  for +a: Nat
  for +b: Nat
  for +n: Nat
  for ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}
  for hb: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}
  for hn: {Nat.is_le(n, 64n) == True{} : Bool}
  {Nat.is_le(M.numerator(a, b, n), W.capacity(Nat.add(width, 6n))) == True{} : Bool}

law word_sample_exact:
  for +bits: Nat
  for +hb: {bits == 32n : Nat}
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: Word(bits)
  for +b: Word(bits)
  for +n: Word(bits)
  for +sixty_four: Word(bits)
  for +h64: {Word.to_nat(bits, sixty_four) == 64n : Nat}
  for ha: {Nat.is_le(Word.to_nat(bits, a), W.capacity(width)) == True{} : Bool}
  for hc: {Nat.is_le(Word.to_nat(bits, b), W.capacity(width)) == True{} : Bool}
  for +hn: {Nat.is_le(Word.to_nat(bits, n), 64n) == True{} : Bool}
  {Word.to_nat(bits, M.word_sample(bits, a, b, n, sixty_four)) == M.numerator(Word.to_nat(bits, a), Word.to_nat(bits, b), Word.to_nat(bits, n)) : Nat}

law guarded_sample_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +x: Word(32n)
  for +y: Word(32n)
  for +u: Word(32n)
  for +v: Word(32n)
  for +n: Word(32n)
  for +hs: M.Bounds<width, Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, u), Word.to_nat(32n, v), Word.to_nat(32n, n)>
  {M.values(T.sample(T.P{U32{x}, U32{y}}, T.P{U32{u}, U32{v}}, U32{n})) == (M.numerator(Word.to_nat(32n, x), Word.to_nat(32n, u), Word.to_nat(32n, n)), (M.numerator(Word.to_nat(32n, y), Word.to_nat(32n, v), Word.to_nat(32n, n)), 64n)) : Nat & (Nat & Nat)}

law guarded_sample_envelope:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +x: Word(32n)
  for +y: Word(32n)
  for +u: Word(32n)
  for +v: Word(32n)
  for +n: Word(32n)
  for +hs: M.Bounds<width, Word.to_nat(32n, x), Word.to_nat(32n, y), Word.to_nat(32n, u), Word.to_nat(32n, v), Word.to_nat(32n, n)>
  {M.envelope(width, T.sample(T.P{U32{x}, U32{y}}, T.P{U32{u}, U32{v}}, U32{n})) == True{} : Bool}

law accepted_sample_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +p: T.Point
  for +q: T.Point
  for +n: U32
  for hp: {G.envelope(width, p) == True{} : Bool}
  for hq: {G.envelope(width, q) == True{} : Bool}
  for hn: {U32.is_le(n, 64) == True{} : Bool}
  {M.values(T.sample(p, q, n)) == M.exact_sample(p, q, n) : Nat & (Nat & Nat)}

law accepted_sample_envelope:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +p: T.Point
  for +q: T.Point
  for +n: U32
  for hp: {G.envelope(width, p) == True{} : Bool}
  for hq: {G.envelope(width, q) == True{} : Bool}
  for hn: {U32.is_le(n, 64) == True{} : Bool}
  {M.envelope(width, T.sample(p, q, n)) == True{} : Bool}

law vertex_witness_exact:
  for +p: T.Point
  {M.values(T.witness(p)) == M.vertex_values(p) : Nat & (Nat & Nat)}
law vertex_witness_envelope:
  for +width: Nat
  for +p: T.Point
  for hp: {G.envelope(width, p) == True{} : Bool}
  {M.envelope(width, T.witness(p)) == True{} : Bool}
law search_weight_guard:
  for +fuel: Nat
  for +n: Nat
  for hf: {Nat.is_le(fuel, 63n) == True{} : Bool}
  for hn: {Nat.is_le(n, fuel) == True{} : Bool}
  {U32.is_le(U32.from_nat(1n+n), 64) == True{} : Bool}
