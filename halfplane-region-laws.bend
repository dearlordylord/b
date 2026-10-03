import Base
import ./topology.bend as T
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as H
import ./halfplane-region.bend as M
import ./inside-arithmetic.bend as I
import ./search-witness.bend as Search
import ./sample-arithmetic.bend as S

law edge_halfplane_decoded:
  for +a: T.Point
  for +b: T.Point
  for +w: T.Witness
  {I.edge(a, b, w) == M.edge(N.decode_point(a), N.decode_point(b), M.decode_witness(w)) : Bool}
law inside_halfplanes_decoded:
  for +w: T.Witness
  for +q: T.Quad
  {I.inside(w, q) == M.contains(M.decode_witness(w), N.decode_quad(q)) : Bool}
law production_inside_halfplanes:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +w: T.Witness
  for +q: T.Quad
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for henv: {S.envelope(width, w) == True{} : Bool}
  {T.inside(w, q) == M.contains(M.decode_witness(w), N.decode_quad(q)) : Bool}
law region_positive_scale:
  for +p: H.Point
  for +q: N.Quad
  for +k: Nat
  {M.contains(H.scale(p, k), q) == M.contains(p, q) : Bool}
law region_equivalent_point:
  for +p: H.Point
  for +r: H.Point
  for +q: N.Quad
  for +hp: {H.positive_denominator(p) == True{} : Bool}
  for +hr: {H.positive_denominator(r) == True{} : Bool}
  for +hs: {H.equivalent(p, r) == True{} : Bool}
  {M.contains(p, q) == M.contains(r, q) : Bool}
law common_halfplanes_decoded:
  for +w: T.Witness
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  {I.common(w, a, b, c) == M.common(M.decode_witness(w), N.decode_quad(a), N.decode_quad(b), N.decode_quad(c)) : Bool}
law triangle_halfplane_witness:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for accepted: {T.triangle_witness(a, b, c) == True{} : Bool}
  M.CommonPoint(N.decode_quad(a), N.decode_quad(b), N.decode_quad(c))
