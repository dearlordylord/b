import ./source-cells-proof.bend as Fields
import Base
import ./triangle-area.bend as M
import ./triangle-area-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q
import ./quad-geometry-proof.bend as QP
import ./quad-diagonal.bend as D
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous-combination-proof.bend as CP
import ./order-facts.bend as O
import ./facts.bend as F
import ./boolean-reflection.bend as B
import ./subtraction-algebra-proof.bend as Cancel

def area_side_equation(+a: N.Point, +b: N.Point, +p: G.Point) -> {Region.edge(a, b, p) == Bool.not(Cmp.is_lt(Nat.cmp(M.positive(a, b, p), M.negative(a, b, p)))) : Bool}:
  match a b p:
    case N.P{ax, ay} N.P{bx, by} G.P{x, y, d}: {==}
def L.area_reconstruct(a, b, p, h):
  O.sub_add_cancel(M.positive(a, b, p), M.negative(a, b, p), Equal.trans(Bool, Nat.is_le(M.negative(a, b, p), M.positive(a, b, p)), Bool.not(Cmp.is_lt(Nat.cmp(M.positive(a, b, p), M.negative(a, b, p)))), True{}, Equal.sym(Bool, Bool.not(Cmp.is_lt(Nat.cmp(M.positive(a, b, p), M.negative(a, b, p)))), Nat.is_le(M.negative(a, b, p), M.positive(a, b, p)), CP.nonnegative_le(M.positive(a, b, p), M.negative(a, b, p))), Equal.trans(Bool, Bool.not(Cmp.is_lt(Nat.cmp(M.positive(a, b, p), M.negative(a, b, p)))), Region.edge(a, b, p), True{}, Equal.sym(Bool, Region.edge(a, b, p), Bool.not(Cmp.is_lt(Nat.cmp(M.positive(a, b, p), M.negative(a, b, p)))), area_side_equation(a, b, p)), h)))
def area_strict_difference(+a: Nat, +b: Nat, h: {Nat.is_gt(a, b) == True{} : Bool}) -> {Nat.is_gt(Nat.sub(a, b), 0n) == True{} : Bool}:
  match a b:
    case 0n 0n: B.absurd({Nat.is_gt(Nat.sub(0n, 0n), 0n) == True{} : Bool}, B.false_impossible(h))
    case 0n 1n+q: B.absurd({Nat.is_gt(Nat.sub(0n, 1n+q), 0n) == True{} : Bool}, B.false_impossible(h))
    case 1n+p 0n: {==}
    case 1n+p 1n+q: area_strict_difference(p, q, h)
def area_turn_equation(+a: N.Point, +b: N.Point, +c: N.Point) -> {Q.turn(a, b, c) == Nat.is_gt(M.positive(a, b, Q.embed(c)), M.negative(a, b, Q.embed(c))) : Bool}:
  match a b c:
    case N.P{ax, ay} N.P{bx, by} N.P{cx, cy}: {==}
def L.triangle_area_positive(a, b, c, h):
  area_strict_difference(M.positive(a, b, Q.embed(c)), M.negative(a, b, Q.embed(c)), Equal.trans(Bool, Nat.is_gt(M.positive(a, b, Q.embed(c)), M.negative(a, b, Q.embed(c))), Q.turn(a, b, c), True{}, Equal.sym(Bool, Q.turn(a, b, c), Nat.is_gt(M.positive(a, b, Q.embed(c)), M.negative(a, b, Q.embed(c))), area_turn_equation(a, b, c)), h))

def sum3(a: Nat, b: Nat, c: Nat) -> Nat:
  Nat.add(Nat.add(a, b), c)
def transpose3(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +e: Nat, +f: Nat, +g: Nat, +h: Nat, +i: Nat) -> {sum3(sum3(a, b, c), sum3(d, e, f), sum3(g, h, i)) == sum3(sum3(a, d, g), sum3(b, e, h), sum3(c, f, i)) : Nat}:
  Equal.trans(Nat, sum3(sum3(a, b, c), sum3(d, e, f), sum3(g, h, i)), Nat.add(sum3(Nat.add(a, d), Nat.add(b, e), Nat.add(c, f)), sum3(g, h, i)), sum3(sum3(a, d, g), sum3(b, e, h), sum3(c, f, i)), Equal.cong(Nat, Nat, n => Nat.add(n, sum3(g, h, i)), Nat.add(sum3(a, b, c), sum3(d, e, f)), sum3(Nat.add(a, d), Nat.add(b, e), Nat.add(c, f)), Equal.sym(Nat, sum3(Nat.add(a, d), Nat.add(b, e), Nat.add(c, f)), Nat.add(sum3(a, b, c), sum3(d, e, f)), CP.regroup3(a, b, c, d, e, f))), Equal.sym(Nat, sum3(sum3(a, d, g), sum3(b, e, h), sum3(c, f, i)), Nat.add(sum3(Nat.add(a, d), Nat.add(b, e), Nat.add(c, f)), sum3(g, h, i)), CP.regroup3(Nat.add(a, d), Nat.add(b, e), Nat.add(c, f), g, h, i)))
