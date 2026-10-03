import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region

def different(cp:Bool,cq:Bool) -> Bool:
  match cp cq:
    case True{} False{}: True{}
    case False{} True{}: True{}
    case True{} True{}: False{}
    case False{} False{}: False{}
def crosses(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point) -> Bool:
  different(Region.edge(a,b,p),Region.edge(a,b,q))
