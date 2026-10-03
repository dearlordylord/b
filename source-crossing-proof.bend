import Base
import ./source-crossing.bend as M
import ./source-crossing-laws.bend as L
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./homogeneous-source-proof.bend as Basis
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S
import ./strict-geometry-proof.bend as SP
import ./boolean-reflection.bend as B

def L.different_exact(cp,cq):
  match cp cq:
    case True{} False{}: {==}
    case False{} True{}: {==}
    case True{} True{}: {==}
    case False{} False{}: {==}
def L.crosses_exact(a,b,p,q):
  L.different_exact(Region.edge(a,b,p),Region.edge(a,b,q))
def closed_join(a:N.Point,b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,hp:{Region.edge(a,b,p) == True{} : Bool},hq:{Region.edge(a,b,q) == True{} : Bool}) -> {Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}:
  match a b:
    case N.P{ax,ay} N.P{bx,by}: CL.halfplane_weighted_join(ax,ay,bx,by,p,q,k,l,hp,hq)
def crossing_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,+m:Nat,+n:Nat,cp:Bool,cq:Bool,hp:{Region.edge(a,b,p) == cp : Bool},hq:{Region.edge(a,b,q) == cq : Bool},hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},hc:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool},hn:{S.negative(a,b,C.join(p,q,m,n)) == True{} : Bool}) -> {M.different(cp,cq) == True{} : Bool}:
  match cp cq:
    case True{} False{}: {==}
    case False{} True{}: {==}
    case True{} True{}: B.absurd({M.different(True{},True{}) == True{} : Bool},SP.strict_closed_impossible(a,b,C.join(p,q,m,n),closed_join(a,b,p,q,m,n,hp,hq),hn))
    case False{} False{}: B.absurd({M.different(False{},False{}) == True{} : Bool},SP.strict_closed_impossible(a,b,C.join(p,q,k,l),hc,SP.negative_weighted_join(a,b,p,q,k,l,SP.negative_from_false(a,b,p,hp),SP.negative_from_false(a,b,q,hq),hs)))
def L.weighted_crossing(a,b,p,q,k,l,m,n,hs,hc,hn):
  crossing_cases(a,b,p,q,k,l,m,n,Region.edge(a,b,p),Region.edge(a,b,q),{==},{==},hs,hc,hn)
def L.valid_crossing(a,b,p,q,k,l,m,n,hp,hc,hn):
  L.weighted_crossing(a,b,p,q,k,l,m,n,Basis.positive_coefficients(p,q,k,l,hp),hc,hn)
