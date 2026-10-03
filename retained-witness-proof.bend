import Base
import ./retained-witness-laws.bend as L
import ./tracked-interval.bend as Trace
import ./tracked-interval-laws.bend as TL
import ./tracked-interval-proof.bend as TP
import ./tracked-origin-laws.bend as OL
import ./tracked-origin-proof.bend as OP
import ./tracked-candidates-laws.bend as CL
import ./tracked-candidates-proof.bend as CP
import ./search-admission-laws.bend as AL
import ./search-admission-proof.bend as AP
import ./source-edge-region-laws.bend as SL
import ./source-edge-region-proof.bend as SP
import ./interval-walk.bend as Walk
import ./interval-walk-laws.bend as WL
import ./interval-walk-proof.bend as WP
import ./interval-clip.bend as Clip
import ./intersection-search.bend as Search
import ./search-membership.bend as Member
import ./search-membership-laws.bend as ML
import ./search-membership-proof.bend as MP
import ./tracked-candidates.bend as Candidate
import ./candidate-existence.bend as E
import ./quad-geometry.bend as Q
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./boolean-reflection.bend as B

def copy_tail(+edge:Search.Edge,+head:Search.Edge,+rest:List<&2,Search.Edge>,h:Member.EdgeOccurs(edge,rest) & Member.EdgeOccurs(edge,rest)) -> Member.EdgeOccurs(edge,head <> rest) & Member.EdgeOccurs(edge,head <> rest):
  match h:
    case (hl,hr): (Inr{hl},Inr{hr})
def copy_branch(+edge:Search.Edge,+head:Search.Edge,+rest:List<&2,Search.Edge>,h:Member.EdgeOccurs(edge,head <> rest),ih:Member.EdgeOccurs(edge,rest) -> Member.EdgeOccurs(edge,rest) & Member.EdgeOccurs(edge,rest)) -> Member.EdgeOccurs(edge,head <> rest) & Member.EdgeOccurs(edge,head <> rest):
  match h:
    case Inl{+eq}: (Inl{eq},Inl{eq})
    case Inr{ht}: copy_tail(edge,head,rest,ih(ht))
def copy_occurrence(+edge:Search.Edge,edges:List<&2,Search.Edge>,h:Member.EdgeOccurs(edge,edges)) -> Member.EdgeOccurs(edge,edges) & Member.EdgeOccurs(edge,edges):
  match edges:
    case []: B.absurd(Member.EdgeOccurs(edge,[]) & Member.EdgeOccurs(edge,[]),h)
    case +head <> +rest: copy_branch(edge,head,rest,h,ht => copy_occurrence(edge,rest,ht))

def left_reports(+a:N.Point,+b:N.Point,+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,right:Trace.Endpoint,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hl:OL.Occurs(Walk.Halfplane{a,b},Walk.quad_edges(q)),hg:({G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}})) == True{} : Bool} & {G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),right)) == True{} : Bool}) & ({Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),q) == True{} : Bool} & {Region.contains(Trace.point(Q.embed(c),Q.embed(d),right),q) == True{} : Bool}),hc:{Cross.crosses(a,b,Q.embed(c),Q.embed(d)) == True{} : Bool} & {G.equivalent(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,Q.embed(c),Q.embed(d))) == True{} : Bool},hj:{Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),r) == True{} : Bool}) -> E.Witness(Search.candidates(q,r),q,r):
  match hg hc:
    case ((vl, vr), (il, ir)), (cross, equiv): AL.boundary_search_witness(a,b,c,d,q,r,Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),hl,hs,cross,vl,equiv,il,hj)
