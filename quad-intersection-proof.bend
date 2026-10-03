import Base
import ./quad-intersection.bend as M
import ./quad-intersection-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-geometry-laws.bend as QL
import ./quad-geometry-proof.bend as QP
import ./quad-hull.bend as H
import ./quad-hull-laws.bend as HL
import ./quad-hull-proof.bend as HP
import ./halfplane-region.bend as Region
import ./homogeneous-combination-proof.bend as CP
import ./strict-halfplane.bend as S
import ./strict-halfplane-laws.bend as SL
import ./strict-halfplane-proof.bend as SP
import ./quad-barycentric-proof.bend as BP
import ./sat-arithmetic.bend as Sat
import ./sat-arithmetic-laws.bend as SatL
import ./sat-arithmetic-proof.bend as SatP
import ./topology.bend as T
import ./boolean-reflection.bend as B

def intersection_or_four_cong(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +u: Bool, +v: Bool, +w: Bool, +z: Bool, ha: {a == u : Bool}, hb: {b == v : Bool}, hc: {c == w : Bool}, hd: {d == z : Bool}) -> {a || b || c || d == u || v || w || z : Bool}:
  %ha : {a || b || c || d == _ || v || w || z : Bool}
  %hb : {a || b || c || d == a || _ || w || z : Bool}
  %hc : {a || b || c || d == a || b || _ || z : Bool}
  %hd : {a || b || c || d == a || b || c || _ : Bool}
  {==}
def L.outside_decoded(q, r):
  match q:
    case T.Q{+a, +b, +c, +d}: intersection_or_four_cong(Sat.separated(a, b, r), Sat.separated(b, c, r), Sat.separated(c, d, r), Sat.separated(d, a, r), S.separated(N.decode_point(a), N.decode_point(b), N.decode_quad(r)), S.separated(N.decode_point(b), N.decode_point(c), N.decode_quad(r)), S.separated(N.decode_point(c), N.decode_point(d), N.decode_quad(r)), S.separated(N.decode_point(d), N.decode_point(a), N.decode_quad(r)), SL.separated_decoded(a, b, r), SL.separated_decoded(b, c, r), SL.separated_decoded(c, d, r), SL.separated_decoded(d, a, r))
def L.meets_decoded(q, r):
  %L.outside_decoded(q, r) : {Sat.meets(q, r) == Bool.not(_ || M.outside(N.decode_quad(r), N.decode_quad(q))) : Bool}
  %L.outside_decoded(r, q) : {Sat.meets(q, r) == Bool.not(Sat.outside(q, r) || _) : Bool}
  {==}
def intersection_refuted(+value: Bool, reject: {value == True{} : Bool} -> Empty) -> {value == False{} : Bool}:
  match value:
    case False{}: {==}
    case True{}: B.absurd({True{} == False{} : Bool}, reject({==}))
def intersection_side_not_separated(+a: N.Point, +b: N.Point, +r: N.Quad, +p: G.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, +hw: {Nat.is_gt(H.weight_total(k, l, m, n), 0n) == True{} : Bool}, +hp: {G.positive_denominator(p) == True{} : Bool}, +he: {G.equivalent(p, H.weighted(r, k, l, m, n)) == True{} : Bool}, +closed: {Region.edge(a, b, p) == True{} : Bool}) -> {S.separated(a, b, r) == False{} : Bool}:
  intersection_refuted(S.separated(a, b, r), separated => SP.strict_closed_impossible(a, b, p, closed, SP.strict_hull_weights(a, b, r, p, k, l, m, n, hw, hp, he, separated)))