def coeff_triangle(+a: Nat, +b: Nat, +c: Nat) -> {sum3(b, c, a) == Nat.add(Nat.add(Nat.mul(a, 1n), b), c) : Nat}:
  Equal.trans(Nat, sum3(b, c, a), sum3(a, b, c), Nat.add(Nat.add(Nat.mul(a, 1n), b), c), Equal.sym(Nat, sum3(a, b, c), sum3(b, c, a), QP.rotate_sum(a, b, c)), Equal.cong(Nat, Nat, n => Nat.add(Nat.add(n, b), c), a, Nat.mul(a, 1n), Equal.sym(Nat, Nat.mul(a, 1n), a, F.mul_one(a))))
def column_rotate(+a: Nat, +b: Nat, +c: Nat, +x: Nat) -> {sum3(Nat.mul(x, a), Nat.mul(x, b), Nat.mul(x, c)) == Nat.mul(sum3(b, c, a), x) : Nat}:
  Equal.trans(Nat, sum3(Nat.mul(x, a), Nat.mul(x, b), Nat.mul(x, c)), sum3(Nat.mul(a, x), Nat.mul(b, x), Nat.mul(c, x)), Nat.mul(sum3(b, c, a), x), GP.sum3_cong(Nat.mul(x, a), Nat.mul(x, b), Nat.mul(x, c), Nat.mul(a, x), Nat.mul(b, x), Nat.mul(c, x), F.mul_comm(x, a), F.mul_comm(x, b), F.mul_comm(x, c)), Equal.trans(Nat, sum3(Nat.mul(a, x), Nat.mul(b, x), Nat.mul(c, x)), Nat.mul(sum3(a, b, c), x), Nat.mul(sum3(b, c, a), x), GP.sum3_scale(a, b, c, x), Equal.cong(Nat, Nat, n => Nat.mul(n, x), sum3(a, b, c), sum3(b, c, a), QP.rotate_sum(a, b, c))))

def area_positive_cycle_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat, +x: Nat, +y: Nat, +d: Nat) -> {M.positive_total(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d}) == Nat.add(Nat.mul(M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), M.common(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d})) : Nat}:
  Equal.trans(Nat, M.positive_total(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d}), sum3(sum3(Nat.mul(Nat.mul(bx, cy), d), Nat.mul(Nat.mul(cx, ay), d), Nat.mul(Nat.mul(ax, by), d)), sum3(Nat.mul(cx, y), Nat.mul(ax, y), Nat.mul(bx, y)), sum3(Nat.mul(x, by), Nat.mul(x, cy), Nat.mul(x, ay))), Nat.add(Nat.mul(M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), M.common(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d})), transpose3(Nat.mul(Nat.mul(bx, cy), d), Nat.mul(cx, y), Nat.mul(x, by), Nat.mul(Nat.mul(cx, ay), d), Nat.mul(ax, y), Nat.mul(x, cy), Nat.mul(Nat.mul(ax, by), d), Nat.mul(bx, y), Nat.mul(x, ay)), Equal.trans(Nat, sum3(sum3(Nat.mul(Nat.mul(bx, cy), d), Nat.mul(Nat.mul(cx, ay), d), Nat.mul(Nat.mul(ax, by), d)), sum3(Nat.mul(cx, y), Nat.mul(ax, y), Nat.mul(bx, y)), sum3(Nat.mul(x, by), Nat.mul(x, cy), Nat.mul(x, ay))), sum3(Nat.mul(M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cx, ax, bx), y), Nat.mul(sum3(cy, ay, by), x)), Nat.add(Nat.mul(M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), M.common(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d})), GP.sum3_cong(sum3(Nat.mul(Nat.mul(bx, cy), d), Nat.mul(Nat.mul(cx, ay), d), Nat.mul(Nat.mul(ax, by), d)), sum3(Nat.mul(cx, y), Nat.mul(ax, y), Nat.mul(bx, y)), sum3(Nat.mul(x, by), Nat.mul(x, cy), Nat.mul(x, ay)), Nat.mul(M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cx, ax, bx), y), Nat.mul(sum3(cy, ay, by), x), Equal.trans(Nat, sum3(Nat.mul(Nat.mul(bx, cy), d), Nat.mul(Nat.mul(cx, ay), d), Nat.mul(Nat.mul(ax, by), d)), Nat.mul(sum3(Nat.mul(bx, cy), Nat.mul(cx, ay), Nat.mul(ax, by)), d), Nat.mul(M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), GP.sum3_scale(Nat.mul(bx, cy), Nat.mul(cx, ay), Nat.mul(ax, by), d), Equal.cong(Nat, Nat, n => Nat.mul(n, d), sum3(Nat.mul(bx, cy), Nat.mul(cx, ay), Nat.mul(ax, by)), M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), coeff_triangle(Nat.mul(ax, by), Nat.mul(bx, cy), Nat.mul(cx, ay)))), GP.sum3_scale(cx, ax, bx, y), column_rotate(by, cy, ay, x)), F.add_assoc(Nat.mul(M.positive(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cx, ax, bx), y), Nat.mul(sum3(cy, ay, by), x))))
