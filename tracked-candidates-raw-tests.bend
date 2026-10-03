import Base
import ./tracked-candidates.bend as M
import ./tracked-interval.bend as Trace
import ./tracked-interval-fixtures.bend as F
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N

def p() -> G.Point: G.P{0n,2n,1n}
def q() -> G.Point: G.P{4n,0n,1n}
def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{4n,1n}
def source_left() -> {M.label(p(),q(),p(),Trace.SourceLeft{}) == True{} : Bool}: {==}
def source_right() -> {M.label(p(),q(),q(),Trace.SourceRight{}) == True{} : Bool}: {==}
def wrong_boundary_point() -> {M.label(p(),q(),p(),Trace.Boundary{a(),b()}) == False{} : Bool}: {==}
def uncrossed_boundary() -> {M.label(p(),p(),p(),Trace.Boundary{a(),b()}) == False{} : Bool}: {==}
def actual_walk() -> {M.candidates(F.p(),F.q(),Trace.clip_quad(F.p(),F.q(),F.box())) == True{} : Bool}: {==}
def reversed_walk() -> {M.candidates(F.q(),F.p(),Trace.clip_quad(F.q(),F.p(),F.box())) == True{} : Bool}: {==}
def rejected_span() -> {M.candidates(p(),q(),Trace.Segment{Trace.End{0n,1n,Trace.SourceLeft{}},Trace.End{0n,1n,Trace.SourceRight{}}}) == False{} : Bool}: {==}
