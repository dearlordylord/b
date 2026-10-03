import Base
import ./interval-clip.bend as M
import ./interval-clip-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut
import ./segment-cut-laws.bend as CutL
import ./segment-cut-proof.bend as CutP
import ./clip-halfplane-laws.bend as ClipL
import ./clip-halfplane-proof.bend as ClipP
import ./strict-halfplane.bend as S
import ./strict-halfplane-laws.bend as SL
import ./strict-halfplane-proof.bend as SP
import ./boolean-reflection.bend as B
import ./facts.bend as F

def L.choose_exact(a,b,p,q,cp,cq):
  match cp cq:
    case True{} True{}: {==}
    case True{} False{}: {==}
    case False{} True{}: {==}
    case False{} False{}: {==}
def L.clip_exact(a,b,p,q):
  L.choose_exact(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q))
def L.closed_report_exact(a,b,result):
  match result:
    case M.Gone{}: {==}
    case M.Span{p,q}: {==}
def L.region_report_exact(r,result):
  match result:
    case M.Gone{}: {==}
    case M.Span{p,q}: {==}
def L.present_report_exact(result):
  match result:
    case M.Gone{}: {==}
    case M.Span{p,q}: {==}
def negative_from_false(+a:N.Point,+b:N.Point,+p:G.Point,h:{Region.edge(a,b,p) == False{} : Bool}) -> {S.negative(a,b,p) == True{} : Bool}:
  Equal.trans(Bool,S.negative(a,b,p),Bool.not(Region.edge(a,b,p)),True{},SL.negative_closed_complement(a,b,p),Equal.cong(Bool,Bool,x => Bool.not(x),Region.edge(a,b,p),False{},h))
def cmp_eq_closed(side:Cmp,h:{Cmp.is_eq(side) == True{} : Bool}) -> {Bool.not(Cmp.is_lt(side)) == True{} : Bool}:
  match side:
    case LT{}: B.absurd({Bool.not(Cmp.is_lt(LT{})) == True{} : Bool},B.false_impossible(h))
    case EQ{}: {==}
    case GT{}: {==}
def on_line_closed(+a:N.Point,+b:N.Point,+p:G.Point,h:{Cut.on_line(a,b,p) == True{} : Bool}) -> {Region.edge(a,b,p) == True{} : Bool}:
  match a b:
    case N.P{ax,ay} N.P{bx,by}: cmp_eq_closed(G.side(ax,ay,bx,by,p),h)
def span_closed(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool},cp:{Region.edge(a,b,p) == True{} : Bool},cq:{Region.edge(a,b,q) == True{} : Bool}) -> {M.closed_valid(a,b,M.Span{p,q}) == True{} : Bool}:
  B.and_join(G.positive_denominator(p) && G.positive_denominator(q),Region.edge(a,b,p) && Region.edge(a,b,q),B.and_join(G.positive_denominator(p),G.positive_denominator(q),hp,hq),B.and_join(Region.edge(a,b,p),Region.edge(a,b,q),cp,cq))
def closed_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,cp:Bool,cq:Bool,+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},+hcp:{Region.edge(a,b,p) == cp : Bool},+hcq:{Region.edge(a,b,q) == cq : Bool}) -> {M.closed_valid(a,b,M.choose(a,b,p,q,cp,cq)) == True{} : Bool}:
  match cp cq:
    case True{} True{}: span_closed(a,b,p,q,hp,hq,hcp,hcq)
    case True{} False{}: span_closed(a,b,p,Cut.point(a,b,p,q),hp,CutL.crossing_denominator_positive(a,b,p,q,hp,hq,negative_from_false(a,b,q,hcq)),hcp,on_line_closed(a,b,Cut.point(a,b,p,q),CutL.crossing_on_line(a,b,p,q,hcp,negative_from_false(a,b,q,hcq))))
    case False{} True{}: span_closed(a,b,q,Cut.point(a,b,q,p),hq,CutL.crossing_denominator_positive(a,b,q,p,hq,hp,negative_from_false(a,b,p,hcp)),hcq,on_line_closed(a,b,Cut.point(a,b,q,p),CutL.crossing_on_line(a,b,q,p,hcq,negative_from_false(a,b,p,hcp))))
    case False{} False{}: {==}
def L.clip_closed_valid(a,b,p,q,hp,hq):
  closed_cases(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q),hp,hq,{==},{==})
def span_region(+r:N.Quad,+p:G.Point,+q:G.Point,hp:{Region.contains(p,r) == True{} : Bool},hq:{Region.contains(q,r) == True{} : Bool}) -> {M.in_region(r,M.Span{p,q}) == True{} : Bool}:
  B.and_join(Region.contains(p,r),Region.contains(q,r),hp,hq)
