import Base
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as M
import ./natural-cover.bend as N
import ./halfplane-region.bend as Region

law weighted_form_exact:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +p: G.Point
  for +q: G.Point
  for +k: Nat
  for +l: Nat
  {M.value(a, b, c, M.join(p, q, k, l)) == Nat.add(Nat.mul(M.value(a, b, c, p), k), Nat.mul(M.value(a, b, c, q), l)) : Nat}
law joined_denominator_positive:
  for +p: G.Point
  for +q: G.Point
  for +k: Nat
  for +l: Nat
  for hp: {G.positive_denominator(p) == True{} : Bool}
  for hq: {G.positive_denominator(q) == True{} : Bool}
  for hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}
  {G.positive_denominator(M.join(p, q, k, l)) == True{} : Bool}
law halfplane_weighted_join:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +p: G.Point
  for +q: G.Point
  for +k: Nat
  for +l: Nat
  for hp: {G.left_closed(ax, ay, bx, by, p) == True{} : Bool}
  for hq: {G.left_closed(ax, ay, bx, by, q) == True{} : Bool}
  {G.left_closed(ax, ay, bx, by, M.join(p, q, k, l)) == True{} : Bool}
law region_weighted_join:
  for +p: G.Point
  for +q: G.Point
  for +r: N.Quad
  for +k: Nat
  for +l: Nat
  for hp: {Region.contains(p, r) == True{} : Bool}
  for hq: {Region.contains(q, r) == True{} : Bool}
  {Region.contains(M.join(p, q, k, l), r) == True{} : Bool}
law mixture_denominator_exact:
  for +p: G.Point
  for +q: G.Point
  for +k: Nat
  for +l: Nat
  {M.denominator(M.mix(p, q, k, l)) == Nat.mul(Nat.mul(M.denominator(p), M.denominator(q)), Nat.add(k, l)) : Nat}
law region_convex_mixture:
  for +p: G.Point
  for +q: G.Point
  for +r: N.Quad
  for +k: Nat
  for +l: Nat
  for hpd: {G.positive_denominator(p) == True{} : Bool}
  for hqd: {G.positive_denominator(q) == True{} : Bool}
  for hw: {Nat.is_gt(Nat.add(k, l), 0n) == True{} : Bool}
  for hp: {Region.contains(p, r) == True{} : Bool}
  for hq: {Region.contains(q, r) == True{} : Bool}
  {G.positive_denominator(M.mix(p, q, k, l)) == True{} : Bool} & {Region.contains(M.mix(p, q, k, l), r) == True{} : Bool}
