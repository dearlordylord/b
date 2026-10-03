import Base
import ./strict-halfplane.bend as M
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
import ./facts.bend as F
import ./order-facts.bend as O
import ./strict-complement-proof.bend as Complement

def strict_not_not(b:Bool) -> {b == Bool.not(Bool.not(b)) : Bool}: Complement.strict_not_not(b)
def negative_closed_complement(+a: N.Point,+b: N.Point,+p: G.Point) -> {M.negative(a, b, p) == Bool.not(Region.edge(a, b, p)) : Bool}: Complement.negative_closed_complement(a,b,p)
def strict_add_left(+k: Nat, +a: Nat, +b: Nat, h: {Nat.is_lt(a, b) == True{} : Bool}) -> {Nat.is_lt(Nat.add(k, a), Nat.add(k, b)) == True{} : Bool}:
  match k:
    case 0n: h
    case 1n+t: strict_add_left(t, a, b, h)
def strict_add_right(+a: Nat, +b: Nat, +k: Nat, h: {Nat.is_lt(a, b) == True{} : Bool}) -> {Nat.is_lt(Nat.add(a, k), Nat.add(b, k)) == True{} : Bool}:
  %Equal.sym(Nat, Nat.add(a, k), Nat.add(k, a), F.add_comm(a, k)) : {Nat.is_lt(_, Nat.add(b, k)) == True{} : Bool}
  %Equal.sym(Nat, Nat.add(b, k), Nat.add(k, b), F.add_comm(b, k)) : {Nat.is_lt(Nat.add(k, a), _) == True{} : Bool}
  strict_add_left(k, a, b, h)
def strict_positive_product(+a: Nat, +b: Nat, +k: Nat, h: {Nat.is_lt(a, b) == True{} : Bool}) -> {Nat.is_lt(Nat.mul(a, 1n+k), Nat.mul(b, 1n+k)) == True{} : Bool}:
  Equal.trans(Bool, Nat.is_lt(Nat.mul(a, 1n+k), Nat.mul(b, 1n+k)), Nat.is_lt(a, b), True{}, Equal.cong(Cmp, Bool, c => Cmp.is_lt(c), Nat.cmp(Nat.mul(a, 1n+k), Nat.mul(b, 1n+k)), Nat.cmp(a, b), GL.positive_product_comparison(a, b, k)), h)
def strict_closed_sum(+a: Nat, +b: Nat, +c: Nat, +d: Nat, hab: {Nat.is_lt(a, b) == True{} : Bool}, hcd: {Nat.is_le(c, d) == True{} : Bool}) -> {Nat.is_lt(Nat.add(a, c), Nat.add(b, d)) == True{} : Bool}:
  O.lt_of_le_of_lt(Nat.add(a, c), Nat.add(a, d), Nat.add(b, d), O.add_le_add_left(c, d, a, hcd), strict_add_right(a, b, d, hab))
def strict_pair(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +k: Nat, +l: Nat, hp: {Nat.is_lt(a, b) == True{} : Bool}, hq: {Nat.is_lt(c, d) == True{} : Bool}, hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}) -> {Nat.is_lt(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.add(Nat.mul(b, k), Nat.mul(d, l))) == True{} : Bool}:
  match k l:
    case 0n 0n: B.absurd({Nat.is_lt(Nat.add(Nat.mul(a, 0n), Nat.mul(c, 0n)), Nat.add(Nat.mul(b, 0n), Nat.mul(d, 0n))) == True{} : Bool}, B.false_impossible(hw))
    case 0n 1n+ll:
      %Equal.sym(Nat, Nat.mul(a, 0n), 0n, F.mul_zero(a)) : {Nat.is_lt(Nat.add(_, Nat.mul(c, 1n+ll)), Nat.add(Nat.mul(b, 0n), Nat.mul(d, 1n+ll))) == True{} : Bool}
      %Equal.sym(Nat, Nat.mul(b, 0n), 0n, F.mul_zero(b)) : {Nat.is_lt(Nat.mul(c, 1n+ll), Nat.add(_, Nat.mul(d, 1n+ll))) == True{} : Bool}
      strict_positive_product(c, d, ll, hq)
    case 1n+kk _:
      strict_closed_sum(Nat.mul(a, 1n+kk), Nat.mul(b, 1n+kk), Nat.mul(c, l), Nat.mul(d, l), strict_positive_product(a, b, kk, hp), O.mul_le_mul_right(c, d, l, O.le_of_lt(c, d, hq)))