def region_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+r:N.Quad,cp:Bool,cq:Bool,+hp:{Region.contains(p,r) == True{} : Bool},+hq:{Region.contains(q,r) == True{} : Bool}) -> {M.in_region(r,M.choose(a,b,p,q,cp,cq)) == True{} : Bool}:
  match cp cq:
    case True{} True{}: span_region(r,p,q,hp,hq)
    case True{} False{}: span_region(r,p,Cut.point(a,b,p,q),hp,CutL.crossing_region_preserved(a,b,p,q,r,hp,hq))
    case False{} True{}: span_region(r,q,Cut.point(a,b,q,p),hq,CutL.crossing_region_preserved(a,b,q,p,r,hq,hp))
    case False{} False{}: {==}
def L.clip_region_preserved(a,b,p,q,r,hp,hq):
  region_cases(a,b,p,q,r,Region.edge(a,b,p),Region.edge(a,b,q),hp,hq)
def present_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+cp:Bool,+cq:Bool) -> {M.present(M.choose(a,b,p,q,cp,cq)) == cp || cq : Bool}:
  match cp cq:
    case True{} True{}: {==}
    case True{} False{}: {==}
    case False{} True{}: {==}
    case False{} False{}: {==}
def L.clip_present_exact(a,b,p,q):
  present_cases(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q))
def outside_weighted_impossible(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,hp:{Region.edge(a,b,p) == False{} : Bool},hq:{Region.edge(a,b,q) == False{} : Bool},hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}) -> Empty:
  SP.strict_closed_impossible(a,b,C.join(p,q,k,l),h,SL.negative_weighted_join(a,b,p,q,k,l,negative_from_false(a,b,p,hp),negative_from_false(a,b,q,hq),hs))
def retained_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,cp:Bool,cq:Bool,hcp:{Region.edge(a,b,p) == cp : Bool},hcq:{Region.edge(a,b,q) == cq : Bool},hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}) -> {M.present(M.choose(a,b,p,q,cp,cq)) == True{} : Bool}:
  match cp cq:
    case True{} True{}: {==}
    case True{} False{}: {==}
    case False{} True{}: {==}
    case False{} False{}: B.absurd({M.present(M.Gone{}) == True{} : Bool},outside_weighted_impossible(a,b,p,q,k,l,hcp,hcq,hs,h))
def L.retained_present(a,b,p,q,k,l,hs,h):
  retained_cases(a,b,p,q,k,l,Region.edge(a,b,p),Region.edge(a,b,q),{==},{==},hs,h)

def reversed_total(+k:Nat,+l:Nat,h:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}) -> {Nat.is_gt(Nat.add(l,k),0n) == True{} : Bool}:
  %F.add_comm(k,l) : {Nat.is_gt(_,0n) == True{} : Bool}
  h
def reversed_closed(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}) -> {Region.edge(a,b,C.join(q,p,l,k)) == True{} : Bool}:
  %Equal.sym(G.Point,C.join(q,p,l,k),C.join(p,q,k,l),CP.join_reversed(p,q,k,l)) : {Region.edge(a,b,_) == True{} : Bool}
  h
def member_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,cp:Bool,cq:Bool,+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},hcp:{Region.edge(a,b,p) == cp : Bool},hcq:{Region.edge(a,b,q) == cq : Bool},+hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}) -> L.Member(M.choose(a,b,p,q,cp,cq),C.join(p,q,k,l)):
  match cp cq:
    case True{} True{}: (k,(l,(hs,(hp,(hq,(CL.joined_denominator_positive(p,q,k,l,hp,hq,hs),CutP.cut_equivalent_self(C.join(p,q,k,l))))))))
    case True{} False{}: ClipL.retained_member_all_gaps(a,b,p,q,k,l,hcp,negative_from_false(a,b,q,hcq),h,hs,hp,hq)
    case False{} True{}:
      %CP.join_reversed(p,q,k,l) : Cut.InSegment(q,Cut.point(a,b,q,p),_)
      ClipL.retained_member_all_gaps(a,b,q,p,l,k,hcq,negative_from_false(a,b,p,hcp),reversed_closed(a,b,p,q,k,l,h),reversed_total(k,l,hs),hq,hp)
    case False{} False{}: outside_weighted_impossible(a,b,p,q,k,l,hcp,hcq,hs,h)
def L.retained_member(a,b,p,q,k,l,hp,hq,hs,h):
  member_cases(a,b,p,q,k,l,Region.edge(a,b,p),Region.edge(a,b,q),hp,hq,{==},{==},hs,h)
