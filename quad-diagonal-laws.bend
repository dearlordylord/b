import Base
import ./quad-diagonal.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q
import ./topology.bend as T
import ./search-witness.bend as Search
import ./sample-arithmetic.bend as S

law opposite_closed_halfplane:
  for +a: N.Point
  for +b: N.Point
  for +p: G.Point
  for h: {Region.edge(a, b, p) == False{} : Bool}
  {Region.edge(b, a, p) == True{} : Bool}
law region_diagonal_split:
  for +q: N.Quad
  for +p: G.Point
  for h: {Region.contains(p, q) == True{} : Bool}
  M.Split<q, p>
law strict_diagonal_triangles:
  for +q: N.Quad
  for h: {Q.strict_quad(q) == True{} : Bool}
  {M.triangles_strict(q) == True{} : Bool}
law production_diagonal_split:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +w: T.Witness
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for henv: {S.envelope(width, w) == True{} : Bool}
  for h: {T.inside(w, q) == True{} : Bool}
  M.Split<N.decode_quad(q), Region.decode_witness(w)>
