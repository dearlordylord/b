import Base
import ./segment-boundary.bend as M
import ./segment-boundary-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut
import ./segment-cut-laws.bend as CutL
import ./segment-cut-proof.bend as CutP
import ./segment-proportional-laws.bend as PL
import ./segment-proportional-proof.bend as PP
import ./clip-halfplane-proof.bend as Gap
import ./triangle-area.bend as A
import ./triangle-area-laws.bend as AL
import ./triangle-area-proof.bend as AP
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S
import ./order-facts.bend as O
import ./facts.bend as F

def eq_common(c:Nat,+a:Nat,+b:Nat) -> {Nat.is_eq(Nat.add(c,a),Nat.add(c,b)) == Nat.is_eq(a,b) : Bool}:
  match c:
    case 0n: {==}
    case 1n+t: eq_common(t,a,b)
def common_equality(+a:Nat,+b:Nat,+c:Nat) -> {Nat.is_eq(Nat.add(a,c),Nat.add(b,c)) == Nat.is_eq(a,b) : Bool}:
  %F.add_comm(c,a) : {Nat.is_eq(_,Nat.add(b,c)) == Nat.is_eq(a,b) : Bool}
  %F.add_comm(c,b) : {Nat.is_eq(Nat.add(c,a),_) == Nat.is_eq(a,b) : Bool}
  eq_common(c,a,b)
def weighted_equality(+w:Nat,+v:Nat,+pp:Nat,+np:Nat,+pq:Nat,+nq:Nat,+k:Nat,+l:Nat,hp:{Nat.add(w,np) == pp : Nat},hq:{Nat.add(v,pq) == nq : Nat}) -> {Nat.is_eq(Nat.add(Nat.mul(pp,k),Nat.mul(pq,l)),Nat.add(Nat.mul(np,k),Nat.mul(nq,l))) == Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v)) : Bool}:
  %hp : {Nat.is_eq(Nat.add(Nat.mul(_,k),Nat.mul(pq,l)),Nat.add(Nat.mul(np,k),Nat.mul(nq,l))) == Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v)) : Bool}
  %hq : {Nat.is_eq(Nat.add(Nat.mul(Nat.add(w,np),k),Nat.mul(pq,l)),Nat.add(Nat.mul(np,k),Nat.mul(_,l))) == Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v)) : Bool}
  %Equal.sym(Nat,Nat.add(Nat.mul(Nat.add(w,np),k),Nat.mul(pq,l)),Nat.add(Nat.mul(k,w),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))),Gap.gap_right(w,np,pq,k,l)) : {Nat.is_eq(_,Nat.add(Nat.mul(np,k),Nat.mul(Nat.add(v,pq),l))) == Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v)) : Bool}
  %Equal.sym(Nat,Nat.add(Nat.mul(np,k),Nat.mul(Nat.add(v,pq),l)),Nat.add(Nat.mul(l,v),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))),Gap.gap_left(v,np,pq,k,l)) : {Nat.is_eq(Nat.add(Nat.mul(k,w),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))),_) == Nat.is_eq(Nat.mul(k,w),Nat.mul(l,v)) : Bool}
  common_equality(Nat.mul(k,w),Nat.mul(l,v),Nat.add(Nat.mul(np,k),Nat.mul(pq,l)))
def area_on_line(a:N.Point,b:N.Point,p:G.Point) -> {Nat.is_eq(A.positive(a,b,p),A.negative(a,b,p)) == Cut.on_line(a,b,p) : Bool}:
  match a b p:
    case N.P{ax,ay} N.P{bx,by} G.P{x,y,d}: {==}
def joined_line(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat) -> {Nat.is_eq(Nat.add(Nat.mul(A.positive(a,b,p),k),Nat.mul(A.positive(a,b,q),l)),Nat.add(Nat.mul(A.negative(a,b,p),k),Nat.mul(A.negative(a,b,q),l))) == Cut.on_line(a,b,C.join(p,q,k,l)) : Bool}:
  %CutP.cut_positive_join(a,b,p,q,k,l) : {Nat.is_eq(_,Nat.add(Nat.mul(A.negative(a,b,p),k),Nat.mul(A.negative(a,b,q),l))) == Cut.on_line(a,b,C.join(p,q,k,l)) : Bool}
  %CutP.cut_negative_join(a,b,p,q,k,l) : {Nat.is_eq(A.positive(a,b,C.join(p,q,k,l)),_) == Cut.on_line(a,b,C.join(p,q,k,l)) : Bool}
  area_on_line(a,b,C.join(p,q,k,l))
def L.ratio_on_line_exact(a,b,p,q,k,l,hp,hq):
  Equal.trans(Bool,M.ratio(a,b,p,q,k,l),Nat.is_eq(Nat.add(Nat.mul(A.positive(a,b,p),k),Nat.mul(A.positive(a,b,q),l)),Nat.add(Nat.mul(A.negative(a,b,p),k),Nat.mul(A.negative(a,b,q),l))),Cut.on_line(a,b,C.join(p,q,k,l)),Equal.sym(Bool,Nat.is_eq(Nat.add(Nat.mul(A.positive(a,b,p),k),Nat.mul(A.positive(a,b,q),l)),Nat.add(Nat.mul(A.negative(a,b,p),k),Nat.mul(A.negative(a,b,q),l))),M.ratio(a,b,p,q,k,l),weighted_equality(Cut.second_weight(a,b,p),Cut.first_weight(a,b,q),A.positive(a,b,p),A.negative(a,b,p),A.positive(a,b,q),A.negative(a,b,q),k,l,AL.area_reconstruct(a,b,p,hp),O.sub_add_cancel(A.negative(a,b,q),A.positive(a,b,q),O.le_of_lt(A.positive(a,b,q),A.negative(a,b,q),CutP.cut_negative_lt(a,b,q,hq))))),joined_line(a,b,p,q,k,l))
def boundary_ratio(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,hp:{Region.edge(a,b,p) == True{} : Bool},hq:{S.negative(a,b,q) == True{} : Bool},h:{Cut.on_line(a,b,C.join(p,q,k,l)) == True{} : Bool}) -> {M.ratio(a,b,p,q,k,l) == True{} : Bool}:
  Equal.trans(Bool,M.ratio(a,b,p,q,k,l),Cut.on_line(a,b,C.join(p,q,k,l)),True{},L.ratio_on_line_exact(a,b,p,q,k,l,hp,hq),h)
def L.boundary_same_cut(a,b,p,q,k,l,hp,hq,h):
  PL.proportional_same_point(p,q,k,l,Cut.first_weight(a,b,q),Cut.second_weight(a,b,p),boundary_ratio(a,b,p,q,k,l,hp,hq,h))
def L.boundary_region_same_cut(a,b,p,q,r,k,l,hp,hq,h,hpd,hqd,hs):
  PL.proportional_region_exact(p,q,r,k,l,Cut.first_weight(a,b,q),Cut.second_weight(a,b,p),boundary_ratio(a,b,p,q,k,l,hp,hq,h),hpd,hqd,hs,CutL.crossing_total_positive(a,b,p,q,hq))
