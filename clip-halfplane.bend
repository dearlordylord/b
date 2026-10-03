import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./segment-cut.bend as Cut
import ./clip-weights.bend as W

# Geometry supplies the actual inside and outside determinant gaps.
def balance(+a:N.Point,+b:N.Point,p:G.Point,q:G.Point,k:Nat,l:Nat) -> Bool:
  Nat.is_le(Nat.mul(l,Cut.first_weight(a,b,q)),Nat.mul(k,Cut.second_weight(a,b,p)))
def rebased(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,k:Nat,l:Nat) -> G.Point:
  W.rebase(p,q,k,l,Cut.second_weight(a,b,p),Cut.first_weight(a,b,q))
