import Base
import ./quad-geometry.bend as M
import ./quad-geometry-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous-combination-proof.bend as CP
import ./coordinate-sum.bend as Sum
import ./facts.bend as F
import ./boolean-reflection.bend as B
import ./sat-arithmetic.bend as Sat
import ./sat-arithmetic-laws.bend as SL
import ./sat-arithmetic-proof.bend as SP
import ./topology.bend as T

def vertex_polynomial(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat) -> {G.side(ax, ay, bx, by, G.P{cx, cy, 1n}) == Nat.cmp(Sum.exact(ax, by, bx, cy, cx, ay), Sum.exact(ay, bx, by, cx, cy, ax)) : Cmp}:
  %Equal.sym(Nat, Nat.mul(Nat.mul(ax, by), 1n), Nat.mul(ax, by), F.mul_one(Nat.mul(ax, by))) : {Nat.cmp(Nat.add(Nat.add(_, Nat.mul(bx, cy)), Nat.mul(cx, ay)), Nat.add(Nat.add(Nat.mul(Nat.mul(ay, bx), 1n), Nat.mul(by, cx)), Nat.mul(cy, ax))) == Nat.cmp(Sum.exact(ax, by, bx, cy, cx, ay), Sum.exact(ay, bx, by, cx, cy, ax)) : Cmp}
  %Equal.sym(Nat, Nat.mul(Nat.mul(ay, bx), 1n), Nat.mul(ay, bx), F.mul_one(Nat.mul(ay, bx))) : {Nat.cmp(Sum.exact(ax, by, bx, cy, cx, ay), Nat.add(Nat.add(_, Nat.mul(by, cx)), Nat.mul(cy, ax))) == Nat.cmp(Sum.exact(ax, by, bx, cy, cx, ay), Sum.exact(ay, bx, by, cx, cy, ax)) : Cmp}
  {==}
def rotate_sum(+a: Nat, +b: Nat, +c: Nat) -> {Nat.add(Nat.add(a, b), c) == Nat.add(Nat.add(b, c), a) : Nat}:
  Equal.trans(Nat, Nat.add(Nat.add(a, b), c), Nat.add(a, Nat.add(b, c)), Nat.add(Nat.add(b, c), a), F.add_assoc(a, b, c), F.add_comm(a, Nat.add(b, c)))
def cyclic_products(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat) -> {Nat.cmp(Sum.exact(ax, by, bx, cy, cx, ay), Sum.exact(ay, bx, by, cx, cy, ax)) == Nat.cmp(Sum.exact(bx, cy, cx, ay, ax, by), Sum.exact(by, cx, cy, ax, ay, bx)) : Cmp}:
  %Equal.sym(Nat, Sum.exact(ax, by, bx, cy, cx, ay), Sum.exact(bx, cy, cx, ay, ax, by), rotate_sum(Nat.mul(ax, by), Nat.mul(bx, cy), Nat.mul(cx, ay))) : {Nat.cmp(_, Sum.exact(ay, bx, by, cx, cy, ax)) == Nat.cmp(Sum.exact(bx, cy, cx, ay, ax, by), Sum.exact(by, cx, cy, ax, ay, bx)) : Cmp}
  %Equal.sym(Nat, Sum.exact(ay, bx, by, cx, cy, ax), Sum.exact(by, cx, cy, ax, ay, bx), rotate_sum(Nat.mul(ay, bx), Nat.mul(by, cx), Nat.mul(cy, ax))) : {Nat.cmp(Sum.exact(bx, cy, cx, ay, ax, by), _) == Nat.cmp(Sum.exact(bx, cy, cx, ay, ax, by), Sum.exact(by, cx, cy, ax, ay, bx)) : Cmp}
  {==}
