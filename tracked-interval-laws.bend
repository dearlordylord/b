import Base
import ./tracked-interval.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut
import ./segment-provenance.bend as Source
import ./interval-clip.bend as Clip
import ./interval-walk.bend as Walk
import ./halfplane-region.bend as Region

# Physical label interpretation is specified independently of the report.
def label_spec(p:G.Point,q:G.Point,r:G.Point,origin:M.Origin) -> Bool:
  match origin:
    case M.SourceLeft{}: G.equivalent(r,p)
    case M.SourceRight{}: G.equivalent(r,q)
    case M.Boundary{a,b}: Cut.on_line(a,b,r)
def endpoint_spec(+p:G.Point,+q:G.Point,end:M.Endpoint) -> Bool:
  match end:
    case M.End{k,l,origin}: label_spec(p,q,C.join(p,q,k,l),origin)
def honest_spec(+p:G.Point,+q:G.Point,state:M.Traced) -> Bool:
  match state:
    case M.Lost{}: True{}
    case M.Segment{left,right}: endpoint_spec(p,q,left) && endpoint_spec(p,q,right)

def reference_choose(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:M.Endpoint,+right:M.Endpoint,cp:Bool,cq:Bool) -> M.Traced:
  match cp cq:
    case True{} True{}: M.Segment{left,right}
    case True{} False{}: M.Segment{left,M.cut_endpoint(a,b,p,q,left,right)}
    case False{} True{}: M.Segment{right,M.cut_endpoint(a,b,p,q,right,left)}
    case False{} False{}: M.Lost{}
def reference_step(+p:G.Point,+q:G.Point,edge:Walk.Edge,state:M.Traced) -> M.Traced:
  match edge state:
    case Walk.Halfplane{a,b} M.Lost{}: M.Lost{}
    case Walk.Halfplane{+a,+b} M.Segment{+left,+right}: reference_choose(a,b,p,q,left,right,Region.edge(a,b,M.point(p,q,left)),Region.edge(a,b,M.point(p,q,right)))
law step_exact:
  for +p:G.Point
  for +q:G.Point
  for +edge:Walk.Edge
  for +state:M.Traced
  {M.step(p,q,edge,state) == reference_step(p,q,edge,state) : M.Traced}
law quad_exact:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  {M.clip_quad(p,q,quad) == M.run(p,q,Walk.quad_edges(quad),M.initial()) : M.Traced}
law origin_exact:
  for +p:G.Point
  for +q:G.Point
  for +r:G.Point
  for +origin:M.Origin
  {M.origin_honest(p,q,r,origin) == label_spec(p,q,r,origin) : Bool}
law choose_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +left:M.Endpoint
  for +right:M.Endpoint
  for +cp:Bool
  for +cq:Bool
  {M.choose(a,b,p,q,left,right,cp,cq) == reference_choose(a,b,p,q,left,right,cp,cq) : M.Traced}
law run_nil:
  for +p:G.Point
  for +q:G.Point
  for +state:M.Traced
  {M.run(p,q,[],state) == state : M.Traced}
law run_cons:
  for +p:G.Point
  for +q:G.Point
  for +edge:Walk.Edge
  for +rest:List<&2,Walk.Edge>
  for +state:M.Traced
  {M.run(p,q,edge <> rest,state) == M.run(p,q,rest,M.step(p,q,edge,state)) : M.Traced}

law point_exact:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +origin:M.Origin
  {M.point(p,q,M.End{k,l,origin}) == C.join(p,q,k,l) : G.Point}
law cut_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +m:Nat
  for +n:Nat
  for +lo:M.Origin
  for +ro:M.Origin
  {M.cut_endpoint(a,b,p,q,M.End{k,l,lo},M.End{m,n,ro}) == M.End{Source.first(k,m,Cut.first_weight(a,b,C.join(p,q,m,n)),Cut.second_weight(a,b,C.join(p,q,k,l))),Source.second(l,n,Cut.first_weight(a,b,C.join(p,q,m,n)),Cut.second_weight(a,b,C.join(p,q,k,l))),M.Boundary{a,b}} : M.Endpoint}
