import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{1n,1n}
def p() -> G.Point: G.P{0n,3n,1n}
def q() -> G.Point: G.P{1n,0n,1n}
def inside() -> G.Point: G.P{1n,2n,1n}
def boundary() -> G.Point: G.P{0n,1n,1n}
def box() -> N.Quad: N.Q{N.P{0n,0n},N.P{3n,0n},N.P{3n,3n},N.P{0n,3n}}
