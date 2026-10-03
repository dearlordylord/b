import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./intersection-search.bend as Search

def a() -> N.Point: N.P{1n,1n}
def b() -> N.Point: N.P{3n,1n}
def c() -> N.Point: N.P{2n,4n}
def d() -> N.Point: N.P{2n,0n}
def q() -> N.Quad: N.Q{a(),b(),N.P{3n,3n},N.P{1n,3n}}
def r() -> N.Quad: N.Q{d(),N.P{4n,0n},N.P{4n,4n},c()}
def reversed_r() -> N.Quad: N.Q{d(),c(),N.P{4n,4n},N.P{4n,0n}}
def point() -> G.Point: G.P{4n,2n,2n}
def wide_q() -> N.Quad: N.Q{a(),N.P{5n,1n},N.P{5n,3n},N.P{1n,3n}}
def right_low() -> N.Point: N.P{4n,0n}
def right_high() -> N.Point: N.P{4n,4n}
def right_point() -> G.Point: G.P{8n,2n,2n}
