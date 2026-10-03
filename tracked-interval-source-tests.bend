import Base
import ./tracked-interval.bend as M
import ./tracked-interval-laws.bend as L
import ./tracked-interval-proof.bend as Proof
import ./tracked-interval-fixtures.bend as F
import ./interval-walk.bend as Walk
import ./interval-clip.bend as Clip
import ./homogeneous-geometry.bend as G

def source_members() -> L.SourceMembers(F.p(),F.q(),M.clip_quad(F.p(),F.q(),F.box())): L.quad_source_endpoints(F.p(),F.q(),F.box(),{==},{==})
def fraction_members() -> L.SourceMembers(G.P{0n,4n,2n},G.P{12n,6n,3n},M.clip_quad(G.P{0n,4n,2n},G.P{12n,6n,3n},F.box())): L.quad_source_endpoints(G.P{0n,4n,2n},G.P{12n,6n,3n},F.box(),{==},{==})
