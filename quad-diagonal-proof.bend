import Base
import ./quad-diagonal.bend as M
import ./quad-diagonal-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./halfplane-region-laws.bend as RL
import ./halfplane-region-proof.bend as RP
import ./quad-geometry.bend as Q
import ./quad-geometry-proof.bend as QP
import ./homogeneous-combination-proof.bend as CP
import ./exact-arithmetic.bend as A
import ./arithmetic-laws.bend as AL
import ./arithmetic-proof.bend as AP
import ./boolean-reflection.bend as B
import ./topology.bend as T

def comparison_opposite(+a: Nat, +b: Nat, h: {Bool.not(Cmp.is_lt(Nat.cmp(a, b))) == False{} : Bool}) -> {Bool.not(Cmp.is_lt(Nat.cmp(b, a))) == True{} : Bool}:
  match a b:
    case 0n 0n: B.absurd({Bool.not(Cmp.is_lt(Nat.cmp(0n, 0n))) == True{} : Bool}, B.false_impossible(Equal.sym(Bool, True{}, False{}, h)))
    case 0n 1n+q: {==}
    case 1n+p 0n: B.absurd({Bool.not(Cmp.is_lt(Nat.cmp(0n, 1n+p))) == True{} : Bool}, B.false_impossible(Equal.sym(Bool, True{}, False{}, h)))
    case 1n+p 1n+q: comparison_opposite(p, q, h)
def opposite_values(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat, h: {G.left_closed(ax, ay, bx, by, G.P{x, y, d}) == False{} : Bool}) -> {G.left_closed(bx, by, ax, ay, G.P{x, y, d}) == True{} : Bool}:
  %AL.edge_reversal_right(ax, ay, bx, by, x, y, d) : {Bool.not(Cmp.is_lt(Nat.cmp(_, A.right(bx, by, ax, ay, x, y, d)))) == True{} : Bool}
  %AL.edge_reversal_left(ax, ay, bx, by, x, y, d) : {Bool.not(Cmp.is_lt(Nat.cmp(A.right(ax, ay, bx, by, x, y, d), _))) == True{} : Bool}
  comparison_opposite(A.left(ax, ay, bx, by, x, y, d), A.right(ax, ay, bx, by, x, y, d), h)
def opposite_points(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, p: G.Point, h: {G.left_closed(ax, ay, bx, by, p) == False{} : Bool}) -> {G.left_closed(bx, by, ax, ay, p) == True{} : Bool}:
  match p:
    case G.P{x, y, d}: opposite_values(ax, ay, bx, by, x, y, d, h)
def L.opposite_closed_halfplane(a, b, p, h):
  match a b:
    case N.P{ax, ay} N.P{bx, by}: opposite_points(ax, ay, bx, by, p, h)
def diagonal_split_choice(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +p: G.Point, choice: Bool, +hc: {choice == Region.edge(a, c, p) : Bool}, hab: {Region.edge(a, b, p) == True{} : Bool}, hbc: {Region.edge(b, c, p) == True{} : Bool}, hcd: {Region.edge(c, d, p) == True{} : Bool}, hda: {Region.edge(d, a, p) == True{} : Bool}) -> M.Split<N.Q{a, b, c, d}, p>:
  match choice:
    case False{}:
      M.ABC{Equal.sym(Bool, False{}, Region.edge(a, c, p), hc), B.and_join(Region.edge(a, b, p) && Region.edge(b, c, p), Region.edge(c, a, p), B.and_join(Region.edge(a, b, p), Region.edge(b, c, p), hab, hbc), L.opposite_closed_halfplane(a, c, p, Equal.sym(Bool, False{}, Region.edge(a, c, p), hc)))}
    case True{}:
      M.ACD{Equal.sym(Bool, True{}, Region.edge(a, c, p), hc), B.and_join(Region.edge(a, c, p) && Region.edge(c, d, p), Region.edge(d, a, p), B.and_join(Region.edge(a, c, p), Region.edge(c, d, p), Equal.sym(Bool, True{}, Region.edge(a, c, p), hc), hcd), hda)}
def split_fields(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, +p: G.Point, hs: {Region.edge(a, b, p) == True{} : Bool} & ({Region.edge(b, c, p) == True{} : Bool} & ({Region.edge(c, d, p) == True{} : Bool} & {Region.edge(d, a, p) == True{} : Bool}))) -> M.Split<N.Q{a, b, c, d}, p>:
  match hs:
    case (hab, (hbc, (hcd, hda))): diagonal_split_choice(a, b, c, d, p, Region.edge(a, c, p), {==}, hab, hbc, hcd, hda)
def L.region_diagonal_split(q, p, h):
  match q:
    case N.Q{+a, +b, +c, +d}: split_fields(a, b, c, d, p, CP.four_fields(Region.edge(a, b, p), Region.edge(b, c, p), Region.edge(c, d, p), Region.edge(d, a, p), h))
def diagonal_strict_fields(+a: N.Point, +b: N.Point, +c: N.Point, +d: N.Point, hs: {Q.turn(a, b, c) == True{} : Bool} & ({Q.turn(b, c, d) == True{} : Bool} & ({Q.turn(c, d, a) == True{} : Bool} & {Q.turn(d, a, b) == True{} : Bool}))) -> {M.triangles_strict(N.Q{a, b, c, d}) == True{} : Bool}:
  match hs:
    case (habc, (hbcd, (hcda, hdab))): B.and_join(Q.turn(a, b, c), Q.turn(a, c, d), habc, QP.rotated_turn(d, a, c, QP.rotated_turn(c, d, a, hcda)))
def L.strict_diagonal_triangles(q, h):
  match q:
    case N.Q{+a, +b, +c, +d}: diagonal_strict_fields(a, b, c, d, CP.four_fields(Q.turn(a, b, c), Q.turn(b, c, d), Q.turn(c, d, a), Q.turn(d, a, b), h))
def L.production_diagonal_split(width, hw, q, w, hq, henv, h):
  L.region_diagonal_split(N.decode_quad(q), Region.decode_witness(w), Equal.trans(Bool, Region.contains(Region.decode_witness(w), N.decode_quad(q)), T.inside(w, q), True{}, Equal.sym(Bool, T.inside(w, q), Region.contains(Region.decode_witness(w), N.decode_quad(q)), RL.production_inside_halfplanes(width, hw, w, q, hq, henv)), h))
