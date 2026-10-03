import Base
import ./tracked-candidates.bend as M
import ./tracked-candidates-laws.bend as L
import ./tracked-interval.bend as Trace
import ./tracked-interval-laws.bend as TraceL
import ./tracked-interval-proof.bend as TraceProof
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./source-boundary-laws.bend as BoundaryL
import ./source-boundary-proof.bend as BoundaryProof
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S
import ./strict-halfplane-proof.bend as SP
import ./interval-walk.bend as Walk
import ./interval-walk-laws.bend as WalkL
import ./interval-walk-proof.bend as WalkProof
import ./interval-clip.bend as Clip
import ./natural-cover.bend as N
import ./boolean-reflection.bend as B

def L.label_exact(p,q,r,origin):
  match origin:
    case Trace.SourceLeft{}: {==}
    case Trace.SourceRight{}: {==}
    case Trace.Boundary{a,b}: {==}
def L.endpoint_exact(p,q,end):
  match end:
    case Trace.End{k,l,origin}: L.label_exact(p,q,Trace.point(p,q,Trace.End{k,l,origin}),origin)
def conjunction_cong(+a:Bool,+b:Bool,+u:Bool,+v:Bool,ha:{a == u : Bool},hb:{b == v : Bool}) -> {a && b == u && v : Bool}:
  Equal.trans(Bool,a && b,u && b,u && v,Equal.cong(Bool,Bool,x => x && b,a,u,ha),Equal.cong(Bool,Bool,x => u && x,b,v,hb))
def L.candidates_exact(p,q,state):
  match state:
    case Trace.Lost{}: {==}
    case Trace.Segment{+left,+right}: conjunction_cong(M.endpoint(p,q,left),M.endpoint(p,q,right),L.endpoint_spec(p,q,left),L.endpoint_spec(p,q,right),L.endpoint_exact(p,q,left),L.endpoint_exact(p,q,right))
def L.initial_candidates(p,q): TraceL.initial_honest(p,q)
def cut_candidate(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,left:Trace.Endpoint,right:Trace.Endpoint,+hv:{G.positive_denominator(Trace.point(p,q,left)) == True{} : Bool},+hi:{Region.edge(a,b,Trace.point(p,q,left)) == True{} : Bool},+ho:{S.negative(a,b,Trace.point(p,q,right)) == True{} : Bool}) -> {M.endpoint(p,q,Trace.cut_endpoint(a,b,p,q,left,right)) == True{} : Bool}:
  match left right:
    case Trace.End{+k,+l,+lo} Trace.End{+m,+n,+ro}: B.and_join(Cross.crosses(a,b,p,q),G.equivalent(Trace.point(p,q,Trace.cut_endpoint(a,b,p,q,Trace.End{k,l,lo},Trace.End{m,n,ro})),Boundary.direct(a,b,p,q)),BoundaryL.traced_cut_crosses(a,b,p,q,Trace.End{k,l,lo},Trace.End{m,n,ro},hv,hi,ho),BoundaryL.traced_cut_direct(a,b,p,q,Trace.End{k,l,lo},Trace.End{m,n,ro},hv,hi,ho))
def choose_candidates(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:Trace.Endpoint,+right:Trace.Endpoint,cp:Bool,cq:Bool,+vl:{G.positive_denominator(Trace.point(p,q,left)) == True{} : Bool},+vr:{G.positive_denominator(Trace.point(p,q,right)) == True{} : Bool},hl:{M.endpoint(p,q,left) == True{} : Bool},hr:{M.endpoint(p,q,right) == True{} : Bool},hi:{Region.edge(a,b,Trace.point(p,q,left)) == cp : Bool},ho:{Region.edge(a,b,Trace.point(p,q,right)) == cq : Bool}) -> {M.candidates(p,q,Trace.choose(a,b,p,q,left,right,cp,cq)) == True{} : Bool}:
  match cp cq:
    case True{} True{}: B.and_join(M.endpoint(p,q,left),M.endpoint(p,q,right),hl,hr)
    case True{} False{}: B.and_join(M.endpoint(p,q,left),M.endpoint(p,q,Trace.cut_endpoint(a,b,p,q,left,right)),hl,cut_candidate(a,b,p,q,left,right,vl,hi,SP.negative_from_false(a,b,Trace.point(p,q,right),ho)))
    case False{} True{}: B.and_join(M.endpoint(p,q,right),M.endpoint(p,q,Trace.cut_endpoint(a,b,p,q,right,left)),hr,cut_candidate(a,b,p,q,right,left,vr,ho,SP.negative_from_false(a,b,Trace.point(p,q,left),hi)))
    case False{} False{}: {==}
