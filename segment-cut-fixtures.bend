import Base
import ./segment-cut.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S

def a() -> N.Point: N.P{0n, 2n}
def b() -> N.Point: N.P{6n, 2n}
def p() -> G.Point: G.P{1n, 4n, 1n}
def q() -> G.Point: G.P{5n, 1n, 1n}
def box() -> N.Quad: N.Q{N.P{0n, 0n}, N.P{6n, 0n}, N.P{6n, 5n}, N.P{0n, 5n}}
