import Base
import ./clip-halfplane.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S
import ./segment-cut.bend as Cut
import ./triangle-coordinate.bend as Scale

# Exact decision characterization, including rejection of outside weighted points.
law closed_join_balance_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  {M.balance(a,b,p,q,k,l) == Region.edge(a,b,C.join(p,q,k,l)) : Bool}
# The clipping coefficient balance follows from the three geometric decisions.
law closed_join_balance:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for hp:{Region.edge(a,b,p) == True{} : Bool}
  for hq:{S.negative(a,b,q) == True{} : Bool}
  for h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  {M.balance(a,b,p,q,k,l) == True{} : Bool}
# The positive-inside-gap branch retains the old point in the clipped segment.
law positive_gap_retained_member:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  for +h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for +hw:{Nat.is_gt(Cut.second_weight(a,b,p),0n) == True{} : Bool}
  for +hpd:{G.positive_denominator(p) == True{} : Bool}
  for +hqd:{G.positive_denominator(q) == True{} : Bool}
  Cut.InSegment(p,Cut.point(a,b,p,q),C.join(p,q,k,l))

# The actual geometry-bound rebase uses the proved inside gap as its scale.
law halfplane_rebase_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  for +h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  {M.rebased(a,b,p,q,k,l) == Scale.scaled(C.join(p,q,k,l),Cut.second_weight(a,b,p)) : G.Point}
law positive_gap_rebased_valid:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  for +h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for +hw:{Nat.is_gt(Cut.second_weight(a,b,p),0n) == True{} : Bool}
  for +hpd:{G.positive_denominator(p) == True{} : Bool}
  for +hqd:{G.positive_denominator(q) == True{} : Bool}
  {G.positive_denominator(M.rebased(a,b,p,q,k,l)) == True{} : Bool} & {G.equivalent(C.join(p,q,k,l),M.rebased(a,b,p,q,k,l)) == True{} : Bool}
# On the boundary, a retained closed point cannot use the strictly outside end.
law zero_gap_second_weight_zero:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  for +h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for +hw:{Cut.second_weight(a,b,p) == 0n : Nat}
  {l == 0n : Nat}
law zero_gap_retained_member:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  for +h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for +hw:{Cut.second_weight(a,b,p) == 0n : Nat}
  for +hpd:{G.positive_denominator(p) == True{} : Bool}
  for +hqd:{G.positive_denominator(q) == True{} : Bool}
  Cut.InSegment(p,Cut.point(a,b,p,q),C.join(p,q,k,l))
# One-sided clipping preserves every valid weighted point that remains closed.
law retained_member_all_gaps:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{Region.edge(a,b,p) == True{} : Bool}
  for +hq:{S.negative(a,b,q) == True{} : Bool}
  for +h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for +hpd:{G.positive_denominator(p) == True{} : Bool}
  for +hqd:{G.positive_denominator(q) == True{} : Bool}
  Cut.InSegment(p,Cut.point(a,b,p,q),C.join(p,q,k,l))
