import Base
import ./strict-halfplane.bend as M
import ./strict-halfplane-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-geometry-laws.bend as GL
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q
import ./quad-hull.bend as Hull
import ./quad-hull-laws.bend as HL
import ./quad-hull-proof.bend as HP
import ./boolean-reflection.bend as B
import ./homogeneous.bend as H
import ./sat-arithmetic.bend as Sat
import ./sat-arithmetic-laws.bend as SL
import ./sat-arithmetic-proof.bend as SP
import ./topology.bend as T
import ./facts.bend as F
import ./order-facts.bend as O
import ./strict-complement-proof.bend as Complement
import ./strict-geometry-proof.bend as Geometry

def L.negative_closed_complement(a,b,p): Geometry.negative_closed_complement(a,b,p)
def L.negative_weighted_join(a, b, p, q, k, l, hp, hq, hw): Geometry.negative_weighted_join(a, b, p, q, k, l, hp, hq, hw)
def L.separated_weighted_quad(a, b, q, k, l, m, n, hs, hw): Geometry.separated_weighted_quad(a, b, q, k, l, m, n, hs, hw)
def L.separated_hull_point(a, b, q, p, hs, member): Geometry.separated_hull_point(a, b, q, p, hs, member)
def L.separated_region_exclusion(a, b, q, p, hs, hp): Geometry.separated_region_exclusion(a, b, q, p, hs, hp)
def strict_not_not(b:Bool) -> {b == Bool.not(Bool.not(b)) : Bool}: Geometry.strict_not_not(b)
def strict_closed_impossible(+a: N.Point, +b: N.Point, +p: G.Point, hp: {Region.edge(a, b, p) == True{} : Bool}, hn: {M.negative(a, b, p) == True{} : Bool}) -> Empty: Geometry.strict_closed_impossible(a,b,p,hp,hn)
def strict_hull_weights(+a: N.Point, +b: N.Point, +q: N.Quad, +p: G.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, +hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}, hp: {G.positive_denominator(p) == True{} : Bool}, he: {G.equivalent(p, Hull.weighted(q, k, l, m, n)) == True{} : Bool}, hs: {M.separated(a, b, q) == True{} : Bool}) -> {M.negative(a, b, p) == True{} : Bool}: Geometry.strict_hull_weights(a,b,q,p,k,l,m,n,hw,hp,he,hs)

def strict_native_corner(+a: T.Point, +b: T.Point, +p: T.Point) -> {Sat.negative(a, b, p) == M.negative(N.decode_point(a), N.decode_point(b), Q.embed(N.decode_point(p))) : Bool}:
  match a b p:
    case T.P{ax, ay} T.P{bx, by} T.P{x, y}: {==}
def L.separated_decoded(a, b, q):
  match q:
    case T.Q{+p, +q, +r, +s}: B.four_cong(Sat.negative(a, b, p), Sat.negative(a, b, q), Sat.negative(a, b, r), Sat.negative(a, b, s), M.negative(N.decode_point(a), N.decode_point(b), Q.embed(N.decode_point(p))), M.negative(N.decode_point(a), N.decode_point(b), Q.embed(N.decode_point(q))), M.negative(N.decode_point(a), N.decode_point(b), Q.embed(N.decode_point(r))), M.negative(N.decode_point(a), N.decode_point(b), Q.embed(N.decode_point(s))), strict_native_corner(a, b, p), strict_native_corner(a, b, q), strict_native_corner(a, b, r), strict_native_corner(a, b, s))
def L.production_separated_exact(width, hw, a, b, q, ha, hb, hq):
  Equal.trans(Bool, T.separated(a, b, q), Sat.separated(a, b, q), M.separated(N.decode_point(a), N.decode_point(b), N.decode_quad(q)), SL.separated_arithmetic_exact(width, hw, a, b, q, ha, hb, hq), L.separated_decoded(a, b, q))
def L.production_separated_region_exclusion(width, hw, a, b, q, p, ha, hb, hq, hs, hp):
  L.separated_region_exclusion(N.decode_point(a), N.decode_point(b), N.decode_quad(q), p, Equal.trans(Bool, M.separated(N.decode_point(a), N.decode_point(b), N.decode_quad(q)), T.separated(a, b, q), True{}, Equal.sym(Bool, T.separated(a, b, q), M.separated(N.decode_point(a), N.decode_point(b), N.decode_quad(q)), L.production_separated_exact(width, hw, a, b, q, ha, hb, hq)), hs), hp)

# Reflection from the shared closed/strict complement law.
def negative_from_false(+a:N.Point,+b:N.Point,+p:G.Point,h:{Region.edge(a,b,p) == False{} : Bool}) -> {M.negative(a,b,p) == True{} : Bool}:
  Complement.negative_from_false(a,b,p,h)
