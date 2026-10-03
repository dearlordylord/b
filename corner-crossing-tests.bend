import Base
import ./corner-candidate.bend as M
import ./candidate-existence.bend as E
import ./intersection-search.bend as S
import ./natural-cover.bend as N

def horizontal() -> N.Quad:
  N.Q{N.P{0n,1n},N.P{6n,1n},N.P{6n,3n},N.P{0n,3n}}
def vertical() -> N.Quad:
  N.Q{N.P{2n,0n},N.P{4n,0n},N.P{4n,4n},N.P{2n,4n}}
# A true crossing has no contained corner in either direction.
def no_corner_left() -> {M.inside_other(horizontal(),vertical()) == False{} : Bool}:
  {==}
def no_corner_right() -> {M.inside_other(vertical(),horizontal()) == False{} : Bool}:
  {==}
def crossing_hit() -> {E.found(S.find(horizontal(),vertical())) == True{} : Bool}:
  {==}
