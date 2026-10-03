import Base
import ./intersection-search.bend as Search
import ./interval-walk.bend as Walk
import ./homogeneous-geometry.bend as G

# Occurrences carry exact head equality or a concrete tail occurrence.
def PointOccurs(-point:G.Point,points:List<&2,G.Point>) -> Type:
  match points:
    case []: Empty
    case head <> rest: Or({point == head : G.Point},PointOccurs(point,rest))
def EdgeOccurs(-edge:Search.Edge,edges:List<&2,Search.Edge>) -> Type:
  match edges:
    case []: Empty
    case head <> rest: Or({edge == head : Search.Edge},EdgeOccurs(edge,rest))
def convert(edge:Walk.Edge) -> Search.Edge:
  match edge:
    case Walk.Halfplane{a,b}: Search.E{a,b}
def converted(edges:List<&2,Walk.Edge>) -> List<&2,Search.Edge>:
  match edges:
    case []: []
    case head <> rest: convert(head) <> converted(rest)