law cut_point_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +left:M.Endpoint
  for +right:M.Endpoint
  {M.point(p,q,M.cut_endpoint(a,b,p,q,left,right)) == Cut.point(a,b,M.point(p,q,left),M.point(p,q,right)) : G.Point}
law choose_erases:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +left:M.Endpoint
  for +right:M.Endpoint
  for +cp:Bool
  for +cq:Bool
  {M.erase(p,q,M.choose(a,b,p,q,left,right,cp,cq)) == Clip.choose(a,b,M.point(p,q,left),M.point(p,q,right),cp,cq) : Clip.ClipResult}
law step_erases:
  for +p:G.Point
  for +q:G.Point
  for +edge:Walk.Edge
  for +state:M.Traced
  {M.erase(p,q,M.step(p,q,edge,state)) == Walk.step(edge,M.erase(p,q,state)) : Clip.ClipResult}
law run_erases:
  for +p:G.Point
  for +q:G.Point
  for +edges:List<&2,Walk.Edge>
  for +state:M.Traced
  {M.erase(p,q,M.run(p,q,edges,state)) == Walk.run(edges,M.erase(p,q,state)) : Clip.ClipResult}
law initial_exact:
  {M.initial() == M.Segment{M.End{1n,0n,M.SourceLeft{}},M.End{0n,1n,M.SourceRight{}}} : M.Traced}
law initial_erases:
  for +p:G.Point
  for +q:G.Point
  {M.erase(p,q,M.initial()) == Clip.Span{p,q} : Clip.ClipResult}
law honest_exact:
  for +p:G.Point
  for +q:G.Point
  for +state:M.Traced
  {M.honest(p,q,state) == honest_spec(p,q,state) : Bool}
law initial_honest:
  for +p:G.Point
  for +q:G.Point
  {M.honest(p,q,M.initial()) == True{} : Bool}
law step_honest:
  for +p:G.Point
  for +q:G.Point
  for +edge:Walk.Edge
  for +state:M.Traced
  for h:{M.honest(p,q,state) == True{} : Bool}
  {M.honest(p,q,M.step(p,q,edge,state)) == True{} : Bool}
law run_honest:
  for +p:G.Point
  for +q:G.Point
  for +edges:List<&2,Walk.Edge>
  for +state:M.Traced
  for h:{M.honest(p,q,state) == True{} : Bool}
  {M.honest(p,q,M.run(p,q,edges,state)) == True{} : Bool}
law quad_erases:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  {M.erase(p,q,M.clip_quad(p,q,quad)) == Walk.clip_quad(quad,p,q) : Clip.ClipResult}

# Constructive source membership belongs to the specification.
def SourceMembers(-p:G.Point,-q:G.Point,state:M.Traced) -> Type:
  match state:
    case M.Lost{}: Unit
    case M.Segment{left,right}: Cut.InSegment(p,q,M.point(p,q,left)) & Cut.InSegment(p,q,M.point(p,q,right))
law endpoint_member:
  for +p:G.Point
  for +q:G.Point
  for +end:M.Endpoint
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  for +hr:{G.positive_denominator(M.point(p,q,end)) == True{} : Bool}
  Cut.InSegment(p,q,M.point(p,q,end))
law quad_source_endpoints:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  SourceMembers(p,q,M.clip_quad(p,q,quad))

# Physical properties of both endpoints identified in the actual clipped state.
law retained_closed_valid:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  for +left:M.Endpoint
  for +right:M.Endpoint
  for hp:{G.positive_denominator(p) == True{} : Bool}
  for hq:{G.positive_denominator(q) == True{} : Bool}
  for h:{M.clip_quad(p,q,quad) == M.Segment{left,right} : M.Traced}
  ({G.positive_denominator(M.point(p,q,left)) == True{} : Bool} & {G.positive_denominator(M.point(p,q,right)) == True{} : Bool}) & ({Region.contains(M.point(p,q,left),quad) == True{} : Bool} & {Region.contains(M.point(p,q,right),quad) == True{} : Bool})
