import Base
import ./topology.bend as T
import ./side-bridge.bend as Side
import ./sample-arithmetic.bend as S

def vertex(a: T.Point, b: T.Point, p: T.Point) -> Cmp:
  Side.from_values(a, b, S.vertex_values(p))
def negative(a: T.Point, b: T.Point, p: T.Point) -> Bool:
  Cmp.is_lt(vertex(a, b, p))
def positive(a: T.Point, b: T.Point, p: T.Point) -> Bool:
  Cmp.is_gt(vertex(a, b, p))
def separated(+a: T.Point, +b: T.Point, q: T.Quad) -> Bool:
  match q:
    case T.Q{p, q, r, s}:
      negative(a, b, p) && negative(a, b, q) && negative(a, b, r) && negative(a, b, s)
def outside(q: T.Quad, +r: T.Quad) -> Bool:
  match q:
    case T.Q{+a, +b, +c, +d}:
      separated(a, b, r) || separated(b, c, r) || separated(c, d, r) || separated(d, a, r)
def meets(+q: T.Quad, +r: T.Quad) -> Bool:
  Bool.not(outside(q, r) || outside(r, q))
def strictly_convex(q: T.Quad) -> Bool:
  match q:
    case T.Q{+a, +b, +c, +d}:
      positive(a, b, c) && positive(b, c, d) && positive(c, d, a) && positive(d, a, b)
def orientation(q: T.Quad) -> Bool:
  match q:
    case T.Q{a, b, c, d}: positive(a, b, c)
