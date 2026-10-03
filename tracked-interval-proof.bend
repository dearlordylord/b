import Base
import ./tracked-interval.bend as M
import ./tracked-cut-proof.bend as CutTrace
import ./tracked-interval-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./homogeneous-source-proof.bend as Basis
import ./segment-cut.bend as Cut
import ./segment-cut-laws.bend as CutL
import ./segment-cut-proof.bend as CutP
import ./segment-provenance-laws.bend as SourceL
import ./segment-provenance-proof.bend as SourceP
import ./interval-clip.bend as Clip
import ./interval-clip-proof.bend as ClipP
import ./interval-walk.bend as Walk
import ./interval-walk-laws.bend as WalkL
import ./interval-walk-proof.bend as WalkP
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S
import ./boolean-reflection.bend as B

def L.origin_exact(p,q,r,origin):
  match origin:
    case M.SourceLeft{}: {==}
    case M.SourceRight{}: {==}
    case M.Boundary{a,b}: {==}
def L.choose_exact(a,b,p,q,left,right,cp,cq):
  match cp cq:
    case True{} True{}: {==}
    case True{} False{}: {==}
    case False{} True{}: {==}
    case False{} False{}: {==}
def L.step_exact(p,q,edge,state):
  match edge state:
    case Walk.Halfplane{a,b} M.Lost{}: {==}
    case Walk.Halfplane{+a,+b} M.Segment{+left,+right}: L.choose_exact(a,b,p,q,left,right,Region.edge(a,b,M.point(p,q,left)),Region.edge(a,b,M.point(p,q,right)))
def L.quad_exact(p,q,quad): {==}
def L.run_nil(p,q,state): {==}
def L.run_cons(p,q,edge,rest,state): {==}
def L.point_exact(p,q,k,l,origin): {==}
def L.cut_exact(a,b,p,q,k,l,m,n,lo,ro): {==}
def L.cut_point_exact(a,b,p,q,left,right):
  CutTrace.cut_point_exact(a,b,p,q,left,right)
def L.choose_erases(a,b,p,q,left,right,cp,cq):
  match cp cq:
    case True{} True{}: {==}
    case True{} False{}: Equal.cong(G.Point,Clip.ClipResult,x => Clip.Span{M.point(p,q,left),x},M.point(p,q,M.cut_endpoint(a,b,p,q,left,right)),Cut.point(a,b,M.point(p,q,left),M.point(p,q,right)),L.cut_point_exact(a,b,p,q,left,right))
    case False{} True{}: Equal.cong(G.Point,Clip.ClipResult,x => Clip.Span{M.point(p,q,right),x},M.point(p,q,M.cut_endpoint(a,b,p,q,right,left)),Cut.point(a,b,M.point(p,q,right),M.point(p,q,left)),L.cut_point_exact(a,b,p,q,right,left))
    case False{} False{}: {==}
def L.step_erases(p,q,edge,state):
  match edge state:
    case Walk.Halfplane{a,b} M.Lost{}: {==}
    case Walk.Halfplane{+a,+b} M.Segment{+left,+right}: L.choose_erases(a,b,p,q,left,right,Region.edge(a,b,M.point(p,q,left)),Region.edge(a,b,M.point(p,q,right)))
def L.run_erases(p,q,edges,state):
  match edges:
    case []: {==}
    case +edge <> +rest: Equal.trans(Clip.ClipResult,M.erase(p,q,M.run(p,q,rest,M.step(p,q,edge,state))),Walk.run(rest,M.erase(p,q,M.step(p,q,edge,state))),Walk.run(rest,Walk.step(edge,M.erase(p,q,state))),L.run_erases(p,q,rest,M.step(p,q,edge,state)),Equal.cong(Clip.ClipResult,Clip.ClipResult,x => Walk.run(rest,x),M.erase(p,q,M.step(p,q,edge,state)),Walk.step(edge,M.erase(p,q,state)),L.step_erases(p,q,edge,state)))
def L.initial_exact(): {==}
def L.initial_erases(p,q):
  %Basis.join_left_unit(p,q) : {Clip.Span{C.join(p,q,1n,0n),C.join(p,q,0n,1n)} == Clip.Span{_,q} : Clip.ClipResult}
  %Basis.join_right_unit(p,q) : {Clip.Span{C.join(p,q,1n,0n),C.join(p,q,0n,1n)} == Clip.Span{C.join(p,q,1n,0n),_} : Clip.ClipResult}
  {==}
def endpoint_equal(+p:G.Point,+q:G.Point,end:M.Endpoint) -> {M.endpoint_honest(p,q,end) == L.endpoint_spec(p,q,end) : Bool}:
  match end:
    case M.End{k,l,origin}: L.origin_exact(p,q,C.join(p,q,k,l),origin)
def L.honest_exact(p,q,state):
  match state:
    case M.Lost{}: {==}
    case M.Segment{+left,+right}:
      %endpoint_equal(p,q,left) : {M.endpoint_honest(p,q,left) && M.endpoint_honest(p,q,right) == _ && L.endpoint_spec(p,q,right) : Bool}
      %endpoint_equal(p,q,right) : {M.endpoint_honest(p,q,left) && M.endpoint_honest(p,q,right) == M.endpoint_honest(p,q,left) && _ : Bool}
      {==}
