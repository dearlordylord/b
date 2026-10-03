import Base
import ./clip-halfplane.bend as M
import ./clip-halfplane-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-proof.bend as CP
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S
import ./segment-cut.bend as Cut
import ./segment-cut-proof.bend as CutP
import ./triangle-area.bend as A
import ./triangle-area-laws.bend as AL
import ./triangle-area-proof.bend as AP
import ./clip-weights-laws.bend as WL
import ./clip-weights-proof.bend as WP
import ./order-facts.bend as O
import ./facts.bend as F
import ./triangle-coordinate.bend as Scale
import ./triangle-coordinate-proof.bend as Coord
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-geometry-proof.bend as GP
import ./segment-cut-laws.bend as CutL
import ./boolean-reflection.bend as B

def gap_left(+v:Nat,+np:Nat,+pq:Nat,+k:Nat,+l:Nat) -> {Nat.add(Nat.mul(np,k),Nat.mul(Nat.add(v,pq),l)) == Nat.add(Nat.mul(l,v),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))) : Nat}:
  %Equal.sym(Nat,Nat.mul(Nat.add(v,pq),l),Nat.add(Nat.mul(v,l),Nat.mul(pq,l)),F.add_mul(v,pq,l)) : {Nat.add(Nat.mul(np,k),_) == Nat.add(Nat.mul(l,v),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))) : Nat}
  %Equal.sym(Nat,Nat.mul(v,l),Nat.mul(l,v),F.mul_comm(v,l)) : {Nat.add(Nat.mul(np,k),Nat.add(_,Nat.mul(pq,l))) == Nat.add(Nat.mul(l,v),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))) : Nat}
  F.add_left_comm(Nat.mul(np,k),Nat.mul(l,v),Nat.mul(pq,l))
def gap_right(+w:Nat,+np:Nat,+pq:Nat,+k:Nat,+l:Nat) -> {Nat.add(Nat.mul(Nat.add(w,np),k),Nat.mul(pq,l)) == Nat.add(Nat.mul(k,w),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))) : Nat}:
  %Equal.sym(Nat,Nat.mul(Nat.add(w,np),k),Nat.add(Nat.mul(w,k),Nat.mul(np,k)),F.add_mul(w,np,k)) : {Nat.add(_,Nat.mul(pq,l)) == Nat.add(Nat.mul(k,w),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))) : Nat}
  %Equal.sym(Nat,Nat.mul(w,k),Nat.mul(k,w),F.mul_comm(w,k)) : {Nat.add(Nat.add(_,Nat.mul(np,k)),Nat.mul(pq,l)) == Nat.add(Nat.mul(k,w),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))) : Nat}
  F.add_assoc(Nat.mul(k,w),Nat.mul(np,k),Nat.mul(pq,l))
def le_common_exact(c:Nat,+a:Nat,+b:Nat) -> {Nat.is_le(Nat.add(c,a),Nat.add(c,b)) == Nat.is_le(a,b) : Bool}:
  match c:
    case 0n: {==}
    case 1n+t: le_common_exact(t,a,b)
def common_comparison(+a:Nat,+b:Nat,+c:Nat) -> {Nat.is_le(Nat.add(a,c),Nat.add(b,c)) == Nat.is_le(a,b) : Bool}:
  %F.add_comm(c,a) : {Nat.is_le(_,Nat.add(b,c)) == Nat.is_le(a,b) : Bool}
  %F.add_comm(c,b) : {Nat.is_le(Nat.add(c,a),_) == Nat.is_le(a,b) : Bool}
  le_common_exact(c,a,b)
def weighted_comparison(+w:Nat,+v:Nat,+pp:Nat,+np:Nat,+pq:Nat,+nq:Nat,+k:Nat,+l:Nat,hp:{Nat.add(w,np) == pp : Nat},hq:{Nat.add(v,pq) == nq : Nat}) -> {Nat.is_le(Nat.add(Nat.mul(np,k),Nat.mul(nq,l)),Nat.add(Nat.mul(pp,k),Nat.mul(pq,l))) == Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) : Bool}:
  %hp : {Nat.is_le(Nat.add(Nat.mul(np,k),Nat.mul(nq,l)),Nat.add(Nat.mul(_,k),Nat.mul(pq,l))) == Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) : Bool}
  %hq : {Nat.is_le(Nat.add(Nat.mul(np,k),Nat.mul(_,l)),Nat.add(Nat.mul(Nat.add(w,np),k),Nat.mul(pq,l))) == Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) : Bool}
  %Equal.sym(Nat,Nat.add(Nat.mul(np,k),Nat.mul(Nat.add(v,pq),l)),Nat.add(Nat.mul(l,v),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))),gap_left(v,np,pq,k,l)) : {Nat.is_le(_,Nat.add(Nat.mul(Nat.add(w,np),k),Nat.mul(pq,l))) == Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) : Bool}
  %Equal.sym(Nat,Nat.add(Nat.mul(Nat.add(w,np),k),Nat.mul(pq,l)),Nat.add(Nat.mul(k,w),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))),gap_right(w,np,pq,k,l)) : {Nat.is_le(Nat.add(Nat.mul(l,v),Nat.add(Nat.mul(np,k),Nat.mul(pq,l))),_) == Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) : Bool}
  common_comparison(Nat.mul(l,v),Nat.mul(k,w),Nat.add(Nat.mul(np,k),Nat.mul(pq,l)))