def intersection_outside_fields(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +r: N.Quad, +p: G.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, +hw: {Nat.is_gt(H.weight_total(k, l, m, n), 0n) == True{} : Bool}, +hp: {G.positive_denominator(p) == True{} : Bool}, +he: {G.equivalent(p, H.weighted(r, k, l, m, n)) == True{} : Bool}, fields: {Region.edge(a, b, p) == True{} : Bool} & ({Region.edge(b, c, p) == True{} : Bool} & ({Region.edge(c, d, p) == True{} : Bool} & {Region.edge(d, a, p) == True{} : Bool}))) -> {M.outside(N.Q{a, b, c, d}, r) == False{} : Bool}:
  match fields:
    case (hab, (hbc, (hcd, hda))): intersection_or_four_cong(S.separated(a, b, r), S.separated(b, c, r), S.separated(c, d, r), S.separated(d, a, r), False{}, False{}, False{}, False{}, intersection_side_not_separated(a, b, r, p, k, l, m, n, hw, hp, he, hab), intersection_side_not_separated(b, c, r, p, k, l, m, n, hw, hp, he, hbc), intersection_side_not_separated(c, d, r, p, k, l, m, n, hw, hp, he, hcd), intersection_side_not_separated(d, a, r, p, k, l, m, n, hw, hp, he, hda))
def intersection_outside_weights(+q: N.Quad, +r: N.Quad, +p: G.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, hw: {Nat.is_gt(H.weight_total(k, l, m, n), 0n) == True{} : Bool}, hp: {G.positive_denominator(p) == True{} : Bool}, he: {G.equivalent(p, H.weighted(r, k, l, m, n)) == True{} : Bool}, inside: {Region.contains(p, q) == True{} : Bool}) -> {M.outside(q, r) == False{} : Bool}:
  match q:
    case N.Q{+a, +b, +c, +d}: intersection_outside_fields(a, b, c, d, r, p, k, l, m, n, hw, hp, he, CP.four_fields(Region.edge(a, b, p), Region.edge(b, c, p), Region.edge(c, d, p), Region.edge(d, a, p), inside))
def L.hull_region_not_outside(q, r, p, h, member):
  match member:
    case (k, (l, (m, (n, (hw, (hp, he)))))): intersection_outside_weights(q, r, p, k, l, m, n, hw, hp, he, h)

def intersection_meets_parts(+q: N.Quad, +r: N.Quad, hqr: {M.outside(q, r) == False{} : Bool}, hrq: {M.outside(r, q) == False{} : Bool}) -> {M.meets(q, r) == True{} : Bool}:
  %Equal.sym(Bool, M.outside(q, r), False{}, hqr) : {Bool.not(_ || M.outside(r, q)) == True{} : Bool}
  %Equal.sym(Bool, M.outside(r, q), False{}, hrq) : {Bool.not(False{} || _) == True{} : Bool}
  {==}
def intersection_common_weights(+q: N.Quad, +r: N.Quad, +p: G.Point, +kq: Nat, +lq: Nat, +mq: Nat, +nq: Nat, +kr: Nat, +lr: Nat, +mr: Nat, +nr: Nat, +hwq: {Nat.is_gt(H.weight_total(kq, lq, mq, nq), 0n) == True{} : Bool}, +hpq: {G.positive_denominator(p) == True{} : Bool}, +heq: {G.equivalent(p, H.weighted(q, kq, lq, mq, nq)) == True{} : Bool}, +hwr: {Nat.is_gt(H.weight_total(kr, lr, mr, nr), 0n) == True{} : Bool}, +hpr: {G.positive_denominator(p) == True{} : Bool}, +her: {G.equivalent(p, H.weighted(r, kr, lr, mr, nr)) == True{} : Bool}, hq: {Q.corners_inside(q) == True{} : Bool}, hr: {Q.corners_inside(r) == True{} : Bool}) -> {M.meets(q, r) == True{} : Bool}:
  intersection_meets_parts(q, r, L.hull_region_not_outside(q, r, p, HP.hull_weights(q, p, kq, lq, mq, nq, hwq, hpq, heq, hq), (kr, (lr, (mr, (nr, (hwr, (hpr, her))))))), L.hull_region_not_outside(r, q, p, HP.hull_weights(r, p, kr, lr, mr, nr, hwr, hpr, her, hr), (kq, (lq, (mq, (nq, (hwq, (hpq, heq))))))))
