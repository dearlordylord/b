import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./interval-clip.bend as Clip

type Edge is Data:
  Halfplane{start:N.Point,end:N.Point}
def step(edge:Edge,result:Clip.ClipResult) -> Clip.ClipResult:
  match edge result:
    case Halfplane{a,b} Clip.Gone{}: Clip.Gone{}
    case Halfplane{a,b} Clip.Span{p,q}: Clip.clip(a,b,p,q)
def run(edges:List<&2,Edge>,result:Clip.ClipResult) -> Clip.ClipResult:
  match edges:
    case []: result
    case edge <> rest: run(rest,step(edge,result))
def accepts(edge:Edge,p:G.Point) -> Bool:
  match edge:
    case Halfplane{a,b}: Region.edge(a,b,p)
def inside(+p:G.Point,edges:List<&2,Edge>) -> Bool:
  match edges:
    case []: True{}
    case edge <> rest: accepts(edge,p) && inside(p,rest)
def valid(result:Clip.ClipResult) -> Bool:
  match result:
    case Clip.Gone{}: True{}
    case Clip.Span{p,q}: G.positive_denominator(p) && G.positive_denominator(q)
def closed(+edges:List<&2,Edge>,result:Clip.ClipResult) -> Bool:
  match result:
    case Clip.Gone{}: True{}
    case Clip.Span{p,q}: inside(p,edges) && inside(q,edges)
def quad_edges(q:N.Quad) -> List<&2,Edge>:
  match q:
    case N.Q{+a,+b,+c,+d}: [Halfplane{a,b},Halfplane{b,c},Halfplane{c,d},Halfplane{d,a}]
def clip_quad(q:N.Quad,p:G.Point,r:G.Point) -> Clip.ClipResult:
  run(quad_edges(q),Clip.Span{p,r})
