import Base
import ./quad-barycentric.bend as M
import ./quad-barycentric-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-geometry-proof.bend as GP
import ./quad-hull.bend as H
import ./quad-hull-laws.bend as HL
import ./quad-hull-proof.bend as HP
import ./quad-geometry.bend as Q
import ./quad-geometry-laws.bend as QL
import ./quad-geometry-proof.bend as QP
import ./quad-diagonal.bend as D
import ./quad-diagonal-laws.bend as DL
import ./quad-diagonal-proof.bend as DP
import ./triangle-area.bend as A
import ./triangle-area-laws.bend as AL
import ./triangle-area-proof.bend as AP
import ./triangle-coordinate.bend as C
import ./triangle-coordinate-laws.bend as CL
import ./triangle-coordinate-proof.bend as CP
import ./halfplane-region.bend as Region
import ./halfplane-region-laws.bend as RL
import ./halfplane-region-proof.bend as RP
import ./sat-arithmetic.bend as Sat
import ./sat-arithmetic-laws.bend as SL
import ./sat-arithmetic-proof.bend as SP
import ./boolean-reflection.bend as B
import ./source-cells-proof.bend as Fields
import ./facts.bend as F
import ./topology.bend as T
import ./search-witness.bend as Search

# A zero-weight unused corner disappears by checked Nat equalities.
def bary_zero_tail(+a: Nat, +b: Nat) -> {Nat.add(a, Nat.mul(b, 0n)) == a : Nat}:
  Equal.trans(Nat, Nat.add(a, Nat.mul(b, 0n)), Nat.add(a, 0n), a, Equal.cong(Nat, Nat, n => Nat.add(a, n), Nat.mul(b, 0n), 0n, F.mul_zero(b)), F.add_zero(a))
def bary_abc_coordinate(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +k: Nat, +l: Nat, +m: Nat) -> {HL.coordinate(a, b, c, d, k, l, m, 0n) == Nat.add(Nat.add(Nat.mul(a, k), Nat.mul(b, l)), Nat.mul(c, m)) : Nat}:
  Equal.cong(Nat, Nat, n => Nat.add(Nat.add(Nat.mul(a, k), Nat.mul(b, l)), n), Nat.add(Nat.mul(c, m), Nat.mul(d, 0n)), Nat.mul(c, m), bary_zero_tail(Nat.mul(c, m), d))
def bary_acd_coordinate(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +k: Nat, +l: Nat, +m: Nat) -> {HL.coordinate(a, b, c, d, k, 0n, l, m) == Nat.add(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.mul(d, m)) : Nat}:
  Equal.trans(Nat, HL.coordinate(a, b, c, d, k, 0n, l, m), Nat.add(Nat.mul(a, k), Nat.add(Nat.mul(c, l), Nat.mul(d, m))), Nat.add(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.mul(d, m)), Equal.cong(Nat, Nat, n => Nat.add(n, Nat.add(Nat.mul(c, l), Nat.mul(d, m))), Nat.add(Nat.mul(a, k), Nat.mul(b, 0n)), Nat.mul(a, k), bary_zero_tail(Nat.mul(a, k), b)), Equal.sym(Nat, Nat.add(Nat.add(Nat.mul(a, k), Nat.mul(c, l)), Nat.mul(d, m)), Nat.add(Nat.mul(a, k), Nat.add(Nat.mul(c, l), Nat.mul(d, m))), F.add_assoc(Nat.mul(a, k), Nat.mul(c, l), Nat.mul(d, m))))
def bary_abc_total(+k: Nat, +l: Nat, +m: Nat) -> {H.weight_total(k, l, m, 0n) == Nat.add(Nat.add(k, l), m) : Nat}:
  Equal.cong(Nat, Nat, n => Nat.add(Nat.add(k, l), n), Nat.add(m, 0n), m, F.add_zero(m))
