import Base
import ./homogeneous.bend as H

type Point is Data:
  P{x: Nat, y: Nat, denominator: Nat}
def positive_denominator(p: Point) -> Bool:
  match p:
    case P{x, y, d}: Nat.is_gt(d, 0n)
def scale(p: Point, +k: Nat) -> Point:
  match p:
    case P{x, y, d}: P{Nat.mul(x, 1n+k), Nat.mul(y, 1n+k), Nat.mul(d, 1n+k)}
def side(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, p: Point) -> Cmp:
  match p:
    case P{+x, +y, +d}: Nat.cmp(H.exact(ax, by, d, bx, y, x, ay), H.exact(ay, bx, d, by, x, y, ax))
def left_closed(ax: Nat, ay: Nat, bx: Nat, by: Nat, p: Point) -> Bool:
  Bool.not(Cmp.is_lt(side(ax, ay, bx, by, p)))
def equivalent(+p: Point, +q: Point) -> Bool:
  match p q:
    case P{x, y, +d} P{u, v, +e}: Nat.is_eq(Nat.mul(x, e), Nat.mul(u, d)) && Nat.is_eq(Nat.mul(y, e), Nat.mul(v, d))
