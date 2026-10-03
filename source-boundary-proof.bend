import Base
import ./source-boundary.bend as M
import ./source-boundary-laws.bend as L
import ./source-crossing.bend as Cross
import ./source-crossing-laws.bend as CrossL
import ./source-crossing-proof.bend as CrossProof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-proof.bend as CP
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut
import ./segment-boundary-laws.bend as BoundaryL
import ./segment-boundary-proof.bend as BoundaryProof
import ./strict-halfplane-proof.bend as SP
import ./tracked-interval.bend as Trace
import ./tracked-cut-proof.bend as CutTrace
import ./strict-halfplane.bend as S
import ./boolean-reflection.bend as B

def L.direct_exact(a,b,p,q): {==}
def L.choose_exact(a,b,p,q): ({==},{==})
def reversed_line(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,h:{Cut.on_line(a,b,C.join(p,q,k,l)) == True{} : Bool}) -> {Cut.on_line(a,b,C.join(q,p,l,k)) == True{} : Bool}:
  Equal.trans(Bool,Cut.on_line(a,b,C.join(q,p,l,k)),Cut.on_line(a,b,C.join(p,q,k,l)),True{},Equal.cong(G.Point,Bool,r => Cut.on_line(a,b,r),C.join(q,p,l,k),C.join(p,q,k,l),CP.join_reversed(p,q,k,l)),h)
def boundary_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,cp:Bool,cq:Bool,hp:{Region.edge(a,b,p) == cp : Bool},hq:{Region.edge(a,b,q) == cq : Bool},hc:{Cross.different(cp,cq) == True{} : Bool},hl:{Cut.on_line(a,b,C.join(p,q,k,l)) == True{} : Bool}) -> {G.equivalent(C.join(p,q,k,l),M.choose(a,b,p,q,cp)) == True{} : Bool}:
  match cp cq:
    case True{} False{}: BoundaryL.boundary_same_cut(a,b,p,q,k,l,hp,SP.negative_from_false(a,b,q,hq),hl)
    case False{} True{}: Equal.trans(Bool,G.equivalent(C.join(p,q,k,l),Cut.point(a,b,q,p)),G.equivalent(C.join(q,p,l,k),Cut.point(a,b,q,p)),True{},Equal.cong(G.Point,Bool,r => G.equivalent(r,Cut.point(a,b,q,p)),C.join(p,q,k,l),C.join(q,p,l,k),CP.join_reversed(q,p,l,k)),BoundaryL.boundary_same_cut(a,b,q,p,l,k,hq,SP.negative_from_false(a,b,p,hp),reversed_line(a,b,p,q,k,l,hl)))
    case True{} True{}: B.absurd({G.equivalent(C.join(p,q,k,l),M.choose(a,b,p,q,True{})) == True{} : Bool},B.false_impossible(hc))
    case False{} False{}: B.absurd({G.equivalent(C.join(p,q,k,l),M.choose(a,b,p,q,False{})) == True{} : Bool},B.false_impossible(hc))
def L.boundary_direct(a,b,p,q,k,l,hc,hl):
  boundary_cases(a,b,p,q,k,l,Region.edge(a,b,p),Region.edge(a,b,q),{==},{==},hc,hl)
def L.traced_cut_crosses(a,b,p,q,left,right,hv,hi,ho):
  match left right:
    case Trace.End{k,l,lo} Trace.End{m,n,ro}: CrossL.valid_crossing(a,b,p,q,k,l,m,n,hv,hi,ho)

def endpoint_direct(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,end:Trace.Endpoint,hc:{Cross.crosses(a,b,p,q) == True{} : Bool},hl:{Cut.on_line(a,b,Trace.point(p,q,end)) == True{} : Bool}) -> {G.equivalent(Trace.point(p,q,end),M.direct(a,b,p,q)) == True{} : Bool}:
  match end:
    case Trace.End{k,l,origin}: L.boundary_direct(a,b,p,q,k,l,hc,hl)
def L.traced_cut_direct(a,b,p,q,left,right,hv,hi,ho):
  endpoint_direct(a,b,p,q,Trace.cut_endpoint(a,b,p,q,left,right),L.traced_cut_crosses(a,b,p,q,left,right,hv,hi,ho),CutTrace.cut_line(a,b,p,q,left,right,hi,ho))