def left_source(+a:N.Point,+b:N.Point,+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,+right:Trace.Endpoint,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)) & Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hr:{Q.strict_quad(r) == True{} : Bool},+h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right} : Trace.Traced}) -> E.Witness(Search.candidates(q,r),q,r):
  match hs:
    case (search,source): left_reports(a,b,c,d,q,r,k,l,right,search,OL.retained_left_boundary(Q.embed(c),Q.embed(d),q,a,b,k,l,right,h),TL.retained_closed_valid(Q.embed(c),Q.embed(d),q,Trace.End{k,l,Trace.Boundary{a,b}},right,AP.embedded_positive(c),AP.embedded_positive(d),h),CL.retained_left_boundary(Q.embed(c),Q.embed(d),q,a,b,k,l,right,AP.embedded_positive(c),AP.embedded_positive(d),h),SL.weighted_source_inside(c,d,r,k,l,source,hr))
def L.left_boundary_witness(a,b,c,d,q,r,k,l,right,hs,hr,h):
  left_source(a,b,c,d,q,r,k,l,right,copy_occurrence(Search.E{c,d},Search.edges(r),hs),hr,h)

def right_reports(+a:N.Point,+b:N.Point,+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,left:Trace.Endpoint,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hl:OL.Occurs(Walk.Halfplane{a,b},Walk.quad_edges(q)),hg:({G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),left)) == True{} : Bool} & {G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}})) == True{} : Bool}) & ({Region.contains(Trace.point(Q.embed(c),Q.embed(d),left),q) == True{} : Bool} & {Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),q) == True{} : Bool}),hc:{Cross.crosses(a,b,Q.embed(c),Q.embed(d)) == True{} : Bool} & {G.equivalent(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,Q.embed(c),Q.embed(d))) == True{} : Bool},hj:{Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),r) == True{} : Bool}) -> E.Witness(Search.candidates(q,r),q,r):
  match hg hc:
    case ((vl, vr), (il, ir)), (cross, equiv): AL.boundary_search_witness(a,b,c,d,q,r,Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.Boundary{a,b}}),hl,hs,cross,vr,equiv,ir,hj)
def right_source(+a:N.Point,+b:N.Point,+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,+left:Trace.Endpoint,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)) & Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hr:{Q.strict_quad(r) == True{} : Bool},+h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}} : Trace.Traced}) -> E.Witness(Search.candidates(q,r),q,r):
  match hs:
    case (search,source): right_reports(a,b,c,d,q,r,k,l,left,search,OL.retained_right_boundary(Q.embed(c),Q.embed(d),q,a,b,k,l,left,h),TL.retained_closed_valid(Q.embed(c),Q.embed(d),q,left,Trace.End{k,l,Trace.Boundary{a,b}},AP.embedded_positive(c),AP.embedded_positive(d),h),CL.retained_right_boundary(Q.embed(c),Q.embed(d),q,a,b,k,l,left,AP.embedded_positive(c),AP.embedded_positive(d),h),SL.weighted_source_inside(c,d,r,k,l,source,hr))
def L.right_boundary_witness(a,b,c,d,q,r,k,l,left,hs,hr,h):
  right_source(a,b,c,d,q,r,k,l,left,copy_occurrence(Search.E{c,d},Search.edges(r),hs),hr,h)

def vertex_candidate(+vertex:N.Point,+q:N.Quad,+r:N.Quad,hm:Member.PointOccurs(Q.embed(vertex),Search.vertices(r))) -> Member.PointOccurs(Q.embed(vertex),Search.candidates(q,r)):
  ML.append_right(Q.embed(vertex),Search.vertices(q),List.append(&2,G.Point,Search.vertices(r),Search.pairs(Search.edges(q),Search.edges(r))),ML.append_left(Q.embed(vertex),Search.vertices(r),Search.pairs(Search.edges(q),Search.edges(r)),hm))
