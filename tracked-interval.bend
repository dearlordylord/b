import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut
import ./segment-provenance.bend as Source
import ./interval-clip.bend as Clip
import ./interval-walk.bend as Walk

type Origin is Data:
  SourceLeft{}
  SourceRight{}
  Boundary{a:N.Point,b:N.Point}
type Endpoint is Data:
  End{first:Nat,second:Nat,origin:Origin}
type Traced is Data:
  Lost{}
  Segment{left:Endpoint,right:Endpoint}
def point(p:G.Point,q:G.Point,end:Endpoint) -> G.Point:
  match end:
    case End{k,l,origin}: C.join(p,q,k,l)
def cut_endpoint(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,left:Endpoint,right:Endpoint) -> Endpoint:
  match left right:
    case End{+k,+l,lo} End{+m,+n,ro}:
      +v = Cut.first_weight(a,b,C.join(p,q,m,n))
      +w = Cut.second_weight(a,b,C.join(p,q,k,l))
      End{Source.first(k,m,v,w),Source.second(l,n,v,w),Boundary{a,b}}
def choose(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:Endpoint,+right:Endpoint,cp:Bool,cq:Bool) -> Traced:
  match cp cq:
    case True{} True{}: Segment{left,right}
    case True{} False{}: Segment{left,cut_endpoint(a,b,p,q,left,right)}
    case False{} True{}: Segment{right,cut_endpoint(a,b,p,q,right,left)}
    case False{} False{}: Lost{}
def step(+p:G.Point,+q:G.Point,edge:Walk.Edge,state:Traced) -> Traced:
  match edge state:
    case Walk.Halfplane{a,b} Lost{}: Lost{}
    case Walk.Halfplane{+a,+b} Segment{+left,+right}: choose(a,b,p,q,left,right,Region.edge(a,b,point(p,q,left)),Region.edge(a,b,point(p,q,right)))
def run(+p:G.Point,+q:G.Point,edges:List<&2,Walk.Edge>,state:Traced) -> Traced:
  match edges:
    case []: state
    case edge <> rest: run(p,q,rest,step(p,q,edge,state))
def erase(+p:G.Point,+q:G.Point,state:Traced) -> Clip.ClipResult:
  match state:
    case Lost{}: Clip.Gone{}
    case Segment{left,right}: Clip.Span{point(p,q,left),point(p,q,right)}
def initial() -> Traced:
  Segment{End{1n,0n,SourceLeft{}},End{0n,1n,SourceRight{}}}
def origin_honest(p:G.Point,q:G.Point,r:G.Point,origin:Origin) -> Bool:
  match origin:
    case SourceLeft{}: G.equivalent(r,p)
    case SourceRight{}: G.equivalent(r,q)
    case Boundary{a,b}: Cut.on_line(a,b,r)
def endpoint_honest(+p:G.Point,+q:G.Point,end:Endpoint) -> Bool:
  match end:
    case End{+k,+l,origin}: origin_honest(p,q,C.join(p,q,k,l),origin)
def honest(+p:G.Point,+q:G.Point,state:Traced) -> Bool:
  match state:
    case Lost{}: True{}
    case Segment{left,right}: endpoint_honest(p,q,left) && endpoint_honest(p,q,right)
def clip_quad(+p:G.Point,+q:G.Point,quad:N.Quad) -> Traced:
  run(p,q,Walk.quad_edges(quad),initial())
