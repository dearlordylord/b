import Base
import ./natural-cover.bend as N
import ./quad-geometry.bend as Q
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C

def weight_total(k: Nat, l: Nat, m: Nat, n: Nat) -> Nat:
  Nat.add(Nat.add(k, l), Nat.add(m, n))
def weighted(q: N.Quad, k: Nat, l: Nat, m: Nat, n: Nat) -> G.Point:
  match q:
    case N.Q{a, b, c, d}:
      C.join(C.join(Q.embed(a), Q.embed(b), k, l), C.join(Q.embed(c), Q.embed(d), m, n), 1n, 1n)
def InHull(-q: N.Quad, -p: G.Point) -> Type:
  &k:Nat -> &l:Nat -> &m:Nat -> &n:Nat -> {Nat.is_gt(weight_total(k, l, m, n), 0n) == True{} : Bool} & ({G.positive_denominator(p) == True{} : Bool} & {G.equivalent(p, weighted(q, k, l, m, n)) == True{} : Bool})