def strict_closed_pair(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +k: Nat, +l: Nat, hp: {Nat.is_lt(a, b) == True{} : Bool}, hq: {Nat.is_lt(c, d) == True{} : Bool}) -> {Nat.is_le(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.add(Nat.mul(b, k), Nat.mul(d, l))) == True{} : Bool}:
  O.add_le_add(Nat.mul(a, k), Nat.mul(c, l), Nat.mul(b, k), Nat.mul(d, l), O.mul_le_mul_right(a, b, k, O.le_of_lt(a, b, hp)), O.mul_le_mul_right(c, d, l, O.le_of_lt(c, d, hq)))
def closed_strict_sum(+a: Nat, +b: Nat, +c: Nat, +d: Nat, hab: {Nat.is_le(a, b) == True{} : Bool}, hcd: {Nat.is_lt(c, d) == True{} : Bool}) -> {Nat.is_lt(Nat.add(a, c), Nat.add(b, d)) == True{} : Bool}:
  %Equal.sym(Nat, Nat.add(a, c), Nat.add(c, a), F.add_comm(a, c)) : {Nat.is_lt(_, Nat.add(b, d)) == True{} : Bool}
  %Equal.sym(Nat, Nat.add(b, d), Nat.add(d, b), F.add_comm(b, d)) : {Nat.is_lt(Nat.add(c, a), _) == True{} : Bool}
  strict_closed_sum(c, d, a, b, hcd, hab)
def strict_four(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +u: Nat, +v: Nat, +w: Nat, +z: Nat, +k: Nat, +l: Nat, +m: Nat, +n: Nat, ha: {Nat.is_lt(a, u) == True{} : Bool}, hb: {Nat.is_lt(b, v) == True{} : Bool}, hc: {Nat.is_lt(c, w) == True{} : Bool}, hd: {Nat.is_lt(d, z) == True{} : Bool}, hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}) -> {Nat.is_lt(Nat.add(Nat.add(Nat.mul(a, k), Nat.mul(b, l)), Nat.add(Nat.mul(c, m), Nat.mul(d, n))), Nat.add(Nat.add(Nat.mul(u, k), Nat.mul(v, l)), Nat.add(Nat.mul(w, m), Nat.mul(z, n)))) == True{} : Bool}:
  match k l m n:
    case 1n+kk _ _ _: strict_closed_sum(Nat.add(Nat.mul(a, 1n+kk), Nat.mul(b, l)), Nat.add(Nat.mul(u, 1n+kk), Nat.mul(v, l)), Nat.add(Nat.mul(c, m), Nat.mul(d, n)), Nat.add(Nat.mul(w, m), Nat.mul(z, n)), strict_pair(a, u, b, v, 1n+kk, l, ha, hb, {==}), strict_closed_pair(c, w, d, z, m, n, hc, hd))
    case 0n 1n+ll _ _: strict_closed_sum(Nat.add(Nat.mul(a, 0n), Nat.mul(b, 1n+ll)), Nat.add(Nat.mul(u, 0n), Nat.mul(v, 1n+ll)), Nat.add(Nat.mul(c, m), Nat.mul(d, n)), Nat.add(Nat.mul(w, m), Nat.mul(z, n)), strict_pair(a, u, b, v, 0n, 1n+ll, ha, hb, {==}), strict_closed_pair(c, w, d, z, m, n, hc, hd))
    case 0n 0n 1n+mm _: closed_strict_sum(Nat.add(Nat.mul(a, 0n), Nat.mul(b, 0n)), Nat.add(Nat.mul(u, 0n), Nat.mul(v, 0n)), Nat.add(Nat.mul(c, 1n+mm), Nat.mul(d, n)), Nat.add(Nat.mul(w, 1n+mm), Nat.mul(z, n)), strict_closed_pair(a, u, b, v, 0n, 0n, ha, hb), strict_pair(c, w, d, z, 1n+mm, n, hc, hd, {==}))
    case 0n 0n 0n 1n+nn: closed_strict_sum(Nat.add(Nat.mul(a, 0n), Nat.mul(b, 0n)), Nat.add(Nat.mul(u, 0n), Nat.mul(v, 0n)), Nat.add(Nat.mul(c, 0n), Nat.mul(d, 1n+nn)), Nat.add(Nat.mul(w, 0n), Nat.mul(z, 1n+nn)), strict_closed_pair(a, u, b, v, 0n, 0n, ha, hb), strict_pair(c, w, d, z, 0n, 1n+nn, hc, hd, {==}))
    case 0n 0n 0n 0n: B.absurd({Nat.is_lt(Nat.add(Nat.add(Nat.mul(a, 0n), Nat.mul(b, 0n)), Nat.add(Nat.mul(c, 0n), Nat.mul(d, 0n))), Nat.add(Nat.add(Nat.mul(u, 0n), Nat.mul(v, 0n)), Nat.add(Nat.mul(w, 0n), Nat.mul(z, 0n)))) == True{} : Bool}, B.false_impossible(hw))