def intersection_second_member(+q: N.Quad, +r: N.Quad, +p: G.Point, +kq: Nat, +lq: Nat, +mq: Nat, +nq: Nat, hwq: {Nat.is_gt(H.weight_total(kq, lq, mq, nq), 0n) == True{} : Bool}, hpq: {G.positive_denominator(p) == True{} : Bool}, heq: {G.equivalent(p, H.weighted(q, kq, lq, mq, nq)) == True{} : Bool}, hq: {Q.corners_inside(q) == True{} : Bool}, hr: {Q.corners_inside(r) == True{} : Bool}, member: H.InHull(r, p)) -> {M.meets(q, r) == True{} : Bool}:
  match member:
    case (kr, (lr, (mr, (nr, (hwr, (hpr, her)))))): intersection_common_weights(q, r, p, kq, lq, mq, nq, kr, lr, mr, nr, hwq, hpq, heq, hwr, hpr, her, hq, hr)
def intersection_first_member(+q: N.Quad, +r: N.Quad, +p: G.Point, hq: {Q.corners_inside(q) == True{} : Bool}, hr: {Q.corners_inside(r) == True{} : Bool}, member: H.InHull(q, p), other: H.InHull(r, p)) -> {M.meets(q, r) == True{} : Bool}:
  match member:
    case (kq, (lq, (mq, (nq, (hwq, (hpq, heq)))))): intersection_second_member(q, r, p, kq, lq, mq, nq, hwq, hpq, heq, hq, hr, other)
def L.common_hull_meets(q, r, hq, hr, common):
  match common:
    case (+p, (member, other)): intersection_first_member(q, r, p, QL.strict_quad_corners_inside(q, hq), QL.strict_quad_corners_inside(r, hr), member, other)
def intersection_contradict(+value: Bool, rejected: {value == False{} : Bool}, accepted: {value == True{} : Bool}) -> Empty:
  B.false_impossible(Equal.trans(Bool, False{}, value, True{}, Equal.sym(Bool, value, False{}, rejected), accepted))
def L.rejected_meets_excludes(q, r, hq, hr, h):
  common => intersection_contradict(M.meets(q, r), h, L.common_hull_meets(q, r, hq, hr, common))
def L.production_meets_exact(width, hw, q, r, hq, hr):
  Equal.trans(Bool, T.meets(q, r), Sat.meets(q, r), M.meets(N.decode_quad(q), N.decode_quad(r)), SatL.meets_arithmetic_exact(width, hw, q, r, hq, hr), L.meets_decoded(q, r))
def L.production_common_hull_meets(width, hw, q, r, hq, hr, hsq, hsr, common):
  Equal.trans(Bool, T.meets(q, r), M.meets(N.decode_quad(q), N.decode_quad(r)), True{}, L.production_meets_exact(width, hw, q, r, hq, hr), L.common_hull_meets(N.decode_quad(q), N.decode_quad(r), BP.bary_native_strict(width, hw, q, hq, hsq), BP.bary_native_strict(width, hw, r, hr, hsr), common))
def L.production_rejected_meets_excludes(width, hw, q, r, hq, hr, hsq, hsr, h):
  common => intersection_contradict(T.meets(q, r), h, L.production_common_hull_meets(width, hw, q, r, hq, hr, hsq, hsr, common))

def intersection_or_comm(+a: Bool, +b: Bool) -> {a || b == b || a : Bool}:
  match a b:
    case False{} False{}: {==}
    case False{} True{}: {==}
    case True{} False{}: {==}
    case True{} True{}: {==}
def L.meets_symmetric(q, r):
  Equal.cong(Bool, Bool, b => Bool.not(b), M.outside(q, r) || M.outside(r, q), M.outside(r, q) || M.outside(q, r), intersection_or_comm(M.outside(q, r), M.outside(r, q)))
def L.production_meets_symmetric(q, r):
  Equal.cong(Bool, Bool, b => Bool.not(b), T.outside(q, r) || T.outside(r, q), T.outside(r, q) || T.outside(q, r), intersection_or_comm(T.outside(q, r), T.outside(r, q)))