def joined_comparison(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat) -> {Nat.is_le(Nat.add(Nat.mul(A.negative(a,b,p),k),Nat.mul(A.negative(a,b,q),l)),Nat.add(Nat.mul(A.positive(a,b,p),k),Nat.mul(A.positive(a,b,q),l))) == Region.edge(a,b,C.join(p,q,k,l)) : Bool}:
  %CutP.cut_negative_join(a,b,p,q,k,l) : {Nat.is_le(_,Nat.add(Nat.mul(A.positive(a,b,p),k),Nat.mul(A.positive(a,b,q),l))) == Region.edge(a,b,C.join(p,q,k,l)) : Bool}
  %CutP.cut_positive_join(a,b,p,q,k,l) : {Nat.is_le(A.negative(a,b,C.join(p,q,k,l)),_) == Region.edge(a,b,C.join(p,q,k,l)) : Bool}
  Equal.trans(Bool,Nat.is_le(A.negative(a,b,C.join(p,q,k,l)),A.positive(a,b,C.join(p,q,k,l))),Bool.not(Cmp.is_lt(Nat.cmp(A.positive(a,b,C.join(p,q,k,l)),A.negative(a,b,C.join(p,q,k,l))))),Region.edge(a,b,C.join(p,q,k,l)),Equal.sym(Bool,Bool.not(Cmp.is_lt(Nat.cmp(A.positive(a,b,C.join(p,q,k,l)),A.negative(a,b,C.join(p,q,k,l))))),Nat.is_le(A.negative(a,b,C.join(p,q,k,l)),A.positive(a,b,C.join(p,q,k,l))),CP.nonnegative_le(A.positive(a,b,C.join(p,q,k,l)),A.negative(a,b,C.join(p,q,k,l)))),Equal.sym(Bool,Region.edge(a,b,C.join(p,q,k,l)),Bool.not(Cmp.is_lt(Nat.cmp(A.positive(a,b,C.join(p,q,k,l)),A.negative(a,b,C.join(p,q,k,l))))),AP.area_side_equation(a,b,C.join(p,q,k,l))))
def L.closed_join_balance_exact(a,b,p,q,k,l,hp,hq):
  Equal.trans(Bool,M.balance(a,b,p,q,k,l),Nat.is_le(Nat.add(Nat.mul(A.negative(a,b,p),k),Nat.mul(A.negative(a,b,q),l)),Nat.add(Nat.mul(A.positive(a,b,p),k),Nat.mul(A.positive(a,b,q),l))),Region.edge(a,b,C.join(p,q,k,l)),Equal.sym(Bool,Nat.is_le(Nat.add(Nat.mul(A.negative(a,b,p),k),Nat.mul(A.negative(a,b,q),l)),Nat.add(Nat.mul(A.positive(a,b,p),k),Nat.mul(A.positive(a,b,q),l))),M.balance(a,b,p,q,k,l),weighted_comparison(Cut.second_weight(a,b,p),Cut.first_weight(a,b,q),A.positive(a,b,p),A.negative(a,b,p),A.positive(a,b,q),A.negative(a,b,q),k,l,AL.area_reconstruct(a,b,p,hp),O.sub_add_cancel(A.negative(a,b,q),A.positive(a,b,q),O.le_of_lt(A.positive(a,b,q),A.negative(a,b,q),CutP.cut_negative_lt(a,b,q,hq))))),joined_comparison(a,b,p,q,k,l))
def L.closed_join_balance(a,b,p,q,k,l,hp,hq,h):
  Equal.trans(Bool,M.balance(a,b,p,q,k,l),Region.edge(a,b,C.join(p,q,k,l)),True{},L.closed_join_balance_exact(a,b,p,q,k,l,hp,hq),h)
def L.positive_gap_retained_member(a,b,p,q,k,l,hp,hq,h,hs,hw,hpd,hqd):
  WL.rebase_segment_member(p,q,k,l,Cut.second_weight(a,b,p),Cut.first_weight(a,b,q),L.closed_join_balance(a,b,p,q,k,l,hp,hq,h),hs,hw,hpd,hqd)