def strict_form(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: G.Point) -> Bool:
  Nat.is_lt(C.value(Nat.mul(ax, by), bx, ay, p), C.value(Nat.mul(ay, bx), ax, by, p))
def strict_form_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat) -> {M.negative(N.P{ax, ay}, N.P{bx, by}, G.P{x, y, d}) == strict_form(ax, ay, bx, by, G.P{x, y, d}) : Bool}:
  %Equal.sym(Nat, C.value(Nat.mul(ax, by), bx, ay, G.P{x, y, d}), H.exact(ax, by, d, bx, y, x, ay), CP.form_polynomial(ax, by, bx, d, x, y, ay)) : {M.negative(N.P{ax, ay}, N.P{bx, by}, G.P{x, y, d}) == Nat.is_lt(_, C.value(Nat.mul(ay, bx), ax, by, G.P{x, y, d})) : Bool}
  %Equal.sym(Nat, C.value(Nat.mul(ay, bx), ax, by, G.P{x, y, d}), H.exact(ay, bx, d, by, x, y, ax), CP.negative_polynomial(ay, bx, by, ax, x, y, d)) : {M.negative(N.P{ax, ay}, N.P{bx, by}, G.P{x, y, d}) == Nat.is_lt(H.exact(ax, by, d, bx, y, x, ay), _) : Bool}
  {==}
def strict_form_exact(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, p: G.Point) -> {M.negative(N.P{ax, ay}, N.P{bx, by}, p) == strict_form(ax, ay, bx, by, p) : Bool}:
  match p:
    case G.P{x, y, d}: strict_form_fields(ax, ay, bx, by, x, y, d)
def strict_form_join(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: G.Point, +q: G.Point, +k: Nat, +l: Nat, hp: {strict_form(ax, ay, bx, by, p) == True{} : Bool}, hq: {strict_form(ax, ay, bx, by, q) == True{} : Bool}, hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}) -> {strict_form(ax, ay, bx, by, C.join(p, q, k, l)) == True{} : Bool}:
  %Equal.sym(Nat, C.value(Nat.mul(ax, by), bx, ay, C.join(p, q, k, l)), Nat.add(Nat.mul(C.value(Nat.mul(ax, by), bx, ay, p), k), Nat.mul(C.value(Nat.mul(ax, by), bx, ay, q), l)), CL.weighted_form_exact(Nat.mul(ax, by), bx, ay, p, q, k, l)) : {Nat.is_lt(_, C.value(Nat.mul(ay, bx), ax, by, C.join(p, q, k, l))) == True{} : Bool}
  %Equal.sym(Nat, C.value(Nat.mul(ay, bx), ax, by, C.join(p, q, k, l)), Nat.add(Nat.mul(C.value(Nat.mul(ay, bx), ax, by, p), k), Nat.mul(C.value(Nat.mul(ay, bx), ax, by, q), l)), CL.weighted_form_exact(Nat.mul(ay, bx), ax, by, p, q, k, l)) : {Nat.is_lt(Nat.add(Nat.mul(C.value(Nat.mul(ax, by), bx, ay, p), k), Nat.mul(C.value(Nat.mul(ax, by), bx, ay, q), l)), _) == True{} : Bool}
  strict_pair(C.value(Nat.mul(ax, by), bx, ay, p), C.value(Nat.mul(ay, bx), ax, by, p), C.value(Nat.mul(ax, by), bx, ay, q), C.value(Nat.mul(ay, bx), ax, by, q), k, l, hp, hq, hw)
