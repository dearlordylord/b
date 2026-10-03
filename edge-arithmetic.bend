import Base
import ./topology.bend as T

def point_equal(a: T.Point, b: T.Point) -> Bool:
  match a b:
    case T.P{x, y} T.P{u, v}:
      Nat.is_eq(U32.to_nat(x), U32.to_nat(u)) && Nat.is_eq(U32.to_nat(y), U32.to_nat(v))
def reverse_edge(+a: T.Point, +b: T.Point, q: T.Quad) -> Bool:
  match q:
    case T.Q{+p, +q, +r, +s}:
      (point_equal(a, q) && point_equal(b, p)) || (point_equal(a, r) && point_equal(b, q)) || (point_equal(a, s) && point_equal(b, r)) || (point_equal(a, p) && point_equal(b, s))
def shared_edge(q: T.Quad, +r: T.Quad) -> Bool:
  match q:
    case T.Q{+a, +b, +c, +d}:
      reverse_edge(a, b, r) || reverse_edge(b, c, r) || reverse_edge(c, d, r) || reverse_edge(d, a, r)
