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
def cut_exact() -> {M.cut_on_source(a(),b(),p(),q(),2n,1n,1n,3n) == Cut.point(a(),b(),C.join(p(),q(),2n,1n),C.join(p(),q(),1n,3n)) : G.Point}:
  L.source_cut_exact(a(),b(),p(),q(),2n,1n,1n,3n)
def cut_positive() -> {G.positive_denominator(M.cut_on_source(a(),b(),p(),q(),2n,1n,1n,3n)) == True{} : Bool}:
  L.source_cut_positive(a(),b(),p(),q(),2n,1n,1n,3n,{==},{==},{==},{==},{==})
def different_source_coefficients() -> {M.cut_on_source(a(),b(),p(),q(),10n,2n,1n,3n) == Cut.point(a(),b(),C.join(p(),q(),10n,2n),C.join(p(),q(),1n,3n)) : G.Point}:
  L.source_cut_exact(a(),b(),p(),q(),10n,2n,1n,3n)

def boundary_cut_positive() -> {G.positive_denominator(M.cut_on_source(a(),b(),p(),q(),1n,1n,1n,3n)) == True{} : Bool}:
  L.source_cut_positive(a(),b(),p(),q(),1n,1n,1n,3n,{==},{==},{==},{==},{==})
