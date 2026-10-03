import Base
import ./topology.bend as T
import ./search-arithmetic.bend as M
import ./search-witness.bend as Search
import ./grid-scaling.bend as G
import ./sample-arithmetic.bend as S

law sample_common_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +p: T.Point
  for +q: T.Point
  for +n: Nat
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +hp: {G.envelope(width, p) == True{} : Bool}
  for +hq: {G.envelope(width, q) == True{} : Bool}
  for +hn: {Nat.is_le(n, 64n) == True{} : Bool}
  {T.common(T.sample(p, q, U32.from_nat(n)), a, b, c) == M.common(M.sample(p, q, n), a, b, c) : Bool}

law vertex_common_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +p: T.Point
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +hp: {G.envelope(width, p) == True{} : Bool}
  {T.common(T.witness(p), a, b, c) == M.common(S.vertex_values(p), a, b, c) : Bool}

law segment_search_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +p: T.Point
  for +q: T.Point
  for +fuel: Nat
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +hp: {G.envelope(width, p) == True{} : Bool}
  for +hq: {G.envelope(width, q) == True{} : Bool}
  for +hf: {Nat.is_le(fuel, 63n) == True{} : Bool}
  {T.segment_search(fuel, p, q, a, b, c) == M.segment_search(fuel, p, q, a, b, c) : Bool}

law pair_search_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +p: T.Point
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +hp: {G.envelope(width, p) == True{} : Bool}
  for +hx: {Search.points_envelope(width, xs) == True{} : Bool}
  {T.pair_search(xs, p, a, b, c) == M.pair_search(xs, p, a, b, c) : Bool}

law all_pairs_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +hx: {Search.points_envelope(width, xs) == True{} : Bool}
  {T.all_pairs(xs, a, b, c) == M.all_pairs(xs, a, b, c) : Bool}

law vertex_search_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +hx: {Search.points_envelope(width, xs) == True{} : Bool}
  {T.vertex_search(xs, a, b, c) == M.vertex_search(xs, a, b, c) : Bool}

law triangle_search_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +hx: {Search.points_envelope(width, xs) == True{} : Bool}
  {T.triangle_search(xs, a, b, c) == M.triangle_search(xs, a, b, c) : Bool}

law triangle_witness_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  {T.triangle_witness(a, b, c) == M.triangle_witness(a, b, c) : Bool}
