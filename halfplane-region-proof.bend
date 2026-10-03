import ./search-witness.bend as Search
import Base
import ./halfplane-region.bend as M
import ./halfplane-region-laws.bend as L
import ./topology.bend as T
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as H
import ./homogeneous-geometry-laws.bend as HL
import ./homogeneous-geometry-proof.bend as HP
import ./inside-arithmetic.bend as I
import ./inside-arithmetic-laws.bend as IL
import ./inside-arithmetic-proof.bend as IP

def edge_values(+ax: U32, +ay: U32, +bx: U32, +by: U32, w: T.Witness) -> {I.edge(T.P{ax, ay}, T.P{bx, by}, w) == M.edge(N.decode_point(T.P{ax, ay}), N.decode_point(T.P{bx, by}), M.decode_witness(w)) : Bool}:
  match w:
    case T.W{x, y, d}: {==}
def L.edge_halfplane_decoded(a, b, w):
  match a b:
    case T.P{ax, ay} T.P{bx, by}: edge_values(ax, ay, bx, by, w)
def four_cong(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +u: Bool, +v: Bool, +w: Bool, +z: Bool, ha: {a == u : Bool}, hb: {b == v : Bool}, hc: {c == w : Bool}, hd: {d == z : Bool}) -> {a && b && c && d == u && v && w && z : Bool}:
  %ha : {a && b && c && d == _ && v && w && z : Bool}
  %hb : {a && b && c && d == a && _ && w && z : Bool}
  %hc : {a && b && c && d == a && b && _ && z : Bool}
  %hd : {a && b && c && d == a && b && c && _ : Bool}
  {==}
def L.inside_halfplanes_decoded(w, q):
  match q:
    case T.Q{+a, +b, +c, +d}:
      four_cong(I.edge(a, b, w), I.edge(b, c, w), I.edge(c, d, w), I.edge(d, a, w), M.edge(N.decode_point(a), N.decode_point(b), M.decode_witness(w)), M.edge(N.decode_point(b), N.decode_point(c), M.decode_witness(w)), M.edge(N.decode_point(c), N.decode_point(d), M.decode_witness(w)), M.edge(N.decode_point(d), N.decode_point(a), M.decode_witness(w)), L.edge_halfplane_decoded(a, b, w), L.edge_halfplane_decoded(b, c, w), L.edge_halfplane_decoded(c, d, w), L.edge_halfplane_decoded(d, a, w))
def L.production_inside_halfplanes(width, hw, w, q, hq, henv):
  Equal.trans(Bool, T.inside(w, q), I.inside(w, q), M.contains(M.decode_witness(w), N.decode_quad(q)), IL.inside_arithmetic_exact(width, hw, w, q, hq, henv), L.inside_halfplanes_decoded(w, q))
def edge_scaled(+p: H.Point, a: N.Point, b: N.Point, +k: Nat) -> {M.edge(a, b, H.scale(p, k)) == M.edge(a, b, p) : Bool}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: HL.closed_halfplane_positive_scale(ax, ay, bx, by, p, k)
def L.region_positive_scale(p, q, k):
  match q:
    case N.Q{+a, +b, +c, +d}:
      four_cong(M.edge(a, b, H.scale(p, k)), M.edge(b, c, H.scale(p, k)), M.edge(c, d, H.scale(p, k)), M.edge(d, a, H.scale(p, k)), M.edge(a, b, p), M.edge(b, c, p), M.edge(c, d, p), M.edge(d, a, p), edge_scaled(p, a, b, k), edge_scaled(p, b, c, k), edge_scaled(p, c, d, k), edge_scaled(p, d, a, k))
def edge_equivalent(+p: H.Point, +r: H.Point, a: N.Point, b: N.Point, +hp: {H.positive_denominator(p) == True{} : Bool}, +hr: {H.positive_denominator(r) == True{} : Bool}, +hs: {H.equivalent(p, r) == True{} : Bool}) -> {M.edge(a, b, p) == M.edge(a, b, r) : Bool}:
  match a b:
    case N.P{ax, ay} N.P{bx, by}: HL.equivalent_point_closed_halfplane(ax, ay, bx, by, p, r, hp, hr, hs)
def L.region_equivalent_point(p, r, q, hp, hr, hs):
  match q:
    case N.Q{+a, +b, +c, +d}:
      four_cong(M.edge(a, b, p), M.edge(b, c, p), M.edge(c, d, p), M.edge(d, a, p), M.edge(a, b, r), M.edge(b, c, r), M.edge(c, d, r), M.edge(d, a, r), edge_equivalent(p, r, a, b, hp, hr, hs), edge_equivalent(p, r, b, c, hp, hr, hs), edge_equivalent(p, r, c, d, hp, hr, hs), edge_equivalent(p, r, d, a, hp, hr, hs))
def L.common_halfplanes_decoded(w, a, b, c):
  %L.inside_halfplanes_decoded(w, a) : {I.common(w, a, b, c) == _ && M.contains(M.decode_witness(w), N.decode_quad(b)) && M.contains(M.decode_witness(w), N.decode_quad(c)) : Bool}
  %L.inside_halfplanes_decoded(w, b) : {I.common(w, a, b, c) == I.inside(w, a) && _ && M.contains(M.decode_witness(w), N.decode_quad(c)) : Bool}
  %L.inside_halfplanes_decoded(w, c) : {I.common(w, a, b, c) == I.inside(w, a) && I.inside(w, b) && _ : Bool}
  {==}

def positive_decoded(+w: T.Witness) -> {H.positive_denominator(M.decode_witness(w)) == Nat.is_gt(U32.to_nat(Search.denominator(w)), 0n) : Bool}:
  match w:
    case T.W{x, y, d}: {==}
def halfplane_ready(+width: Nat, +a: T.Quad, +b: T.Quad, +c: T.Quad, found: I.Ready(width, a, b, c)) -> M.CommonPoint(N.decode_quad(a), N.decode_quad(b), N.decode_quad(c)):
  match found:
    case (+w, (henv, (hcommon, positive))):
      (M.decode_witness(w), (Equal.trans(Bool, H.positive_denominator(M.decode_witness(w)), Nat.is_gt(U32.to_nat(Search.denominator(w)), 0n), True{}, positive_decoded(w), positive), Equal.trans(Bool, M.common(M.decode_witness(w), N.decode_quad(a), N.decode_quad(b), N.decode_quad(c)), I.common(w, a, b, c), True{}, Equal.sym(Bool, I.common(w, a, b, c), M.common(M.decode_witness(w), N.decode_quad(a), N.decode_quad(b), N.decode_quad(c)), L.common_halfplanes_decoded(w, a, b, c)), hcommon)))
def L.triangle_halfplane_witness(width, hw, a, b, c, ha, hb, hc, accepted):
  halfplane_ready(width, a, b, c, IL.triangle_witness_natural(width, hw, a, b, c, ha, hb, hc, accepted))
