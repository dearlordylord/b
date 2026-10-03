import Base
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C

# Replace old endpoints p,q by p and cut = v*p + w*q.
# The balance condition l*v <= k*w prevents subtraction saturation.
def retained(+k:Nat,l:Nat,w:Nat,v:Nat) -> Nat:
  Nat.sub(Nat.mul(k,w),Nat.mul(l,v))
def rebase(+p:G.Point,q:G.Point,+k:Nat,+l:Nat,+w:Nat,+v:Nat) -> G.Point:
  C.join(p,C.join(p,q,v,w),retained(k,l,w,v),l)
