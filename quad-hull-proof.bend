import Base
import ./quad-hull.bend as M
import ./quad-hull-laws.bend as L
import ./natural-cover.bend as N
import ./quad-geometry.bend as Q
import ./quad-geometry-laws.bend as QL
import ./quad-geometry-proof.bend as QP
import ./homogeneous-geometry.bend as G
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./halfplane-region.bend as Region
import ./halfplane-region-laws.bend as RL
import ./halfplane-region-proof.bend as RP
import ./facts.bend as F

def add_cong(+a: Nat, +b: Nat, +c: Nat, +d: Nat, ha: {a == c : Nat}, hb: {b == d : Nat}) -> {Nat.add(a, b) == Nat.add(c, d) : Nat}:
  %ha : {Nat.add(a, b) == Nat.add(_, d) : Nat}
  %hb : {Nat.add(a, b) == Nat.add(a, _) : Nat}
  {==}
def scalar_ones(+a: Nat, +b: Nat) -> {Nat.add(Nat.mul(a, 1n), Nat.mul(b, 1n)) == Nat.add(a, b) : Nat}:
  add_cong(Nat.mul(a, 1n), Nat.mul(b, 1n), a, b, F.mul_one(a), F.mul_one(b))
def denominator_sum(+k: Nat, +l: Nat, +m: Nat, +n: Nat) -> {Nat.add(Nat.mul(Nat.add(Nat.mul(1n, k), Nat.mul(1n, l)), 1n), Nat.mul(Nat.add(Nat.mul(1n, m), Nat.mul(1n, n)), 1n)) == M.weight_total(k, l, m, n) : Nat}:
  Equal.trans(Nat, Nat.add(Nat.mul(Nat.add(Nat.mul(1n, k), Nat.mul(1n, l)), 1n), Nat.mul(Nat.add(Nat.mul(1n, m), Nat.mul(1n, n)), 1n)), Nat.add(Nat.add(Nat.mul(1n, k), Nat.mul(1n, l)), Nat.add(Nat.mul(1n, m), Nat.mul(1n, n))), M.weight_total(k, l, m, n), scalar_ones(Nat.add(Nat.mul(1n, k), Nat.mul(1n, l)), Nat.add(Nat.mul(1n, m), Nat.mul(1n, n))), add_cong(Nat.add(Nat.mul(1n, k), Nat.mul(1n, l)), Nat.add(Nat.mul(1n, m), Nat.mul(1n, n)), Nat.add(k, l), Nat.add(m, n), add_cong(Nat.mul(1n, k), Nat.mul(1n, l), k, l, F.one_mul(k), F.one_mul(l)), add_cong(Nat.mul(1n, m), Nat.mul(1n, n), m, n, F.one_mul(m), F.one_mul(n))))
def quad_weighted_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat, +dx: Nat, +dy: Nat, +k: Nat, +l: Nat, +m: Nat, +n: Nat) -> {M.weighted(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, k, l, m, n) == L.point(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, k, l, m, n) : G.Point}:
  GP.point_equal(Nat.add(Nat.mul(Nat.add(Nat.mul(ax, k), Nat.mul(bx, l)), 1n), Nat.mul(Nat.add(Nat.mul(cx, m), Nat.mul(dx, n)), 1n)), Nat.add(Nat.mul(Nat.add(Nat.mul(ay, k), Nat.mul(by, l)), 1n), Nat.mul(Nat.add(Nat.mul(cy, m), Nat.mul(dy, n)), 1n)), Nat.add(Nat.mul(Nat.add(Nat.mul(1n, k), Nat.mul(1n, l)), 1n), Nat.mul(Nat.add(Nat.mul(1n, m), Nat.mul(1n, n)), 1n)), L.coordinate(ax, bx, cx, dx, k, l, m, n), L.coordinate(ay, by, cy, dy, k, l, m, n), M.weight_total(k, l, m, n), scalar_ones(Nat.add(Nat.mul(ax, k), Nat.mul(bx, l)), Nat.add(Nat.mul(cx, m), Nat.mul(dx, n))), scalar_ones(Nat.add(Nat.mul(ay, k), Nat.mul(by, l)), Nat.add(Nat.mul(cy, m), Nat.mul(dy, n))), denominator_sum(k, l, m, n))
def L.weighted_quad_point_exact(q, k, l, m, n):
  match q:
    case N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}: quad_weighted_fields(ax, ay, bx, by, cx, cy, dx, dy, k, l, m, n)