def negative_weighted_join(+a: N.Point,+b: N.Point,+p: G.Point,+q: G.Point,+k: Nat,+l: Nat,hp: {M.negative(a, b, p) == True{} : Bool},hq: {M.negative(a, b, q) == True{} : Bool},hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}) -> {M.negative(a, b, C.join(p, q, k, l)) == True{} : Bool}:
  match a b:
    case N.P{+ax, +ay} N.P{+bx, +by}:
      Equal.trans(Bool, M.negative(N.P{ax, ay}, N.P{bx, by}, C.join(p, q, k, l)), strict_form(ax, ay, bx, by, C.join(p, q, k, l)), True{}, strict_form_exact(ax, ay, bx, by, C.join(p, q, k, l)), strict_form_join(ax, ay, bx, by, p, q, k, l, Equal.trans(Bool, strict_form(ax, ay, bx, by, p), M.negative(N.P{ax, ay}, N.P{bx, by}, p), True{}, Equal.sym(Bool, M.negative(N.P{ax, ay}, N.P{bx, by}, p), strict_form(ax, ay, bx, by, p), strict_form_exact(ax, ay, bx, by, p)), hp), Equal.trans(Bool, strict_form(ax, ay, bx, by, q), M.negative(N.P{ax, ay}, N.P{bx, by}, q), True{}, Equal.sym(Bool, M.negative(N.P{ax, ay}, N.P{bx, by}, q), strict_form(ax, ay, bx, by, q), strict_form_exact(ax, ay, bx, by, q)), hq), hw))

def strict_quad_value(+aa: Nat, +bb: Nat, +cc: Nat, +p: N.Point, +q: N.Point, +r: N.Point, +s: N.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat) -> {C.value(aa, bb, cc, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)) == Nat.add(Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(p)), k), Nat.mul(C.value(aa, bb, cc, Q.embed(q)), l)), Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(r)), m), Nat.mul(C.value(aa, bb, cc, Q.embed(s)), n))) : Nat}:
  Equal.trans(Nat, C.value(aa, bb, cc, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)), Nat.add(Nat.mul(C.value(aa, bb, cc, C.join(Q.embed(p), Q.embed(q), k, l)), 1n), Nat.mul(C.value(aa, bb, cc, C.join(Q.embed(r), Q.embed(s), m, n)), 1n)), Nat.add(Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(p)), k), Nat.mul(C.value(aa, bb, cc, Q.embed(q)), l)), Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(r)), m), Nat.mul(C.value(aa, bb, cc, Q.embed(s)), n))), CL.weighted_form_exact(aa, bb, cc, C.join(Q.embed(p), Q.embed(q), k, l), C.join(Q.embed(r), Q.embed(s), m, n), 1n, 1n), Equal.trans(Nat, Nat.add(Nat.mul(C.value(aa, bb, cc, C.join(Q.embed(p), Q.embed(q), k, l)), 1n), Nat.mul(C.value(aa, bb, cc, C.join(Q.embed(r), Q.embed(s), m, n)), 1n)), Nat.add(C.value(aa, bb, cc, C.join(Q.embed(p), Q.embed(q), k, l)), C.value(aa, bb, cc, C.join(Q.embed(r), Q.embed(s), m, n))), Nat.add(Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(p)), k), Nat.mul(C.value(aa, bb, cc, Q.embed(q)), l)), Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(r)), m), Nat.mul(C.value(aa, bb, cc, Q.embed(s)), n))), HP.scalar_ones(C.value(aa, bb, cc, C.join(Q.embed(p), Q.embed(q), k, l)), C.value(aa, bb, cc, C.join(Q.embed(r), Q.embed(s), m, n))), HP.add_cong(C.value(aa, bb, cc, C.join(Q.embed(p), Q.embed(q), k, l)), C.value(aa, bb, cc, C.join(Q.embed(r), Q.embed(s), m, n)), Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(p)), k), Nat.mul(C.value(aa, bb, cc, Q.embed(q)), l)), Nat.add(Nat.mul(C.value(aa, bb, cc, Q.embed(r)), m), Nat.mul(C.value(aa, bb, cc, Q.embed(s)), n)), CL.weighted_form_exact(aa, bb, cc, Q.embed(p), Q.embed(q), k, l), CL.weighted_form_exact(aa, bb, cc, Q.embed(r), Q.embed(s), m, n))))
