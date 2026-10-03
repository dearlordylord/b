import ./homogeneous-geometry-laws.bend as GL
import Base
import ./homogeneous-combination.bend as M
import ./homogeneous-combination-laws.bend as L
import ./homogeneous-geometry.bend as G
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous.bend as H
import ./facts.bend as F
import ./order-facts.bend as O
import ./boolean-reflection.bend as B
import ./natural-cover.bend as N
import ./halfplane-region.bend as Region

def regroup3(+a: Nat, +b: Nat, +c: Nat, +u: Nat, +v: Nat, +w: Nat) -> {Nat.add(Nat.add(Nat.add(a, u), Nat.add(b, v)), Nat.add(c, w)) == Nat.add(Nat.add(Nat.add(a, b), c), Nat.add(Nat.add(u, v), w)) : Nat}:
  Equal.trans(Nat, Nat.add(Nat.add(Nat.add(a, u), Nat.add(b, v)), Nat.add(c, w)), Nat.add(Nat.add(Nat.add(a, b), Nat.add(u, v)), Nat.add(c, w)), Nat.add(Nat.add(Nat.add(a, b), c), Nat.add(Nat.add(u, v), w)), Equal.cong(Nat, Nat, z => Nat.add(z, Nat.add(c, w)), Nat.add(Nat.add(a, u), Nat.add(b, v)), Nat.add(Nat.add(a, b), Nat.add(u, v)), F.add_add_add_comm(a, u, b, v)), F.add_add_add_comm(Nat.add(a, b), Nat.add(u, v), c, w))
def form_add(+a: Nat, +b: Nat, +c: Nat, +x: Nat, +y: Nat, +d: Nat, +u: Nat, +v: Nat, +e: Nat) -> {H.exact(a, 1n, Nat.add(d, e), b, Nat.add(y, v), Nat.add(x, u), c) == Nat.add(H.exact(a, 1n, d, b, y, x, c), H.exact(a, 1n, e, b, v, u, c)) : Nat}:
  Equal.trans(Nat, H.exact(a, 1n, Nat.add(d, e), b, Nat.add(y, v), Nat.add(x, u), c), Nat.add(Nat.add(Nat.add(Nat.mul(Nat.mul(a, 1n), d), Nat.mul(Nat.mul(a, 1n), e)), Nat.add(Nat.mul(b, y), Nat.mul(b, v))), Nat.add(Nat.mul(x, c), Nat.mul(u, c))), Nat.add(H.exact(a, 1n, d, b, y, x, c), H.exact(a, 1n, e, b, v, u, c)), GP.sum3_cong(Nat.mul(Nat.mul(a, 1n), Nat.add(d, e)), Nat.mul(b, Nat.add(y, v)), Nat.mul(Nat.add(x, u), c), Nat.add(Nat.mul(Nat.mul(a, 1n), d), Nat.mul(Nat.mul(a, 1n), e)), Nat.add(Nat.mul(b, y), Nat.mul(b, v)), Nat.add(Nat.mul(x, c), Nat.mul(u, c)), F.mul_add(Nat.mul(a, 1n), d, e), F.mul_add(b, y, v), F.add_mul(x, u, c)), regroup3(Nat.mul(Nat.mul(a, 1n), d), Nat.mul(b, y), Nat.mul(x, c), Nat.mul(Nat.mul(a, 1n), e), Nat.mul(b, v), Nat.mul(u, c)))
