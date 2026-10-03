import Base
import ./tracked-interval.bend as M
import ./interval-walk.bend as Walk
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

def p() -> G.Point: G.P{0n,2n,1n}
def q() -> G.Point: G.P{4n,2n,1n}
def box() -> N.Quad: N.Q{N.P{1n,1n},N.P{3n,1n},N.P{3n,3n},N.P{1n,3n}}
def right_edge() -> Walk.Edge: Walk.Halfplane{N.P{3n,1n},N.P{3n,3n}}
