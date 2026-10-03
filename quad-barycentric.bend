import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./triangle-area.bend as A
import ./quad-diagonal.bend as D
import ./quad-hull.bend as H

# Area weights in the original A,B,C,D corner order.
type Weights is Data:
  W{a: Nat, b: Nat, c: Nat, d: Nat}
def abc(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point) -> Weights:
  W{A.area(b, c, p), A.area(c, a, p), A.area(a, b, p), 0n}
def acd(+a: N.Point, +c: N.Point, +d: N.Point, +p: G.Point) -> Weights:
  W{A.area(c, d, p), 0n, A.area(d, a, p), A.area(a, c, p)}
def choose(q: N.Quad, p: G.Point, choice: Bool) -> Weights:
  match q choice:
    case N.Q{a, b, c, d} False{}: abc(a, b, c, p)
    case N.Q{a, b, c, d} True{}: acd(a, c, d, p)
def selected(+q: N.Quad, +p: G.Point) -> Weights:
  choose(q, p, D.diagonal_acd(q, p))
def total(w: Weights) -> Nat:
  match w:
    case W{k, l, m, n}: H.weight_total(k, l, m, n)
def point(q: N.Quad, w: Weights) -> G.Point:
  match w:
    case W{k, l, m, n}: H.weighted(q, k, l, m, n)

# A common rational point carries independent four-weight membership evidence
# for every cell. Each InHull witness includes the positive-point domain.
def CommonHull(-a: N.Quad, -b: N.Quad, -c: N.Quad) -> Type:
  &p:G.Point -> H.InHull(a, p) & (H.InHull(b, p) & H.InHull(c, p))