def point_denominator(q: N.Quad, +k: Nat, +l: Nat, +m: Nat, +n: Nat) -> {C.denominator(L.point(q, k, l, m, n)) == M.weight_total(k, l, m, n) : Nat}:
  match q:
    case N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}: {==}
def L.weighted_quad_denominator_exact(q, k, l, m, n):
  Equal.trans(Nat, C.denominator(M.weighted(q, k, l, m, n)), C.denominator(L.point(q, k, l, m, n)), M.weight_total(k, l, m, n), Equal.cong(G.Point, Nat, p => C.denominator(p), M.weighted(q, k, l, m, n), L.point(q, k, l, m, n), L.weighted_quad_point_exact(q, k, l, m, n)), point_denominator(q, k, l, m, n))
def positive_projection(+p: G.Point) -> {G.positive_denominator(p) == Nat.is_gt(C.denominator(p), 0n) : Bool}:
  match p:
    case G.P{x, y, d}: {==}
def L.weighted_quad_positive(q, k, l, m, n, hw):
  Equal.trans(Bool, G.positive_denominator(M.weighted(q, k, l, m, n)), Nat.is_gt(C.denominator(M.weighted(q, k, l, m, n)), 0n), True{}, positive_projection(M.weighted(q, k, l, m, n)), Equal.trans(Bool, Nat.is_gt(C.denominator(M.weighted(q, k, l, m, n)), 0n), Nat.is_gt(M.weight_total(k, l, m, n), 0n), True{}, Equal.cong(Nat, Bool, d => Nat.is_gt(d, 0n), C.denominator(M.weighted(q, k, l, m, n)), M.weight_total(k, l, m, n), L.weighted_quad_denominator_exact(q, k, l, m, n)), hw))
def inside_vertices(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, hs: {Region.contains(Q.embed(a), N.Q{a, b, c, d}) == True{} : Bool} & ({Region.contains(Q.embed(b), N.Q{a, b, c, d}) == True{} : Bool} & ({Region.contains(Q.embed(c), N.Q{a, b, c, d}) == True{} : Bool} & {Region.contains(Q.embed(d), N.Q{a, b, c, d}) == True{} : Bool}))) -> {Region.contains(M.weighted(N.Q{a, b, c, d}, k, l, m, n), N.Q{a, b, c, d}) == True{} : Bool}:
  match hs:
    case (ha, (hb, (hc, hd))):
      CL.region_weighted_join(C.join(Q.embed(a), Q.embed(b), k, l), C.join(Q.embed(c), Q.embed(d), m, n), N.Q{a, b, c, d}, 1n, 1n, CL.region_weighted_join(Q.embed(a), Q.embed(b), N.Q{a, b, c, d}, k, l, ha, hb), CL.region_weighted_join(Q.embed(c), Q.embed(d), N.Q{a, b, c, d}, m, n, hc, hd))
def L.weighted_quad_inside(q, k, l, m, n, h):
  match q:
    case N.Q{+a, +b, +c, +d}: inside_vertices(a, b, c, d, k, l, m, n, CP.four_fields(Region.contains(Q.embed(a), N.Q{a, b, c, d}), Region.contains(Q.embed(b), N.Q{a, b, c, d}), Region.contains(Q.embed(c), N.Q{a, b, c, d}), Region.contains(Q.embed(d), N.Q{a, b, c, d}), h))
def L.hull_point_positive(q, p, member):
  match member:
    case (k, (l, (m, (n, (hw, (hp, he)))))): hp
def hull_weights(+q: N.Quad, +p: G.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, hw: {Nat.is_gt(M.weight_total(k, l, m, n), 0n) == True{} : Bool}, hp: {G.positive_denominator(p) == True{} : Bool}, he: {G.equivalent(p, M.weighted(q, k, l, m, n)) == True{} : Bool}, h: {Q.corners_inside(q) == True{} : Bool}) -> {Region.contains(p, q) == True{} : Bool}:
  Equal.trans(Bool, Region.contains(p, q), Region.contains(M.weighted(q, k, l, m, n), q), True{}, RL.region_equivalent_point(p, M.weighted(q, k, l, m, n), q, hp, L.weighted_quad_positive(q, k, l, m, n, hw), he), L.weighted_quad_inside(q, k, l, m, n, h))
def L.hull_point_inside(q, p, h, member):
  match member:
    case (k, (l, (m, (n, (hw, (hp, he)))))): hull_weights(q, p, k, l, m, n, hw, hp, he, h)
def L.production_hull_point_inside(width, hw, q, p, hq, h, member):
  L.hull_point_inside(N.decode_quad(q), p, QL.production_corners_inside(width, hw, q, hq, h), member)