def cyclic_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +cx: Nat, +cy: Nat) -> {M.side(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}) == M.side(N.P{bx, by}, N.P{cx, cy}, N.P{ax, ay}) : Cmp}:
  Equal.trans(Cmp, M.side(N.P{ax, ay}, N.P{bx, by}, N.P{cx, cy}), Nat.cmp(Sum.exact(ax, by, bx, cy, cx, ay), Sum.exact(ay, bx, by, cx, cy, ax)), M.side(N.P{bx, by}, N.P{cx, cy}, N.P{ax, ay}), vertex_polynomial(ax, ay, bx, by, cx, cy), Equal.trans(Cmp, Nat.cmp(Sum.exact(ax, by, bx, cy, cx, ay), Sum.exact(ay, bx, by, cx, cy, ax)), Nat.cmp(Sum.exact(bx, cy, cx, ay, ax, by), Sum.exact(by, cx, cy, ax, ay, bx)), M.side(N.P{bx, by}, N.P{cx, cy}, N.P{ax, ay}), cyclic_products(ax, ay, bx, by, cx, cy), Equal.sym(Cmp, M.side(N.P{bx, by}, N.P{cx, cy}, N.P{ax, ay}), Nat.cmp(Sum.exact(bx, cy, cx, ay, ax, by), Sum.exact(by, cx, cy, ax, ay, bx)), vertex_polynomial(bx, by, cx, cy, ax, ay))))
def L.triangle_cyclic_side(a, b, c):
  match a b c:
    case N.P{ax, ay} N.P{bx, by} N.P{cx, cy}: cyclic_fields(ax, ay, bx, by, cx, cy)
def cmp_reflexive(+n: Nat) -> {Nat.cmp(n, n) == EQ{} : Cmp}:
  match n:
    case 0n: {==}
    case 1n+p: cmp_reflexive(p)
def endpoint_products(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat) -> {Sum.exact(ax, by, bx, ay, ax, ay) == Sum.exact(ay, bx, by, ax, ay, ax) : Nat}:
  Equal.trans(Nat, Sum.exact(ax, by, bx, ay, ax, ay), Nat.add(Nat.add(Nat.mul(by, ax), Nat.mul(ay, bx)), Nat.mul(ay, ax)), Sum.exact(ay, bx, by, ax, ay, ax), GP.sum3_cong(Nat.mul(ax, by), Nat.mul(bx, ay), Nat.mul(ax, ay), Nat.mul(by, ax), Nat.mul(ay, bx), Nat.mul(ay, ax), F.mul_comm(ax, by), F.mul_comm(bx, ay), F.mul_comm(ax, ay)), Equal.cong(Nat, Nat, n => Nat.add(n, Nat.mul(ay, ax)), Nat.add(Nat.mul(by, ax), Nat.mul(ay, bx)), Nat.add(Nat.mul(ay, bx), Nat.mul(by, ax)), F.add_comm(Nat.mul(by, ax), Nat.mul(ay, bx))))
def start_fields(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat) -> {M.side(N.P{ax, ay}, N.P{bx, by}, N.P{ax, ay}) == EQ{} : Cmp}:
  Equal.trans(Cmp, M.side(N.P{ax, ay}, N.P{bx, by}, N.P{ax, ay}), Nat.cmp(Sum.exact(ax, by, bx, ay, ax, ay), Sum.exact(ay, bx, by, ax, ay, ax)), EQ{}, vertex_polynomial(ax, ay, bx, by, ax, ay), Equal.trans(Cmp, Nat.cmp(Sum.exact(ax, by, bx, ay, ax, ay), Sum.exact(ay, bx, by, ax, ay, ax)), Nat.cmp(Sum.exact(ay, bx, by, ax, ay, ax), Sum.exact(ay, bx, by, ax, ay, ax)), EQ{}, Equal.cong(Nat, Cmp, n => Nat.cmp(n, Sum.exact(ay, bx, by, ax, ay, ax)), Sum.exact(ax, by, bx, ay, ax, ay), Sum.exact(ay, bx, by, ax, ay, ax), endpoint_products(ax, ay, bx, by)), cmp_reflexive(Sum.exact(ay, bx, by, ax, ay, ax))))
def L.side_at_start_zero(a, b):
  match a b:
    case N.P{ax, ay} N.P{bx, by}: start_fields(ax, ay, bx, by)
