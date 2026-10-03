import Base
import ./segment-boundary.bend as M
import ./segment-boundary-laws.bend as L
import ./segment-boundary-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut
import ./halfplane-region.bend as Region

def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{1n,1n}
def p() -> G.Point: G.P{0n,3n,1n}
def q() -> G.Point: G.P{1n,0n,1n}
def box() -> N.Quad: N.Q{N.P{0n,0n},N.P{2n,0n},N.P{2n,2n},N.P{0n,2n}}
def actual_ratio() -> {M.ratio(a(),b(),p(),q(),2n,4n) == True{} : Bool}:
  L.ratio_on_line_exact(a(),b(),p(),q(),2n,4n,{==},{==})
def interior_rejected() -> {M.ratio(a(),b(),p(),q(),1n,1n) == False{} : Bool}:
  L.ratio_on_line_exact(a(),b(),p(),q(),1n,1n,{==},{==})
