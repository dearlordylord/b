import Base
import ./search-witness-laws.bend as L
import ./search-witness.bend as M
import ./topology.bend as T
import ./sample-arithmetic.bend as S
import ./sample-arithmetic-laws.bend as Sample
import ./sample-production-proof.bend as SampleProof
import ./grid-scaling.bend as G
import ./boolean-reflection.bend as B
import ./absolute-order-proof.bend as Reflexive
import ./order-facts.bend as Order

def sample_denominator(p: T.Point, q: T.Point, n: U32) -> {M.denominator(T.sample(p, q, n)) == 64 : U32}:
  match p, q:
    case T.P{x, y}, T.P{u, v}: {==}

def choice(+width: Nat, +a: T.Quad, +b: T.Quad, +c: T.Quad, +w: T.Witness, head: Bool, +tail: Bool, common: {T.common(w, a, b, c) == head : Bool}, envelope: {S.envelope(width, w) == True{} : Bool}, denominator: {M.denominator(w) == 64 : U32}, ih: {tail == True{} : Bool} -> M.Hit(width, a, b, c, 64), accepted: {Bool.or(head, tail) == True{} : Bool}) -> M.Hit(width, a, b, c, 64):
  match head:
    case False{}: ih(accepted)
    case True{}: (w, (envelope, (common, denominator)))

def L.segment_search_hit(width, hw, fuel, p, q, a, b, c, hp, hq, hf, accepted):
  match fuel:
    case 0n:
      B.absurd(M.Hit(width, a, b, c, 64), B.false_impossible(accepted))
    case 1n++n:
      choice(width, a, b, c, T.sample(p, q, U32.from_nat(1n+n)), T.common(T.sample(p, q, U32.from_nat(1n+n)), a, b, c), T.segment_search(n, p, q, a, b, c), {==}, Sample.accepted_sample_envelope(width, hw, p, q, U32.from_nat(1n+n), hp, hq, Sample.search_weight_guard(1n+n, n, hf, Reflexive.le_succ(n))), sample_denominator(p, q, U32.from_nat(1n+n)), h => L.segment_search_hit(width, hw, n, p, q, a, b, c, hp, hq, Order.le_trans(n, 1n+n, 63n, Reflexive.le_succ(n), hf), h), accepted)

def head_bound(+width: Nat, +h: T.Point, +t: List<&2, T.Point>, hs: {M.points_envelope(width, Con{h, t}) == True{} : Bool}) -> {G.envelope(width, h) == True{} : Bool}:
  Pair.fst({G.envelope(width, h) == True{} : Bool}, {M.points_envelope(width, t) == True{} : Bool}, B.and_split(G.envelope(width, h), M.points_envelope(width, t), hs))
def tail_bound(+width: Nat, +h: T.Point, +t: List<&2, T.Point>, hs: {M.points_envelope(width, Con{h, t}) == True{} : Bool}) -> {M.points_envelope(width, t) == True{} : Bool}:
  Pair.snd({G.envelope(width, h) == True{} : Bool}, {M.points_envelope(width, t) == True{} : Bool}, B.and_split(G.envelope(width, h), M.points_envelope(width, t), hs))

def choose_hit(-R: Type, head: Bool, +tail: Bool, first: {head == True{} : Bool} -> R, rest: {tail == True{} : Bool} -> R, accepted: {Bool.or(head, tail) == True{} : Bool}) -> R:
  match head:
    case False{}: rest(accepted)
    case True{}: first({==})

def L.pair_search_hit(width, hw, xs, a, b, c, hxs, p, hp, accepted):
  match xs:
    case Nil{}: B.absurd(M.Hit(width, a, b, c, 64), B.false_impossible(accepted))
    case Con{+h, +t}:
      choose_hit(M.Hit(width, a, b, c, 64), T.segment_search(63n, p, h, a, b, c), T.pair_search(t, p, a, b, c), hit => L.segment_search_hit(width, hw, 63n, p, h, a, b, c, hp, head_bound(width, h, t, hxs), {==}, hit), hit => L.pair_search_hit(width, hw, t, a, b, c, tail_bound(width, h, t, hxs), p, hp, hit), accepted)

