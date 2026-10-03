import Base
import ./segment-cut.bend as M
import ./segment-cut-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./homogeneous-geometry-proof.bend as GP
import ./triangle-area.bend as A
import ./triangle-area-laws.bend as AL
import ./triangle-area-proof.bend as AP
import ./strict-halfplane.bend as S
import ./halfplane-region.bend as Region
import ./facts.bend as F
import ./order-facts.bend as O
import ./homogeneous.bend as Form
import ./validation-proof.bend as Reflection
import ./boolean-reflection.bend as B

def cut_gt_lt(+a: Nat, +b: Nat) -> {Nat.is_gt(b, a) == Nat.is_lt(a, b) : Bool}:
  match a b:
    case 0n 0n: {==}
    case 0n 1n+t: {==}
    case 1n+t 0n: {==}
    case 1n+s 1n+t: cut_gt_lt(s, t)
def cut_negative_equation(+a: N.Point, +b: N.Point, +p: G.Point) -> {S.negative(a, b, p) == Nat.is_lt(A.positive(a, b, p), A.negative(a, b, p)) : Bool}:
  match a b p:
    case N.P{ax, ay} N.P{bx, by} G.P{x, y, d}: {==}
def cut_negative_lt(+a: N.Point, +b: N.Point, +p: G.Point, h: {S.negative(a, b, p) == True{} : Bool}) -> {Nat.is_lt(A.positive(a, b, p), A.negative(a, b, p)) == True{} : Bool}:
  Equal.trans(Bool, Nat.is_lt(A.positive(a, b, p), A.negative(a, b, p)), S.negative(a, b, p), True{}, Equal.sym(Bool, S.negative(a, b, p), Nat.is_lt(A.positive(a, b, p), A.negative(a, b, p)), cut_negative_equation(a, b, p)), h)
def L.negative_gap_positive(a, b, q, h):
  AP.area_strict_difference(A.negative(a, b, q), A.positive(a, b, q), Equal.trans(Bool, Nat.is_gt(A.negative(a, b, q), A.positive(a, b, q)), Nat.is_lt(A.positive(a, b, q), A.negative(a, b, q)), True{}, cut_gt_lt(A.positive(a, b, q), A.negative(a, b, q)), cut_negative_lt(a, b, q, h)))
def cut_positive_add(+a: Nat, +b: Nat, h: {Nat.is_gt(a, 0n) == True{} : Bool}) -> {Nat.is_gt(Nat.add(a, b), 0n) == True{} : Bool}:
  match a:
    case 0n: B.absurd({Nat.is_gt(Nat.add(0n, b), 0n) == True{} : Bool}, B.false_impossible(h))
    case 1n+t: {==}
def L.crossing_total_positive(a, b, p, q, h):
  cut_positive_add(M.first_weight(a, b, q), M.second_weight(a, b, p), L.negative_gap_positive(a, b, q, h))
def cut_balance(+w: Nat, +v: Nat, +pp: Nat, +np: Nat, +pq: Nat, +nq: Nat, hp: {Nat.add(w, np) == pp : Nat}, hq: {Nat.add(v, pq) == nq : Nat}) -> {Nat.add(Nat.mul(pp, v), Nat.mul(pq, w)) == Nat.add(Nat.mul(np, v), Nat.mul(nq, w)) : Nat}:
  %hp : {Nat.add(Nat.mul(_, v), Nat.mul(pq, w)) == Nat.add(Nat.mul(np, v), Nat.mul(nq, w)) : Nat}
  %hq : {Nat.add(Nat.mul(Nat.add(w, np), v), Nat.mul(pq, w)) == Nat.add(Nat.mul(np, v), Nat.mul(_, w)) : Nat}
  %Equal.sym(Nat, Nat.mul(Nat.add(w, np), v), Nat.add(Nat.mul(w, v), Nat.mul(np, v)), F.add_mul(w, np, v)) : {Nat.add(_, Nat.mul(pq, w)) == Nat.add(Nat.mul(np, v), Nat.mul(Nat.add(v, pq), w)) : Nat}
  %Equal.sym(Nat, Nat.mul(Nat.add(v, pq), w), Nat.add(Nat.mul(v, w), Nat.mul(pq, w)), F.add_mul(v, pq, w)) : {Nat.add(Nat.add(Nat.mul(w, v), Nat.mul(np, v)), Nat.mul(pq, w)) == Nat.add(Nat.mul(np, v), _) : Nat}
  Equal.trans(Nat, Nat.add(Nat.add(Nat.mul(w, v), Nat.mul(np, v)), Nat.mul(pq, w)), Nat.add(Nat.add(Nat.mul(np, v), Nat.mul(w, v)), Nat.mul(pq, w)), Nat.add(Nat.mul(np, v), Nat.add(Nat.mul(v, w), Nat.mul(pq, w))), Equal.cong(Nat, Nat, n => Nat.add(n, Nat.mul(pq, w)), Nat.add(Nat.mul(w, v), Nat.mul(np, v)), Nat.add(Nat.mul(np, v), Nat.mul(w, v)), F.add_comm(Nat.mul(w, v), Nat.mul(np, v))), Equal.trans(Nat, Nat.add(Nat.add(Nat.mul(np, v), Nat.mul(w, v)), Nat.mul(pq, w)), Nat.add(Nat.mul(np, v), Nat.add(Nat.mul(w, v), Nat.mul(pq, w))), Nat.add(Nat.mul(np, v), Nat.add(Nat.mul(v, w), Nat.mul(pq, w))), F.add_assoc(Nat.mul(np, v), Nat.mul(w, v), Nat.mul(pq, w)), Equal.cong(Nat, Nat, n => Nat.add(Nat.mul(np, v), Nat.add(n, Nat.mul(pq, w))), Nat.mul(w, v), Nat.mul(v, w), F.mul_comm(w, v))))
