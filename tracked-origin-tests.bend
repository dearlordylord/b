import Base
import ./tracked-origin-laws.bend as L
import ./tracked-origin-proof.bend as Proof
import ./tracked-interval.bend as Trace
import ./tracked-interval-fixtures.bend as F
import ./interval-walk.bend as Walk
import ./natural-cover.bend as N

def actual_walk() -> L.StateAllowed(Walk.quad_edges(F.box()),Trace.clip_quad(F.p(),F.q(),F.box())): L.quad_allowed(F.p(),F.q(),F.box())
def reversed_walk() -> L.StateAllowed(Walk.quad_edges(F.box()),Trace.clip_quad(F.q(),F.p(),F.box())): L.quad_allowed(F.q(),F.p(),F.box())
def second_occurrence() -> L.Occurs(Walk.Halfplane{N.P{3n,1n},N.P{3n,3n}},Walk.quad_edges(F.box())): Inr{Inl{{==}}}
def direct_cut_origin() -> L.EndpointAllowed(Walk.quad_edges(F.box()),Trace.cut_endpoint(N.P{3n,1n},N.P{3n,3n},F.p(),F.q(),Trace.End{1n,0n,Trace.SourceLeft{}},Trace.End{0n,1n,Trace.SourceRight{}})): L.cut_allowed(Walk.quad_edges(F.box()),N.P{3n,1n},N.P{3n,3n},F.p(),F.q(),Trace.End{1n,0n,Trace.SourceLeft{}},Trace.End{0n,1n,Trace.SourceRight{}},second_occurrence())

def retained_left_occurrence() -> L.Occurs(Walk.Halfplane{N.P{3n,1n},N.P{3n,3n}},Walk.quad_edges(F.box())):
  L.retained_left_boundary(F.p(),F.q(),F.box(),N.P{3n,1n},N.P{3n,3n},2n,6n,Trace.End{36n,12n,Trace.Boundary{N.P{1n,3n},N.P{1n,1n}}},{==})
def retained_right_occurrence() -> L.Occurs(Walk.Halfplane{N.P{1n,3n},N.P{1n,1n}},Walk.quad_edges(F.box())):
  L.retained_right_boundary(F.p(),F.q(),F.box(),N.P{1n,3n},N.P{1n,1n},36n,12n,Trace.End{2n,6n,Trace.Boundary{N.P{3n,1n},N.P{3n,3n}}},{==})