def L.side_at_finish_zero(a, b):
  Equal.trans(Cmp, M.side(a, b, b), M.side(b, b, a), EQ{}, L.triangle_cyclic_side(a, b, b), Equal.trans(Cmp, M.side(b, b, a), M.side(b, a, b), EQ{}, L.triangle_cyclic_side(b, b, a), L.side_at_start_zero(b, a)))
def edge_side(a: N.Point, b: N.Point, +v: N.Point) -> {Region.edge(a, b, M.embed(v)) == Bool.not(Cmp.is_lt(M.side(a, b, v))) : Bool}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: {==}
def gt_nonnegative(c: Cmp, h: {Cmp.is_gt(c) == True{} : Bool}) -> {Bool.not(Cmp.is_lt(c)) == True{} : Bool}:
  match c:
    case LT{}: B.absurd({Bool.not(Cmp.is_lt(LT{})) == True{} : Bool}, B.false_impossible(h))
    case EQ{}: B.absurd({Bool.not(Cmp.is_lt(EQ{})) == True{} : Bool}, B.false_impossible(h))
    case GT{}: {==}
def edge_zero(+a: N.Point, +b: N.Point, +v: N.Point, h: {M.side(a, b, v) == EQ{} : Cmp}) -> {Region.edge(a, b, M.embed(v)) == True{} : Bool}:
  Equal.trans(Bool, Region.edge(a, b, M.embed(v)), Bool.not(Cmp.is_lt(M.side(a, b, v))), True{}, edge_side(a, b, v), Equal.cong(Cmp, Bool, c => Bool.not(Cmp.is_lt(c)), M.side(a, b, v), EQ{}, h))
def edge_turn(+a: N.Point, +b: N.Point, +v: N.Point, h: {M.turn(a, b, v) == True{} : Bool}) -> {Region.edge(a, b, M.embed(v)) == True{} : Bool}:
  Equal.trans(Bool, Region.edge(a, b, M.embed(v)), Bool.not(Cmp.is_lt(M.side(a, b, v))), True{}, edge_side(a, b, v), gt_nonnegative(M.side(a, b, v), h))
def rotated_turn(+a: N.Point, +b: N.Point, +c: N.Point, h: {M.turn(a, b, c) == True{} : Bool}) -> {M.turn(b, c, a) == True{} : Bool}:
  %L.triangle_cyclic_side(a, b, c) : {Cmp.is_gt(_) == True{} : Bool}
  h
def corner_inside(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +v: N.Point, hab: {Region.edge(a, b, M.embed(v)) == True{} : Bool}, hbc: {Region.edge(b, c, M.embed(v)) == True{} : Bool}, hcd: {Region.edge(c, d, M.embed(v)) == True{} : Bool}, hda: {Region.edge(d, a, M.embed(v)) == True{} : Bool}) -> {Region.contains(M.embed(v), N.Q{a, b, c, d}) == True{} : Bool}:
  CP.four_join(Region.edge(a, b, M.embed(v)), Region.edge(b, c, M.embed(v)), Region.edge(c, d, M.embed(v)), Region.edge(d, a, M.embed(v)), hab, hbc, hcd, hda)
