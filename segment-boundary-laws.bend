import Base
import ./segment-boundary.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S

# The computed gap proportion characterizes the actual boundary condition.
law ratio_on_line_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for hp:{Region.edge(a,b,p) == True{} : Bool}
  for hq:{S.negative(a,b,q) == True{} : Bool}
  {M.ratio(a,b,p,q,k,l) == Cut.on_line(a,b,C.join(p,q,k,l)) : Bool}

law boundary_same_cut:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for hp:{Region.edge(a,b,p) == True{} : Bool}
  for hq:{S.negative(a,b,q) == True{} : Bool}
  for h:{Cut.on_line(a,b,C.join(p,q,k,l)) == True{} : Bool}
  {G.equivalent(C.join(p,q,k,l),Cut.point(a,b,p,q)) == True{} : Bool}

# Valid representatives have identical membership in every closed quad region.
law boundary_region_same_cut:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +r:N.Quad
  for +k:Nat
  for +l:Nat
  for hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  for h:{Cut.on_line(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for hpd:{G.positive_denominator(p) == True{} : Bool}
  for hqd:{G.positive_denominator(q) == True{} : Bool}
  for hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  {Region.contains(C.join(p,q,k,l),r) == Region.contains(Cut.point(a,b,p,q),r) : Bool}
