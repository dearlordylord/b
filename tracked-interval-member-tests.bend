import Base
import ./tracked-interval.bend as M
import ./tracked-interval-laws.bend as L
import ./tracked-interval-proof.bend as Proof
import ./tracked-interval-fixtures.bend as F
import ./interval-walk.bend as Walk
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./segment-cut.bend as Cut

def boundary_endpoint_source_member() -> Cut.InSegment(F.p(),F.q(),M.point(F.p(),F.q(),M.End{36n,12n,M.Boundary{N.P{1n,3n},N.P{1n,1n}}})): L.endpoint_member(F.p(),F.q(),M.End{36n,12n,M.Boundary{N.P{1n,3n},N.P{1n,1n}}},{==},{==},{==})
def corner_contact_source_members() -> L.SourceMembers(G.P{0n,1n,1n},G.P{1n,1n,1n},M.clip_quad(G.P{0n,1n,1n},G.P{1n,1n,1n},F.box())): L.quad_source_endpoints(G.P{0n,1n,1n},G.P{1n,1n,1n},F.box(),{==},{==})
def source_right_zero_weight() -> Cut.InSegment(F.p(),F.q(),M.point(F.p(),F.q(),M.End{0n,1n,M.SourceRight{}})): L.endpoint_member(F.p(),F.q(),M.End{0n,1n,M.SourceRight{}},{==},{==},{==})
