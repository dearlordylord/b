import Base
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./natural-cover.bend as N
import ./segment-cut.bend as Cut

# Flatten a combination of two points expressed on the same original segment.
def first(+k:Nat,+m:Nat,+v:Nat,+w:Nat) -> Nat:
  Nat.add(Nat.mul(k,v),Nat.mul(m,w))
def second(+l:Nat,+n:Nat,+v:Nat,+w:Nat) -> Nat:
  Nat.add(Nat.mul(l,v),Nat.mul(n,w))
def compose(p:G.Point,q:G.Point,k:Nat,l:Nat,m:Nat,n:Nat,+v:Nat,+w:Nat) -> G.Point:
  C.join(p,q,first(k,m,v,w),second(l,n,v,w))

# Exact determinant gaps are computed from the current endpoints, not the source ends.
def cut_on_source(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,+m:Nat,+n:Nat) -> G.Point:
  compose(p,q,k,l,m,n,Cut.first_weight(a,b,C.join(p,q,m,n)),Cut.second_weight(a,b,C.join(p,q,k,l)))
