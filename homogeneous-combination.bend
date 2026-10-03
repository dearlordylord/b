import Base
import ./homogeneous-geometry.bend as G
import ./homogeneous.bend as H

def join(+p: G.Point, +q: G.Point, +k: Nat, +l: Nat) -> G.Point:
  match p q:
    case G.P{x, y, d} G.P{u, v, e}:
      G.P{Nat.add(Nat.mul(x, k), Nat.mul(u, l)), Nat.add(Nat.mul(y, k), Nat.mul(v, l)), Nat.add(Nat.mul(d, k), Nat.mul(e, l))}
def value(a: Nat, b: Nat, c: Nat, p: G.Point) -> Nat:
  match p:
    case G.P{x, y, d}: H.exact(a, 1n, d, b, y, x, c)
def denominator(p: G.Point) -> Nat:
  match p:
    case G.P{x, y, d}: d
# Ordinary rational weighted mean: compensate for unequal denominators.
def mix(+p: G.Point, +q: G.Point, +k: Nat, +l: Nat) -> G.Point:
  match p q:
    case G.P{+x, +y, +d} G.P{+u, +v, +e}:
      join(G.P{x, y, d}, G.P{u, v, e}, Nat.mul(k, e), Nat.mul(l, d))