def L.halfplane_rebase_exact(a,b,p,q,k,l,hp,hq,h):
  WL.rebase_exact(p,q,k,l,Cut.second_weight(a,b,p),Cut.first_weight(a,b,q),L.closed_join_balance(a,b,p,q,k,l,hp,hq,h))
def scaled_positive(p:G.Point,+w:Nat,hp:{G.positive_denominator(p) == True{} : Bool},hw:{Nat.is_gt(w,0n) == True{} : Bool}) -> {G.positive_denominator(Scale.scaled(p,w)) == True{} : Bool}:
  match p:
    case G.P{x,y,+d}: AP.area_positive_product(d,w,hp,hw)
def valid_from_scale(+old:G.Point,+new:G.Point,+w:Nat,+he:{new == Scale.scaled(old,w) : G.Point},hp:{G.positive_denominator(old) == True{} : Bool},hw:{Nat.is_gt(w,0n) == True{} : Bool}) -> {G.positive_denominator(new) == True{} : Bool} & {G.equivalent(old,new) == True{} : Bool}:
  (Equal.trans(Bool,G.positive_denominator(new),G.positive_denominator(Scale.scaled(old,w)),True{},Equal.cong(G.Point,Bool,G.positive_denominator,new,Scale.scaled(old,w),he),scaled_positive(old,w,hp,hw)),Equal.trans(Bool,G.equivalent(old,new),G.equivalent(old,Scale.scaled(old,w)),True{},Equal.cong(G.Point,Bool,x => G.equivalent(old,x),new,Scale.scaled(old,w),he),Coord.coord_scaled_equivalent(old,w)))
def L.positive_gap_rebased_valid(a,b,p,q,k,l,hp,hq,h,hs,hw,hpd,hqd):
  valid_from_scale(C.join(p,q,k,l),M.rebased(a,b,p,q,k,l),Cut.second_weight(a,b,p),L.halfplane_rebase_exact(a,b,p,q,k,l,hp,hq,h),CL.joined_denominator_positive(p,q,k,l,hpd,hqd,hs),hw)

def gt_zero_le_zero_impossible(n:Nat,hg:{Nat.is_gt(n,0n) == True{} : Bool},hl:{Nat.is_le(n,0n) == True{} : Bool}) -> Empty:
  match n:
    case 0n: B.false_impossible(hg)
    case 1n+t: B.false_impossible(hl)
def positive_factor_zero_coefficient(l:Nat,+v:Nat,hv:{Nat.is_gt(v,0n) == True{} : Bool},h:{Nat.is_le(Nat.mul(l,v),0n) == True{} : Bool}) -> {l == 0n : Nat}:
  match l:
    case 0n: {==}
    case 1n++t: B.absurd({1n+t == 0n : Nat},gt_zero_le_zero_impossible(Nat.mul(1n+t,v),AP.area_positive_product(1n+t,v,{==},hv),h))
def zero_gap_bound(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,hw:{Cut.second_weight(a,b,p) == 0n : Nat},h:{M.balance(a,b,p,q,k,l) == True{} : Bool}) -> {Nat.is_le(Nat.mul(l,Cut.first_weight(a,b,q)),0n) == True{} : Bool}:
  %F.mul_zero(k) : {Nat.is_le(Nat.mul(l,Cut.first_weight(a,b,q)),_) == True{} : Bool}
  %hw : {Nat.is_le(Nat.mul(l,Cut.first_weight(a,b,q)),Nat.mul(k,_)) == True{} : Bool}
  h
def L.zero_gap_second_weight_zero(a,b,p,q,k,l,hp,hq,h,hw):
  positive_factor_zero_coefficient(l,Cut.first_weight(a,b,q),CutL.negative_gap_positive(a,b,q,hq),zero_gap_bound(a,b,p,q,k,l,hw,L.closed_join_balance(a,b,p,q,k,l,hp,hq,h)))
def scaled_zero_drop(+a:Nat,+b:Nat,+k:Nat) -> {Nat.add(Nat.mul(a,k),Nat.mul(b,0n)) == Nat.mul(a,k) : Nat}:
  Equal.trans(Nat,Nat.add(Nat.mul(a,k),Nat.mul(b,0n)),Nat.add(Nat.mul(a,k),0n),Nat.mul(a,k),Equal.cong(Nat,Nat,x => Nat.add(Nat.mul(a,k),x),Nat.mul(b,0n),0n,F.mul_zero(b)),F.add_zero(Nat.mul(a,k)))