def bary_acd_total(+k: Nat, +l: Nat, +m: Nat) -> {H.weight_total(k, 0n, l, m) == Nat.add(Nat.add(k, l), m) : Nat}:
  Equal.trans(Nat, H.weight_total(k, 0n, l, m), Nat.add(k, Nat.add(l, m)), Nat.add(Nat.add(k, l), m), Equal.cong(Nat, Nat, n => Nat.add(n, Nat.add(l, m)), Nat.add(k, 0n), k, F.add_zero(k)), Equal.sym(Nat, Nat.add(Nat.add(k, l), m), Nat.add(k, Nat.add(l, m)), F.add_assoc(k, l, m)))

def bary_abc_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat, +dx: Nat, +dy: Nat, +p: G.Point) -> {M.point(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, M.abc(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, p)) == C.reconstruct(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, p) : G.Point}:
  Equal.trans(G.Point, M.point(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, M.abc(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, p)), HL.point(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p), 0n), C.reconstruct(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, p), HL.weighted_quad_point_exact(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p), 0n), GP.point_equal(HL.coordinate(ax, bx, cx, dx, A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p), 0n), HL.coordinate(ay, by, cy, dy, A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p), 0n), H.weight_total(A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p), 0n), C.weighted(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, p, False{}), C.weighted(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, p, True{}), A.weights_total(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, p), bary_abc_coordinate(ax, bx, cx, dx, A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p)), bary_abc_coordinate(ay, by, cy, dy, A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p)), bary_abc_total(A.area(N.P{bx, by}, N.P{cx, cy}, p), A.area(N.P{cx, cy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{bx, by}, p))))
def L.abc_point_reconstruction(a, b, c, d, p):
  match a b c d:
    case N.P{ax, ay} N.P{bx, by} N.P{cx, cy} N.P{dx, dy}: bary_abc_fields(ax, ay, bx, by, cx, cy, dx, dy, p)

def bary_acd_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat, +dx: Nat, +dy: Nat, +p: G.Point) -> {M.point(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, M.acd(N.P{ax, ay}, N.P{cx, cy}, N.P{dx, dy}, p)) == C.reconstruct(N.P{ax, ay}, N.P{cx, cy}, N.P{dx, dy}, p) : G.Point}:
  Equal.trans(G.Point, M.point(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, M.acd(N.P{ax, ay}, N.P{cx, cy}, N.P{dx, dy}, p)), HL.point(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, A.area(N.P{cx, cy}, N.P{dx, dy}, p), 0n, A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p)), C.reconstruct(N.P{ax, ay}, N.P{cx, cy}, N.P{dx, dy}, p), HL.weighted_quad_point_exact(N.Q{N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}, N.P{dx, dy}}, A.area(N.P{cx, cy}, N.P{dx, dy}, p), 0n, A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p)), GP.point_equal(HL.coordinate(ax, bx, cx, dx, A.area(N.P{cx, cy}, N.P{dx, dy}, p), 0n, A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p)), HL.coordinate(ay, by, cy, dy, A.area(N.P{cx, cy}, N.P{dx, dy}, p), 0n, A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p)), H.weight_total(A.area(N.P{cx, cy}, N.P{dx, dy}, p), 0n, A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p)), C.weighted(N.P{ax, ay}, N.P{cx, cy}, N.P{dx, dy}, p, False{}), C.weighted(N.P{ax, ay}, N.P{cx, cy}, N.P{dx, dy}, p, True{}), A.weights_total(N.P{ax, ay}, N.P{cx, cy}, N.P{dx, dy}, p), bary_acd_coordinate(ax, bx, cx, dx, A.area(N.P{cx, cy}, N.P{dx, dy}, p), A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p)), bary_acd_coordinate(ay, by, cy, dy, A.area(N.P{cx, cy}, N.P{dx, dy}, p), A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p)), bary_acd_total(A.area(N.P{cx, cy}, N.P{dx, dy}, p), A.area(N.P{dx, dy}, N.P{ax, ay}, p), A.area(N.P{ax, ay}, N.P{cx, cy}, p))))
