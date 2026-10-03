import Base
import ./segment-proportional.bend as M
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./natural-cover.bend as N
import ./halfplane-region.bend as Region

law proportional_exact:
  for +k:Nat
  for +l:Nat
  for +v:Nat
  for +w:Nat
  {M.proportional(k,l,v,w) == Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v)) : Bool}
# Pin the reported equivalence to the actual homogeneous points for all inputs.
law same_point_exact:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +v:Nat
  for +w:Nat
  {M.same_point(p,q,k,l,v,w) == G.equivalent(C.join(p,q,k,l),C.join(p,q,v,w)) : Bool}
# Algebraic equivalence alone does not assert positive denominators.
law proportional_same_point:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +v:Nat
  for +w:Nat
  for h:{M.proportional(k,l,v,w) == True{} : Bool}
  {M.same_point(p,q,k,l,v,w) == True{} : Bool}
# Domain guards make the equivalence usable for geometric membership.
law proportional_region_exact:
  for +p:G.Point
  for +q:G.Point
  for +r:N.Quad
  for +k:Nat
  for +l:Nat
  for +v:Nat
  for +w:Nat
  for h:{M.proportional(k,l,v,w) == True{} : Bool}
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  for hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for ht:{Nat.is_gt(Nat.add(v,w),0n) == True{} : Bool}
  {Region.contains(C.join(p,q,k,l),r) == Region.contains(C.join(p,q,v,w),r) : Bool}