def candidate_pair(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:Trace.Endpoint,+right:Trace.Endpoint,+vl:{G.positive_denominator(Trace.point(p,q,left)) == True{} : Bool},+vr:{G.positive_denominator(Trace.point(p,q,right)) == True{} : Bool},h:{M.endpoint(p,q,left) == True{} : Bool} & {M.endpoint(p,q,right) == True{} : Bool}) -> {M.candidates(p,q,Trace.step(p,q,Walk.Halfplane{a,b},Trace.Segment{left,right})) == True{} : Bool}:
  match h:
    case (hl,hr): choose_candidates(a,b,p,q,left,right,Region.edge(a,b,Trace.point(p,q,left)),Region.edge(a,b,Trace.point(p,q,right)),vl,vr,hl,hr,{==},{==})
def valid_pair(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:Trace.Endpoint,+right:Trace.Endpoint,hv:{G.positive_denominator(Trace.point(p,q,left)) == True{} : Bool} & {G.positive_denominator(Trace.point(p,q,right)) == True{} : Bool},hc:{M.candidates(p,q,Trace.Segment{left,right}) == True{} : Bool}) -> {M.candidates(p,q,Trace.step(p,q,Walk.Halfplane{a,b},Trace.Segment{left,right})) == True{} : Bool}:
  match hv:
    case (vl,vr): candidate_pair(a,b,p,q,left,right,vl,vr,B.and_split(M.endpoint(p,q,left),M.endpoint(p,q,right),hc))
def L.step_candidates(p,q,edge,state,hv,hc):
  match edge state:
    case Walk.Halfplane{a,b} Trace.Lost{}: {==}
    case Walk.Halfplane{a,b} Trace.Segment{+left,+right}: valid_pair(a,b,p,q,left,right,B.and_split(G.positive_denominator(Trace.point(p,q,left)),G.positive_denominator(Trace.point(p,q,right)),hv),hc)
def step_valid(+p:G.Point,+q:G.Point,+edge:Walk.Edge,+state:Trace.Traced,h:{Walk.valid(Trace.erase(p,q,state)) == True{} : Bool}) -> {Walk.valid(Trace.erase(p,q,Trace.step(p,q,edge,state))) == True{} : Bool}:
  Equal.trans(Bool,Walk.valid(Trace.erase(p,q,Trace.step(p,q,edge,state))),Walk.valid(Walk.step(edge,Trace.erase(p,q,state))),True{},Equal.cong(Clip.ClipResult,Bool,r => Walk.valid(r),Trace.erase(p,q,Trace.step(p,q,edge,state)),Walk.step(edge,Trace.erase(p,q,state)),TraceL.step_erases(p,q,edge,state)),WalkL.step_valid(edge,Trace.erase(p,q,state),h))
def L.run_candidates(p,q,edges,state,hv,hc):
  match edges:
    case []: hc
    case +edge <> rest: L.run_candidates(p,q,rest,Trace.step(p,q,edge,state),step_valid(p,q,edge,state,hv),L.step_candidates(p,q,edge,state,hv,hc))
