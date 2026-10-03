import Base
import ./segment-proportional.bend as M
import ./homogeneous-geometry.bend as G

def unequal_denominators() -> {M.proportional(1n,2n,2n,4n) && M.same_point(G.P{0n,2n,1n},G.P{2n,0n,2n},1n,2n,2n,4n) == True{} : Bool}:
  {==}
def rejected_ratio() -> {M.proportional(1n,2n,2n,3n) == False{} : Bool}:
  {==}
def zero_pair_algebra() -> {M.proportional(0n,0n,1n,2n) && M.same_point(G.P{0n,2n,1n},G.P{2n,0n,2n},0n,0n,1n,2n) == True{} : Bool}:
  {==}
def zero_pair_invalid() -> {G.positive_denominator(G.P{0n,0n,0n}) == False{} : Bool}:
  {==}
