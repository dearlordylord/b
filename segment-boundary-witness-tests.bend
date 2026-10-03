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
def same_cut() -> {G.equivalent(C.join(p(),q(),2n,4n),Cut.point(a(),b(),p(),q())) == True{} : Bool}:
  L.boundary_same_cut(a(),b(),p(),q(),2n,4n,{==},{==},{==})
def same_region() -> {Region.contains(C.join(p(),q(),2n,4n),box()) == Region.contains(Cut.point(a(),b(),p(),q()),box()) : Bool}:
  L.boundary_region_same_cut(a(),b(),p(),q(),box(),2n,4n,{==},{==},{==},{==},{==},{==})
def boundary_endpoint_same() -> {G.equivalent(C.join(G.P{0n,1n,1n},q(),2n,0n),Cut.point(a(),b(),G.P{0n,1n,1n},q())) == True{} : Bool}:
  L.boundary_same_cut(a(),b(),G.P{0n,1n,1n},q(),2n,0n,{==},{==},{==})
