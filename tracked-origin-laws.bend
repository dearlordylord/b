import Base
import ./tracked-interval.bend as Trace
import ./interval-walk.bend as Walk
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N

import ./tracked-origin.bend as M

def Occurs(-edge:Walk.Edge,edges:List<&2,Walk.Edge>) -> Type: M.Occurs(edge,edges)
def AllOccur(edges:List<&2,Walk.Edge>,allowed:List<&2,Walk.Edge>) -> Type: M.AllOccur(edges,allowed)
def OriginAllowed(allowed:List<&2,Walk.Edge>,origin:Trace.Origin) -> Type: M.OriginAllowed(allowed,origin)
def EndpointAllowed(allowed:List<&2,Walk.Edge>,end:Trace.Endpoint) -> Type: M.EndpointAllowed(allowed,end)
def StateAllowed(allowed:List<&2,Walk.Edge>,state:Trace.Traced) -> Type: M.StateAllowed(allowed,state)
# A boundary origin must provide an actual directed-edge occurrence.
law boundary_occurrence:
  for +allowed:List<&2,Walk.Edge>
  for +a:N.Point
  for +b:N.Point
  for h:OriginAllowed(allowed,Trace.Boundary{a,b})
  Occurs(Walk.Halfplane{a,b},allowed)
law all_self:
  for +edges:List<&2,Walk.Edge>
  AllOccur(edges,edges)
law initial_allowed:
  for +allowed:List<&2,Walk.Edge>
  StateAllowed(allowed,Trace.initial())
law cut_allowed:
  for +allowed:List<&2,Walk.Edge>
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +left:Trace.Endpoint
  for +right:Trace.Endpoint
  for h:Occurs(Walk.Halfplane{a,b},allowed)
  EndpointAllowed(allowed,Trace.cut_endpoint(a,b,p,q,left,right))
law step_allowed:
  for +allowed:List<&2,Walk.Edge>
  for +p:G.Point
  for +q:G.Point
  for +edge:Walk.Edge
  for +state:Trace.Traced
  for he:Occurs(edge,allowed)
  for hs:StateAllowed(allowed,state)
  StateAllowed(allowed,Trace.step(p,q,edge,state))
law run_allowed:
  for +allowed:List<&2,Walk.Edge>
  for +p:G.Point
  for +q:G.Point
  for +edges:List<&2,Walk.Edge>
  for +state:Trace.Traced
  for he:AllOccur(edges,allowed)
  for hs:StateAllowed(allowed,state)
  StateAllowed(allowed,Trace.run(p,q,edges,state))
law quad_allowed:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  StateAllowed(Walk.quad_edges(quad),Trace.clip_quad(p,q,quad))

# Anti-vacuity extractors expose what each constructive report guarantees.
law no_empty_occurrence:
  for +edge:Walk.Edge
  for h:Occurs(edge,[])
  Empty
law endpoint_origin:
  for +allowed:List<&2,Walk.Edge>
  for +k:Nat
  for +l:Nat
  for +origin:Trace.Origin
  for h:EndpointAllowed(allowed,Trace.End{k,l,origin})
  OriginAllowed(allowed,origin)
law state_endpoints:
  for +allowed:List<&2,Walk.Edge>
  for +left:Trace.Endpoint
  for +right:Trace.Endpoint
  for h:StateAllowed(allowed,Trace.Segment{left,right})
  EndpointAllowed(allowed,left) & EndpointAllowed(allowed,right)

# Recover directed occurrence from a concrete retained endpoint of the actual walk.
law retained_left_boundary:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  for +a:N.Point
  for +b:N.Point
  for +k:Nat
  for +l:Nat
  for +right:Trace.Endpoint
  for h:{Trace.clip_quad(p,q,quad) == Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right} : Trace.Traced}
  Occurs(Walk.Halfplane{a,b},Walk.quad_edges(quad))
law retained_right_boundary:
  for +p:G.Point
  for +q:G.Point
  for +quad:N.Quad
  for +a:N.Point
  for +b:N.Point
  for +k:Nat
  for +l:Nat
  for +left:Trace.Endpoint
  for h:{Trace.clip_quad(p,q,quad) == Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}} : Trace.Traced}
  Occurs(Walk.Halfplane{a,b},Walk.quad_edges(quad))
