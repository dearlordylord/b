import Base
import ./clip-weights.bend as M
import ./clip-weights-laws.bend as L
import ./homogeneous-geometry.bend as G
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous-combination.bend as C
import ./triangle-coordinate.bend as Scale
import ./order-facts.bend as O
import ./facts.bend as F

import ./triangle-area-proof.bend as AP
import ./triangle-coordinate-proof.bend as Coord
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./boolean-reflection.bend as B
import ./segment-cut.bend as Cut

def L.retained_reconstruct(k,l,w,v,h):
  O.sub_add_cancel(Nat.mul(k,w),Nat.mul(l,v),h)
def regroup_product(+a:Nat,+b:Nat,+c:Nat) -> {Nat.mul(Nat.mul(a,b),c) == Nat.mul(a,Nat.mul(c,b)) : Nat}:
  Equal.trans(Nat,Nat.mul(Nat.mul(a,b),c),Nat.mul(a,Nat.mul(b,c)),Nat.mul(a,Nat.mul(c,b)),F.mul_assoc(a,b,c),Equal.cong(Nat,Nat,x => Nat.mul(a,x),Nat.mul(b,c),Nat.mul(c,b),F.mul_comm(b,c)))
def scalar_rebase(+a:Nat,+b:Nat,+k:Nat,+l:Nat,+w:Nat,+v:Nat,+alpha:Nat,h:{Nat.add(alpha,Nat.mul(l,v)) == Nat.mul(k,w) : Nat}) -> {Nat.add(Nat.mul(a,alpha),Nat.mul(Nat.add(Nat.mul(a,v),Nat.mul(b,w)),l)) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}:
  %Equal.sym(Nat,Nat.mul(Nat.add(Nat.mul(a,v),Nat.mul(b,w)),l),Nat.add(Nat.mul(Nat.mul(a,v),l),Nat.mul(Nat.mul(b,w),l)),F.add_mul(Nat.mul(a,v),Nat.mul(b,w),l)) : {Nat.add(Nat.mul(a,alpha),_) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  %F.add_assoc(Nat.mul(a,alpha),Nat.mul(Nat.mul(a,v),l),Nat.mul(Nat.mul(b,w),l)) : {_ == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  %Equal.sym(Nat,Nat.mul(Nat.mul(a,v),l),Nat.mul(a,Nat.mul(l,v)),regroup_product(a,v,l)) : {Nat.add(Nat.add(Nat.mul(a,alpha),_),Nat.mul(Nat.mul(b,w),l)) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  %F.mul_add(a,alpha,Nat.mul(l,v)) : {Nat.add(_,Nat.mul(Nat.mul(b,w),l)) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  %Equal.sym(Nat,Nat.add(alpha,Nat.mul(l,v)),Nat.mul(k,w),h) : {Nat.add(Nat.mul(a,_),Nat.mul(Nat.mul(b,w),l)) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  %F.mul_assoc(a,k,w) : {Nat.add(_,Nat.mul(Nat.mul(b,w),l)) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  %Equal.sym(Nat,Nat.mul(Nat.mul(b,w),l),Nat.mul(b,Nat.mul(l,w)),regroup_product(b,w,l)) : {Nat.add(Nat.mul(Nat.mul(a,k),w),_) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  %F.mul_assoc(b,l,w) : {Nat.add(Nat.mul(Nat.mul(a,k),w),_) == Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w) : Nat}
  Equal.sym(Nat,Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),w),Nat.add(Nat.mul(Nat.mul(a,k),w),Nat.mul(Nat.mul(b,l),w)),F.add_mul(Nat.mul(a,k),Nat.mul(b,l),w))
def L.rebase_exact(p,q,k,l,w,v,h):
  match p q:
    case G.P{+x,+y,+d} G.P{+u,+z,+e}:
      GP.point_equal(Nat.add(Nat.mul(x,M.retained(k,l,w,v)),Nat.mul(Nat.add(Nat.mul(x,v),Nat.mul(u,w)),l)),Nat.add(Nat.mul(y,M.retained(k,l,w,v)),Nat.mul(Nat.add(Nat.mul(y,v),Nat.mul(z,w)),l)),Nat.add(Nat.mul(d,M.retained(k,l,w,v)),Nat.mul(Nat.add(Nat.mul(d,v),Nat.mul(e,w)),l)),Nat.mul(Nat.add(Nat.mul(x,k),Nat.mul(u,l)),w),Nat.mul(Nat.add(Nat.mul(y,k),Nat.mul(z,l)),w),Nat.mul(Nat.add(Nat.mul(d,k),Nat.mul(e,l)),w),scalar_rebase(x,u,k,l,w,v,M.retained(k,l,w,v),L.retained_reconstruct(k,l,w,v,h)),scalar_rebase(y,z,k,l,w,v,M.retained(k,l,w,v),L.retained_reconstruct(k,l,w,v,h)),scalar_rebase(d,e,k,l,w,v,M.retained(k,l,w,v),L.retained_reconstruct(k,l,w,v,h)))

def positive_right(+v:Nat,+w:Nat,h:{Nat.is_gt(w,0n) == True{} : Bool}) -> {Nat.is_gt(Nat.add(v,w),0n) == True{} : Bool}:
  match w:
    case 0n: B.absurd({Nat.is_gt(Nat.add(v,0n),0n) == True{} : Bool},B.false_impossible(h))
    case 1n+t:
      %Equal.sym(Nat,Nat.add(v,1n+t),1n+Nat.add(v,t),F.add_succ(v,t)) : {Nat.is_gt(_,0n) == True{} : Bool}
      {==}
def zero_total_k(+k:Nat,h:{Nat.is_gt(Nat.add(k,0n),0n) == True{} : Bool}) -> {Nat.is_gt(k,0n) == True{} : Bool}:
  %F.add_zero(k) : {Nat.is_gt(_,0n) == True{} : Bool}
  h
def L.retained_total_positive(k,l,w,v,h,hs,hw):
  match l:
    case 0n:
      Equal.trans(Bool,Nat.is_gt(Nat.add(M.retained(k,0n,w,v),0n),0n),Nat.is_gt(Nat.mul(k,w),0n),True{},Equal.cong(Nat,Bool,x => Nat.is_gt(x,0n),Nat.add(M.retained(k,0n,w,v),0n),Nat.mul(k,w),L.retained_reconstruct(k,0n,w,v,h)),AP.area_positive_product(k,w,zero_total_k(k,hs),hw))
    case 1n+t: positive_right(M.retained(k,1n+t,w,v),1n+t,{==})
def L.rebase_valid(p,q,k,l,w,v,h,hs,hw,hp,hq):
  (CL.joined_denominator_positive(p,C.join(p,q,v,w),M.retained(k,l,w,v),l,hp,CL.joined_denominator_positive(p,q,v,w,hp,hq,positive_right(v,w,hw)),L.retained_total_positive(k,l,w,v,h,hs,hw)),Equal.trans(Bool,G.equivalent(C.join(p,q,k,l),M.rebase(p,q,k,l,w,v)),G.equivalent(C.join(p,q,k,l),Scale.scaled(C.join(p,q,k,l),w)),True{},Equal.cong(G.Point,Bool,x => G.equivalent(C.join(p,q,k,l),x),M.rebase(p,q,k,l,w,v),Scale.scaled(C.join(p,q,k,l),w),L.rebase_exact(p,q,k,l,w,v,h)),Coord.coord_scaled_equivalent(C.join(p,q,k,l),w)))

def member_from_rebase(+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,+w:Nat,+v:Nat,+h:{Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) == True{} : Bool},+hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},+hw:{Nat.is_gt(w,0n) == True{} : Bool},+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},facts:{G.positive_denominator(M.rebase(p,q,k,l,w,v)) == True{} : Bool} & {G.equivalent(C.join(p,q,k,l),M.rebase(p,q,k,l,w,v)) == True{} : Bool}) -> Cut.InSegment(p,C.join(p,q,v,w),C.join(p,q,k,l)):
  match facts:
    case (valid,equivalent):
      (M.retained(k,l,w,v),(l,(L.retained_total_positive(k,l,w,v,h,hs,hw),(hp,(CL.joined_denominator_positive(p,q,v,w,hp,hq,positive_right(v,w,hw)),(CL.joined_denominator_positive(p,q,k,l,hp,hq,hs),equivalent))))))
def L.rebase_segment_member(p,q,k,l,w,v,h,hs,hw,hp,hq):
  member_from_rebase(p,q,k,l,w,v,h,hs,hw,hp,hq,L.rebase_valid(p,q,k,l,w,v,h,hs,hw,hp,hq))