def L.acd_point_reconstruction(a, b, c, d, p):
  match a b c d:
    case N.P{ax, ay} N.P{bx, by} N.P{cx, cy} N.P{dx, dy}: bary_acd_fields(ax, ay, bx, by, cx, cy, dx, dy, p)

def bary_equiv_projection(+p: G.Point, +r: G.Point, hs: {G.positive_denominator(r) == True{} : Bool} & {G.equivalent(p, r) == True{} : Bool}) -> {G.equivalent(p, r) == True{} : Bool}:
  match hs:
    case (positive, equivalent): equivalent
def bary_abc_valid(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +p: G.Point, +ht: {Q.turn(a, b, c) == True{} : Bool}, +h: {D.triangle(a, b, c, p) == True{} : Bool}, +hp: {G.positive_denominator(p) == True{} : Bool}) -> {Nat.is_gt(M.total(M.abc(a, b, c, p)), 0n) == True{} : Bool} & {G.equivalent(p, M.point(N.Q{a, b, c, d}, M.abc(a, b, c, p))) == True{} : Bool}:
  (Equal.trans(Bool, Nat.is_gt(M.total(M.abc(a, b, c, p)), 0n), Nat.is_gt(A.weights_total(a, b, c, p), 0n), True{}, Equal.cong(Nat, Bool, n => Nat.is_gt(n, 0n), M.total(M.abc(a, b, c, p)), A.weights_total(a, b, c, p), bary_abc_total(A.area(b, c, p), A.area(c, a, p), A.area(a, b, p))), AL.triangle_weights_positive(a, b, c, p, ht, h, hp)), Equal.trans(Bool, G.equivalent(p, M.point(N.Q{a, b, c, d}, M.abc(a, b, c, p))), G.equivalent(p, C.reconstruct(a, b, c, p)), True{}, Equal.cong(G.Point, Bool, r => G.equivalent(p, r), M.point(N.Q{a, b, c, d}, M.abc(a, b, c, p)), C.reconstruct(a, b, c, p), L.abc_point_reconstruction(a, b, c, d, p)), bary_equiv_projection(p, C.reconstruct(a, b, c, p), CL.reconstructed_point_valid(a, b, c, p, ht, h, hp))))
def bary_acd_valid(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +p: G.Point, +ht: {Q.turn(a, c, d) == True{} : Bool}, +h: {D.triangle(a, c, d, p) == True{} : Bool}, +hp: {G.positive_denominator(p) == True{} : Bool}) -> {Nat.is_gt(M.total(M.acd(a, c, d, p)), 0n) == True{} : Bool} & {G.equivalent(p, M.point(N.Q{a, b, c, d}, M.acd(a, c, d, p))) == True{} : Bool}:
  (Equal.trans(Bool, Nat.is_gt(M.total(M.acd(a, c, d, p)), 0n), Nat.is_gt(A.weights_total(a, c, d, p), 0n), True{}, Equal.cong(Nat, Bool, n => Nat.is_gt(n, 0n), M.total(M.acd(a, c, d, p)), A.weights_total(a, c, d, p), bary_acd_total(A.area(c, d, p), A.area(d, a, p), A.area(a, c, p))), AL.triangle_weights_positive(a, c, d, p, ht, h, hp)), Equal.trans(Bool, G.equivalent(p, M.point(N.Q{a, b, c, d}, M.acd(a, c, d, p))), G.equivalent(p, C.reconstruct(a, c, d, p)), True{}, Equal.cong(G.Point, Bool, r => G.equivalent(p, r), M.point(N.Q{a, b, c, d}, M.acd(a, c, d, p)), C.reconstruct(a, c, d, p), L.acd_point_reconstruction(a, b, c, d, p)), bary_equiv_projection(p, C.reconstruct(a, c, d, p), CL.reconstructed_point_valid(a, c, d, p, ht, h, hp))))
