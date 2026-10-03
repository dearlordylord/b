import Base
import ./tracked-interval-laws.bend as L
import ./tracked-interval-proof.bend as Proof
import ./tracked-interval.bend as Trace
import ./tracked-interval-fixtures.bend as F
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./natural-cover.bend as N

def left() -> Trace.Endpoint: Trace.End{2n,6n,Trace.Boundary{N.P{3n,1n},N.P{3n,3n}}}
def right() -> Trace.Endpoint: Trace.End{36n,12n,Trace.Boundary{N.P{1n,3n},N.P{1n,1n}}}
def actual_closed_valid() -> ({G.positive_denominator(Trace.point(F.p(),F.q(),left())) == True{} : Bool} & {G.positive_denominator(Trace.point(F.p(),F.q(),right())) == True{} : Bool}) & ({Region.contains(Trace.point(F.p(),F.q(),left()),F.box()) == True{} : Bool} & {Region.contains(Trace.point(F.p(),F.q(),right()),F.box()) == True{} : Bool}):
  L.retained_closed_valid(F.p(),F.q(),F.box(),left(),right(),{==},{==},{==})
