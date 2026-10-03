import Base
import ./halfplane-region.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as H
import ./homogeneous-geometry-laws.bend as HL
import ./homogeneous-geometry-proof.bend as HP
import ./boolean-reflection.bend as B

# Pure representation transport, independent of native witness decoding.
def edge_equivalent(+p: H.Point, +r: H.Point, a: N.Point, b: N.Point, +hp: {H.positive_denominator(p) == True{} : Bool}, +hr: {H.positive_denominator(r) == True{} : Bool}, +hs: {H.equivalent(p, r) == True{} : Bool}) -> {M.edge(a, b, p) == M.edge(a, b, r) : Bool}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: HL.equivalent_point_closed_halfplane(ax, ay, bx, by, p, r, hp, hr, hs)
def region_equivalent_point(+p:H.Point,+r:H.Point,+q:N.Quad,+hp:{H.positive_denominator(p) == True{} : Bool},+hr:{H.positive_denominator(r) == True{} : Bool},+hs:{H.equivalent(p,r) == True{} : Bool}) -> {M.contains(p,q) == M.contains(r,q) : Bool}:
  match q:
    case N.Q{+a, +b, +c, +d}:
      B.four_cong(M.edge(a, b, p), M.edge(b, c, p), M.edge(c, d, p), M.edge(d, a, p), M.edge(a, b, r), M.edge(b, c, r), M.edge(c, d, r), M.edge(d, a, r), edge_equivalent(p, r, a, b, hp, hr, hs), edge_equivalent(p, r, b, c, hp, hr, hs), edge_equivalent(p, r, c, d, hp, hr, hs), edge_equivalent(p, r, d, a, hp, hr, hs))
