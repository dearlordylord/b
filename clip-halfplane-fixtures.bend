import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

def a() -> N.Point: N.P{0n,2n}
def b() -> N.Point: N.P{6n,2n}
def p() -> G.Point: G.P{1n,4n,1n}
def q() -> G.Point: G.P{5n,1n,1n}
def boundary() -> G.Point: G.P{3n,2n,1n}
