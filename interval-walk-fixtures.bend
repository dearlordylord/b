import Base
import ./interval-walk.bend as M
import ./interval-clip.bend as Clip
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

def box() -> N.Quad: N.Q{N.P{1n,1n},N.P{3n,1n},N.P{3n,3n},N.P{1n,3n}}
def p() -> G.Point: G.P{0n,2n,1n}
def q() -> G.Point: G.P{4n,2n,1n}
def prior() -> List<&2,M.Edge>: [M.Halfplane{N.P{0n,2n},N.P{4n,2n}}]