def weighted_fields(+a: Nat, +b: Nat, +c: Nat, +x: Nat, +y: Nat, +d: Nat, +u: Nat, +v: Nat, +e: Nat, +k: Nat, +l: Nat) -> {M.value(a, b, c, M.join(G.P{x, y, d}, G.P{u, v, e}, k, l)) == Nat.add(Nat.mul(M.value(a, b, c, G.P{x, y, d}), k), Nat.mul(M.value(a, b, c, G.P{u, v, e}), l)) : Nat}:
  Equal.trans(Nat, M.value(a, b, c, M.join(G.P{x, y, d}, G.P{u, v, e}, k, l)), Nat.add(H.exact(a, 1n, Nat.mul(d, k), b, Nat.mul(y, k), Nat.mul(x, k), c), H.exact(a, 1n, Nat.mul(e, l), b, Nat.mul(v, l), Nat.mul(u, l), c)), Nat.add(Nat.mul(M.value(a, b, c, G.P{x, y, d}), k), Nat.mul(M.value(a, b, c, G.P{u, v, e}), l)), form_add(a, b, c, Nat.mul(x, k), Nat.mul(y, k), Nat.mul(d, k), Nat.mul(u, l), Nat.mul(v, l), Nat.mul(e, l)), Equal.trans(Nat, Nat.add(H.exact(a, 1n, Nat.mul(d, k), b, Nat.mul(y, k), Nat.mul(x, k), c), H.exact(a, 1n, Nat.mul(e, l), b, Nat.mul(v, l), Nat.mul(u, l), c)), Nat.add(Nat.mul(M.value(a, b, c, G.P{x, y, d}), k), H.exact(a, 1n, Nat.mul(e, l), b, Nat.mul(v, l), Nat.mul(u, l), c)), Nat.add(Nat.mul(M.value(a, b, c, G.P{x, y, d}), k), Nat.mul(M.value(a, b, c, G.P{u, v, e}), l)), Equal.cong(Nat, Nat, z => Nat.add(z, H.exact(a, 1n, Nat.mul(e, l), b, Nat.mul(v, l), Nat.mul(u, l), c)), H.exact(a, 1n, Nat.mul(d, k), b, Nat.mul(y, k), Nat.mul(x, k), c), Nat.mul(M.value(a, b, c, G.P{x, y, d}), k), GL.homogeneous_linear_scale(a, 1n, d, b, y, x, c, k)), Equal.cong(Nat, Nat, z => Nat.add(Nat.mul(M.value(a, b, c, G.P{x, y, d}), k), z), H.exact(a, 1n, Nat.mul(e, l), b, Nat.mul(v, l), Nat.mul(u, l), c), Nat.mul(M.value(a, b, c, G.P{u, v, e}), l), GL.homogeneous_linear_scale(a, 1n, e, b, v, u, c, l))))
def L.weighted_form_exact(a, b, c, p, q, k, l):
  match p q:
    case G.P{x, y, d} G.P{u, v, e}: weighted_fields(a, b, c, x, y, d, u, v, e, k, l)
def positive_sum(+d: Nat, +e: Nat, +k: Nat, +l: Nat, hp: {Nat.is_gt(d, 0n) == True{} : Bool}, hq: {Nat.is_gt(e, 0n) == True{} : Bool}, hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}) -> {Nat.is_gt(Nat.add(Nat.mul(d, k), Nat.mul(e, l)), 0n) == True{} : Bool}:
  match d e k l:
    case 0n _ _ _: B.absurd({Nat.is_gt(Nat.add(Nat.mul(0n, k), Nat.mul(e, l)), 0n) == True{} : Bool}, B.false_impossible(hp))
    case 1n+dd 0n _ _: B.absurd({Nat.is_gt(Nat.add(Nat.mul(1n+dd, k), Nat.mul(0n, l)), 0n) == True{} : Bool}, B.false_impossible(hq))
    case 1n+dd 1n+ee 0n 0n: B.absurd({Nat.is_gt(Nat.add(Nat.mul(1n+dd, 0n), Nat.mul(1n+ee, 0n)), 0n) == True{} : Bool}, B.false_impossible(hw))
    case 1n+dd 1n+ee 1n+kk _: {==}
    case 1n+dd 1n+ee 0n 1n+ll:
      %Equal.sym(Nat, Nat.mul(1n+dd, 0n), 0n, F.mul_zero(1n+dd)) : {Nat.is_gt(Nat.add(_, Nat.mul(1n+ee, 1n+ll)), 0n) == True{} : Bool}
      {==}
def L.joined_denominator_positive(p, q, k, l, hp, hq, hw):
  match p q:
    case G.P{x, y, d} G.P{u, v, e}: positive_sum(d, e, k, l, hp, hq, hw)
def nonnegative_le(+a: Nat, +b: Nat) -> {Bool.not(Cmp.is_lt(Nat.cmp(a, b))) == Nat.is_le(b, a) : Bool}:
  match a b:
    case 0n 0n: {==}
    case 0n 1n+q: {==}
    case 1n+p 0n: {==}
    case 1n+p 1n+q: nonnegative_le(p, q)
