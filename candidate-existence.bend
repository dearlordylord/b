import Base
import ./intersection-search.bend as S
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

# Whether the supplied list contains a valid common-region point.
def any_valid(xs:List<&2,G.Point>,+q:N.Quad,+r:N.Quad) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h,t}: S.admit(h,q,r) || any_valid(t,q,r)
def found(result:S.SearchResult) -> Bool:
  match result:
    case S.Miss{}: False{}
    case S.Hit{p}: True{}
# The actual search output, with its acceptance predicate, is retained.
def Witness(-xs:List<&2,G.Point>,-q:N.Quad,-r:N.Quad) -> Type:
  &p:G.Point -> {S.scan(xs,q,r) == S.Hit{p} : S.SearchResult} & {S.admit(p,q,r) == True{} : Bool}