def bary_selected_abc(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +p: G.Point, h: {D.diagonal_acd(N.Q{a, b, c, d}, p) == False{} : Bool}) -> {M.selected(N.Q{a, b, c, d}, p) == M.abc(a, b, c, p) : M.Weights}:
  Equal.cong(Bool, M.Weights, t => M.choose(N.Q{a, b, c, d}, p, t), D.diagonal_acd(N.Q{a, b, c, d}, p), False{}, h)
def bary_selected_acd(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +p: G.Point, h: {D.diagonal_acd(N.Q{a, b, c, d}, p) == True{} : Bool}) -> {M.selected(N.Q{a, b, c, d}, p) == M.acd(a, c, d, p) : M.Weights}:
  Equal.cong(Bool, M.Weights, t => M.choose(N.Q{a, b, c, d}, p, t), D.diagonal_acd(N.Q{a, b, c, d}, p), True{}, h)
def bary_valid_transport(+q: N.Quad, +p: G.Point, +u: M.Weights, +v: M.Weights, +heq: {u == v : M.Weights}, hs: {Nat.is_gt(M.total(v), 0n) == True{} : Bool} & {G.equivalent(p, M.point(q, v)) == True{} : Bool}) -> {Nat.is_gt(M.total(u), 0n) == True{} : Bool} & {G.equivalent(p, M.point(q, u)) == True{} : Bool}:
  match hs:
    case (positive, equivalent):
      (Equal.trans(Bool, Nat.is_gt(M.total(u), 0n), Nat.is_gt(M.total(v), 0n), True{}, Equal.cong(M.Weights, Bool, w => Nat.is_gt(M.total(w), 0n), u, v, heq), positive), Equal.trans(Bool, G.equivalent(p, M.point(q, u)), G.equivalent(p, M.point(q, v)), True{}, Equal.cong(M.Weights, Bool, w => G.equivalent(p, M.point(q, w)), u, v, heq), equivalent))
def bary_split_valid(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +p: G.Point, +hp: {G.positive_denominator(p) == True{} : Bool}, strict: {Q.turn(a, b, c) == True{} : Bool} & {Q.turn(a, c, d) == True{} : Bool}, split: D.Split<N.Q{a, b, c, d}, p>) -> {Nat.is_gt(M.total(M.selected(N.Q{a, b, c, d}, p)), 0n) == True{} : Bool} & {G.equivalent(p, M.point(N.Q{a, b, c, d}, M.selected(N.Q{a, b, c, d}, p))) == True{} : Bool}:
  match strict split:
    case (habc, hacd) D.ABC{decision, inside}:
      bary_valid_transport(N.Q{a, b, c, d}, p, M.selected(N.Q{a, b, c, d}, p), M.abc(a, b, c, p), bary_selected_abc(a, b, c, d, p, decision), bary_abc_valid(a, b, c, d, p, habc, inside, hp))
    case (habc, hacd) D.ACD{decision, inside}:
      bary_valid_transport(N.Q{a, b, c, d}, p, M.selected(N.Q{a, b, c, d}, p), M.acd(a, c, d, p), bary_selected_acd(a, b, c, d, p, decision), bary_acd_valid(a, b, c, d, p, hacd, inside, hp))
def L.selected_weights_valid(q, p, hq, hp, h):
  match q:
    case N.Q{+a, +b, +c, +d}: bary_split_valid(a, b, c, d, p, hp, B.and_split(Q.turn(a, b, c), Q.turn(a, c, d), DL.strict_diagonal_triangles(N.Q{a, b, c, d}, hq)), DL.region_diagonal_split(N.Q{a, b, c, d}, p, h))
def bary_membership_fields(+q: N.Quad, +p: G.Point, +k: Nat, +l: Nat, +m: Nat, +n: Nat, hp: {G.positive_denominator(p) == True{} : Bool}, hs: {Nat.is_gt(H.weight_total(k, l, m, n), 0n) == True{} : Bool} & {G.equivalent(p, H.weighted(q, k, l, m, n)) == True{} : Bool}) -> H.InHull(q, p):
  match hs:
    case (positive, equivalent): (k, (l, (m, (n, (positive, (hp, equivalent))))))
