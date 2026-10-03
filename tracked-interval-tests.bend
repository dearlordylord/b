import Base
import ./tracked-interval.bend as M
import ./tracked-interval-laws.bend as L
import ./tracked-interval-proof.bend as Proof
import ./tracked-interval-fixtures.bend as F
import ./interval-walk.bend as Walk
import ./interval-clip.bend as Clip
import ./homogeneous-geometry.bend as G

def exact_plain_quad() -> {M.erase(F.p(),F.q(),M.clip_quad(F.p(),F.q(),F.box())) == Walk.clip_quad(F.box(),F.p(),F.q()) : Clip.ClipResult}: L.quad_erases(F.p(),F.q(),F.box())
def final_honest() -> {M.honest(F.p(),F.q(),M.clip_quad(F.p(),F.q(),F.box())) == True{} : Bool}: L.run_honest(F.p(),F.q(),Walk.quad_edges(F.box()),M.initial(),L.initial_honest(F.p(),F.q()))