def L.initial_honest(p,q):
  %Basis.join_left_unit(p,q) : {G.equivalent(C.join(p,q,1n,0n),_) && G.equivalent(C.join(p,q,0n,1n),q) == True{} : Bool}
  %Basis.join_right_unit(p,q) : {G.equivalent(C.join(p,q,1n,0n),C.join(p,q,1n,0n)) && G.equivalent(C.join(p,q,0n,1n),_) == True{} : Bool}
  B.and_join(G.equivalent(C.join(p,q,1n,0n),C.join(p,q,1n,0n)),G.equivalent(C.join(p,q,0n,1n),C.join(p,q,0n,1n)),CutP.cut_equivalent_self(C.join(p,q,1n,0n)),CutP.cut_equivalent_self(C.join(p,q,0n,1n)))

def cut_line(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:M.Endpoint,+right:M.Endpoint,hp:{Region.edge(a,b,M.point(p,q,left)) == True{} : Bool},hq:{S.negative(a,b,M.point(p,q,right)) == True{} : Bool}) -> {Cut.on_line(a,b,M.point(p,q,M.cut_endpoint(a,b,p,q,left,right))) == True{} : Bool}:
  CutTrace.cut_line(a,b,p,q,left,right,hp,hq)
def cut_honest(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,left:M.Endpoint,right:M.Endpoint,hp:{Region.edge(a,b,M.point(p,q,left)) == True{} : Bool},hq:{S.negative(a,b,M.point(p,q,right)) == True{} : Bool}) -> {M.endpoint_honest(p,q,M.cut_endpoint(a,b,p,q,left,right)) == True{} : Bool}:
  match left right:
    case M.End{k,l,lo} M.End{m,n,ro}: cut_line(a,b,p,q,M.End{k,l,lo},M.End{m,n,ro},hp,hq)
def choose_honest(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:M.Endpoint,+right:M.Endpoint,cp:Bool,cq:Bool,+hl:{M.endpoint_honest(p,q,left) == True{} : Bool},+hr:{M.endpoint_honest(p,q,right) == True{} : Bool},hc:{Region.edge(a,b,M.point(p,q,left)) == cp : Bool},hd:{Region.edge(a,b,M.point(p,q,right)) == cq : Bool}) -> {M.honest(p,q,M.choose(a,b,p,q,left,right,cp,cq)) == True{} : Bool}:
  match cp cq:
    case True{} True{}: B.and_join(M.endpoint_honest(p,q,left),M.endpoint_honest(p,q,right),hl,hr)
    case True{} False{}: B.and_join(M.endpoint_honest(p,q,left),M.endpoint_honest(p,q,M.cut_endpoint(a,b,p,q,left,right)),hl,cut_honest(a,b,p,q,left,right,hc,ClipP.negative_from_false(a,b,M.point(p,q,right),hd)))
    case False{} True{}: B.and_join(M.endpoint_honest(p,q,right),M.endpoint_honest(p,q,M.cut_endpoint(a,b,p,q,right,left)),hr,cut_honest(a,b,p,q,right,left,hd,ClipP.negative_from_false(a,b,M.point(p,q,left),hc)))
    case False{} False{}: {==}
def span_honest(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:M.Endpoint,+right:M.Endpoint,h:{M.endpoint_honest(p,q,left) == True{} : Bool} & {M.endpoint_honest(p,q,right) == True{} : Bool}) -> {M.honest(p,q,M.choose(a,b,p,q,left,right,Region.edge(a,b,M.point(p,q,left)),Region.edge(a,b,M.point(p,q,right)))) == True{} : Bool}:
  match h:
    case (hl,hr): choose_honest(a,b,p,q,left,right,Region.edge(a,b,M.point(p,q,left)),Region.edge(a,b,M.point(p,q,right)),hl,hr,{==},{==})
def L.step_honest(p,q,edge,state,h):
  match edge state:
    case Walk.Halfplane{a,b} M.Lost{}: {==}
    case Walk.Halfplane{a,b} M.Segment{+left,+right}: span_honest(a,b,p,q,left,right,B.and_split(M.endpoint_honest(p,q,left),M.endpoint_honest(p,q,right),h))
def L.run_honest(p,q,edges,state,h):
  match edges:
    case []: h
    case +edge <> rest: L.run_honest(p,q,rest,M.step(p,q,edge,state),L.step_honest(p,q,edge,state,h))
def L.quad_erases(p,q,quad):
  Equal.trans(Clip.ClipResult,M.erase(p,q,M.run(p,q,Walk.quad_edges(quad),M.initial())),Walk.run(Walk.quad_edges(quad),M.erase(p,q,M.initial())),Walk.run(Walk.quad_edges(quad),Clip.Span{p,q}),L.run_erases(p,q,Walk.quad_edges(quad),M.initial()),Equal.cong(Clip.ClipResult,Clip.ClipResult,x => Walk.run(Walk.quad_edges(quad),x),M.erase(p,q,M.initial()),Clip.Span{p,q},L.initial_erases(p,q)))

