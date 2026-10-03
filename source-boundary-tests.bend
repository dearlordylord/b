import Base
import ./source-boundary.bend as M
import ./source-boundary-laws.bend as L
import ./source-boundary-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./tracked-interval.bend as Trace

def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{4n,1n}
def p() -> G.Point: G.P{0n,4n,2n}
def q() -> G.Point: G.P{12n,0n,3n}
def left() -> Trace.Endpoint: Trace.End{1n,0n,Trace.SourceLeft{}}
def right() -> Trace.Endpoint: Trace.End{0n,1n,Trace.SourceRight{}}
def actual_cut() -> {G.equivalent(Trace.point(p(),q(),Trace.cut_endpoint(a(),b(),p(),q(),left(),right())),M.direct(a(),b(),p(),q())) == True{} : Bool}: L.traced_cut_direct(a(),b(),p(),q(),left(),right(),{==},{==},{==})
def source_reverse() -> {G.equivalent(Trace.point(q(),p(),Trace.cut_endpoint(a(),b(),q(),p(),right(),left())),M.direct(a(),b(),q(),p())) == True{} : Bool}: L.traced_cut_direct(a(),b(),q(),p(),right(),left(),{==},{==},{==})
