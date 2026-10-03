import Base
import ./strict-halfplane.bend as M
import ./halfplane-region.bend as Region
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

def strict_not_not(b:Bool) -> {b == Bool.not(Bool.not(b)) : Bool}:
  match b:
    case False{}: {==}
    case True{}: {==}
def negative_closed_complement(a:N.Point,b:N.Point,p:G.Point) -> {M.negative(a,b,p) == Bool.not(Region.edge(a,b,p)) : Bool}:
  match a b:
    case N.P{ax,ay} N.P{bx,by}: strict_not_not(Cmp.is_lt(G.side(ax,ay,bx,by,p)))
def negative_from_false(+a:N.Point,+b:N.Point,+p:G.Point,h:{Region.edge(a,b,p) == False{} : Bool}) -> {M.negative(a,b,p) == True{} : Bool}:
  Equal.trans(Bool,M.negative(a,b,p),Bool.not(Region.edge(a,b,p)),True{},negative_closed_complement(a,b,p),Equal.cong(Bool,Bool,x => Bool.not(x),Region.edge(a,b,p),False{},h))
