import Base
import ./segment-proportional.bend as M
import ./segment-proportional-laws.bend as L
import ./segment-proportional-proof.bend as Proof
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./natural-cover.bend as N
import ./halfplane-region.bend as Region

def p() -> G.Point: G.P{0n,2n,1n}
def q() -> G.Point: G.P{2n,0n,2n}
def box() -> N.Quad: N.Q{N.P{0n,0n},N.P{2n,0n},N.P{2n,2n},N.P{0n,2n}}
def actual_ratio() -> {M.proportional(1n,2n,2n,4n) == True{} : Bool}:
  L.proportional_exact(1n,2n,2n,4n)
def fraction_same() -> {M.same_point(p(),q(),1n,2n,2n,4n) == True{} : Bool}:
  L.proportional_same_point(p(),q(),1n,2n,2n,4n,{==})
def inside_region_preserved() -> {Region.contains(C.join(p(),q(),1n,2n),box()) == Region.contains(C.join(p(),q(),2n,4n),box()) : Bool}:
  L.proportional_region_exact(p(),q(),box(),1n,2n,2n,4n,{==},{==},{==},{==},{==})
def zero_endpoint_weight() -> {M.same_point(p(),q(),0n,2n,0n,3n) == True{} : Bool}:
  L.proportional_same_point(p(),q(),0n,2n,0n,3n,{==})
def zero_pair_algebra_only() -> {M.same_point(p(),q(),0n,0n,1n,2n) == True{} : Bool}:
  L.proportional_same_point(p(),q(),0n,0n,1n,2n,{==})

def outside_region_preserved() -> {Region.contains(C.join(G.P{3n,0n,1n},G.P{4n,0n,1n},1n,2n),box()) == Region.contains(C.join(G.P{3n,0n,1n},G.P{4n,0n,1n},2n,4n),box()) : Bool}:
  L.proportional_region_exact(G.P{3n,0n,1n},G.P{4n,0n,1n},box(),1n,2n,2n,4n,{==},{==},{==},{==},{==})
