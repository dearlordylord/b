import Base
import ./topology.bend as T
import ./search-arithmetic.bend as M
import ./search-arithmetic-laws.bend as L
import ./inside-arithmetic.bend as Inside
import ./inside-arithmetic-laws.bend as InsideLaw
import ./inside-arithmetic-proof.bend as InsideProof
import ./sample-arithmetic.bend as S
import ./sample-arithmetic-laws.bend as Sample
import ./sample-production-proof.bend as SampleProof
import ./search-witness-proof.bend as SearchProof
import ./word-conversion-laws.bend as Conversion
import ./coordinate-support.bend as Coordinate
import ./coordinate-limit.bend as Limit
import ./absolute-order-proof.bend as Reflexive
import ./order-facts.bend as Order
import ./grid-scaling.bend as G
import ./search-witness.bend as Search
import ./cover-arithmetic-proof.bend as Cover

def inside_coords_values(+x: U32, +y: U32, +d: U32, q: T.Quad) -> {Inside.inside(T.W{x, y, d}, q) == M.inside_coords(U32.to_nat(x), U32.to_nat(y), U32.to_nat(d), q) : Bool}:
  match q:
    case T.Q{a, b, c, e}: {==}
def common_coords_values(+x: U32, +y: U32, +d: U32, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> {Inside.common(T.W{x, y, d}, a, b, c) == M.common_coords(U32.to_nat(x), U32.to_nat(y), U32.to_nat(d), a, b, c) : Bool}:
  %inside_coords_values(x, y, d, a) : {Inside.common(T.W{x, y, d}, a, b, c) == _ && M.inside_coords(U32.to_nat(x), U32.to_nat(y), U32.to_nat(d), b) && M.inside_coords(U32.to_nat(x), U32.to_nat(y), U32.to_nat(d), c) : Bool}
  %inside_coords_values(x, y, d, b) : {Inside.common(T.W{x, y, d}, a, b, c) == Inside.inside(T.W{x, y, d}, a) && _ && M.inside_coords(U32.to_nat(x), U32.to_nat(y), U32.to_nat(d), c) : Bool}
  %inside_coords_values(x, y, d, c) : {Inside.common(T.W{x, y, d}, a, b, c) == Inside.inside(T.W{x, y, d}, a) && Inside.inside(T.W{x, y, d}, b) && _ : Bool}
  {==}
def common_values(+w: T.Witness, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> {Inside.common(w, a, b, c) == M.common(S.values(w), a, b, c) : Bool}:
  match w:
    case T.W{x, y, d}: common_coords_values(x, y, d, a, b, c)
def word_sample_values(+p: T.Point, +q: T.Point, +n: U32) -> {S.exact_sample(p, q, n) == M.sample(p, q, U32.to_nat(n)) : Nat & (Nat & Nat)}:
  match p q:
    case T.P{x, y} T.P{u, v}: {==}
def natural_sample_values(+p: T.Point, +q: T.Point, +n: Nat, hn: {Nat.is_le(n, 64n) == True{} : Bool}) -> {S.exact_sample(p, q, U32.from_nat(n)) == M.sample(p, q, n) : Nat & (Nat & Nat)}:
  Equal.trans(Nat & (Nat & Nat), S.exact_sample(p, q, U32.from_nat(n)), M.sample(p, q, U32.to_nat(U32.from_nat(n))), M.sample(p, q, n), word_sample_values(p, q, U32.from_nat(n)), Equal.cong(Nat, Nat & (Nat & Nat), k => M.sample(p, q, k), U32.to_nat(U32.from_nat(n)), n, Conversion.bounded_u32_conversion(n, Coordinate.coordinate32(n, Order.le_trans(n, 64n, Limit.maximum(), hn, {==})))))
def classified_values(+width: Nat, +hw: {width == 12n : Nat}, +w: T.Witness, +a: T.Quad, +b: T.Quad, +c: T.Quad, ha: {Search.quad_envelope(width, a) == True{} : Bool}, hb: {Search.quad_envelope(width, b) == True{} : Bool}, hc: {Search.quad_envelope(width, c) == True{} : Bool}, henv: {S.envelope(width, w) == True{} : Bool}) -> {T.common(w, a, b, c) == M.common(S.values(w), a, b, c) : Bool}:
  Equal.trans(Bool, T.common(w, a, b, c), Inside.common(w, a, b, c), M.common(S.values(w), a, b, c), InsideLaw.common_arithmetic_exact(width, hw, w, a, b, c, ha, hb, hc, henv), common_values(w, a, b, c))
def L.sample_common_arithmetic_exact(width, hw, p, q, n, a, b, c, ha, hb, hc, hp, hq, hn):
  Equal.trans(Bool, T.common(T.sample(p, q, U32.from_nat(n)), a, b, c), M.common(S.values(T.sample(p, q, U32.from_nat(n))), a, b, c), M.common(M.sample(p, q, n), a, b, c), classified_values(width, hw, T.sample(p, q, U32.from_nat(n)), a, b, c, ha, hb, hc, Sample.accepted_sample_envelope(width, hw, p, q, U32.from_nat(n), hp, hq, SampleProof.natural_weight_guard(n, hn))), Equal.cong(Nat & (Nat & Nat), Bool, v => M.common(v, a, b, c), S.values(T.sample(p, q, U32.from_nat(n))), M.sample(p, q, n), Equal.trans(Nat & (Nat & Nat), S.values(T.sample(p, q, U32.from_nat(n))), S.exact_sample(p, q, U32.from_nat(n)), M.sample(p, q, n), Sample.accepted_sample_exact(width, hw, p, q, U32.from_nat(n), hp, hq, SampleProof.natural_weight_guard(n, hn)), natural_sample_values(p, q, n, hn))))
def L.vertex_common_arithmetic_exact(width, hw, p, a, b, c, ha, hb, hc, hp):
  Equal.trans(Bool, T.common(T.witness(p), a, b, c), M.common(S.values(T.witness(p)), a, b, c), M.common(S.vertex_values(p), a, b, c), classified_values(width, hw, T.witness(p), a, b, c, ha, hb, hc, Sample.vertex_witness_envelope(width, p, hp)), Equal.cong(Nat & (Nat & Nat), Bool, v => M.common(v, a, b, c), S.values(T.witness(p)), S.vertex_values(p), Sample.vertex_witness_exact(p)))
def L.segment_search_arithmetic_exact(width, hw, p, q, fuel, a, b, c, ha, hb, hc, hp, hq, hf):
  match fuel:
    case Zero{}: {==}
    case Succ{+n}:
      Cover.or_two(T.common(T.sample(p, q, U32.from_nat(Succ{n})), a, b, c), T.segment_search(n, p, q, a, b, c), M.common(M.sample(p, q, Succ{n}), a, b, c), M.segment_search(n, p, q, a, b, c), L.sample_common_arithmetic_exact(width, hw, p, q, Succ{n}, a, b, c, ha, hb, hc, hp, hq, SampleProof.successor_bound(n, Order.le_trans(n, Succ{n}, 63n, Reflexive.le_succ(n), hf))), L.segment_search_arithmetic_exact(width, hw, p, q, n, a, b, c, ha, hb, hc, hp, hq, Order.le_trans(n, Succ{n}, 63n, Reflexive.le_succ(n), hf)))
def L.pair_search_arithmetic_exact(width, hw, p, xs, a, b, c, ha, hb, hc, hp, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      Cover.or_two(T.segment_search(63n, p, h, a, b, c), T.pair_search(t, p, a, b, c), M.segment_search(63n, p, h, a, b, c), M.pair_search(t, p, a, b, c), L.segment_search_arithmetic_exact(width, hw, p, h, 63n, a, b, c, ha, hb, hc, hp, SearchProof.head_bound(width, h, t, hx), {==}), L.pair_search_arithmetic_exact(width, hw, p, t, a, b, c, ha, hb, hc, hp, SearchProof.tail_bound(width, h, t, hx)))
def L.all_pairs_arithmetic_exact(width, hw, xs, a, b, c, ha, hb, hc, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      Cover.or_two(T.pair_search(t, h, a, b, c), T.all_pairs(t, a, b, c), M.pair_search(t, h, a, b, c), M.all_pairs(t, a, b, c), L.pair_search_arithmetic_exact(width, hw, h, t, a, b, c, ha, hb, hc, SearchProof.head_bound(width, h, t, hx), SearchProof.tail_bound(width, h, t, hx)), L.all_pairs_arithmetic_exact(width, hw, t, a, b, c, ha, hb, hc, SearchProof.tail_bound(width, h, t, hx)))
def L.vertex_search_arithmetic_exact(width, hw, xs, a, b, c, ha, hb, hc, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      Cover.or_two(T.common(T.witness(h), a, b, c), T.vertex_search(t, a, b, c), M.common(S.vertex_values(h), a, b, c), M.vertex_search(t, a, b, c), L.vertex_common_arithmetic_exact(width, hw, h, a, b, c, ha, hb, hc, SearchProof.head_bound(width, h, t, hx)), L.vertex_search_arithmetic_exact(width, hw, t, a, b, c, ha, hb, hc, SearchProof.tail_bound(width, h, t, hx)))
def L.triangle_search_arithmetic_exact(width, hw, xs, a, b, c, ha, hb, hc, hx):
  Cover.or_two(T.vertex_search(xs, a, b, c), T.all_pairs(xs, a, b, c), M.vertex_search(xs, a, b, c), M.all_pairs(xs, a, b, c), L.vertex_search_arithmetic_exact(width, hw, xs, a, b, c, ha, hb, hc, hx), L.all_pairs_arithmetic_exact(width, hw, xs, a, b, c, ha, hb, hc, hx))
def L.triangle_witness_arithmetic_exact(width, hw, a, b, c, ha, hb, hc):
  L.triangle_search_arithmetic_exact(width, hw, List.append(&2, T.Point, T.vertices(a), List.append(&2, T.Point, T.vertices(b), T.vertices(c))), a, b, c, ha, hb, hc, SearchProof.append_bound(width, T.vertices(a), List.append(&2, T.Point, T.vertices(b), T.vertices(c)), ha, SearchProof.append_bound(width, T.vertices(b), T.vertices(c), hb, hc)))