def L.all_pairs_hit(width, hw, xs, a, b, c, hxs, accepted):
  match xs:
    case Nil{}: B.absurd(M.Hit(width, a, b, c, 64), B.false_impossible(accepted))
    case Con{+h, +t}:
      choose_hit(M.Hit(width, a, b, c, 64), T.pair_search(t, h, a, b, c), T.all_pairs(t, a, b, c), hit => L.pair_search_hit(width, hw, t, a, b, c, tail_bound(width, h, t, hxs), h, head_bound(width, h, t, hxs), hit), hit => L.all_pairs_hit(width, hw, t, a, b, c, tail_bound(width, h, t, hxs), hit), accepted)

def vertex_denominator(p: T.Point) -> {M.denominator(T.witness(p)) == 1 : U32}:
  match p:
    case T.P{x, y}: {==}

def L.vertex_search_hit(width, hw, xs, a, b, c, hxs, accepted):
  match xs:
    case Nil{}: B.absurd(M.Hit(width, a, b, c, 1), B.false_impossible(accepted))
    case Con{+h, +t}:
      choose_hit(M.Hit(width, a, b, c, 1), T.common(T.witness(h), a, b, c), T.vertex_search(t, a, b, c), hit => (T.witness(h), (Sample.vertex_witness_envelope(width, h, head_bound(width, h, t, hxs)), (hit, vertex_denominator(h)))), hit => L.vertex_search_hit(width, hw, t, a, b, c, tail_bound(width, h, t, hxs), hit), accepted)

def positive_hit(+width: Nat, +a: T.Quad, +b: T.Quad, +c: T.Quad, +d: U32, positive: {U32.is_gt(d, 0) == True{} : Bool}, found: M.Hit(width, a, b, c, d)) -> M.Ready(width, a, b, c):
  match found:
    case (+w, (envelope, (common, denominator))):
      (w, (envelope, (common, Equal.trans(Bool, U32.is_gt(M.denominator(w), 0), U32.is_gt(d, 0), True{}, Equal.cong(U32, Bool, x => U32.is_gt(x, 0), M.denominator(w), d, denominator), positive))))

def L.triangle_search_ready(width, hw, xs, a, b, c, hxs, accepted):
  choose_hit(M.Ready(width, a, b, c), T.vertex_search(xs, a, b, c), T.all_pairs(xs, a, b, c), hit => positive_hit(width, a, b, c, 1, {==}, L.vertex_search_hit(width, hw, xs, a, b, c, hxs, hit)), hit => positive_hit(width, a, b, c, 64, {==}, L.all_pairs_hit(width, hw, xs, a, b, c, hxs, hit)), accepted)

def append_bound(+width: Nat, xs: List<&2, T.Point>, +ys: List<&2, T.Point>, +hx: {M.points_envelope(width, xs) == True{} : Bool}, +hy: {M.points_envelope(width, ys) == True{} : Bool}) -> {M.points_envelope(width, List.append(&2, T.Point, xs, ys)) == True{} : Bool}:
  match xs:
    case Nil{}: hy
    case Con{+h, +t}:
      B.and_join(G.envelope(width, h), M.points_envelope(width, List.append(&2, T.Point, t, ys)), head_bound(width, h, t, hx), append_bound(width, t, ys, tail_bound(width, h, t, hx), hy))

def L.triangle_witness_ready(width, hw, a, b, c, ha, hb, hc, accepted):
  L.triangle_search_ready(width, hw, List.append(&2, T.Point, T.vertices(a), List.append(&2, T.Point, T.vertices(b), T.vertices(c))), a, b, c, append_bound(width, T.vertices(a), List.append(&2, T.Point, T.vertices(b), T.vertices(c)), ha, append_bound(width, T.vertices(b), T.vertices(c), hb, hc)), accepted)
