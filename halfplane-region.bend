import Base
import ./topology.bend as T
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as H

def decode_witness(w: T.Witness) -> H.Point:
  match w:
    case T.W{x, y, d}: H.P{U32.to_nat(x), U32.to_nat(y), U32.to_nat(d)}
def edge(a: N.Point, b: N.Point, p: H.Point) -> Bool:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: H.left_closed(ax, ay, bx, by, p)
def contains(+p: H.Point, q: N.Quad) -> Bool:
  match q:
    case N.Q{+a, +b, +c, +d}: edge(a, b, p) && edge(b, c, p) && edge(c, d, p) && edge(d, a, p)
def common(+p: H.Point, a: N.Quad, b: N.Quad, c: N.Quad) -> Bool:
  contains(p, a) && contains(p, b) && contains(p, c)
def CommonPoint(-a: N.Quad, -b: N.Quad, -c: N.Quad) -> Type:
  &p:H.Point -> {H.positive_denominator(p) == True{} : Bool} & {common(p, a, b, c) == True{} : Bool}
