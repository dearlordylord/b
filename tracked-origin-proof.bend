import Base
import ./tracked-origin-laws.bend as L
import ./tracked-interval.bend as Trace
import ./interval-walk.bend as Walk
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N
import ./halfplane-region.bend as Region

def L.boundary_occurrence(allowed,a,b,h): h
def weaken_pair(+head:Walk.Edge,+edge:Walk.Edge,+rest:List<&2,Walk.Edge>,+allowed:List<&2,Walk.Edge>,h:L.Occurs(edge,allowed) & L.AllOccur(rest,allowed),ih:L.AllOccur(rest,allowed) -> L.AllOccur(rest,head <> allowed)) -> L.AllOccur(edge <> rest,head <> allowed):
  match h:
    case (he,hr): (Inr{he},ih(hr))
def weaken_all(+head:Walk.Edge,edges:List<&2,Walk.Edge>,+allowed:List<&2,Walk.Edge>,h:L.AllOccur(edges,allowed)) -> L.AllOccur(edges,head <> allowed):
  match edges:
    case []: Unit{}
    case edge <> +rest: weaken_pair(head,edge,rest,allowed,h,hr => weaken_all(head,rest,allowed,hr))
def L.all_self(edges):
  match edges:
    case []: Unit{}
    case +head <> +rest: (Inl{{==}},weaken_all(head,rest,rest,L.all_self(rest)))
def L.initial_allowed(allowed): (Unit{},Unit{})
def L.cut_allowed(allowed,a,b,p,q,left,right,h):
  match left right:
    case Trace.End{k,l,lo} Trace.End{m,n,ro}: h
def choose_allowed(+allowed:List<&2,Walk.Edge>,+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:Trace.Endpoint,+right:Trace.Endpoint,cp:Bool,cq:Bool,he:L.Occurs(Walk.Halfplane{a,b},allowed),hl:L.EndpointAllowed(allowed,left),hr:L.EndpointAllowed(allowed,right)) -> L.StateAllowed(allowed,Trace.choose(a,b,p,q,left,right,cp,cq)):
  match cp cq:
    case True{} True{}: (hl,hr)
    case True{} False{}: (hl,L.cut_allowed(allowed,a,b,p,q,left,right,he))
    case False{} True{}: (hr,L.cut_allowed(allowed,a,b,p,q,right,left,he))
    case False{} False{}: Unit{}
def step_pair(+allowed:List<&2,Walk.Edge>,+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:Trace.Endpoint,+right:Trace.Endpoint,he:L.Occurs(Walk.Halfplane{a,b},allowed),hs:L.EndpointAllowed(allowed,left) & L.EndpointAllowed(allowed,right)) -> L.StateAllowed(allowed,Trace.step(p,q,Walk.Halfplane{a,b},Trace.Segment{left,right})):
  match hs:
    case (hl,hr): choose_allowed(allowed,a,b,p,q,left,right,Region.edge(a,b,Trace.point(p,q,left)),Region.edge(a,b,Trace.point(p,q,right)),he,hl,hr)
def L.step_allowed(allowed,p,q,edge,state,he,hs):
  match edge state:
    case Walk.Halfplane{a,b} Trace.Lost{}: Unit{}
    case Walk.Halfplane{a,b} Trace.Segment{left,right}: step_pair(allowed,a,b,p,q,left,right,he,hs)
def run_pair(+allowed:List<&2,Walk.Edge>,+p:G.Point,+q:G.Point,+edge:Walk.Edge,+rest:List<&2,Walk.Edge>,+state:Trace.Traced,he:L.Occurs(edge,allowed) & L.AllOccur(rest,allowed),hs:L.StateAllowed(allowed,state),ih:@next:Trace.Traced -> L.AllOccur(rest,allowed) -> L.StateAllowed(allowed,next) -> L.StateAllowed(allowed,Trace.run(p,q,rest,next))) -> L.StateAllowed(allowed,Trace.run(p,q,rest,Trace.step(p,q,edge,state))):
  match he:
    case (hh,ht): ih(Trace.step(p,q,edge,state),ht,L.step_allowed(allowed,p,q,edge,state,hh,hs))
def L.run_allowed(allowed,p,q,edges,state,he,hs):
  match edges:
    case []: hs
    case +edge <> +rest: run_pair(allowed,p,q,edge,rest,state,he,hs,next => hr => hn => L.run_allowed(allowed,p,q,rest,next,hr,hn))
def L.quad_allowed(p,q,quad):
  L.run_allowed(Walk.quad_edges(quad),p,q,Walk.quad_edges(quad),Trace.initial(),L.all_self(Walk.quad_edges(quad)),L.initial_allowed(Walk.quad_edges(quad)))

def L.no_empty_occurrence(edge,h): h
def L.endpoint_origin(allowed,k,l,origin,h): h
def L.state_endpoints(allowed,left,right,h): h

def retained_state(+p:G.Point,+q:G.Point,+quad:N.Quad,+state:Trace.Traced,h:{Trace.clip_quad(p,q,quad) == state : Trace.Traced}) -> L.StateAllowed(Walk.quad_edges(quad),state):
  %h : L.StateAllowed(Walk.quad_edges(quad),_)
  L.quad_allowed(p,q,quad)
def left_occurrence(+allowed:List<&2,Walk.Edge>,+a:N.Point,+b:N.Point,k:Nat,l:Nat,right:Trace.Endpoint,h:L.StateAllowed(allowed,Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right})) -> L.Occurs(Walk.Halfplane{a,b},allowed):
  match h:
    case (hl,hr): hl
def right_occurrence(+allowed:List<&2,Walk.Edge>,+a:N.Point,+b:N.Point,k:Nat,l:Nat,left:Trace.Endpoint,h:L.StateAllowed(allowed,Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}})) -> L.Occurs(Walk.Halfplane{a,b},allowed):
  match h:
    case (hl,hr): hr
def L.retained_left_boundary(p,q,quad,a,b,k,l,right,h):
  left_occurrence(Walk.quad_edges(quad),a,b,k,l,right,retained_state(p,q,quad,Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right},h))
def L.retained_right_boundary(p,q,quad,a,b,k,l,left,h):
  right_occurrence(Walk.quad_edges(quad),a,b,k,l,left,retained_state(p,q,quad,Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}},h))
