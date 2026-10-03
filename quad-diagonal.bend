import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q

def triangle(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point) -> Bool:
  Region.edge(a, b, p) && Region.edge(b, c, p) && Region.edge(c, a, p)
def triangle_abc(q: N.Quad, p: G.Point) -> Bool:
  match q:
    case N.Q{a, b, c, d}: triangle(a, b, c, p)
def triangle_acd(q: N.Quad, p: G.Point) -> Bool:
  match q:
    case N.Q{a, b, c, d}: triangle(a, c, d, p)
def diagonal_acd(q: N.Quad, p: G.Point) -> Bool:
  match q:
    case N.Q{a, b, c, d}: Region.edge(a, c, p)
def triangles_strict(q: N.Quad) -> Bool:
  match q:
    case N.Q{+a, b, +c, d}: Q.turn(a, b, c) && Q.turn(a, c, d)
type Split<-q: N.Quad, -p: G.Point> is Data:
  ABC{decision: {diagonal_acd(q, p) == False{} : Bool}, inside: {triangle_abc(q, p) == True{} : Bool}}
  ACD{decision: {diagonal_acd(q, p) == True{} : Bool}, inside: {triangle_acd(q, p) == True{} : Bool}}