def initial_valid(+p:G.Point,+q:G.Point,hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool}) -> {Walk.valid(Trace.erase(p,q,Trace.initial())) == True{} : Bool}:
  Equal.trans(Bool,Walk.valid(Trace.erase(p,q,Trace.initial())),Walk.valid(Clip.Span{p,q}),True{},Equal.cong(Clip.ClipResult,Bool,r => Walk.valid(r),Trace.erase(p,q,Trace.initial()),Clip.Span{p,q},TraceL.initial_erases(p,q)),B.and_join(G.positive_denominator(p),G.positive_denominator(q),hp,hq))
def L.quad_candidates(p,q,quad,hp,hq):
  L.run_candidates(p,q,Walk.quad_edges(quad),Trace.initial(),initial_valid(p,q,hp,hq),L.initial_candidates(p,q))

def retained_candidates(+p:G.Point,+q:G.Point,+quad:N.Quad,+state:Trace.Traced,hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool},h:{Trace.clip_quad(p,q,quad) == state : Trace.Traced}) -> {M.candidates(p,q,state) == True{} : Bool}:
  %h : {M.candidates(p,q,_) == True{} : Bool}
  L.quad_candidates(p,q,quad,hp,hq)
def boundary_components(+p:G.Point,+q:G.Point,+a:N.Point,+b:N.Point,+k:Nat,+l:Nat,h:{M.endpoint(p,q,Trace.End{k,l,Trace.Boundary{a,b}}) == True{} : Bool}) -> {Cross.crosses(a,b,p,q) == True{} : Bool} & {G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)) == True{} : Bool}:
  B.and_split(Cross.crosses(a,b,p,q),G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)),h)
def retained_left_pair(+p:G.Point,+q:G.Point,+a:N.Point,+b:N.Point,+k:Nat,+l:Nat,right:Trace.Endpoint,h:{M.endpoint(p,q,Trace.End{k,l,Trace.Boundary{a,b}}) == True{} : Bool} & {M.endpoint(p,q,right) == True{} : Bool}) -> {Cross.crosses(a,b,p,q) == True{} : Bool} & {G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)) == True{} : Bool}:
  match h:
    case (hl,hr): boundary_components(p,q,a,b,k,l,hl)
def retained_left_components(+p:G.Point,+q:G.Point,+a:N.Point,+b:N.Point,+k:Nat,+l:Nat,+right:Trace.Endpoint,h:{M.candidates(p,q,Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right}) == True{} : Bool}) -> {Cross.crosses(a,b,p,q) == True{} : Bool} & {G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)) == True{} : Bool}:
  retained_left_pair(p,q,a,b,k,l,right,B.and_split(M.endpoint(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),M.endpoint(p,q,right),h))
def L.retained_left_boundary(p,q,quad,a,b,k,l,right,hp,hq,h):
  retained_left_components(p,q,a,b,k,l,right,retained_candidates(p,q,quad,Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right},hp,hq,h))
def retained_right_pair(+p:G.Point,+q:G.Point,+a:N.Point,+b:N.Point,+k:Nat,+l:Nat,left:Trace.Endpoint,h:{M.endpoint(p,q,left) == True{} : Bool} & {M.endpoint(p,q,Trace.End{k,l,Trace.Boundary{a,b}}) == True{} : Bool}) -> {Cross.crosses(a,b,p,q) == True{} : Bool} & {G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)) == True{} : Bool}:
  match h:
    case (hl,hr): boundary_components(p,q,a,b,k,l,hr)
def retained_right_components(+p:G.Point,+q:G.Point,+a:N.Point,+b:N.Point,+k:Nat,+l:Nat,+left:Trace.Endpoint,h:{M.candidates(p,q,Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}}) == True{} : Bool}) -> {Cross.crosses(a,b,p,q) == True{} : Bool} & {G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)) == True{} : Bool}:
  retained_right_pair(p,q,a,b,k,l,left,B.and_split(M.endpoint(p,q,left),M.endpoint(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),h))
def L.retained_right_boundary(p,q,quad,a,b,k,l,left,hp,hq,h):
  retained_right_components(p,q,a,b,k,l,left,retained_candidates(p,q,quad,Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}},hp,hq,h))