def cut_positive_form(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, p: G.Point) -> {C.value(Nat.mul(ax, by), bx, ay, p) == A.positive(N.P{ax, ay}, N.P{bx, by}, p) : Nat}:
  match p:
    case G.P{x, y, d}: CP.form_polynomial(ax, by, bx, d, x, y, ay)
def cut_negative_form(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, p: G.Point) -> {C.value(Nat.mul(ay, bx), ax, by, p) == A.negative(N.P{ax, ay}, N.P{bx, by}, p) : Nat}:
  match p:
    case G.P{x, y, d}: CP.negative_polynomial(ay, bx, by, ax, x, y, d)

def cut_positive_join_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: G.Point, +q: G.Point, +k: Nat, +l: Nat) -> {A.positive(N.P{ax, ay}, N.P{bx, by}, C.join(p, q, k, l)) == Nat.add(Nat.mul(A.positive(N.P{ax, ay}, N.P{bx, by}, p), k), Nat.mul(A.positive(N.P{ax, ay}, N.P{bx, by}, q), l)) : Nat}:
  %cut_positive_form(ax, ay, bx, by, C.join(p, q, k, l)) : {_ == Nat.add(Nat.mul(A.positive(N.P{ax, ay}, N.P{bx, by}, p), k), Nat.mul(A.positive(N.P{ax, ay}, N.P{bx, by}, q), l)) : Nat}
  %cut_positive_form(ax, ay, bx, by, p) : {C.value(Nat.mul(ax, by), bx, ay, C.join(p, q, k, l)) == Nat.add(Nat.mul(_, k), Nat.mul(A.positive(N.P{ax, ay}, N.P{bx, by}, q), l)) : Nat}
  %cut_positive_form(ax, ay, bx, by, q) : {C.value(Nat.mul(ax, by), bx, ay, C.join(p, q, k, l)) == Nat.add(Nat.mul(C.value(Nat.mul(ax, by), bx, ay, p), k), Nat.mul(_, l)) : Nat}
  CL.weighted_form_exact(Nat.mul(ax, by), bx, ay, p, q, k, l)
def cut_positive_join(+a: N.Point, +b: N.Point, +p: G.Point, +q: G.Point, +k: Nat, +l: Nat) -> {A.positive(a, b, C.join(p, q, k, l)) == Nat.add(Nat.mul(A.positive(a, b, p), k), Nat.mul(A.positive(a, b, q), l)) : Nat}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: cut_positive_join_fields(ax, ay, bx, by, p, q, k, l)

def cut_negative_join_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: G.Point, +q: G.Point, +k: Nat, +l: Nat) -> {A.negative(N.P{ax, ay}, N.P{bx, by}, C.join(p, q, k, l)) == Nat.add(Nat.mul(A.negative(N.P{ax, ay}, N.P{bx, by}, p), k), Nat.mul(A.negative(N.P{ax, ay}, N.P{bx, by}, q), l)) : Nat}:
  %cut_negative_form(ax, ay, bx, by, C.join(p, q, k, l)) : {_ == Nat.add(Nat.mul(A.negative(N.P{ax, ay}, N.P{bx, by}, p), k), Nat.mul(A.negative(N.P{ax, ay}, N.P{bx, by}, q), l)) : Nat}
  %cut_negative_form(ax, ay, bx, by, p) : {C.value(Nat.mul(ay, bx), ax, by, C.join(p, q, k, l)) == Nat.add(Nat.mul(_, k), Nat.mul(A.negative(N.P{ax, ay}, N.P{bx, by}, q), l)) : Nat}
  %cut_negative_form(ax, ay, bx, by, q) : {C.value(Nat.mul(ay, bx), ax, by, C.join(p, q, k, l)) == Nat.add(Nat.mul(C.value(Nat.mul(ay, bx), ax, by, p), k), Nat.mul(_, l)) : Nat}
  CL.weighted_form_exact(Nat.mul(ay, bx), ax, by, p, q, k, l)
