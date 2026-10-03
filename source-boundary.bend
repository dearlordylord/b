import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut

def choose(a:N.Point,b:N.Point,p:G.Point,q:G.Point,inside:Bool) -> G.Point:
  match inside:
    case True{}: Cut.point(a,b,p,q)
    case False{}: Cut.point(a,b,q,p)
def direct(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point) -> G.Point:
  choose(a,b,p,q,Region.edge(a,b,p))
