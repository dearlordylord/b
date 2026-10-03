import Base
import ./tracked-candidates.bend as M
import ./tracked-interval.bend as Trace
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./homogeneous-geometry.bend as G
import ./interval-walk.bend as Walk
import ./natural-cover.bend as N

# Independent physical interpretation of retained origin labels.
def label_spec(+p:G.Point,+q:G.Point,+r:G.Point,origin:Trace.Origin) -> Bool:
  match origin:
    case Trace.SourceLeft{}: G.equivalent(r,p)
    case Trace.SourceRight{}: G.equivalent(r,q)
    case Trace.Boundary{+a,+b}: Cross.crosses(a,b,p,q) && G.equivalent(r,Boundary.direct(a,b,p,q))
law label_exact:
  for +p:G.Point
  for +q:G.Point
  for +r:G.Point
  for +origin:Trace.Origin
  {M.label(p,q,r,origin) == label_spec(p,q,r,origin) : Bool}
def endpoint_origin(end:Trace.Endpoint) -> Trace.Origin:
  match end:
    case Trace.End{k,l,origin}: origin
law endpoint_exact:
  for +p:G.Point
  for +q:G.Point
  for +end:Trace.Endpoint
  {M.endpoint(p,q,end) == label_spec(p,q,Trace.point(p,q,end),endpoint_origin(end)) : Bool}
def endpoint_spec(+p:G.Point,+q:G.Point,+end:Trace.Endpoint) -> Bool:
  label_spec(p,q,Trace.point(p,q,end),endpoint_origin(end))
def report_spec(+p:G.Point,+q:G.Point,state:Trace.Traced) -> Bool:
  match state:
    case Trace.Lost{}: True{}
    case Trace.Segment{left,right}: endpoint_spec(p,q,left) && endpoint_spec(p,q,right)
law candidates_exact:
  for +p:G.Point
  for +q:G.Point
  for +state:Trace.Traced
  {M.candidates(p,q,state) == report_spec(p,q,state) : Bool}
law initial_candidates:
  for +p:G.Point
  for +q:G.Point
  {M.candidates(p,q,Trace.initial()) == True{} : Bool}
# Validity excludes a zero-weight ghost masquerading as an inside endpoint.
law step_candidates:
  for +p:G.Point
  for +q:G.Point
  for +edge:Walk.Edge
  for +state:Trace.Traced
  for hv:{Walk.valid(Trace.erase(p,q,state)) == True{} : Bool}
  for hc:{M.candidates(p,q,state) == True{} : Bool}
  {M.candidates(p,q,Trace.step(p,q,edge,state)) == True{} : Bool}
law run_candidates:
  for +p:G.Point
  for +q:G.Point
  for +edges:List<&2,Walk.Edge>
  for +state:Trace.Traced
  for +hv:{Walk.valid(Trace.erase(p,q,state)) == True{} : Bool}
  for hc:{M.candidates(p,q,state) == True{} : Bool}
  {M.candidates(p,q,Trace.run(p,q,edges,state)) == True{} : Bool}
law quad_candidates:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  for hp:{G.positive_denominator(p) == True{} : Bool}
  for hq:{G.positive_denominator(q) == True{} : Bool}
  {M.candidates(p,q,Trace.clip_quad(p,q,quad)) == True{} : Bool}

# Exact geometric interpretation derived from the actual retained left endpoint.
law retained_left_boundary:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  for +a:N.Point
  for +b:N.Point
  for +k:Nat
  for +l:Nat
  for +right:Trace.Endpoint
  for hp:{G.positive_denominator(p) == True{} : Bool}
  for hq:{G.positive_denominator(q) == True{} : Bool}
  for h:{Trace.clip_quad(p,q,quad) == Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right} : Trace.Traced}
  {Cross.crosses(a,b,p,q) == True{} : Bool} & {G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)) == True{} : Bool}

# Exact geometric interpretation derived from the actual retained right endpoint.
law retained_right_boundary:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  for +a:N.Point
  for +b:N.Point
  for +k:Nat
  for +l:Nat
  for +left:Trace.Endpoint
  for hp:{G.positive_denominator(p) == True{} : Bool}
  for hq:{G.positive_denominator(q) == True{} : Bool}
  for h:{Trace.clip_quad(p,q,quad) == Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}} : Trace.Traced}
  {Cross.crosses(a,b,p,q) == True{} : Bool} & {G.equivalent(Trace.point(p,q,Trace.End{k,l,Trace.Boundary{a,b}}),Boundary.direct(a,b,p,q)) == True{} : Bool}