def nonnegative_weighted(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +k: Nat, +l: Nat, hp: {Bool.not(Cmp.is_lt(Nat.cmp(a, b))) == True{} : Bool}, hq: {Bool.not(Cmp.is_lt(Nat.cmp(c, d))) == True{} : Bool}) -> {Bool.not(Cmp.is_lt(Nat.cmp(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.add(Nat.mul(b, k), Nat.mul(d, l))))) == True{} : Bool}:
  Equal.trans(Bool, Bool.not(Cmp.is_lt(Nat.cmp(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.add(Nat.mul(b, k), Nat.mul(d, l))))), Nat.is_le(Nat.add(Nat.mul(b, k), Nat.mul(d, l)), Nat.add(Nat.mul(a, k), Nat.mul(c, l))), True{}, nonnegative_le(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.add(Nat.mul(b, k), Nat.mul(d, l))), O.add_le_add(Nat.mul(b, k), Nat.mul(d, l), Nat.mul(a, k), Nat.mul(c, l), O.mul_le_mul_right(b, a, k, Equal.trans(Bool, Nat.is_le(b, a), Bool.not(Cmp.is_lt(Nat.cmp(a, b))), True{}, Equal.sym(Bool, Bool.not(Cmp.is_lt(Nat.cmp(a, b))), Nat.is_le(b, a), nonnegative_le(a, b)), hp)), O.mul_le_mul_right(d, c, l, Equal.trans(Bool, Nat.is_le(d, c), Bool.not(Cmp.is_lt(Nat.cmp(c, d))), True{}, Equal.sym(Bool, Bool.not(Cmp.is_lt(Nat.cmp(c, d))), Nat.is_le(d, c), nonnegative_le(c, d)), hq))))
def form_polynomial(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +x: Nat, +y: Nat, +e: Nat) -> {M.value(Nat.mul(a, b), c, e, G.P{x, y, d}) == H.exact(a, b, d, c, y, x, e) : Nat}:
  Equal.cong(Nat, Nat, n => Nat.add(Nat.add(Nat.mul(n, d), Nat.mul(c, y)), Nat.mul(x, e)), Nat.mul(Nat.mul(a, b), 1n), Nat.mul(a, b), F.mul_one(Nat.mul(a, b)))
def negative_polynomial(+ay: Nat, +bx: Nat, +by: Nat, +ax: Nat, +x: Nat, +y: Nat, +d: Nat) -> {M.value(Nat.mul(ay, bx), ax, by, G.P{x, y, d}) == H.exact(ay, bx, d, by, x, y, ax) : Nat}:
  Equal.trans(Nat, M.value(Nat.mul(ay, bx), ax, by, G.P{x, y, d}), Nat.add(Nat.add(Nat.mul(Nat.mul(ay, bx), d), Nat.mul(y, ax)), Nat.mul(by, x)), H.exact(ay, bx, d, by, x, y, ax), GP.sum3_cong(Nat.mul(Nat.mul(Nat.mul(ay, bx), 1n), d), Nat.mul(ax, y), Nat.mul(x, by), Nat.mul(Nat.mul(ay, bx), d), Nat.mul(y, ax), Nat.mul(by, x), Equal.cong(Nat, Nat, n => Nat.mul(n, d), Nat.mul(Nat.mul(ay, bx), 1n), Nat.mul(ay, bx), F.mul_one(Nat.mul(ay, bx))), F.mul_comm(ax, y), F.mul_comm(x, by)), F.add_right_comm(Nat.mul(Nat.mul(ay, bx), d), Nat.mul(y, ax), Nat.mul(by, x)))
def closed_form(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: G.Point) -> Bool:
  Bool.not(Cmp.is_lt(Nat.cmp(M.value(Nat.mul(ax, by), bx, ay, p), M.value(Nat.mul(ay, bx), ax, by, p))))
def closed_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat) -> {G.left_closed(ax, ay, bx, by, G.P{x, y, d}) == closed_form(ax, ay, bx, by, G.P{x, y, d}) : Bool}:
  %form_polynomial(ax, by, bx, d, x, y, ay) : {Bool.not(Cmp.is_lt(Nat.cmp(_, H.exact(ay, bx, d, by, x, y, ax)))) == closed_form(ax, ay, bx, by, G.P{x, y, d}) : Bool}
  %negative_polynomial(ay, bx, by, ax, x, y, d) : {Bool.not(Cmp.is_lt(Nat.cmp(M.value(Nat.mul(ax, by), bx, ay, G.P{x, y, d}), _))) == closed_form(ax, ay, bx, by, G.P{x, y, d}) : Bool}
  {==}