def L.positive_area_cycle(a, b, c, p):
  match a b c p:
    case N.P{ax, ay} N.P{bx, by} N.P{cx, cy} G.P{x, y, d}: area_positive_cycle_fields(ax, ay, bx, by, cx, cy, x, y, d)

def area_negative_cycle_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat, +x: Nat, +y: Nat, +d: Nat) -> {M.negative_total(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d}) == Nat.add(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), M.common(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d})) : Nat}:
  Equal.trans(Nat, M.negative_total(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d}), sum3(sum3(Nat.mul(Nat.mul(by, cx), d), Nat.mul(Nat.mul(cy, ax), d), Nat.mul(Nat.mul(ay, bx), d)), sum3(Nat.mul(cy, x), Nat.mul(ay, x), Nat.mul(by, x)), sum3(Nat.mul(y, bx), Nat.mul(y, cx), Nat.mul(y, ax))), Nat.add(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), M.common(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d})), transpose3(Nat.mul(Nat.mul(by, cx), d), Nat.mul(cy, x), Nat.mul(y, bx), Nat.mul(Nat.mul(cy, ax), d), Nat.mul(ay, x), Nat.mul(y, cx), Nat.mul(Nat.mul(ay, bx), d), Nat.mul(by, x), Nat.mul(y, ax)), Equal.trans(Nat, sum3(sum3(Nat.mul(Nat.mul(by, cx), d), Nat.mul(Nat.mul(cy, ax), d), Nat.mul(Nat.mul(ay, bx), d)), sum3(Nat.mul(cy, x), Nat.mul(ay, x), Nat.mul(by, x)), sum3(Nat.mul(y, bx), Nat.mul(y, cx), Nat.mul(y, ax))), sum3(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cy, ay, by), x), Nat.mul(sum3(cx, ax, bx), y)), Nat.add(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), M.common(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d})), GP.sum3_cong(sum3(Nat.mul(Nat.mul(by, cx), d), Nat.mul(Nat.mul(cy, ax), d), Nat.mul(Nat.mul(ay, bx), d)), sum3(Nat.mul(cy, x), Nat.mul(ay, x), Nat.mul(by, x)), sum3(Nat.mul(y, bx), Nat.mul(y, cx), Nat.mul(y, ax)), Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cy, ay, by), x), Nat.mul(sum3(cx, ax, bx), y), Equal.trans(Nat, sum3(Nat.mul(Nat.mul(by, cx), d), Nat.mul(Nat.mul(cy, ax), d), Nat.mul(Nat.mul(ay, bx), d)), Nat.mul(sum3(Nat.mul(by, cx), Nat.mul(cy, ax), Nat.mul(ay, bx)), d), Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), GP.sum3_scale(Nat.mul(by, cx), Nat.mul(cy, ax), Nat.mul(ay, bx), d), Equal.cong(Nat, Nat, n => Nat.mul(n, d), sum3(Nat.mul(by, cx), Nat.mul(cy, ax), Nat.mul(ay, bx)), M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), coeff_triangle(Nat.mul(ay, bx), Nat.mul(by, cx), Nat.mul(cy, ax)))), GP.sum3_scale(cy, ay, by, x), column_rotate(bx, cx, ax, y)), Equal.trans(Nat, sum3(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cy, ay, by), x), Nat.mul(sum3(cx, ax, bx), y)), sum3(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cx, ax, bx), y), Nat.mul(sum3(cy, ay, by), x)), Nat.add(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), M.common(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, G.P{x, y, d})), F.add_right_comm(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cy, ay, by), x), Nat.mul(sum3(cx, ax, bx), y)), F.add_assoc(Nat.mul(M.negative(N.P{ax, ay}, N.P{bx, by}, Q.embed(N.P{cx, cy})), d), Nat.mul(sum3(cx, ax, bx), y), Nat.mul(sum3(cy, ay, by), x)))))
