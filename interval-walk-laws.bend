import Base
import ./interval-walk.bend as M
import ./interval-clip.bend as Clip
import ./interval-clip-laws.bend as ClipL
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region

def reference_step(edge:M.Edge,result:Clip.ClipResult) -> Clip.ClipResult:
  match edge result:
    case M.Halfplane{a,b} Clip.Gone{}: Clip.Gone{}
    case M.Halfplane{a,b} Clip.Span{p,q}: ClipL.spec(a,b,p,q)

def reference_accept(edge:M.Edge,p:G.Point) -> Bool:
  match edge:
    case M.Halfplane{a,b}: Region.edge(a,b,p)
def reference_inside(+p:G.Point,edges:List<&2,M.Edge>) -> Bool:
  match edges:
    case []: True{}
    case edge <> rest: reference_accept(edge,p) && reference_inside(p,rest)
def reference_valid(result:Clip.ClipResult) -> Bool:
  match result:
    case Clip.Gone{}: True{}
    case Clip.Span{p,q}: G.positive_denominator(p) && G.positive_denominator(q)
def reference_closed(+edges:List<&2,M.Edge>,result:Clip.ClipResult) -> Bool:
  match result:
    case Clip.Gone{}: True{}
    case Clip.Span{p,q}: reference_inside(p,edges) && reference_inside(q,edges)

law accepts_exact:
  for +edge:M.Edge
  for +p:G.Point
  {M.accepts(edge,p) == reference_accept(edge,p) : Bool}
law inside_exact:
  for +p:G.Point
  for +edges:List<&2,M.Edge>
  {M.inside(p,edges) == reference_inside(p,edges) : Bool}
law valid_exact:
  for +result:Clip.ClipResult
  {M.valid(result) == reference_valid(result) : Bool}
law closed_exact:
  for +edges:List<&2,M.Edge>
  for +result:Clip.ClipResult
  {M.closed(edges,result) == reference_closed(edges,result) : Bool}

law step_exact:
  for +edge: M.Edge
  for +result: Clip.ClipResult
  {M.step(edge,result) == reference_step(edge,result) : Clip.ClipResult}

law run_nil:
  for +result: Clip.ClipResult
  {M.run([],result) == result : Clip.ClipResult}

law run_cons:
  for +edge: M.Edge
  for +rest: List<&2,M.Edge>
  for +result: Clip.ClipResult
  {M.run(edge <> rest,result) == M.run(rest,M.step(edge,result)) : Clip.ClipResult}

law quad_membership_exact:
  for +p: G.Point
  for +q: N.Quad
  {M.inside(p,M.quad_edges(q)) == Region.contains(p,q) : Bool}

law step_valid:
  for +edge: M.Edge
  for +result: Clip.ClipResult
  for h: {M.valid(result) == True{} : Bool}
  {M.valid(M.step(edge,result)) == True{} : Bool}

law step_closed:
  for +edge: M.Edge
  for +result: Clip.ClipResult
  for h: {M.valid(result) == True{} : Bool}
  {M.closed([edge],M.step(edge,result)) == True{} : Bool}

law step_preserves:
  for +edge: M.Edge
  for +edges: List<&2,M.Edge>
  for +result: Clip.ClipResult
  for h: {M.closed(edges,result) == True{} : Bool}
  {M.closed(edges,M.step(edge,result)) == True{} : Bool}

law run_valid:
  for +edges: List<&2,M.Edge>
  for +result: Clip.ClipResult
  for h: {M.valid(result) == True{} : Bool}
  {M.valid(M.run(edges,result)) == True{} : Bool}

law run_closed:
  for +edges: List<&2,M.Edge>
  for +result: Clip.ClipResult
  for +h: {M.valid(result) == True{} : Bool}
  {M.closed(edges,M.run(edges,result)) == True{} : Bool}

law run_preserves:
  for +edges: List<&2,M.Edge>
  for +prior: List<&2,M.Edge>
  for +result: Clip.ClipResult
  for h: {M.closed(prior,result) == True{} : Bool}
  {M.closed(prior,M.run(edges,result)) == True{} : Bool}

law run_retained_present:
  for +edges: List<&2,M.Edge>
  for +result: Clip.ClipResult
  for +p: G.Point
  for member: ClipL.Member(result,p)
  for h: {M.inside(p,edges) == True{} : Bool}
  {Clip.present(M.run(edges,result)) == True{} : Bool}

law quad_edges_exact:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  {M.quad_edges(N.Q{a,b,c,d}) == [M.Halfplane{a,b},M.Halfplane{b,c},M.Halfplane{c,d},M.Halfplane{d,a}] : List<&2,M.Edge>}
law clip_quad_exact:
  for +quad:N.Quad
  for +p:G.Point
  for +q:G.Point
  {M.clip_quad(quad,p,q) == M.run(M.quad_edges(quad),Clip.Span{p,q}) : Clip.ClipResult}
law quad_closed_valid:
  for +quad:N.Quad
  for +p:G.Point
  for +q:G.Point
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  {M.valid(M.clip_quad(quad,p,q)) == True{} : Bool} & {Clip.in_region(quad,M.clip_quad(quad,p,q)) == True{} : Bool}
law quad_retained_present:
  for +quad:N.Quad
  for +p:G.Point
  for +q:G.Point
  for +r:G.Point
  for member:ClipL.Member(Clip.Span{p,q},r)
  for h:{Region.contains(r,quad) == True{} : Bool}
  {Clip.present(M.clip_quad(quad,p,q)) == True{} : Bool}
