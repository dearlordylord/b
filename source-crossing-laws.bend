import Base
import ./source-crossing.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S

# Exact physical classification, including closed boundary endpoints.
law different_exact:
  for +cp:Bool
  for +cq:Bool
  {M.different(cp,cq) == (cp && Bool.not(cq)) || (Bool.not(cp) && cq) : Bool}
law crosses_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  {M.crosses(a,b,p,q) == (Region.edge(a,b,p) && Bool.not(Region.edge(a,b,q))) || (Bool.not(Region.edge(a,b,p)) && Region.edge(a,b,q)) : Bool}
# An accepted nonzero source combination and a rejected combination force
# opposite classifications of the original source endpoints.
law weighted_crossing:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +m:Nat
  for +n:Nat
  for hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for hc:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for hn:{S.negative(a,b,C.join(p,q,m,n)) == True{} : Bool}
  {M.crosses(a,b,p,q) == True{} : Bool}
# Current endpoint validity gives the nonzero weight premise constructively.
law valid_crossing:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +m:Nat
  for +n:Nat
  for hp:{G.positive_denominator(C.join(p,q,k,l)) == True{} : Bool}
  for hc:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for hn:{S.negative(a,b,C.join(p,q,m,n)) == True{} : Bool}
  {M.crosses(a,b,p,q) == True{} : Bool}