def strict_to_form(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: G.Point, h: {M.negative(N.P{ax, ay}, N.P{bx, by}, p) == True{} : Bool}) -> {strict_form(ax, ay, bx, by, p) == True{} : Bool}:
  Equal.trans(Bool, strict_form(ax, ay, bx, by, p), M.negative(N.P{ax, ay}, N.P{bx, by}, p), True{}, Equal.sym(Bool, M.negative(N.P{ax, ay}, N.P{bx, by}, p), strict_form(ax, ay, bx, by, p), strict_form_exact(ax, ay, bx, by, p)), h)

def strict_quad_form(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: N.Point, +q: N.Point, +r: N.Point, +s: N.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, hp: {strict_form(ax, ay, bx, by, Q.embed(p)) == True{} : Bool}, hq: {strict_form(ax, ay, bx, by, Q.embed(q)) == True{} : Bool}, hr: {strict_form(ax, ay, bx, by, Q.embed(r)) == True{} : Bool}, hs: {strict_form(ax, ay, bx, by, Q.embed(s)) == True{} : Bool}, hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}) -> {strict_form(ax, ay, bx, by, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)) == True{} : Bool}:
  %Equal.sym(Nat, C.value(Nat.mul(ax, by), bx, ay, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)), Nat.add(Nat.add(Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(p)), k), Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(q)), l)), Nat.add(Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(r)), m), Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(s)), n))), strict_quad_value(Nat.mul(ax, by), bx, ay, p, q, r, s, k, l, m, n)) : {Nat.is_lt(_, C.value(Nat.mul(ay, bx), ax, by, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n))) == True{} : Bool}
  %Equal.sym(Nat, C.value(Nat.mul(ay, bx), ax, by, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)), Nat.add(Nat.add(Nat.mul(C.value(Nat.mul(ay, bx), ax, by, Q.embed(p)), k), Nat.mul(C.value(Nat.mul(ay, bx), ax, by, Q.embed(q)), l)), Nat.add(Nat.mul(C.value(Nat.mul(ay, bx), ax, by, Q.embed(r)), m), Nat.mul(C.value(Nat.mul(ay, bx), ax, by, Q.embed(s)), n))), strict_quad_value(Nat.mul(ay, bx), ax, by, p, q, r, s, k, l, m, n)) : {Nat.is_lt(Nat.add(Nat.add(Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(p)), k), Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(q)), l)), Nat.add(Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(r)), m), Nat.mul(C.value(Nat.mul(ax, by), bx, ay, Q.embed(s)), n))), _) == True{} : Bool}
  strict_four(C.value(Nat.mul(ax, by), bx, ay, Q.embed(p)), C.value(Nat.mul(ax, by), bx, ay, Q.embed(q)), C.value(Nat.mul(ax, by), bx, ay, Q.embed(r)), C.value(Nat.mul(ax, by), bx, ay, Q.embed(s)), C.value(Nat.mul(ay, bx), ax, by, Q.embed(p)), C.value(Nat.mul(ay, bx), ax, by, Q.embed(q)), C.value(Nat.mul(ay, bx), ax, by, Q.embed(r)), C.value(Nat.mul(ay, bx), ax, by, Q.embed(s)), k, l, m, n, hp, hq, hr, hs, hw)

def strict_quad_corners(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +p: N.Point, +q: N.Point, +r: N.Point, +s: N.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, corners: {M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(p)) == True{} : Bool} & ({M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(q)) == True{} : Bool} & ({M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(r)) == True{} : Bool} & ({M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(s)) == True{} : Bool}))), hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}) -> {M.negative(N.P{ax, ay}, N.P{bx, by}, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)) == True{} : Bool}:
  match corners:
    case (hp, (hq, (hr, hs))): Equal.trans(Bool, M.negative(N.P{ax, ay}, N.P{bx, by}, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)), strict_form(ax, ay, bx, by, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)), True{}, strict_form_exact(ax, ay, bx, by, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)), strict_quad_form(ax, ay, bx, by, p, q, r, s, k, l, m, n, strict_to_form(ax, ay, bx, by, Q.embed(p), hp), strict_to_form(ax, ay, bx, by, Q.embed(q), hq), strict_to_form(ax, ay, bx, by, Q.embed(r), hr), strict_to_form(ax, ay, bx, by, Q.embed(s), hs), hw))
