import Base
import ./tracked-interval.bend as Trace
import ./interval-walk.bend as Walk
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N

# Constructive occurrence in the actual directed edge list, not a Boolean tag.
def Occurs(-edge:Walk.Edge,edges:List<&2,Walk.Edge>) -> Type:
  match edges:
    case []: Empty
    case head <> rest: Or({edge == head : Walk.Edge},Occurs(edge,rest))
def AllOccur(edges:List<&2,Walk.Edge>,+allowed:List<&2,Walk.Edge>) -> Type:
  match edges:
    case []: Unit
    case head <> rest: Occurs(head,allowed) & AllOccur(rest,allowed)
def OriginAllowed(allowed:List<&2,Walk.Edge>,origin:Trace.Origin) -> Type:
  match origin:
    case Trace.SourceLeft{}: Unit
    case Trace.SourceRight{}: Unit
    case Trace.Boundary{a,b}: Occurs(Walk.Halfplane{a,b},allowed)
def EndpointAllowed(allowed:List<&2,Walk.Edge>,end:Trace.Endpoint) -> Type:
  match end:
    case Trace.End{k,l,origin}: OriginAllowed(allowed,origin)
def StateAllowed(+allowed:List<&2,Walk.Edge>,state:Trace.Traced) -> Type:
  match state:
    case Trace.Lost{}: Unit
    case Trace.Segment{left,right}: EndpointAllowed(allowed,left) & EndpointAllowed(allowed,right)