def zero_right_join(p:G.Point,q:G.Point,+k:Nat) -> {C.join(p,q,k,0n) == Scale.scaled(p,k) : G.Point}:
  match p q:
    case G.P{+x,+y,+d} G.P{+u,+v,+e}: GP.point_equal(Nat.add(Nat.mul(x,k),Nat.mul(u,0n)),Nat.add(Nat.mul(y,k),Nat.mul(v,0n)),Nat.add(Nat.mul(d,k),Nat.mul(e,0n)),Nat.mul(x,k),Nat.mul(y,k),Nat.mul(d,k),scaled_zero_drop(x,u,k),scaled_zero_drop(y,v,k),scaled_zero_drop(d,e,k))
def zero_l_member(+p:G.Point,+q:G.Point,+cut:G.Point,+k:Nat,+hs:{Nat.is_gt(Nat.add(k,0n),0n) == True{} : Bool},+hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool},hc:{G.positive_denominator(cut) == True{} : Bool}) -> Cut.InSegment(p,cut,C.join(p,q,k,0n)):
  (k,(0n,(hs,(hp,(hc,(CL.joined_denominator_positive(p,q,k,0n,hp,hq,hs),Equal.trans(Bool,G.equivalent(C.join(p,q,k,0n),C.join(p,cut,k,0n)),G.equivalent(C.join(p,q,k,0n),Scale.scaled(p,k)),True{},Equal.cong(G.Point,Bool,x => G.equivalent(C.join(p,q,k,0n),x),C.join(p,cut,k,0n),Scale.scaled(p,k),zero_right_join(p,cut,k)),Equal.trans(Bool,G.equivalent(C.join(p,q,k,0n),Scale.scaled(p,k)),G.equivalent(Scale.scaled(p,k),Scale.scaled(p,k)),True{},Equal.cong(G.Point,Bool,x => G.equivalent(x,Scale.scaled(p,k)),C.join(p,q,k,0n),Scale.scaled(p,k),zero_right_join(p,q,k)),CutP.cut_equivalent_self(Scale.scaled(p,k))))))))))
def boundary_member_transport(+p:G.Point,+q:G.Point,+cut:G.Point,+k:Nat,+l:Nat,+hl:{l == 0n : Nat},hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool},hc:{G.positive_denominator(cut) == True{} : Bool}) -> Cut.InSegment(p,cut,C.join(p,q,k,l)):
  %Equal.sym(Nat,l,0n,hl) : Cut.InSegment(p,cut,C.join(p,q,k,_))
  zero_l_member(p,q,cut,k,Equal.trans(Bool,Nat.is_gt(Nat.add(k,0n),0n),Nat.is_gt(Nat.add(k,l),0n),True{},Equal.cong(Nat,Bool,x => Nat.is_gt(Nat.add(k,x),0n),0n,l,Equal.sym(Nat,l,0n,hl)),hs),hp,hq,hc)
def L.zero_gap_retained_member(a,b,p,q,k,l,hp,hq,h,hs,hw,hpd,hqd):
  boundary_member_transport(p,q,Cut.point(a,b,p,q),k,l,L.zero_gap_second_weight_zero(a,b,p,q,k,l,hp,hq,h,hw),hs,hpd,hqd,CutL.crossing_denominator_positive(a,b,p,q,hpd,hqd,hq))
def choose_gap(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,w:Nat,he:{w == Cut.second_weight(a,b,p) : Nat},hp:{Region.edge(a,b,p) == True{} : Bool},hq:{S.negative(a,b,q) == True{} : Bool},h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool},hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},hpd:{G.positive_denominator(p) == True{} : Bool},hqd:{G.positive_denominator(q) == True{} : Bool}) -> Cut.InSegment(p,Cut.point(a,b,p,q),C.join(p,q,k,l)):
  match w:
    case 0n: L.zero_gap_retained_member(a,b,p,q,k,l,hp,hq,h,hs,Equal.sym(Nat,0n,Cut.second_weight(a,b,p),he),hpd,hqd)
    case 1n++t: L.positive_gap_retained_member(a,b,p,q,k,l,hp,hq,h,hs,Equal.trans(Bool,Nat.is_gt(Cut.second_weight(a,b,p),0n),Nat.is_gt(1n+t,0n),True{},Equal.cong(Nat,Bool,x => Nat.is_gt(x,0n),Cut.second_weight(a,b,p),1n+t,Equal.sym(Nat,1n+t,Cut.second_weight(a,b,p),he)),{==}),hpd,hqd)
def L.retained_member_all_gaps(a,b,p,q,k,l,hp,hq,h,hs,hpd,hqd):
  choose_gap(a,b,p,q,k,l,Cut.second_weight(a,b,p),{==},hp,hq,h,hs,hpd,hqd)
