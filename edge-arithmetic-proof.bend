import Base
import ./edge-arithmetic-laws.bend as L
import ./edge-arithmetic.bend as M
import ./topology.bend as T
import ./word-comparison-laws.bend as Compare
import ./word-comparison-proof.bend as CompareProof
import ./sat-arithmetic-proof.bend as Sat

def and_two(+a: Bool, +b: Bool, +p: Bool, +q: Bool, ha: {a == p : Bool}, hb: {b == q : Bool}) -> {a && b == p && q : Bool}:
  %ha : {a && b == _ && q : Bool}
  %hb : {a && b == a && _ : Bool}
  {==}
def scalar_equal(+a: U32, +b: U32) -> {U32.is_eq(a, b) == Nat.is_eq(U32.to_nat(a), U32.to_nat(b)) : Bool}:
  match a b:
    case U32{x} U32{y}: Compare.u32_equality_exact(x, y)
def L.point_equal_arithmetic_exact(a, b):
  match a b:
    case T.P{+x, +y} T.P{+u, +v}:
      and_two(U32.is_eq(x, u), U32.is_eq(y, v), Nat.is_eq(U32.to_nat(x), U32.to_nat(u)), Nat.is_eq(U32.to_nat(y), U32.to_nat(v)), scalar_equal(x, u), scalar_equal(y, v))
def reversed_pair(+a: T.Point, +b: T.Point, +p: T.Point, +q: T.Point) -> {T.point_equal(a, q) && T.point_equal(b, p) == M.point_equal(a, q) && M.point_equal(b, p) : Bool}:
  and_two(T.point_equal(a, q), T.point_equal(b, p), M.point_equal(a, q), M.point_equal(b, p), L.point_equal_arithmetic_exact(a, q), L.point_equal_arithmetic_exact(b, p))
def L.reverse_edge_arithmetic_exact(a, b, q):
  match q:
    case T.Q{+p, +q, +r, +s}:
      Sat.or_four(T.point_equal(a, q) && T.point_equal(b, p), T.point_equal(a, r) && T.point_equal(b, q), T.point_equal(a, s) && T.point_equal(b, r), T.point_equal(a, p) && T.point_equal(b, s), M.point_equal(a, q) && M.point_equal(b, p), M.point_equal(a, r) && M.point_equal(b, q), M.point_equal(a, s) && M.point_equal(b, r), M.point_equal(a, p) && M.point_equal(b, s), reversed_pair(a, b, p, q), reversed_pair(a, b, q, r), reversed_pair(a, b, r, s), reversed_pair(a, b, s, p))
def L.shared_edge_arithmetic_exact(q, r):
  match q:
    case T.Q{+a, +b, +c, +d}:
      Sat.or_four(T.reverse_edge(a, b, r), T.reverse_edge(b, c, r), T.reverse_edge(c, d, r), T.reverse_edge(d, a, r), M.reverse_edge(a, b, r), M.reverse_edge(b, c, r), M.reverse_edge(c, d, r), M.reverse_edge(d, a, r), L.reverse_edge_arithmetic_exact(a, b, r), L.reverse_edge_arithmetic_exact(b, c, r), L.reverse_edge_arithmetic_exact(c, d, r), L.reverse_edge_arithmetic_exact(d, a, r))