def corners_proofs(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +habc: {M.turn(a, b, c) == True{} : Bool}, +hbcd: {M.turn(b, c, d) == True{} : Bool}, +hcda: {M.turn(c, d, a) == True{} : Bool}, +hdab: {M.turn(d, a, b) == True{} : Bool}) -> {M.corners_inside(N.Q{a, b, c, d}) == True{} : Bool}:
  CP.four_join(Region.contains(M.embed(a), N.Q{a, b, c, d}), Region.contains(M.embed(b), N.Q{a, b, c, d}), Region.contains(M.embed(c), N.Q{a, b, c, d}), Region.contains(M.embed(d), N.Q{a, b, c, d}), corner_inside(a, b, c, d, a, edge_zero(a, b, a, L.side_at_start_zero(a, b)), edge_turn(b, c, a, rotated_turn(a, b, c, habc)), edge_turn(c, d, a, hcda), edge_zero(d, a, a, L.side_at_finish_zero(d, a))), corner_inside(a, b, c, d, b, edge_zero(a, b, b, L.side_at_finish_zero(a, b)), edge_zero(b, c, b, L.side_at_start_zero(b, c)), edge_turn(c, d, b, rotated_turn(b, c, d, hbcd)), edge_turn(d, a, b, hdab)), corner_inside(a, b, c, d, c, edge_turn(a, b, c, habc), edge_zero(b, c, c, L.side_at_finish_zero(b, c)), edge_zero(c, d, c, L.side_at_start_zero(c, d)), edge_turn(d, a, c, rotated_turn(c, d, a, hcda))), corner_inside(a, b, c, d, d, edge_turn(a, b, d, rotated_turn(d, a, b, hdab)), edge_turn(b, c, d, hbcd), edge_zero(c, d, d, L.side_at_finish_zero(c, d)), edge_zero(d, a, d, L.side_at_start_zero(d, a))))
def corners_fields(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, hs: {M.turn(a, b, c) == True{} : Bool} & ({M.turn(b, c, d) == True{} : Bool} & ({M.turn(c, d, a) == True{} : Bool} & {M.turn(d, a, b) == True{} : Bool}))) -> {M.corners_inside(N.Q{a, b, c, d}) == True{} : Bool}:
  match hs:
    case (habc, (hbcd, (hcda, hdab))): corners_proofs(a, b, c, d, habc, hbcd, hcda, hdab)
def L.strict_quad_corners_inside(q, h):
  match q:
    case N.Q{+a, +b, +c, +d}: corners_fields(a, b, c, d, CP.four_fields(M.turn(a, b, c), M.turn(b, c, d), M.turn(c, d, a), M.turn(d, a, b), h))
def decoded_side(a: T.Point, b: T.Point, c: T.Point) -> {Sat.vertex(a, b, c) == M.side(N.decode_point(a), N.decode_point(b), N.decode_point(c)) : Cmp}:
  match a b c:
    case T.P{ax, ay} T.P{bx, by} T.P{cx, cy}: {==}
def decoded_turn(+a: T.Point, +b: T.Point, +c: T.Point) -> {Sat.positive(a, b, c) == M.turn(N.decode_point(a), N.decode_point(b), N.decode_point(c)) : Bool}:
  Equal.cong(Cmp, Bool, c => Cmp.is_gt(c), Sat.vertex(a, b, c), M.side(N.decode_point(a), N.decode_point(b), N.decode_point(c)), decoded_side(a, b, c))
def L.strict_quad_decoded(q):
  match q:
    case T.Q{+a, +b, +c, +d}:
      B.four_cong(Sat.positive(a, b, c), Sat.positive(b, c, d), Sat.positive(c, d, a), Sat.positive(d, a, b), M.turn(N.decode_point(a), N.decode_point(b), N.decode_point(c)), M.turn(N.decode_point(b), N.decode_point(c), N.decode_point(d)), M.turn(N.decode_point(c), N.decode_point(d), N.decode_point(a)), M.turn(N.decode_point(d), N.decode_point(a), N.decode_point(b)), decoded_turn(a, b, c), decoded_turn(b, c, d), decoded_turn(c, d, a), decoded_turn(d, a, b))
def L.production_corners_inside(width, hw, q, hq, h):
  L.strict_quad_corners_inside(N.decode_quad(q), Equal.trans(Bool, M.strict_quad(N.decode_quad(q)), Sat.strictly_convex(q), True{}, Equal.sym(Bool, Sat.strictly_convex(q), M.strict_quad(N.decode_quad(q)), L.strict_quad_decoded(q)), Equal.trans(Bool, Sat.strictly_convex(q), T.strictly_convex(q), True{}, Equal.sym(Bool, T.strictly_convex(q), Sat.strictly_convex(q), SL.strictly_convex_arithmetic_exact(width, hw, q, hq)), h)))
