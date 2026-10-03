import Base
import ./segment-provenance.bend as M
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./natural-cover.bend as N
import ./segment-cut.bend as Cut
import ./strict-halfplane.bend as S

# Exact raw equality preserves source-segment identity, including denominator.
law compose_exact:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +m:Nat
  for +n:Nat
  for +v:Nat
  for +w:Nat
  {M.compose(p,q,k,l,m,n,v,w) == C.join(C.join(p,q,k,l),C.join(p,q,m,n),v,w) : G.Point}

# Valid endpoint witnesses and a nonempty outer combination remain valid.
law compose_positive:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +m:Nat
  for +n:Nat
  for +v:Nat
  for +w:Nat
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  for hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for ht:{Nat.is_gt(Nat.add(m,n),0n) == True{} : Bool}
  for hu:{Nat.is_gt(Nat.add(v,w),0n) == True{} : Bool}
  {G.positive_denominator(M.compose(p,q,k,l,m,n,v,w)) == True{} : Bool}

# A cut of reparameterized endpoints has exact original-source coefficients.
law source_cut_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +m:Nat
  for +n:Nat
  {M.cut_on_source(a,b,p,q,k,l,m,n) == Cut.point(a,b,C.join(p,q,k,l),C.join(p,q,m,n)) : G.Point}

law source_cut_positive:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +m:Nat
  for +n:Nat
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  for hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for ht:{Nat.is_gt(Nat.add(m,n),0n) == True{} : Bool}
  for h:{S.negative(a,b,C.join(p,q,m,n)) == True{} : Bool}
  {G.positive_denominator(M.cut_on_source(a,b,p,q,k,l,m,n)) == True{} : Bool}
