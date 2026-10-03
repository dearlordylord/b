import Base
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./sat-arithmetic.bend as M
import ./search-witness.bend as Search

law negative_vertex_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +p: T.Point
  for ha: {G.envelope(width, a) == True{} : Bool}
  for hb: {G.envelope(width, b) == True{} : Bool}
  for hp: {G.envelope(width, p) == True{} : Bool}
  {T.negative(T.side(a, b, T.witness(p))) == M.negative(a, b, p) : Bool}

law positive_vertex_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +p: T.Point
  for ha: {G.envelope(width, a) == True{} : Bool}
  for hb: {G.envelope(width, b) == True{} : Bool}
  for hp: {G.envelope(width, p) == True{} : Bool}
  {T.positive(T.side(a, b, T.witness(p))) == M.positive(a, b, p) : Bool}

law separated_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +q: T.Quad
  for +ha: {G.envelope(width, a) == True{} : Bool}
  for +hb: {G.envelope(width, b) == True{} : Bool}
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  {T.separated(a, b, q) == M.separated(a, b, q) : Bool}

law outside_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +r: T.Quad
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hr: {Search.quad_envelope(width, r) == True{} : Bool}
  {T.outside(q, r) == M.outside(q, r) : Bool}

law meets_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +r: T.Quad
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hr: {Search.quad_envelope(width, r) == True{} : Bool}
  {T.meets(q, r) == M.meets(q, r) : Bool}

law strictly_convex_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  {T.strictly_convex(q) == M.strictly_convex(q) : Bool}

law orientation_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  {T.orientation(q) == M.orientation(q) : Bool}
