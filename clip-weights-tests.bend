import Base
import ./clip-weights.bend as M
import ./clip-weights-laws.bend as L
import ./clip-weights-proof.bend as Proof
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut

def p() -> G.Point: G.P{2n,4n,2n}
def q() -> G.Point: G.P{15n,3n,3n}
# Unequal rational endpoint denominators, both retained weights nonzero.
def interior_member() -> Cut.InSegment(p(),C.join(p(),q(),3n,2n),C.join(p(),q(),4n,1n)):
  L.rebase_segment_member(p(),q(),4n,1n,2n,3n,{==},{==},{==},{==},{==})
# Equality in the balance guard permits a zero first coefficient.
def boundary_member() -> Cut.InSegment(p(),C.join(p(),q(),3n,2n),C.join(p(),q(),3n,2n)):
  L.rebase_segment_member(p(),q(),3n,2n,2n,3n,{==},{==},{==},{==},{==})
# Zero second coefficient takes the product-positivity branch.
def first_endpoint_member() -> Cut.InSegment(p(),C.join(p(),q(),3n,2n),C.join(p(),q(),1n,0n)):
  L.rebase_segment_member(p(),q(),1n,0n,2n,3n,{==},{==},{==},{==},{==})
