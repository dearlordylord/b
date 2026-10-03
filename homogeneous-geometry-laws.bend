import Base
import ./homogeneous.bend as H
import ./homogeneous-geometry.bend as M

law positive_product_comparison:
  for +a: Nat
  for +b: Nat
  for +k: Nat
  {Nat.cmp(Nat.mul(a, 1n+k), Nat.mul(b, 1n+k)) == Nat.cmp(a, b) : Cmp}

law homogeneous_linear_scale:
  for +a: Nat
  for +b: Nat
  for +d: Nat
  for +c: Nat
  for +y: Nat
  for +x: Nat
  for +e: Nat
  for +k: Nat
  {H.exact(a, b, Nat.mul(d, k), c, Nat.mul(y, k), Nat.mul(x, k), e) == Nat.mul(H.exact(a, b, d, c, y, x, e), k) : Nat}

law side_positive_scale:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +p: M.Point
  for +k: Nat
  {M.side(ax, ay, bx, by, M.scale(p, k)) == M.side(ax, ay, bx, by, p) : Cmp}

law closed_halfplane_positive_scale:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +p: M.Point
  for +k: Nat
  {M.left_closed(ax, ay, bx, by, M.scale(p, k)) == M.left_closed(ax, ay, bx, by, p) : Bool}

law scale_positive_denominator:
  for +p: M.Point
  for +k: Nat
  {M.positive_denominator(M.scale(p, k)) == M.positive_denominator(p) : Bool}

law scale_equivalent_point:
  for +p: M.Point
  for +k: Nat
  {M.equivalent(p, M.scale(p, k)) == True{} : Bool}

law equivalent_point_side:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +p: M.Point
  for +q: M.Point
  for +hp: {M.positive_denominator(p) == True{} : Bool}
  for +hq: {M.positive_denominator(q) == True{} : Bool}
  for hsame: {M.equivalent(p, q) == True{} : Bool}
  {M.side(ax, ay, bx, by, p) == M.side(ax, ay, bx, by, q) : Cmp}

law equivalent_point_closed_halfplane:
  for +ax: Nat
  for +ay: Nat
  for +bx: Nat
  for +by: Nat
  for +p: M.Point
  for +q: M.Point
  for +hp: {M.positive_denominator(p) == True{} : Bool}
  for +hq: {M.positive_denominator(q) == True{} : Bool}
  for hsame: {M.equivalent(p, q) == True{} : Bool}
  {M.left_closed(ax, ay, bx, by, p) == M.left_closed(ax, ay, bx, by, q) : Bool}
