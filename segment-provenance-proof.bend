import Base
import ./segment-provenance.bend as M
import ./segment-provenance-laws.bend as L
import ./homogeneous-geometry.bend as G
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./facts.bend as F
import ./natural-cover.bend as N
import ./segment-cut.bend as Cut
import ./segment-cut-laws.bend as CutL
import ./segment-cut-proof.bend as CutProof

def scalar_compose(+a:Nat,+b:Nat,+k:Nat,+l:Nat,+m:Nat,+n:Nat,+v:Nat,+w:Nat) -> {Nat.add(Nat.mul(a,Nat.add(Nat.mul(k,v),Nat.mul(m,w))),Nat.mul(b,Nat.add(Nat.mul(l,v),Nat.mul(n,w)))) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}:
  %Equal.sym(Nat,Nat.mul(a,Nat.add(Nat.mul(k,v),Nat.mul(m,w))),Nat.add(Nat.mul(a,Nat.mul(k,v)),Nat.mul(a,Nat.mul(m,w))),F.mul_add(a,Nat.mul(k,v),Nat.mul(m,w))) : {Nat.add(_,Nat.mul(b,Nat.add(Nat.mul(l,v),Nat.mul(n,w)))) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %Equal.sym(Nat,Nat.mul(b,Nat.add(Nat.mul(l,v),Nat.mul(n,w))),Nat.add(Nat.mul(b,Nat.mul(l,v)),Nat.mul(b,Nat.mul(n,w))),F.mul_add(b,Nat.mul(l,v),Nat.mul(n,w))) : {Nat.add(Nat.add(Nat.mul(a,Nat.mul(k,v)),Nat.mul(a,Nat.mul(m,w))),_) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %Equal.sym(Nat,Nat.add(Nat.add(Nat.mul(a,Nat.mul(k,v)),Nat.mul(a,Nat.mul(m,w))),Nat.add(Nat.mul(b,Nat.mul(l,v)),Nat.mul(b,Nat.mul(n,w)))),Nat.add(Nat.add(Nat.mul(a,Nat.mul(k,v)),Nat.mul(b,Nat.mul(l,v))),Nat.add(Nat.mul(a,Nat.mul(m,w)),Nat.mul(b,Nat.mul(n,w)))),F.add_add_add_comm(Nat.mul(a,Nat.mul(k,v)),Nat.mul(a,Nat.mul(m,w)),Nat.mul(b,Nat.mul(l,v)),Nat.mul(b,Nat.mul(n,w)))) : {_ == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %F.mul_assoc(a,k,v) : {Nat.add(Nat.add(_,Nat.mul(b,Nat.mul(l,v))),Nat.add(Nat.mul(a,Nat.mul(m,w)),Nat.mul(b,Nat.mul(n,w)))) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %F.mul_assoc(b,l,v) : {Nat.add(Nat.add(Nat.mul(Nat.mul(a,k),v),_),Nat.add(Nat.mul(a,Nat.mul(m,w)),Nat.mul(b,Nat.mul(n,w)))) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %F.mul_assoc(a,m,w) : {Nat.add(Nat.add(Nat.mul(Nat.mul(a,k),v),Nat.mul(Nat.mul(b,l),v)),Nat.add(_,Nat.mul(b,Nat.mul(n,w)))) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %F.mul_assoc(b,n,w) : {Nat.add(Nat.add(Nat.mul(Nat.mul(a,k),v),Nat.mul(Nat.mul(b,l),v)),Nat.add(Nat.mul(Nat.mul(a,m),w),_)) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %F.add_mul(Nat.mul(a,k),Nat.mul(b,l),v) : {Nat.add(_,Nat.add(Nat.mul(Nat.mul(a,m),w),Nat.mul(Nat.mul(b,n),w))) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  %F.add_mul(Nat.mul(a,m),Nat.mul(b,n),w) : {Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),_) == Nat.add(Nat.mul(Nat.add(Nat.mul(a,k),Nat.mul(b,l)),v),Nat.mul(Nat.add(Nat.mul(a,m),Nat.mul(b,n)),w)) : Nat}
  {==}
def L.compose_exact(p,q,k,l,m,n,v,w):
  match p q:
    case G.P{+x,+y,+d} G.P{+u,+z,+e}:
      GP.point_equal(Nat.add(Nat.mul(x,M.first(k,m,v,w)),Nat.mul(u,M.second(l,n,v,w))),Nat.add(Nat.mul(y,M.first(k,m,v,w)),Nat.mul(z,M.second(l,n,v,w))),Nat.add(Nat.mul(d,M.first(k,m,v,w)),Nat.mul(e,M.second(l,n,v,w))),Nat.add(Nat.mul(Nat.add(Nat.mul(x,k),Nat.mul(u,l)),v),Nat.mul(Nat.add(Nat.mul(x,m),Nat.mul(u,n)),w)),Nat.add(Nat.mul(Nat.add(Nat.mul(y,k),Nat.mul(z,l)),v),Nat.mul(Nat.add(Nat.mul(y,m),Nat.mul(z,n)),w)),Nat.add(Nat.mul(Nat.add(Nat.mul(d,k),Nat.mul(e,l)),v),Nat.mul(Nat.add(Nat.mul(d,m),Nat.mul(e,n)),w)),scalar_compose(x,u,k,l,m,n,v,w),scalar_compose(y,z,k,l,m,n,v,w),scalar_compose(d,e,k,l,m,n,v,w))
def L.compose_positive(p,q,k,l,m,n,v,w,hp,hq,hs,ht,hu):
  Equal.trans(Bool,G.positive_denominator(M.compose(p,q,k,l,m,n,v,w)),G.positive_denominator(C.join(C.join(p,q,k,l),C.join(p,q,m,n),v,w)),True{},Equal.cong(G.Point,Bool,x => G.positive_denominator(x),M.compose(p,q,k,l,m,n,v,w),C.join(C.join(p,q,k,l),C.join(p,q,m,n),v,w),L.compose_exact(p,q,k,l,m,n,v,w)),CL.joined_denominator_positive(C.join(p,q,k,l),C.join(p,q,m,n),v,w,CL.joined_denominator_positive(p,q,k,l,hp,hq,hs),CL.joined_denominator_positive(p,q,m,n,hp,hq,ht),hu))

def L.source_cut_exact(a,b,p,q,k,l,m,n):
  L.compose_exact(p,q,k,l,m,n,Cut.first_weight(a,b,C.join(p,q,m,n)),Cut.second_weight(a,b,C.join(p,q,k,l)))
def L.source_cut_positive(a,b,p,q,k,l,m,n,hp,hq,hs,ht,h):
  Equal.trans(Bool,G.positive_denominator(M.cut_on_source(a,b,p,q,k,l,m,n)),G.positive_denominator(Cut.point(a,b,C.join(p,q,k,l),C.join(p,q,m,n))),True{},Equal.cong(G.Point,Bool,x => G.positive_denominator(x),M.cut_on_source(a,b,p,q,k,l,m,n),Cut.point(a,b,C.join(p,q,k,l),C.join(p,q,m,n)),L.source_cut_exact(a,b,p,q,k,l,m,n)),CutL.crossing_denominator_positive(a,b,C.join(p,q,k,l),C.join(p,q,m,n),CL.joined_denominator_positive(p,q,k,l,hp,hq,hs),CL.joined_denominator_positive(p,q,m,n,hp,hq,ht),h))
