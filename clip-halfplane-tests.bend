import Base
import ./clip-halfplane.bend as M
import ./clip-halfplane-laws.bend as L
import ./clip-halfplane-proof.bend as Proof
import ./clip-halfplane-fixtures.bend as F
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut

def interior_balance() -> {M.balance(F.a(),F.b(),F.p(),F.q(),1n,1n) == True{} : Bool}:
  L.closed_join_balance(F.a(),F.b(),F.p(),F.q(),1n,1n,{==},{==},{==})
def balance_equality() -> {M.balance(F.a(),F.b(),F.p(),F.q(),1n,2n) == True{} : Bool}:
  L.closed_join_balance(F.a(),F.b(),F.p(),F.q(),1n,2n,{==},{==},{==})
def positive_member() -> Cut.InSegment(F.p(),Cut.point(F.a(),F.b(),F.p(),F.q()),C.join(F.p(),F.q(),1n,1n)):
  L.positive_gap_retained_member(F.a(),F.b(),F.p(),F.q(),1n,1n,{==},{==},{==},{==},{==},{==},{==})
def all_gap_positive() -> Cut.InSegment(F.p(),Cut.point(F.a(),F.b(),F.p(),F.q()),C.join(F.p(),F.q(),1n,1n)):
  L.retained_member_all_gaps(F.a(),F.b(),F.p(),F.q(),1n,1n,{==},{==},{==},{==},{==},{==})
def actual_valid() -> {G.positive_denominator(M.rebased(F.a(),F.b(),F.p(),F.q(),1n,1n)) == True{} : Bool} & {G.equivalent(C.join(F.p(),F.q(),1n,1n),M.rebased(F.a(),F.b(),F.p(),F.q(),1n,1n)) == True{} : Bool}:
  L.positive_gap_rebased_valid(F.a(),F.b(),F.p(),F.q(),1n,1n,{==},{==},{==},{==},{==},{==},{==})

# The exact classifier rejects a weighted point outside the retained halfplane.
def rejected_outside() -> {M.balance(F.a(),F.b(),F.p(),F.q(),1n,3n) == False{} : Bool}:
  L.closed_join_balance_exact(F.a(),F.b(),F.p(),F.q(),1n,3n,{==},{==})