def L.negative_area_cycle(a, b, c, p):
  match a b c p:
    case N.P{ax, ay} N.P{bx, by} N.P{cx, cy} G.P{x, y, d}: area_negative_cycle_fields(ax, ay, bx, by, cx, cy, x, y, d)
def area_sum_reconstruct(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point, hs: {Region.edge(a, b, p) == True{} : Bool} & ({Region.edge(b, c, p) == True{} : Bool} & {Region.edge(c, a, p) == True{} : Bool})) -> {Nat.add(M.weights_total(a, b, c, p), M.negative_total(a, b, c, p)) == M.positive_total(a, b, c, p) : Nat}:
  match hs:
    case (hab, (hbc, hca)):
      Equal.trans(Nat, Nat.add(M.weights_total(a, b, c, p), M.negative_total(a, b, c, p)), sum3(Nat.add(M.area(b, c, p), M.negative(b, c, p)), Nat.add(M.area(c, a, p), M.negative(c, a, p)), Nat.add(M.area(a, b, p), M.negative(a, b, p))), M.positive_total(a, b, c, p), Equal.sym(Nat, sum3(Nat.add(M.area(b, c, p), M.negative(b, c, p)), Nat.add(M.area(c, a, p), M.negative(c, a, p)), Nat.add(M.area(a, b, p), M.negative(a, b, p))), Nat.add(M.weights_total(a, b, c, p), M.negative_total(a, b, c, p)), CP.regroup3(M.area(b, c, p), M.area(c, a, p), M.area(a, b, p), M.negative(b, c, p), M.negative(c, a, p), M.negative(a, b, p))), GP.sum3_cong(Nat.add(M.area(b, c, p), M.negative(b, c, p)), Nat.add(M.area(c, a, p), M.negative(c, a, p)), Nat.add(M.area(a, b, p), M.negative(a, b, p)), M.positive(b, c, p), M.positive(c, a, p), M.positive(a, b, p), L.area_reconstruct(b, c, p, hbc), L.area_reconstruct(c, a, p, hca), L.area_reconstruct(a, b, p, hab)))
def area_product(+area: Nat, +nc: Nat, +pc: Nat, +d: Nat, ha: {Nat.add(area, nc) == pc : Nat}) -> {Nat.add(Nat.mul(area, d), Nat.mul(nc, d)) == Nat.mul(pc, d) : Nat}:
  Equal.trans(Nat, Nat.add(Nat.mul(area, d), Nat.mul(nc, d)), Nat.mul(Nat.add(area, nc), d), Nat.mul(pc, d), Equal.sym(Nat, Nat.mul(Nat.add(area, nc), d), Nat.add(Nat.mul(area, d), Nat.mul(nc, d)), F.add_mul(area, nc, d)), Equal.cong(Nat, Nat, n => Nat.mul(n, d), Nat.add(area, nc), pc, ha))
def area_cancel_common(+w: Nat, +pc: Nat, +nc: Nat, +common: Nat, +d: Nat, hs: {Nat.add(w, Nat.add(Nat.mul(nc, d), common)) == Nat.add(Nat.mul(pc, d), common) : Nat}) -> {Nat.add(w, Nat.mul(nc, d)) == Nat.mul(pc, d) : Nat}:
  Cancel.cancel_right(Nat.add(w, Nat.mul(nc, d)), common, Nat.mul(pc, d), Equal.trans(Nat, Nat.add(Nat.add(w, Nat.mul(nc, d)), common), Nat.add(w, Nat.add(Nat.mul(nc, d), common)), Nat.add(Nat.mul(pc, d), common), F.add_assoc(w, Nat.mul(nc, d), common), hs))