def bary_membership(+q: N.Quad, +p: G.Point, +w: M.Weights, hp: {G.positive_denominator(p) == True{} : Bool}, hs: {Nat.is_gt(M.total(w), 0n) == True{} : Bool} & {G.equivalent(p, M.point(q, w)) == True{} : Bool}) -> H.InHull(q, p):
  match w:
    case M.W{k, l, m, n}: bary_membership_fields(q, p, k, l, m, n, hp, hs)
def L.region_point_in_hull(q, p, hq, hp, h):
  bary_membership(q, p, M.selected(q, p), hp, L.selected_weights_valid(q, p, hq, hp, h))
def L.region_hull_characterization(q, p, hq, hp):
  (inside => L.region_point_in_hull(q, p, hq, hp, inside), member => HL.hull_point_inside(q, p, QL.strict_quad_corners_inside(q, hq), member))
def bary_native_strict(+width: Nat, +hw: {width == 12n : Nat}, +q: T.Quad, hq: {Search.quad_envelope(width, q) == True{} : Bool}, h: {T.strictly_convex(q) == True{} : Bool}) -> {Q.strict_quad(N.decode_quad(q)) == True{} : Bool}:
  Equal.trans(Bool, Q.strict_quad(N.decode_quad(q)), Sat.strictly_convex(q), True{}, Equal.sym(Bool, Sat.strictly_convex(q), Q.strict_quad(N.decode_quad(q)), QL.strict_quad_decoded(q)), Equal.trans(Bool, Sat.strictly_convex(q), T.strictly_convex(q), True{}, Equal.sym(Bool, T.strictly_convex(q), Sat.strictly_convex(q), SL.strictly_convex_arithmetic_exact(width, hw, q, hq)), h))
def L.production_region_point_in_hull(width, hw, q, w, hq, henv, hstrict, hp, h):
  L.region_point_in_hull(N.decode_quad(q), Region.decode_witness(w), bary_native_strict(width, hw, q, hq, hstrict), hp, Equal.trans(Bool, Region.contains(Region.decode_witness(w), N.decode_quad(q)), T.inside(w, q), True{}, Equal.sym(Bool, T.inside(w, q), Region.contains(Region.decode_witness(w), N.decode_quad(q)), RL.production_inside_halfplanes(width, hw, w, q, hq, henv)), h))

def bary_three_hulls(+a: N.Quad, +b: N.Quad, +c: N.Quad, +p: G.Point, ha: {Q.strict_quad(a) == True{} : Bool}, hb: {Q.strict_quad(b) == True{} : Bool}, hc: {Q.strict_quad(c) == True{} : Bool}, +hp: {G.positive_denominator(p) == True{} : Bool}, hs: {Region.contains(p, a) == True{} : Bool} & ({Region.contains(p, b) == True{} : Bool} & {Region.contains(p, c) == True{} : Bool})) -> M.CommonHull(a, b, c):
  match hs:
    case (hpa, (hpb, hpc)): (p, (L.region_point_in_hull(a, p, ha, hp, hpa), (L.region_point_in_hull(b, p, hb, hp, hpb), L.region_point_in_hull(c, p, hc, hp, hpc))))
def L.common_region_in_hulls(a, b, c, ha, hb, hc, common):
  match common:
    case (+p, (hp, hs)): bary_three_hulls(a, b, c, p, ha, hb, hc, hp, Fields.three_fields(Region.contains(p, a), Region.contains(p, b), Region.contains(p, c), hs))
def L.production_triangle_hull_witness(width, hw, a, b, c, ha, hb, hc, hsa, hsb, hsc, accepted):
  L.common_region_in_hulls(N.decode_quad(a), N.decode_quad(b), N.decode_quad(c), bary_native_strict(width, hw, a, ha, hsa), bary_native_strict(width, hw, b, hb, hsb), bary_native_strict(width, hw, c, hc, hsc), RL.triangle_halfplane_witness(width, hw, a, b, c, ha, hb, hc, accepted))
