import Base
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./search-witness.bend as M

# A successful production segment search supplies its own bounded witness.
law segment_search_hit:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +fuel: Nat
  for +p: T.Point
  for +q: T.Point
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +hp: {G.envelope(width, p) == True{} : Bool}
  for +hq: {G.envelope(width, q) == True{} : Bool}
  for +hf: {Nat.is_le(fuel, 63n) == True{} : Bool}
  for accepted: {T.segment_search(fuel, p, q, a, b, c) == True{} : Bool}
  M.Hit(width, a, b, c, 64)

law pair_search_hit:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +hxs: {M.points_envelope(width, xs) == True{} : Bool}
  for +p: T.Point
  for +hp: {G.envelope(width, p) == True{} : Bool}
  for accepted: {T.pair_search(xs, p, a, b, c) == True{} : Bool}
  M.Hit(width, a, b, c, 64)

law all_pairs_hit:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +hxs: {M.points_envelope(width, xs) == True{} : Bool}
  for accepted: {T.all_pairs(xs, a, b, c) == True{} : Bool}
  M.Hit(width, a, b, c, 64)

law vertex_search_hit:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +hxs: {M.points_envelope(width, xs) == True{} : Bool}
  for accepted: {T.vertex_search(xs, a, b, c) == True{} : Bool}
  M.Hit(width, a, b, c, 1)

law triangle_search_ready:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Point>
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +hxs: {M.points_envelope(width, xs) == True{} : Bool}
  for accepted: {T.triangle_search(xs, a, b, c) == True{} : Bool}
  M.Ready(width, a, b, c)

law triangle_witness_ready:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for ha: {M.quad_envelope(width, a) == True{} : Bool}
  for hb: {M.quad_envelope(width, b) == True{} : Bool}
  for hc: {M.quad_envelope(width, c) == True{} : Bool}
  for accepted: {T.triangle_witness(a, b, c) == True{} : Bool}
  M.Ready(width, a, b, c)
