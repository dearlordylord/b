import Base
import ./homogeneous-geometry.bend as M
import ./homogeneous-geometry-laws.bend as L
import ./homogeneous.bend as H
import ./facts.bend as F
import ./boolean-reflection.bend as B
import ./validation-proof.bend as Reflection

def compare_add_left(+k: Nat, +a: Nat, +b: Nat) -> {Nat.cmp(Nat.add(k, a), Nat.add(k, b)) == Nat.cmp(a, b) : Cmp}:
  match k:
    case 0n: {==}
    case 1n+p: compare_add_left(p, a, b)
def L.positive_product_comparison(a, b, k):
  match a b:
    case 0n 0n: {==}
    case 0n 1n+q: {==}
    case 1n+p 0n: {==}
    case 1n+p 1n+q:
      Equal.trans(Cmp, Nat.cmp(Nat.mul(1n+p, 1n+k), Nat.mul(1n+q, 1n+k)), Nat.cmp(Nat.mul(p, 1n+k), Nat.mul(q, 1n+k)), Nat.cmp(p, q), compare_add_left(1n+k, Nat.mul(p, 1n+k), Nat.mul(q, 1n+k)), L.positive_product_comparison(p, q, k))
def swap_scale(+x: Nat, +k: Nat, +e: Nat) -> {Nat.mul(Nat.mul(x, k), e) == Nat.mul(Nat.mul(x, e), k) : Nat}:
  Equal.trans(Nat, Nat.mul(Nat.mul(x, k), e), Nat.mul(x, Nat.mul(k, e)), Nat.mul(Nat.mul(x, e), k), F.mul_assoc(x, k, e), Equal.trans(Nat, Nat.mul(x, Nat.mul(k, e)), Nat.mul(x, Nat.mul(e, k)), Nat.mul(Nat.mul(x, e), k), Equal.cong(Nat, Nat, n => Nat.mul(x, n), Nat.mul(k, e), Nat.mul(e, k), F.mul_comm(k, e)), Equal.sym(Nat, Nat.mul(Nat.mul(x, e), k), Nat.mul(x, Nat.mul(e, k)), F.mul_assoc(x, e, k))))
def sum3_cong(+a: Nat, +b: Nat, +c: Nat, +p: Nat, +q: Nat, +r: Nat, ha: {a == p : Nat}, hb: {b == q : Nat}, hc: {c == r : Nat}) -> {Nat.add(Nat.add(a, b), c) == Nat.add(Nat.add(p, q), r) : Nat}:
  %ha : {Nat.add(Nat.add(a, b), c) == Nat.add(Nat.add(_, q), r) : Nat}
  %hb : {Nat.add(Nat.add(a, b), c) == Nat.add(Nat.add(a, _), r) : Nat}
  %hc : {Nat.add(Nat.add(a, b), c) == Nat.add(Nat.add(a, b), _) : Nat}
  {==}
def sum3_scale(+p: Nat, +q: Nat, +r: Nat, +k: Nat) -> {Nat.add(Nat.add(Nat.mul(p, k), Nat.mul(q, k)), Nat.mul(r, k)) == Nat.mul(Nat.add(Nat.add(p, q), r), k) : Nat}:
  %F.add_mul(p, q, k) : {Nat.add(_, Nat.mul(r, k)) == Nat.mul(Nat.add(Nat.add(p, q), r), k) : Nat}
  Equal.sym(Nat, Nat.mul(Nat.add(Nat.add(p, q), r), k), Nat.add(Nat.mul(Nat.add(p, q), k), Nat.mul(r, k)), F.add_mul(Nat.add(p, q), r, k))
def L.homogeneous_linear_scale(a, b, d, c, y, x, e, k):
  Equal.trans(Nat, H.exact(a, b, Nat.mul(d, k), c, Nat.mul(y, k), Nat.mul(x, k), e), Nat.add(Nat.add(Nat.mul(Nat.mul(Nat.mul(a, b), d), k), Nat.mul(Nat.mul(c, y), k)), Nat.mul(Nat.mul(x, e), k)), Nat.mul(H.exact(a, b, d, c, y, x, e), k), sum3_cong(Nat.mul(Nat.mul(a, b), Nat.mul(d, k)), Nat.mul(c, Nat.mul(y, k)), Nat.mul(Nat.mul(x, k), e), Nat.mul(Nat.mul(Nat.mul(a, b), d), k), Nat.mul(Nat.mul(c, y), k), Nat.mul(Nat.mul(x, e), k), Equal.sym(Nat, Nat.mul(Nat.mul(Nat.mul(a, b), d), k), Nat.mul(Nat.mul(a, b), Nat.mul(d, k)), F.mul_assoc(Nat.mul(a, b), d, k)), Equal.sym(Nat, Nat.mul(Nat.mul(c, y), k), Nat.mul(c, Nat.mul(y, k)), F.mul_assoc(c, y, k)), swap_scale(x, k, e)), sum3_scale(Nat.mul(Nat.mul(a, b), d), Nat.mul(c, y), Nat.mul(x, e), k))