def strict_quad_edge(+a: N.Point, +b: N.Point, +p: N.Point, +q: N.Point, +r: N.Point, +s: N.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, corners: {M.negative(a, b, Q.embed(p)) == True{} : Bool} & ({M.negative(a, b, Q.embed(q)) == True{} : Bool} & ({M.negative(a, b, Q.embed(r)) == True{} : Bool} & {M.negative(a, b, Q.embed(s)) == True{} : Bool})), hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}) -> {M.negative(a, b, Hull.weighted(N.Q{p, q, r, s}, k, l, m, n)) == True{} : Bool}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: strict_quad_corners(ax, ay, bx, by, p, q, r, s, k, l, m, n, corners, hw)
def separated_weighted_quad(+a: N.Point,+b: N.Point,+q: N.Quad,+k: Nat,+l: Nat,+m: Nat,+n: Nat,hs: {M.separated(a, b, q) == True{} : Bool},hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}) -> {M.negative(a, b, Hull.weighted(q, k, l, m, n)) == True{} : Bool}:
  match q:
    case N.Q{+p, +q, +r, +s}: strict_quad_edge(a, b, p, q, r, s, k, l, m, n, CP.four_fields(M.negative(a, b, Q.embed(p)), M.negative(a, b, Q.embed(q)), M.negative(a, b, Q.embed(r)), M.negative(a, b, Q.embed(s)), hs), hw)

def strict_equivalent_points(+a: N.Point, +b: N.Point, +p: G.Point, +r: G.Point, hp: {G.positive_denominator(p) == True{} : Bool}, hr: {G.positive_denominator(r) == True{} : Bool}, he: {G.equivalent(p, r) == True{} : Bool}) -> {M.negative(a, b, p) == M.negative(a, b, r) : Bool}:
  match a b:
    case N.P{+ax, +ay} N.P{+bx, +by}: Equal.cong(Cmp, Bool, c => Cmp.is_lt(c), G.side(ax, ay, bx, by, p), G.side(ax, ay, bx, by, r), GL.equivalent_point_side(ax, ay, bx, by, p, r, hp, hr, he))
def strict_hull_weights(+a: N.Point, +b: N.Point, +q: N.Quad, +p: G.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, +hw: {Nat.is_gt(Hull.weight_total(k, l, m, n), 0n) == True{} : Bool}, hp: {G.positive_denominator(p) == True{} : Bool}, he: {G.equivalent(p, Hull.weighted(q, k, l, m, n)) == True{} : Bool}, hs: {M.separated(a, b, q) == True{} : Bool}) -> {M.negative(a, b, p) == True{} : Bool}:
  Equal.trans(Bool, M.negative(a, b, p), M.negative(a, b, Hull.weighted(q, k, l, m, n)), True{}, strict_equivalent_points(a, b, p, Hull.weighted(q, k, l, m, n), hp, HL.weighted_quad_positive(q, k, l, m, n, hw), he), separated_weighted_quad(a, b, q, k, l, m, n, hs, hw))
def separated_hull_point(+a: N.Point,+b: N.Point,+q: N.Quad,+p: G.Point,hs: {M.separated(a, b, q) == True{} : Bool},member: Hull.InHull(q, p)) -> {M.negative(a, b, p) == True{} : Bool}:
  match member:
    case (k, (l, (m, (n, (hw, (hp, he)))))): strict_hull_weights(a, b, q, p, k, l, m, n, hw, hp, he, hs)
def strict_closed_impossible(+a: N.Point, +b: N.Point, +p: G.Point, hp: {Region.edge(a, b, p) == True{} : Bool}, hn: {M.negative(a, b, p) == True{} : Bool}) -> Empty:
  B.false_impossible(Equal.trans(Bool, False{}, M.negative(a, b, p), True{}, Equal.sym(Bool, M.negative(a, b, p), False{}, Equal.trans(Bool, M.negative(a, b, p), Bool.not(Region.edge(a, b, p)), False{}, negative_closed_complement(a, b, p), Equal.cong(Bool, Bool, b => Bool.not(b), Region.edge(a, b, p), True{}, hp))), hn))
def separated_region_exclusion(+a: N.Point,+b: N.Point,+q: N.Quad,+p: G.Point,hs: {M.separated(a, b, q) == True{} : Bool},hp: {Region.edge(a, b, p) == True{} : Bool}) -> Hull.InHull(q, p) -> Empty:
  member => strict_closed_impossible(a, b, p, hp, separated_hull_point(a, b, q, p, hs, member))


def negative_from_false(+a:N.Point,+b:N.Point,+p:G.Point,h:{Region.edge(a,b,p) == False{} : Bool}) -> {M.negative(a,b,p) == True{} : Bool}: Complement.negative_from_false(a,b,p,h)
