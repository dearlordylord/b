import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./segment-cut.bend as Cut
import ./segment-proportional.bend as P

def ratio(+a:N.Point,+b:N.Point,p:G.Point,q:G.Point,k:Nat,l:Nat) -> Bool:
  P.proportional(k,l,Cut.first_weight(a,b,q),Cut.second_weight(a,b,p))
