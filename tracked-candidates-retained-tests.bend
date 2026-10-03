import Base
import ./tracked-candidates-laws.bend as L
import ./tracked-candidates-proof.bend as Proof
import ./tracked-interval.bend as Trace
import ./tracked-interval-fixtures.bend as F
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N

def actual_left_boundary() -> {Cross.crosses(N.P{3n,1n},N.P{3n,3n},F.p(),F.q()) == True{} : Bool} & {G.equivalent(Trace.point(F.p(),F.q(),Trace.End{2n,6n,Trace.Boundary{N.P{3n,1n},N.P{3n,3n}}}),Boundary.direct(N.P{3n,1n},N.P{3n,3n},F.p(),F.q())) == True{} : Bool}:
  L.retained_left_boundary(F.p(),F.q(),F.box(),N.P{3n,1n},N.P{3n,3n},2n,6n,Trace.End{36n,12n,Trace.Boundary{N.P{1n,3n},N.P{1n,1n}}},{==},{==},{==})

def actual_right_boundary() -> {Cross.crosses(N.P{1n,3n},N.P{1n,1n},F.p(),F.q()) == True{} : Bool} & {G.equivalent(Trace.point(F.p(),F.q(),Trace.End{36n,12n,Trace.Boundary{N.P{1n,3n},N.P{1n,1n}}}),Boundary.direct(N.P{1n,3n},N.P{1n,1n},F.p(),F.q())) == True{} : Bool}:
  L.retained_right_boundary(F.p(),F.q(),F.box(),N.P{1n,3n},N.P{1n,1n},36n,12n,Trace.End{2n,6n,Trace.Boundary{N.P{3n,1n},N.P{3n,3n}}},{==},{==},{==})
