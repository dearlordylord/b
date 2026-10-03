import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q

def negative(a: N.Point, b: N.Point, p: G.Point) -> Bool:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: Cmp.is_lt(G.side(ax, ay, bx, by, p))
def separated(+a: N.Point, +b: N.Point, q: N.Quad) -> Bool:
  match q:
    case N.Q{p, q, r, s}:
      negative(a, b, Q.embed(p)) && negative(a, b, Q.embed(q)) && negative(a, b, Q.embed(r)) && negative(a, b, Q.embed(s))