def area_cancel_weights(+w: Nat, +pc: Nat, +nc: Nat, +common: Nat, +area: Nat, +d: Nat, hs: {Nat.add(w, Nat.add(Nat.mul(nc, d), common)) == Nat.add(Nat.mul(pc, d), common) : Nat}, ha: {Nat.add(area, nc) == pc : Nat}) -> {w == Nat.mul(d, area) : Nat}:
  Equal.trans(Nat, w, Nat.mul(area, d), Nat.mul(d, area), Cancel.cancel_right(w, Nat.mul(nc, d), Nat.mul(area, d), Equal.trans(Nat, Nat.add(w, Nat.mul(nc, d)), Nat.mul(pc, d), Nat.add(Nat.mul(area, d), Nat.mul(nc, d)), area_cancel_common(w, pc, nc, common, d, hs), Equal.sym(Nat, Nat.add(Nat.mul(area, d), Nat.mul(nc, d)), Nat.mul(pc, d), area_product(area, nc, pc, d, ha)))), F.mul_comm(area, d))
def area_cycle_recover(+a: N.Point, +b: N.Point, +c: N.Point, +p: G.Point, h: {D.triangle(a, b, c, p) == True{} : Bool}) -> {Nat.add(M.weights_total(a, b, c, p), Nat.add(Nat.mul(M.negative(a, b, Q.embed(c)), C.denominator(p)), M.common(a, b, c, p))) == Nat.add(Nat.mul(M.positive(a, b, Q.embed(c)), C.denominator(p)), M.common(a, b, c, p)) : Nat}:
  %L.negative_area_cycle(a, b, c, p) : {Nat.add(M.weights_total(a, b, c, p), _) == Nat.add(Nat.mul(M.positive(a, b, Q.embed(c)), C.denominator(p)), M.common(a, b, c, p)) : Nat}
  %L.positive_area_cycle(a, b, c, p) : {Nat.add(M.weights_total(a, b, c, p), M.negative_total(a, b, c, p)) == _ : Nat}
  area_sum_reconstruct(a, b, c, p, Fields.three_fields(Region.edge(a, b, p), Region.edge(b, c, p), Region.edge(c, a, p), h))
def L.triangle_weights_total(a, b, c, p, ht, h):
  area_cancel_weights(M.weights_total(a, b, c, p), M.positive(a, b, Q.embed(c)), M.negative(a, b, Q.embed(c)), M.common(a, b, c, p), M.triangle_area(a, b, c), C.denominator(p), area_cycle_recover(a, b, c, p, h), L.area_reconstruct(a, b, Q.embed(c), QP.edge_turn(a, b, c, ht)))
def area_positive_product(+a: Nat, +b: Nat, ha: {Nat.is_gt(a, 0n) == True{} : Bool}, hb: {Nat.is_gt(b, 0n) == True{} : Bool}) -> {Nat.is_gt(Nat.mul(a, b), 0n) == True{} : Bool}:
  match a b:
    case 0n _: B.absurd({Nat.is_gt(Nat.mul(0n, b), 0n) == True{} : Bool}, B.false_impossible(ha))
    case 1n+p 0n: B.absurd({Nat.is_gt(Nat.mul(1n+p, 0n), 0n) == True{} : Bool}, B.false_impossible(hb))
    case 1n+p 1n+q: {==}
def area_denominator_equation(+p: G.Point) -> {G.positive_denominator(p) == Nat.is_gt(C.denominator(p), 0n) : Bool}:
  match p:
    case G.P{x, y, d}: {==}
def L.triangle_weights_positive(a, b, c, p, ht, h, hp):
  Equal.trans(Bool, Nat.is_gt(M.weights_total(a, b, c, p), 0n), Nat.is_gt(Nat.mul(C.denominator(p), M.triangle_area(a, b, c)), 0n), True{}, Equal.cong(Nat, Bool, n => Nat.is_gt(n, 0n), M.weights_total(a, b, c, p), Nat.mul(C.denominator(p), M.triangle_area(a, b, c)), L.triangle_weights_total(a, b, c, p, ht, h)), area_positive_product(C.denominator(p), M.triangle_area(a, b, c), Equal.trans(Bool, Nat.is_gt(C.denominator(p), 0n), G.positive_denominator(p), True{}, Equal.sym(Bool, G.positive_denominator(p), Nat.is_gt(C.denominator(p), 0n), area_denominator_equation(p)), hp), L.triangle_area_positive(a, b, c, ht)))
