import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./exact-arithmetic.bend as A

def positive(a: N.Point, b: N.Point, p: G.Point) -> Nat:
  match a b p:
    case N.P{ax, ay} N.P{bx, by} G.P{x, y, d}: A.left(ax, ay, bx, by, x, y, d)
def negative(a: N.Point, b: N.Point, p: G.Point) -> Nat:
  match a b p:
    case N.P{ax, ay} N.P{bx, by} G.P{x, y, d}: A.right(ax, ay, bx, by, x, y, d)
# Homogeneous determinant difference, using the doubled-area convention.
def area(+a: N.Point, +b: N.Point, +p: G.Point) -> Nat:
  Nat.sub(positive(a, b, p), negative(a, b, p))
def triangle_area(a: N.Point, b: N.Point, c: N.Point) -> Nat:
  area(a, b, Q.embed(c))
def weights_total(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point) -> Nat:
  Nat.add(Nat.add(area(b, c, p), area(c, a, p)), area(a, b, p))
def positive_total(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point) -> Nat:
  Nat.add(Nat.add(positive(b, c, p), positive(c, a, p)), positive(a, b, p))
def negative_total(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point) -> Nat:
  Nat.add(Nat.add(negative(b, c, p), negative(c, a, p)), negative(a, b, p))
def common(a: N.Point, b: N.Point, c: N.Point, p: G.Point) -> Nat:
  match a b c p:
    case N.P{ax, ay} N.P{bx, by} N.P{cx, cy} G.P{x, y, d}:
      Nat.add(Nat.mul(Nat.add(Nat.add(cx, ax), bx), y), Nat.mul(Nat.add(Nat.add(cy, ay), by), x))
