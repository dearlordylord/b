import Base
import ./clip-weights.bend as M
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./triangle-coordinate.bend as Scale
import ./segment-cut.bend as Cut

# No truncated-subtraction error is hidden in the retained coefficient.
law retained_reconstruct:
  for +k:Nat
  for +l:Nat
  for +w:Nat
  for +v:Nat
  for h:{Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) == True{} : Bool}
  {Nat.add(M.retained(k,l,w,v),Nat.mul(l,v)) == Nat.mul(k,w) : Nat}
# All three homogeneous components, including denominator, are preserved.
law rebase_exact:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +w:Nat
  for +v:Nat
  for +h:{Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) == True{} : Bool}
  {M.rebase(p,q,k,l,w,v) == Scale.scaled(C.join(p,q,k,l),w) : G.Point}
# A nonempty old coefficient pair stays nonempty when the scale w is positive.
law retained_total_positive:
  for +k:Nat
  for +l:Nat
  for +w:Nat
  for +v:Nat
  for +h:{Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) == True{} : Bool}
  for hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for hw:{Nat.is_gt(w,0n) == True{} : Bool}
  {Nat.is_gt(Nat.add(M.retained(k,l,w,v),l),0n) == True{} : Bool}
law rebase_valid:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +w:Nat
  for +v:Nat
  for +h:{Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) == True{} : Bool}
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for +hw:{Nat.is_gt(w,0n) == True{} : Bool}
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  {G.positive_denominator(M.rebase(p,q,k,l,w,v)) == True{} : Bool} & {G.equivalent(C.join(p,q,k,l),M.rebase(p,q,k,l,w,v)) == True{} : Bool}

# The original point has explicit nonnegative weights in the retained segment.
law rebase_segment_member:
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +w:Nat
  for +v:Nat
  for +h:{Nat.is_le(Nat.mul(l,v),Nat.mul(k,w)) == True{} : Bool}
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for +hw:{Nat.is_gt(w,0n) == True{} : Bool}
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  Cut.InSegment(p,C.join(p,q,v,w),C.join(p,q,k,l))