def vertex_from_equivalent(+point:G.Point,+vertex:N.Point,+q:N.Quad,+r:N.Quad,hm:Member.PointOccurs(Q.embed(vertex),Search.vertices(r)),+hp:{G.positive_denominator(point) == True{} : Bool},he:{G.equivalent(point,Q.embed(vertex)) == True{} : Bool},hi:{Region.contains(point,q) == True{} : Bool},hj:{Region.contains(point,r) == True{} : Bool}) -> E.Witness(Search.candidates(q,r),q,r):
  AL.search_witness(Q.embed(vertex),q,r,vertex_candidate(vertex,q,r,hm),Equal.trans(Bool,Search.admit(Q.embed(vertex),q,r),Search.admit(point,q,r),True{},Equal.sym(Bool,Search.admit(point,q,r),Search.admit(Q.embed(vertex),q,r),AL.equivalent_admission(point,Q.embed(vertex),q,r,hp,AP.embedded_positive(vertex),he)),AP.common_admission(point,q,r,hp,hi,hj)))
def first_fact(+a:Bool,b:Bool,h:{a == True{} : Bool} & {b == True{} : Bool}) -> {a == True{} : Bool}:
  match h:
    case (ha,hb): ha
def sourceleft_reports(+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,right:Trace.Endpoint,hv:Member.PointOccurs(Q.embed(c),Search.vertices(r)) & Member.PointOccurs(Q.embed(d),Search.vertices(r)),hg:({G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceLeft{}})) == True{} : Bool} & {G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),right)) == True{} : Bool}) & ({Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceLeft{}}),q) == True{} : Bool} & {Region.contains(Trace.point(Q.embed(c),Q.embed(d),right),q) == True{} : Bool}),he:{G.equivalent(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceLeft{}}),Q.embed(c)) == True{} : Bool},hj:{Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceLeft{}}),r) == True{} : Bool}) -> E.Witness(Search.candidates(q,r),q,r):
  match hv hg:
    case (mc, md), ((vl, vr), (il, ir)): vertex_from_equivalent(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceLeft{}}),c,q,r,mc,vl,he,il,hj)
def sourceleft_sources(+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,+right:Trace.Endpoint,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)) & Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hr:{Q.strict_quad(r) == True{} : Bool},+h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{Trace.End{k,l,Trace.SourceLeft{}},right} : Trace.Traced}) -> E.Witness(Search.candidates(q,r),q,r):
  match hs:
    case (vertices, source): sourceleft_reports(c,d,q,r,k,l,right,ML.source_edge_vertices(c,d,r,vertices),TL.retained_closed_valid(Q.embed(c),Q.embed(d),q,Trace.End{k,l,Trace.SourceLeft{}},right,AP.embedded_positive(c),AP.embedded_positive(d),h),first_fact(Candidate.endpoint(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceLeft{}}),Candidate.endpoint(Q.embed(c),Q.embed(d),right),B.and_split(Candidate.endpoint(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceLeft{}}),Candidate.endpoint(Q.embed(c),Q.embed(d),right),CP.retained_candidates(Q.embed(c),Q.embed(d),q,Trace.Segment{Trace.End{k,l,Trace.SourceLeft{}},right},AP.embedded_positive(c),AP.embedded_positive(d),h))),SL.weighted_source_inside(c,d,r,k,l,source,hr))
def sourceright_reports(+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,right:Trace.Endpoint,hv:Member.PointOccurs(Q.embed(c),Search.vertices(r)) & Member.PointOccurs(Q.embed(d),Search.vertices(r)),hg:({G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceRight{}})) == True{} : Bool} & {G.positive_denominator(Trace.point(Q.embed(c),Q.embed(d),right)) == True{} : Bool}) & ({Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceRight{}}),q) == True{} : Bool} & {Region.contains(Trace.point(Q.embed(c),Q.embed(d),right),q) == True{} : Bool}),he:{G.equivalent(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceRight{}}),Q.embed(d)) == True{} : Bool},hj:{Region.contains(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceRight{}}),r) == True{} : Bool}) -> E.Witness(Search.candidates(q,r),q,r):
  match hv hg:
    case (mc, md), ((vl, vr), (il, ir)): vertex_from_equivalent(Trace.point(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceRight{}}),d,q,r,md,vl,he,il,hj)
