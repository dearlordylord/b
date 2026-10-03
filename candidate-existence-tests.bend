import Base
import ./candidate-existence.bend as M
import ./candidate-existence-laws.bend as L
import ./candidate-existence-proof.bend as Proof
import ./intersection-search.bend as S
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

def box() -> N.Quad:
  N.Q{N.P{0n,0n},N.P{2n,0n},N.P{2n,2n},N.P{0n,2n}}
def xs() -> List<&2,G.Point>:
  [G.P{0n,0n,0n},G.P{3n,3n,1n},G.P{1n,1n,1n}]
def has_valid() -> {M.any_valid(xs(),box(),box()) == True{} : Bool}:
  {==}
def actual_witness() -> M.Witness(xs(),box(),box()):
  L.valid_candidate_witness(xs(),box(),box(),has_valid())
def empty_no_candidate() -> {M.any_valid([],box(),box()) == False{} : Bool}:
  L.miss_no_valid_candidate([],box(),box(),{==})
def append_valid() -> {M.any_valid(List.append(&2,G.Point,[G.P{0n,0n,0n}],[G.P{1n,1n,1n}]),box(),box()) == True{} : Bool}:
  {==}
def invalid_only() -> {M.found(S.scan([G.P{0n,0n,0n}],box(),box())) == False{} : Bool}:
  L.scan_found_exact([G.P{0n,0n,0n}],box(),box())
