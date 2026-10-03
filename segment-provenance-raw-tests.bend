import Base
import ./segment-provenance.bend as M
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./natural-cover.bend as N

def unequal_denominators() -> {M.compose(G.P{1n,4n,2n},G.P{5n,1n,3n},2n,1n,1n,3n,2n,1n) == G.P{30n,25n,25n} : G.Point}:
  {==}
def zero_outer() -> {M.compose(G.P{1n,4n,2n},G.P{5n,1n,3n},2n,1n,1n,3n,0n,0n) == G.P{0n,0n,0n} : G.Point}:
  {==}
def zero_pair() -> {M.compose(G.P{1n,4n,2n},G.P{5n,1n,3n},0n,0n,1n,3n,2n,1n) == C.join(G.P{1n,4n,2n},G.P{5n,1n,3n},1n,3n) : G.Point}:
  {==}

def boundary_cut_components() -> {M.cut_on_source(N.P{0n,1n},N.P{6n,1n},G.P{1n,4n,2n},G.P{5n,1n,3n},1n,1n,1n,3n) == G.P{144n,120n,120n} : G.Point}:
  {==}
