import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut

type ClipResult is Data:
  Gone{}
  Span{left:G.Point,right:G.Point}
# Mixed cases put the retained original endpoint first.
def choose(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,cp:Bool,cq:Bool) -> ClipResult:
  match cp cq:
    case True{} True{}: Span{p,q}
    case True{} False{}: Span{p,Cut.point(a,b,p,q)}
    case False{} True{}: Span{q,Cut.point(a,b,q,p)}
    case False{} False{}: Gone{}
def clip(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point) -> ClipResult:
  choose(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q))
def present(result:ClipResult) -> Bool:
  match result:
    case Gone{}: False{}
    case Span{p,q}: True{}
def closed_valid(+a:N.Point,+b:N.Point,result:ClipResult) -> Bool:
  match result:
    case Gone{}: True{}
    case Span{+p,+q}: (G.positive_denominator(p) && G.positive_denominator(q)) && (Region.edge(a,b,p) && Region.edge(a,b,q))
def in_region(+r:N.Quad,result:ClipResult) -> Bool:
  match result:
    case Gone{}: True{}
    case Span{p,q}: Region.contains(p,r) && Region.contains(q,r)
