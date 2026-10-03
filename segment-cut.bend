import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./triangle-area.bend as A

def negative_gap(+a: N.Point, +b: N.Point, +p: G.Point) -> Nat:
  Nat.sub(A.negative(a, b, p), A.positive(a, b, p))
def first_weight(a: N.Point, b: N.Point, q: G.Point) -> Nat:
  negative_gap(a, b, q)
def second_weight(a: N.Point, b: N.Point, p: G.Point) -> Nat:
  A.area(a, b, p)
def point(+a: N.Point, +b: N.Point, +p: G.Point, +q: G.Point) -> G.Point:
  C.join(p, q, first_weight(a, b, q), second_weight(a, b, p))
def on_line(a: N.Point, b: N.Point, p: G.Point) -> Bool:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: Cmp.is_eq(G.side(ax, ay, bx, by, p))
# Rational segment membership, with validity of endpoints and result explicit.
def InSegment(-p: G.Point, -q: G.Point, -r: G.Point) -> Type:
  &k:Nat -> &l:Nat -> {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool} & ({G.positive_denominator(p) == True{} : Bool} & ({G.positive_denominator(q) == True{} : Bool} & ({G.positive_denominator(r) == True{} : Bool} & {G.equivalent(r, C.join(p, q, k, l)) == True{} : Bool})))
