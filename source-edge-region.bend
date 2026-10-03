import Base
import ./intersection-search.bend as Search
import ./quad-geometry.bend as Q
import ./halfplane-region.bend as Region
import ./natural-cover.bend as N

def edge_inside(edge:Search.Edge,+quad:N.Quad) -> Bool:
  match edge:
    case Search.E{a,b}: Region.contains(Q.embed(a),quad) && Region.contains(Q.embed(b),quad)
def all_inside(edges:List<&2,Search.Edge>,+quad:N.Quad) -> Bool:
  match edges:
    case []: True{}
    case head <> rest: edge_inside(head,quad) && all_inside(rest,quad)