def closed_form_exact(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, p: G.Point) -> {G.left_closed(ax, ay, bx, by, p) == closed_form(ax, ay, bx, by, p) : Bool}:
  match p:
    case G.P{x, y, d}: closed_fields(ax, ay, bx, by, x, y, d)
def form_joined(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: G.Point, +q: G.Point, +k: Nat, +l: Nat, hp: {closed_form(ax, ay, bx, by, p) == True{} : Bool}, hq: {closed_form(ax, ay, bx, by, q) == True{} : Bool}) -> {closed_form(ax, ay, bx, by, M.join(p, q, k, l)) == True{} : Bool}:
  %Equal.sym(Nat, M.value(Nat.mul(ax, by), bx, ay, M.join(p, q, k, l)), Nat.add(Nat.mul(M.value(Nat.mul(ax, by), bx, ay, p), k), Nat.mul(M.value(Nat.mul(ax, by), bx, ay, q), l)), L.weighted_form_exact(Nat.mul(ax, by), bx, ay, p, q, k, l)) : {Bool.not(Cmp.is_lt(Nat.cmp(_, M.value(Nat.mul(ay, bx), ax, by, M.join(p, q, k, l))))) == True{} : Bool}
  %Equal.sym(Nat, M.value(Nat.mul(ay, bx), ax, by, M.join(p, q, k, l)), Nat.add(Nat.mul(M.value(Nat.mul(ay, bx), ax, by, p), k), Nat.mul(M.value(Nat.mul(ay, bx), ax, by, q), l)), L.weighted_form_exact(Nat.mul(ay, bx), ax, by, p, q, k, l)) : {Bool.not(Cmp.is_lt(Nat.cmp(Nat.add(Nat.mul(M.value(Nat.mul(ax, by), bx, ay, p), k), Nat.mul(M.value(Nat.mul(ax, by), bx, ay, q), l)), _))) == True{} : Bool}
  nonnegative_weighted(M.value(Nat.mul(ax, by), bx, ay, p), M.value(Nat.mul(ay, bx), ax, by, p), M.value(Nat.mul(ax, by), bx, ay, q), M.value(Nat.mul(ay, bx), ax, by, q), k, l, hp, hq)
def L.halfplane_weighted_join(ax, ay, bx, by, p, q, k, l, hp, hq):
  Equal.trans(Bool, G.left_closed(ax, ay, bx, by, M.join(p, q, k, l)), closed_form(ax, ay, bx, by, M.join(p, q, k, l)), True{}, closed_form_exact(ax, ay, bx, by, M.join(p, q, k, l)), form_joined(ax, ay, bx, by, p, q, k, l, Equal.trans(Bool, closed_form(ax, ay, bx, by, p), G.left_closed(ax, ay, bx, by, p), True{}, Equal.sym(Bool, G.left_closed(ax, ay, bx, by, p), closed_form(ax, ay, bx, by, p), closed_form_exact(ax, ay, bx, by, p)), hp), Equal.trans(Bool, closed_form(ax, ay, bx, by, q), G.left_closed(ax, ay, bx, by, q), True{}, Equal.sym(Bool, G.left_closed(ax, ay, bx, by, q), closed_form(ax, ay, bx, by, q), closed_form_exact(ax, ay, bx, by, q)), hq)))
