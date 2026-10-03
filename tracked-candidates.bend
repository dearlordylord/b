import Base
import ./tracked-interval.bend as Trace
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C

def label(+p:G.Point,+q:G.Point,+r:G.Point,origin:Trace.Origin) -> Bool:
  match origin:
    case Trace.SourceLeft{}: G.equivalent(r,p)
    case Trace.SourceRight{}: G.equivalent(r,q)
    case Trace.Boundary{+a,+b}: Cross.crosses(a,b,p,q) && G.equivalent(r,Boundary.direct(a,b,p,q))
def endpoint(+p:G.Point,+q:G.Point,end:Trace.Endpoint) -> Bool:
  match end:
    case Trace.End{k,l,origin}: label(p,q,C.join(p,q,k,l),origin)
def candidates(+p:G.Point,+q:G.Point,state:Trace.Traced) -> Bool:
  match state:
    case Trace.Lost{}: True{}
    case Trace.Segment{left,right}: endpoint(p,q,left) && endpoint(p,q,right)
