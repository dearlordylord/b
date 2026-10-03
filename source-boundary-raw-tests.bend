import Base
import ./source-boundary.bend as M
import ./source-crossing.bend as Cross
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./segment-cut.bend as Cut

def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{4n,1n}
def p() -> G.Point: G.P{0n,4n,2n}
def q() -> G.Point: G.P{12n,0n,3n}
def forward() -> {M.direct(a(),b(),p(),q()) == Cut.point(a(),b(),p(),q()) : G.Point}: {==}
def reverse() -> {M.direct(a(),b(),q(),p()) == Cut.point(a(),b(),p(),q()) : G.Point}: {==}
def boundary_closed() -> {Cross.crosses(a(),b(),G.P{2n,1n,1n},q()) == True{} : Bool}: {==}
def boundary_kept() -> {G.equivalent(M.direct(a(),b(),G.P{2n,1n,1n},q()),G.P{2n,1n,1n}) == True{} : Bool}: {==}