def sourceright_sources(+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+k:Nat,+l:Nat,+right:Trace.Endpoint,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)) & Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hr:{Q.strict_quad(r) == True{} : Bool},+h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{Trace.End{k,l,Trace.SourceRight{}},right} : Trace.Traced}) -> E.Witness(Search.candidates(q,r),q,r):
  match hs:
    case (vertices, source): sourceright_reports(c,d,q,r,k,l,right,ML.source_edge_vertices(c,d,r,vertices),TL.retained_closed_valid(Q.embed(c),Q.embed(d),q,Trace.End{k,l,Trace.SourceRight{}},right,AP.embedded_positive(c),AP.embedded_positive(d),h),first_fact(Candidate.endpoint(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceRight{}}),Candidate.endpoint(Q.embed(c),Q.embed(d),right),B.and_split(Candidate.endpoint(Q.embed(c),Q.embed(d),Trace.End{k,l,Trace.SourceRight{}}),Candidate.endpoint(Q.embed(c),Q.embed(d),right),CP.retained_candidates(Q.embed(c),Q.embed(d),q,Trace.Segment{Trace.End{k,l,Trace.SourceRight{}},right},AP.embedded_positive(c),AP.embedded_positive(d),h))),SL.weighted_source_inside(c,d,r,k,l,source,hr))
def L.retained_endpoint_witness(c,d,q,r,k,l,origin,right,hs,hr,h):
  match origin:
    case Trace.SourceLeft{}: sourceleft_sources(c,d,q,r,k,l,right,copy_occurrence(Search.E{c,d},Search.edges(r),hs),hr,h)
    case Trace.SourceRight{}: sourceright_sources(c,d,q,r,k,l,right,copy_occurrence(Search.E{c,d},Search.edges(r),hs),hr,h)
    case Trace.Boundary{a,b}: L.left_boundary_witness(a,b,c,d,q,r,k,l,right,hs,hr,h)

def endpoint_state_witness(+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,left:Trace.Endpoint,+right:Trace.Endpoint,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hr:{Q.strict_quad(r) == True{} : Bool},h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{left,right} : Trace.Traced}) -> E.Witness(Search.candidates(q,r),q,r):
  match left:
    case Trace.End{k,l,origin}: L.retained_endpoint_witness(c,d,q,r,k,l,origin,right,hs,hr,h)
def retained_state_witness(+c:N.Point,+d:N.Point,+q:N.Quad,+r:N.Quad,+state:Trace.Traced,hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r)),hr:{Q.strict_quad(r) == True{} : Bool},h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == state : Trace.Traced},hp:{Clip.present(Trace.erase(Q.embed(c),Q.embed(d),state)) == True{} : Bool}) -> E.Witness(Search.candidates(q,r),q,r):
  match state:
    case Trace.Lost{}: B.absurd(E.Witness(Search.candidates(q,r),q,r),B.false_impossible(hp))
    case Trace.Segment{left,right}: endpoint_state_witness(c,d,q,r,left,right,hs,hr,h)
def L.clipped_source_witness(c,d,q,r,hs,hr,hp):
  retained_state_witness(c,d,q,r,Trace.clip_quad(Q.embed(c),Q.embed(d),q),hs,hr,{==},Equal.trans(Bool,Clip.present(Trace.erase(Q.embed(c),Q.embed(d),Trace.clip_quad(Q.embed(c),Q.embed(d),q))),Clip.present(Walk.clip_quad(q,Q.embed(c),Q.embed(d))),True{},Equal.cong(Clip.ClipResult,Bool,result => Clip.present(result),Trace.erase(Q.embed(c),Q.embed(d),Trace.clip_quad(Q.embed(c),Q.embed(d),q)),Walk.clip_quad(q,Q.embed(c),Q.embed(d)),TL.quad_erases(Q.embed(c),Q.embed(d),q)),hp))

def L.source_member_witness(c,d,q,r,point,hs,hr,hm,hi):
  L.clipped_source_witness(c,d,q,r,hs,hr,WL.quad_retained_present(q,Q.embed(c),Q.embed(d),point,hm,hi))
