import Base
import ./segment-provenance.bend as M
import ./segment-provenance-laws.bend as L
import ./segment-provenance-proof.bend as Proof
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./natural-cover.bend as N
import ./segment-cut.bend as Cut

def p() -> G.Point: G.P{1n,4n,2n}
def q() -> G.Point: G.P{5n,1n,3n}
def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{6n,1n}
def composed_exact() -> {M.compose(p(),q(),2n,1n,1n,3n,2n,1n) == C.join(C.join(p(),q(),2n,1n),C.join(p(),q(),1n,3n),2n,1n) : G.Point}:
  L.compose_exact(p(),q(),2n,1n,1n,3n,2n,1n)
def composed_positive() -> {G.positive_denominator(M.compose(p(),q(),2n,1n,1n,3n,2n,1n)) == True{} : Bool}:
  L.compose_positive(p(),q(),2n,1n,1n,3n,2n,1n,{==},{==},{==},{==},{==})
