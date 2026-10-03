import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region

def embed(p: N.Point) -> G.Point:
  match p:
    case N.P{x, y}: G.P{x, y, 1n}
def side(a: N.Point, b: N.Point, c: N.Point) -> Cmp:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: G.side(ax, ay, bx, by, embed(c))
def turn(a: N.Point, b: N.Point, c: N.Point) -> Bool:
  Cmp.is_gt(side(a, b, c))
def strict_quad(q: N.Quad) -> Bool:
  match q:
    case N.Q{+a, +b, +c, +d}: turn(a, b, c) && turn(b, c, d) && turn(c, d, a) && turn(d, a, b)
def corners_inside(q: N.Quad) -> Bool:
  match q:
    case N.Q{+a, +b, +c, +d}: Region.contains(embed(a), N.Q{a, b, c, d}) && Region.contains(embed(b), N.Q{a, b, c, d}) && Region.contains(embed(c), N.Q{a, b, c, d}) && Region.contains(embed(d), N.Q{a, b, c, d})
