import Base
import ./source-crossing.bend as M
import ./source-crossing-laws.bend as L
import ./source-crossing-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region

def mixed_forward() -> {M.different(True{},False{}) == True{} : Bool}: {==}
def mixed_reverse() -> {M.different(False{},True{}) == True{} : Bool}: {==}
def both_inside() -> {M.different(True{},True{}) == False{} : Bool}: {==}
def both_outside() -> {M.different(False{},False{}) == False{} : Bool}: {==}
def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{4n,1n}
def p() -> G.Point: G.P{0n,4n,2n}
def q() -> G.Point: G.P{12n,0n,3n}
def weighted_forward() -> {M.crosses(a(),b(),p(),q()) == True{} : Bool}: L.weighted_crossing(a(),b(),p(),q(),1n,0n,0n,1n,{==},{==},{==})
def weighted_reverse() -> {M.crosses(a(),b(),q(),p()) == True{} : Bool}: L.weighted_crossing(a(),b(),q(),p(),0n,1n,1n,0n,{==},{==},{==})
def valid_forward() -> {M.crosses(a(),b(),p(),q()) == True{} : Bool}: L.valid_crossing(a(),b(),p(),q(),1n,0n,0n,1n,{==},{==},{==})
# Both sources are outside, but the zero combination lies on every line.
# This demonstrates why the nonzero-weight/positive-denominator premise matters.
def zero_combination_closed() -> {Region.edge(a(),b(),C.join(q(),q(),0n,0n)) == True{} : Bool}: {==}
def zero_sources_do_not_cross() -> {M.crosses(a(),b(),q(),q()) == False{} : Bool}: {==}
