import Base
import ./clip-halfplane-laws.bend as L
import ./clip-halfplane-proof.bend as Proof
import ./clip-halfplane-fixtures.bend as F
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut

def zero_second_coefficient() -> {0n == 0n : Nat}:
  L.zero_gap_second_weight_zero(F.a(),F.b(),F.boundary(),F.q(),1n,0n,{==},{==},{==},{==})
def boundary_member() -> Cut.InSegment(F.boundary(),Cut.point(F.a(),F.b(),F.boundary(),F.q()),C.join(F.boundary(),F.q(),1n,0n)):
  L.zero_gap_retained_member(F.a(),F.b(),F.boundary(),F.q(),1n,0n,{==},{==},{==},{==},{==},{==},{==})
def all_gap_boundary() -> Cut.InSegment(F.boundary(),Cut.point(F.a(),F.b(),F.boundary(),F.q()),C.join(F.boundary(),F.q(),1n,0n)):
  L.retained_member_all_gaps(F.a(),F.b(),F.boundary(),F.q(),1n,0n,{==},{==},{==},{==},{==},{==})