def L.endpoint_member(p,q,end,hp,hq,hr):
  match end:
    case M.End{+k,+l,origin}: (k,(l,(Basis.positive_coefficients(p,q,k,l,hr),(hp,(hq,(hr,CutP.cut_equivalent_self(C.join(p,q,k,l))))))))
def source_members_pair(+p:G.Point,+q:G.Point,+left:M.Endpoint,+right:M.Endpoint,+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},h:{G.positive_denominator(M.point(p,q,left)) == True{} : Bool} & {G.positive_denominator(M.point(p,q,right)) == True{} : Bool}) -> L.SourceMembers(p,q,M.Segment{left,right}):
  match h:
    case (hl,hr): (L.endpoint_member(p,q,left,hp,hq,hl),L.endpoint_member(p,q,right,hp,hq,hr))
def source_members_valid(+p:G.Point,+q:G.Point,state:M.Traced,+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},h:{Walk.valid(M.erase(p,q,state)) == True{} : Bool}) -> L.SourceMembers(p,q,state):
  match state:
    case M.Lost{}: Unit{}
    case M.Segment{+left,+right}: source_members_pair(p,q,left,right,hp,hq,B.and_split(G.positive_denominator(M.point(p,q,left)),G.positive_denominator(M.point(p,q,right)),h))
def quad_source_valid(+p:G.Point,+q:G.Point,+quad:N.Quad,+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},h:{Walk.valid(Walk.clip_quad(quad,p,q)) == True{} : Bool} & {Clip.in_region(quad,Walk.clip_quad(quad,p,q)) == True{} : Bool}) -> L.SourceMembers(p,q,M.clip_quad(p,q,quad)):
  match h:
    case (hv,closed): source_members_valid(p,q,M.clip_quad(p,q,quad),hp,hq,Equal.trans(Bool,Walk.valid(M.erase(p,q,M.clip_quad(p,q,quad))),Walk.valid(Walk.clip_quad(quad,p,q)),True{},Equal.cong(Clip.ClipResult,Bool,x => Walk.valid(x),M.erase(p,q,M.clip_quad(p,q,quad)),Walk.clip_quad(quad,p,q),L.quad_erases(p,q,quad)),hv))
def L.quad_source_endpoints(p,q,quad,hp,hq):
  quad_source_valid(p,q,quad,hp,hq,WalkL.quad_closed_valid(quad,p,q,hp,hq))

def erased_closed_valid(+p:G.Point,+q:G.Point,+quad:N.Quad,hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool}) -> {Walk.valid(M.erase(p,q,M.clip_quad(p,q,quad))) == True{} : Bool} & {Clip.in_region(quad,M.erase(p,q,M.clip_quad(p,q,quad))) == True{} : Bool}:
  %Equal.sym(Clip.ClipResult,M.erase(p,q,M.clip_quad(p,q,quad)),Walk.clip_quad(quad,p,q),L.quad_erases(p,q,quad)) : {Walk.valid(_) == True{} : Bool} & {Clip.in_region(quad,_) == True{} : Bool}
  WalkL.quad_closed_valid(quad,p,q,hp,hq)
def retained_raw_closed_valid(+p:G.Point,+q:G.Point,+quad:N.Quad,+left:M.Endpoint,+right:M.Endpoint,hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool},h:{M.clip_quad(p,q,quad) == M.Segment{left,right} : M.Traced}) -> {Walk.valid(M.erase(p,q,M.Segment{left,right})) == True{} : Bool} & {Clip.in_region(quad,M.erase(p,q,M.Segment{left,right})) == True{} : Bool}:
  %h : {Walk.valid(M.erase(p,q,_)) == True{} : Bool} & {Clip.in_region(quad,M.erase(p,q,_)) == True{} : Bool}
  erased_closed_valid(p,q,quad,hp,hq)
def retained_split(+p:G.Point,+q:G.Point,+quad:N.Quad,+left:M.Endpoint,+right:M.Endpoint,h:{Walk.valid(M.erase(p,q,M.Segment{left,right})) == True{} : Bool} & {Clip.in_region(quad,M.erase(p,q,M.Segment{left,right})) == True{} : Bool}) -> ({G.positive_denominator(M.point(p,q,left)) == True{} : Bool} & {G.positive_denominator(M.point(p,q,right)) == True{} : Bool}) & ({Region.contains(M.point(p,q,left),quad) == True{} : Bool} & {Region.contains(M.point(p,q,right),quad) == True{} : Bool}):
  match h:
    case (hv,hi): (B.and_split(G.positive_denominator(M.point(p,q,left)),G.positive_denominator(M.point(p,q,right)),hv),B.and_split(Region.contains(M.point(p,q,left),quad),Region.contains(M.point(p,q,right),quad),hi))
def L.retained_closed_valid(p,q,quad,left,right,hp,hq,h):
  retained_split(p,q,quad,left,right,retained_raw_closed_valid(p,q,quad,left,right,hp,hq,h))
