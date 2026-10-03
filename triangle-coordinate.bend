import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./triangle-area.bend as A

def corner_coordinate(p: N.Point, axis: Bool) -> Nat:
  match p:
    case N.P{x, y}: Bool.pick(Nat, axis, y, x)
def point_coordinate(p: G.Point, axis: Bool) -> Nat:
  match p:
    case G.P{x, y, d}: Bool.pick(Nat, axis, y, x)
def weighted(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point, +axis: Bool) -> Nat:
  Nat.add(Nat.add(Nat.mul(corner_coordinate(a, axis), A.area(b, c, p)), Nat.mul(corner_coordinate(b, axis), A.area(c, a, p))), Nat.mul(corner_coordinate(c, axis), A.area(a, b, p)))
def positive_weighted(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point, +axis: Bool) -> Nat:
  Nat.add(Nat.add(Nat.mul(corner_coordinate(a, axis), A.positive(b, c, p)), Nat.mul(corner_coordinate(b, axis), A.positive(c, a, p))), Nat.mul(corner_coordinate(c, axis), A.positive(a, b, p)))
def negative_weighted(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point, +axis: Bool) -> Nat:
  Nat.add(Nat.add(Nat.mul(corner_coordinate(a, axis), A.negative(b, c, p)), Nat.mul(corner_coordinate(b, axis), A.negative(c, a, p))), Nat.mul(corner_coordinate(c, axis), A.negative(a, b, p)))
def common_x(a: N.Point, b: N.Point, c: N.Point, p: G.Point) -> Nat:
  match a b c p:
    case N.P{+ax, +ay} N.P{+bx, +by} N.P{+cx, +cy} G.P{x, y, d}:
      Nat.add(Nat.mul(Nat.add(Nat.add(Nat.mul(ax, Nat.mul(by, cx)), Nat.mul(bx, Nat.mul(cy, ax))), Nat.mul(cx, Nat.mul(ay, bx))), d), Nat.mul(Nat.add(Nat.add(Nat.mul(ax, bx), Nat.mul(bx, cx)), Nat.mul(cx, ax)), y))
def common_y(a: N.Point, b: N.Point, c: N.Point, p: G.Point) -> Nat:
  match a b c p:
    case N.P{+ax, +ay} N.P{+bx, +by} N.P{+cx, +cy} G.P{x, y, d}:
      Nat.add(Nat.mul(Nat.add(Nat.add(Nat.mul(ay, Nat.mul(by, cx)), Nat.mul(by, Nat.mul(cy, ax))), Nat.mul(cy, Nat.mul(ay, bx))), d), Nat.mul(Nat.add(Nat.add(Nat.mul(ay, cy), Nat.mul(by, ay)), Nat.mul(cy, by)), x))
def common(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point, axis: Bool) -> Nat:
  Bool.pick(Nat, axis, common_y(a, b, c, p), common_x(a, b, c, p))
def reconstruct(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point) -> G.Point:
  G.P{weighted(a, b, c, p, False{}), weighted(a, b, c, p, True{}), A.weights_total(a, b, c, p)}
def scaled(p: G.Point, +factor: Nat) -> G.Point:
  match p:
    case G.P{x, y, d}: G.P{Nat.mul(x, factor), Nat.mul(y, factor), Nat.mul(d, factor)}
