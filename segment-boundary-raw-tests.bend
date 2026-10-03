import Base
import ./segment-boundary.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./segment-cut.bend as Cut

def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{1n,1n}
def p() -> G.Point: G.P{0n,3n,1n}
def q() -> G.Point: G.P{1n,0n,1n}
def exact_boundary() -> {M.ratio(a(),b(),p(),q(),2n,4n) && Cut.on_line(a(),b(),C.join(p(),q(),2n,4n)) == True{} : Bool}:
  {==}
def rejected_interior() -> {M.ratio(a(),b(),p(),q(),1n,1n) == False{} : Bool}:
  {==}
def rejected_exterior() -> {M.ratio(a(),b(),p(),q(),1n,3n) == False{} : Bool}:
  {==}
def zero_weight_algebra() -> {M.ratio(a(),b(),p(),q(),0n,0n) && Cut.on_line(a(),b(),C.join(p(),q(),0n,0n)) == True{} : Bool}:
  {==}
