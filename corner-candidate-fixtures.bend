import Base
import ./corner-candidate.bend as M
import ./candidate-existence.bend as E
import ./intersection-search.bend as S
import ./natural-cover.bend as N

def box() -> N.Quad:
  N.Q{N.P{0n,0n},N.P{4n,0n},N.P{4n,4n},N.P{0n,4n}}
def small_a() -> N.Quad:
  N.Q{N.P{0n,0n},N.P{1n,0n},N.P{1n,1n},N.P{0n,1n}}
def small_b() -> N.Quad:
  N.Q{N.P{3n,0n},N.P{5n,0n},N.P{5n,1n},N.P{3n,1n}}
def small_c() -> N.Quad:
  N.Q{N.P{3n,3n},N.P{5n,3n},N.P{5n,5n},N.P{3n,5n}}
def small_d() -> N.Quad:
  N.Q{N.P{0n,3n},N.P{1n,3n},N.P{1n,5n},N.P{0n,5n}}