def scaled_side(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat, +k: Nat) -> {M.side(ax, ay, bx, by, M.scale(M.P{x, y, d}, k)) == M.side(ax, ay, bx, by, M.P{x, y, d}) : Cmp}:
  %Equal.sym(Nat, H.exact(ax, by, Nat.mul(d, 1n+k), bx, Nat.mul(y, 1n+k), Nat.mul(x, 1n+k), ay), Nat.mul(H.exact(ax, by, d, bx, y, x, ay), 1n+k), L.homogeneous_linear_scale(ax, by, d, bx, y, x, ay, 1n+k)) : {Nat.cmp(_, H.exact(ay, bx, Nat.mul(d, 1n+k), by, Nat.mul(x, 1n+k), Nat.mul(y, 1n+k), ax)) == M.side(ax, ay, bx, by, M.P{x, y, d}) : Cmp}
  %Equal.sym(Nat, H.exact(ay, bx, Nat.mul(d, 1n+k), by, Nat.mul(x, 1n+k), Nat.mul(y, 1n+k), ax), Nat.mul(H.exact(ay, bx, d, by, x, y, ax), 1n+k), L.homogeneous_linear_scale(ay, bx, d, by, x, y, ax, 1n+k)) : {Nat.cmp(Nat.mul(H.exact(ax, by, d, bx, y, x, ay), 1n+k), _) == M.side(ax, ay, bx, by, M.P{x, y, d}) : Cmp}
  L.positive_product_comparison(H.exact(ax, by, d, bx, y, x, ay), H.exact(ay, bx, d, by, x, y, ax), k)
def L.side_positive_scale(ax, ay, bx, by, p, k):
  match p:
    case M.P{+x, +y, +d}: scaled_side(ax, ay, bx, by, x, y, d, k)
def L.closed_halfplane_positive_scale(ax, ay, bx, by, p, k):
  Equal.cong(Cmp, Bool, side => Bool.not(Cmp.is_lt(side)), M.side(ax, ay, bx, by, M.scale(p, k)), M.side(ax, ay, bx, by, p), L.side_positive_scale(ax, ay, bx, by, p, k))

def denominator_scale(+x: Nat, +y: Nat, +d: Nat, +k: Nat) -> {M.positive_denominator(M.scale(M.P{x, y, d}, k)) == M.positive_denominator(M.P{x, y, d}) : Bool}:
  Equal.cong(Cmp, Bool, c => Cmp.is_gt(c), Nat.cmp(Nat.mul(d, 1n+k), Nat.mul(0n, 1n+k)), Nat.cmp(d, 0n), L.positive_product_comparison(d, 0n, k))
def L.scale_positive_denominator(p, k):
  match p:
    case M.P{x, y, d}: denominator_scale(x, y, d, k)
def cross_scale(+x: Nat, +d: Nat, +k: Nat) -> {Nat.mul(x, Nat.mul(d, 1n+k)) == Nat.mul(Nat.mul(x, 1n+k), d) : Nat}:
  Equal.trans(Nat, Nat.mul(x, Nat.mul(d, 1n+k)), Nat.mul(Nat.mul(x, d), 1n+k), Nat.mul(Nat.mul(x, 1n+k), d), Equal.sym(Nat, Nat.mul(Nat.mul(x, d), 1n+k), Nat.mul(x, Nat.mul(d, 1n+k)), F.mul_assoc(x, d, 1n+k)), swap_scale(x, d, 1n+k))
def equivalent_scaled(+x: Nat, +y: Nat, +d: Nat, +k: Nat) -> {M.equivalent(M.P{x, y, d}, M.scale(M.P{x, y, d}, k)) == True{} : Bool}:
  B.and_join(Nat.is_eq(Nat.mul(x, Nat.mul(d, 1n+k)), Nat.mul(Nat.mul(x, 1n+k), d)), Nat.is_eq(Nat.mul(y, Nat.mul(d, 1n+k)), Nat.mul(Nat.mul(y, 1n+k), d)), Reflection.nat_eq_complete(Nat.mul(x, Nat.mul(d, 1n+k)), Nat.mul(Nat.mul(x, 1n+k), d), cross_scale(x, d, k)), Reflection.nat_eq_complete(Nat.mul(y, Nat.mul(d, 1n+k)), Nat.mul(Nat.mul(y, 1n+k), d), cross_scale(y, d, k)))
def L.scale_equivalent_point(p, k):
  match p:
    case M.P{x, y, d}: equivalent_scaled(x, y, d, k)
def point_equal(+x: Nat, +y: Nat, +d: Nat, +u: Nat, +v: Nat, +e: Nat, hx: {x == u : Nat}, hy: {y == v : Nat}, hd: {d == e : Nat}) -> {M.P{x, y, d} == M.P{u, v, e} : M.Point}:
  %hx : {M.P{x, y, d} == M.P{_, v, e} : M.Point}
  %hy : {M.P{x, y, d} == M.P{x, _, e} : M.Point}
  %hd : {M.P{x, y, d} == M.P{x, y, _} : M.Point}
  {==}
