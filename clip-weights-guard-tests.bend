import Base
import ./clip-weights.bend as M
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C

def p() -> G.Point: G.P{2n,4n,2n}
def q() -> G.Point: G.P{15n,3n,3n}
def exact_components() -> {M.rebase(p(),q(),4n,1n,2n,3n) == G.P{46n,38n,22n} : G.Point}:
  {==}
def saturated_guard_false() -> {Nat.is_le(Nat.mul(1n,3n),Nat.mul(1n,2n)) == False{} : Bool}:
  {==}
def saturation_changes_point() -> {G.equivalent(C.join(p(),q(),1n,1n),M.rebase(p(),q(),1n,1n,2n,3n)) == False{} : Bool}:
  {==}
def zero_scale_invalid() -> {G.positive_denominator(M.rebase(p(),q(),1n,0n,0n,3n)) == False{} : Bool}:
  {==}