def edge_join(a: N.Point, b: N.Point, +p: G.Point, +q: G.Point, +k: Nat, +l: Nat, hp: {Region.edge(a, b, p) == True{} : Bool}, hq: {Region.edge(a, b, q) == True{} : Bool}) -> {Region.edge(a, b, M.join(p, q, k, l)) == True{} : Bool}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: L.halfplane_weighted_join(ax, ay, bx, by, p, q, k, l, hp, hq)
def four_fields(+a: Bool, +b: Bool, +c: Bool, +d: Bool, h: {a && b && c && d == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})):
  match a b c d:
    case False{} _ _ _: B.absurd({False{} == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} False{} _ _: B.absurd({True{} == True{} : Bool} & ({False{} == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} False{} _: B.absurd({True{} == True{} : Bool} & ({True{} == True{} : Bool} & ({False{} == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} True{} False{}: B.absurd({True{} == True{} : Bool} & ({True{} == True{} : Bool} & ({True{} == True{} : Bool} & {False{} == True{} : Bool})), B.false_impossible(h))
    case True{} True{} True{} True{}: ({==}, ({==}, ({==}, {==})))
def four_join(+a: Bool, +b: Bool, +c: Bool, +d: Bool, ha: {a == True{} : Bool}, hb: {b == True{} : Bool}, hc: {c == True{} : Bool}, hd: {d == True{} : Bool}) -> {a && b && c && d == True{} : Bool}:
  B.and_join(a && b && c, d, B.and_join(a && b, c, B.and_join(a, b, ha, hb), hc), hd)
def region_qfields(+p: G.Point, +q: G.Point, +a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +k: Nat, +l: Nat, hab: {Region.edge(a, b, p) == True{} : Bool}, hbc: {Region.edge(b, c, p) == True{} : Bool}, hcd: {Region.edge(c, d, p) == True{} : Bool}, hda: {Region.edge(d, a, p) == True{} : Bool}, hq: {Region.edge(a, b, q) == True{} : Bool} & ({Region.edge(b, c, q) == True{} : Bool} & ({Region.edge(c, d, q) == True{} : Bool} & {Region.edge(d, a, q) == True{} : Bool}))) -> {Region.contains(M.join(p, q, k, l), N.Q{a, b, c, d}) == True{} : Bool}:
  match hq:
    case (qab, (qbc, (qcd, qda))): four_join(Region.edge(a, b, M.join(p, q, k, l)), Region.edge(b, c, M.join(p, q, k, l)), Region.edge(c, d, M.join(p, q, k, l)), Region.edge(d, a, M.join(p, q, k, l)), edge_join(a, b, p, q, k, l, hab, qab), edge_join(b, c, p, q, k, l, hbc, qbc), edge_join(c, d, p, q, k, l, hcd, qcd), edge_join(d, a, p, q, k, l, hda, qda))
def region_fields(+p: G.Point, +q: G.Point, +a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +k: Nat, +l: Nat, hp: {Region.edge(a, b, p) == True{} : Bool} & ({Region.edge(b, c, p) == True{} : Bool} & ({Region.edge(c, d, p) == True{} : Bool} & {Region.edge(d, a, p) == True{} : Bool})), hq: {Region.edge(a, b, q) == True{} : Bool} & ({Region.edge(b, c, q) == True{} : Bool} & ({Region.edge(c, d, q) == True{} : Bool} & {Region.edge(d, a, q) == True{} : Bool}))) -> {Region.contains(M.join(p, q, k, l), N.Q{a, b, c, d}) == True{} : Bool}:
  match hp:
    case (hab, (hbc, (hcd, hda))): region_qfields(p, q, a, b, c, d, k, l, hab, hbc, hcd, hda, hq)
def L.region_weighted_join(p, q, r, k, l, hp, hq):
  match r:
    case N.Q{+a, +b, +c, +d}: region_fields(p, q, a, b, c, d, k, l, four_fields(Region.edge(a, b, p), Region.edge(b, c, p), Region.edge(c, d, p), Region.edge(d, a, p), hp), four_fields(Region.edge(a, b, q), Region.edge(b, c, q), Region.edge(c, d, q), Region.edge(d, a, q), hq))
def reordered_product(+a: Nat, +b: Nat, +c: Nat) -> {Nat.mul(a, Nat.mul(b, c)) == Nat.mul(Nat.mul(a, c), b) : Nat}:
  Equal.trans(Nat, Nat.mul(a, Nat.mul(b, c)), Nat.mul(Nat.mul(a, b), c), Nat.mul(Nat.mul(a, c), b), Equal.sym(Nat, Nat.mul(Nat.mul(a, b), c), Nat.mul(a, Nat.mul(b, c)), F.mul_assoc(a, b, c)), GP.swap_scale(a, b, c))
def mix_denominator(+d: Nat, +e: Nat, +k: Nat, +l: Nat) -> {Nat.add(Nat.mul(d, Nat.mul(k, e)), Nat.mul(e, Nat.mul(l, d))) == Nat.mul(Nat.mul(d, e), Nat.add(k, l)) : Nat}:
  %Equal.sym(Nat, Nat.mul(d, Nat.mul(k, e)), Nat.mul(Nat.mul(d, e), k), reordered_product(d, k, e)) : {Nat.add(_, Nat.mul(e, Nat.mul(l, d))) == Nat.mul(Nat.mul(d, e), Nat.add(k, l)) : Nat}
  %Equal.sym(Nat, Nat.mul(e, Nat.mul(l, d)), Nat.mul(Nat.mul(e, d), l), reordered_product(e, l, d)) : {Nat.add(Nat.mul(Nat.mul(d, e), k), _) == Nat.mul(Nat.mul(d, e), Nat.add(k, l)) : Nat}
  %F.mul_comm(d, e) : {Nat.add(Nat.mul(Nat.mul(d, e), k), Nat.mul(_, l)) == Nat.mul(Nat.mul(d, e), Nat.add(k, l)) : Nat}
  Equal.sym(Nat, Nat.mul(Nat.mul(d, e), Nat.add(k, l)), Nat.add(Nat.mul(Nat.mul(d, e), k), Nat.mul(Nat.mul(d, e), l)), F.mul_add(Nat.mul(d, e), k, l))
def L.mixture_denominator_exact(p, q, k, l):
  match p q:
    case G.P{x, y, d} G.P{u, v, e}: mix_denominator(d, e, k, l)
def mixture_weights_positive(+d: Nat, +e: Nat, +k: Nat, +l: Nat, hp: {Nat.is_gt(d, 0n) == True{} : Bool}, hq: {Nat.is_gt(e, 0n) == True{} : Bool}, hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}) -> {Nat.is_gt(Nat.add(Nat.mul(k, e), Nat.mul(l, d)), 0n) == True{} : Bool}:
  %F.mul_comm(e, k) : {Nat.is_gt(Nat.add(_, Nat.mul(l, d)), 0n) == True{} : Bool}
  %F.mul_comm(d, l) : {Nat.is_gt(Nat.add(Nat.mul(e, k), _), 0n) == True{} : Bool}
  positive_sum(e, d, k, l, hq, hp, hw)
def convex_mixture_fields(+x: Nat, +y: Nat, +d: Nat, +u: Nat, +v: Nat, +e: Nat, +r: N.Quad, +k: Nat, +l: Nat, +hpd: {G.positive_denominator(G.P{x, y, d}) == True{} : Bool}, +hqd: {G.positive_denominator(G.P{u, v, e}) == True{} : Bool}, hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}, hp: {Region.contains(G.P{x, y, d}, r) == True{} : Bool}, hq: {Region.contains(G.P{u, v, e}, r) == True{} : Bool}) -> {G.positive_denominator(M.mix(G.P{x, y, d}, G.P{u, v, e}, k, l)) == True{} : Bool} & {Region.contains(M.mix(G.P{x, y, d}, G.P{u, v, e}, k, l), r) == True{} : Bool}:
  (L.joined_denominator_positive(G.P{x, y, d}, G.P{u, v, e}, Nat.mul(k, e), Nat.mul(l, d), hpd, hqd, mixture_weights_positive(d, e, k, l, hpd, hqd, hw)), L.region_weighted_join(G.P{x, y, d}, G.P{u, v, e}, r, Nat.mul(k, e), Nat.mul(l, d), hp, hq))
def L.region_convex_mixture(p, q, r, k, l, hpd, hqd, hw, hp, hq):
  match p q:
    case G.P{x, y, d} G.P{u, v, e}: convex_mixture_fields(x, y, d, u, v, e, r, k, l, hpd, hqd, hw, hp, hq)

# Exact endpoint/weight reversal for an undirected homogeneous segment.
def join_reversed(+p:G.Point,+q:G.Point,+k:Nat,+l:Nat) -> {M.join(q,p,l,k) == M.join(p,q,k,l) : G.Point}:
  match p q:
    case G.P{+x,+y,+d} G.P{+u,+v,+e}:
      GP.point_equal(Nat.add(Nat.mul(u,l),Nat.mul(x,k)),Nat.add(Nat.mul(v,l),Nat.mul(y,k)),Nat.add(Nat.mul(e,l),Nat.mul(d,k)),Nat.add(Nat.mul(x,k),Nat.mul(u,l)),Nat.add(Nat.mul(y,k),Nat.mul(v,l)),Nat.add(Nat.mul(d,k),Nat.mul(e,l)),F.add_comm(Nat.mul(u,l),Nat.mul(x,k)),F.add_comm(Nat.mul(v,l),Nat.mul(y,k)),F.add_comm(Nat.mul(e,l),Nat.mul(d,k)))