def common_scaled(+x: Nat, +y: Nat, +d: Nat, +u: Nat, +v: Nat, +e: Nat, hs: {Nat.is_eq(Nat.mul(x, 1n+e), Nat.mul(u, 1n+d)) == True{} : Bool} & {Nat.is_eq(Nat.mul(y, 1n+e), Nat.mul(v, 1n+d)) == True{} : Bool}) -> {M.scale(M.P{x, y, 1n+d}, e) == M.scale(M.P{u, v, 1n+e}, d) : M.Point}:
  match hs:
    case (hx, hy): point_equal(Nat.mul(x, 1n+e), Nat.mul(y, 1n+e), Nat.mul(1n+d, 1n+e), Nat.mul(u, 1n+d), Nat.mul(v, 1n+d), Nat.mul(1n+e, 1n+d), B.nat_eq_sound(Nat.mul(x, 1n+e), Nat.mul(u, 1n+d), hx), B.nat_eq_sound(Nat.mul(y, 1n+e), Nat.mul(v, 1n+d), hy), F.mul_comm(1n+d, 1n+e))
def same_scaled_side(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat, +u: Nat, +v: Nat, +e: Nat, hs: {M.equivalent(M.P{x, y, 1n+d}, M.P{u, v, 1n+e}) == True{} : Bool}) -> {M.side(ax, ay, bx, by, M.P{x, y, 1n+d}) == M.side(ax, ay, bx, by, M.P{u, v, 1n+e}) : Cmp}:
  Equal.trans(Cmp, M.side(ax, ay, bx, by, M.P{x, y, 1n+d}), M.side(ax, ay, bx, by, M.scale(M.P{x, y, 1n+d}, e)), M.side(ax, ay, bx, by, M.P{u, v, 1n+e}), Equal.sym(Cmp, M.side(ax, ay, bx, by, M.scale(M.P{x, y, 1n+d}, e)), M.side(ax, ay, bx, by, M.P{x, y, 1n+d}), L.side_positive_scale(ax, ay, bx, by, M.P{x, y, 1n+d}, e)), Equal.trans(Cmp, M.side(ax, ay, bx, by, M.scale(M.P{x, y, 1n+d}, e)), M.side(ax, ay, bx, by, M.scale(M.P{u, v, 1n+e}, d)), M.side(ax, ay, bx, by, M.P{u, v, 1n+e}), Equal.cong(M.Point, Cmp, p => M.side(ax, ay, bx, by, p), M.scale(M.P{x, y, 1n+d}, e), M.scale(M.P{u, v, 1n+e}, d), common_scaled(x, y, d, u, v, e, B.and_split(Nat.is_eq(Nat.mul(x, 1n+e), Nat.mul(u, 1n+d)), Nat.is_eq(Nat.mul(y, 1n+e), Nat.mul(v, 1n+d)), hs))), L.side_positive_scale(ax, ay, bx, by, M.P{u, v, 1n+e}, d)))
def equivalent_values(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat, +u: Nat, +v: Nat, +e: Nat, hp: {M.positive_denominator(M.P{x, y, d}) == True{} : Bool}, hq: {M.positive_denominator(M.P{u, v, e}) == True{} : Bool}, hsame: {M.equivalent(M.P{x, y, d}, M.P{u, v, e}) == True{} : Bool}) -> {M.side(ax, ay, bx, by, M.P{x, y, d}) == M.side(ax, ay, bx, by, M.P{u, v, e}) : Cmp}:
  match d e:
    case 0n _: B.absurd({M.side(ax, ay, bx, by, M.P{x, y, 0n}) == M.side(ax, ay, bx, by, M.P{u, v, e}) : Cmp}, B.false_impossible(hp))
    case 1n+dd 0n: B.absurd({M.side(ax, ay, bx, by, M.P{x, y, 1n+dd}) == M.side(ax, ay, bx, by, M.P{u, v, 0n}) : Cmp}, B.false_impossible(hq))
    case 1n+dd 1n+ee: same_scaled_side(ax, ay, bx, by, x, y, dd, u, v, ee, hsame)
def L.equivalent_point_side(ax, ay, bx, by, p, q, hp, hq, hsame):
  match p q:
    case M.P{x, y, d} M.P{u, v, e}: equivalent_values(ax, ay, bx, by, x, y, d, u, v, e, hp, hq, hsame)
def L.equivalent_point_closed_halfplane(ax, ay, bx, by, p, q, hp, hq, hsame):
  Equal.cong(Cmp, Bool, c => Bool.not(Cmp.is_lt(c)), M.side(ax, ay, bx, by, p), M.side(ax, ay, bx, by, q), L.equivalent_point_side(ax, ay, bx, by, p, q, hp, hq, hsame))
