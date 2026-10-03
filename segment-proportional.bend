import Base
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C

def proportional(+k:Nat,+l:Nat,+v:Nat,+w:Nat) -> Bool:
  Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v))
def same_point(+p:G.Point,+q:G.Point,k:Nat,l:Nat,v:Nat,w:Nat) -> Bool:
  G.equivalent(C.join(p,q,k,l),C.join(p,q,v,w))