def cut_negative_join(+a: N.Point, +b: N.Point, +p: G.Point, +q: G.Point, +k: Nat, +l: Nat) -> {A.negative(a, b, C.join(p, q, k, l)) == Nat.add(Nat.mul(A.negative(a, b, p), k), Nat.mul(A.negative(a, b, q), l)) : Nat}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: cut_negative_join_fields(ax, ay, bx, by, p, q, k, l)

def cut_crossing_equal(+a: N.Point, +b: N.Point, +p: G.Point, +q: G.Point, hp: {Region.edge(a, b, p) == True{} : Bool}, hq: {S.negative(a, b, q) == True{} : Bool}) -> {A.positive(a, b, M.point(a, b, p, q)) == A.negative(a, b, M.point(a, b, p, q)) : Nat}:
  Equal.trans(Nat, A.positive(a, b, M.point(a, b, p, q)), Nat.add(Nat.mul(A.positive(a, b, p), M.first_weight(a, b, q)), Nat.mul(A.positive(a, b, q), M.second_weight(a, b, p))), A.negative(a, b, M.point(a, b, p, q)), cut_positive_join(a, b, p, q, M.first_weight(a, b, q), M.second_weight(a, b, p)), Equal.trans(Nat, Nat.add(Nat.mul(A.positive(a, b, p), M.first_weight(a, b, q)), Nat.mul(A.positive(a, b, q), M.second_weight(a, b, p))), Nat.add(Nat.mul(A.negative(a, b, p), M.first_weight(a, b, q)), Nat.mul(A.negative(a, b, q), M.second_weight(a, b, p))), A.negative(a, b, M.point(a, b, p, q)), cut_balance(M.second_weight(a, b, p), M.first_weight(a, b, q), A.positive(a, b, p), A.negative(a, b, p), A.positive(a, b, q), A.negative(a, b, q), AL.area_reconstruct(a, b, p, hp), O.sub_add_cancel(A.negative(a, b, q), A.positive(a, b, q), O.le_of_lt(A.positive(a, b, q), A.negative(a, b, q), cut_negative_lt(a, b, q, hq)))), Equal.sym(Nat, A.negative(a, b, M.point(a, b, p, q)), Nat.add(Nat.mul(A.negative(a, b, p), M.first_weight(a, b, q)), Nat.mul(A.negative(a, b, q), M.second_weight(a, b, p))), cut_negative_join(a, b, p, q, M.first_weight(a, b, q), M.second_weight(a, b, p)))))
def cut_on_line_equation(+a: N.Point, +b: N.Point, +p: G.Point) -> {M.on_line(a, b, p) == Nat.is_eq(A.positive(a, b, p), A.negative(a, b, p)) : Bool}:
  match a b p:
    case N.P{ax, ay} N.P{bx, by} G.P{x, y, d}: {==}
def L.crossing_on_line(a, b, p, q, hp, hq):
  Equal.trans(Bool, M.on_line(a, b, M.point(a, b, p, q)), Nat.is_eq(A.positive(a, b, M.point(a, b, p, q)), A.negative(a, b, M.point(a, b, p, q))), True{}, cut_on_line_equation(a, b, M.point(a, b, p, q)), Reflection.nat_eq_complete(A.positive(a, b, M.point(a, b, p, q)), A.negative(a, b, M.point(a, b, p, q)), cut_crossing_equal(a, b, p, q, hp, hq)))
def L.crossing_denominator_positive(a, b, p, q, hp, hq, h):
  CL.joined_denominator_positive(p, q, M.first_weight(a, b, q), M.second_weight(a, b, p), hp, hq, L.crossing_total_positive(a, b, p, q, h))
def L.crossing_region_preserved(a, b, p, q, r, hp, hq):
  CL.region_weighted_join(p, q, r, M.first_weight(a, b, q), M.second_weight(a, b, p), hp, hq)
def cut_equivalent_self(r: G.Point) -> {G.equivalent(r, r) == True{} : Bool}:
  match r:
    case G.P{+x, +y, +d}: B.and_join(Nat.is_eq(Nat.mul(x, d), Nat.mul(x, d)), Nat.is_eq(Nat.mul(y, d), Nat.mul(y, d)), Reflection.nat_eq_complete(Nat.mul(x, d), Nat.mul(x, d), {==}), Reflection.nat_eq_complete(Nat.mul(y, d), Nat.mul(y, d), {==}))
def L.crossing_in_segment(a, b, p, q, hp, hq, h):
  (M.first_weight(a, b, q), (M.second_weight(a, b, p), (L.crossing_total_positive(a, b, p, q, h), (hp, (hq, (L.crossing_denominator_positive(a, b, p, q, hp, hq, h), cut_equivalent_self(M.point(a, b, p, q))))))))
