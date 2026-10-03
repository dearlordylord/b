import Base
import ./interval-walk.bend as M
import ./interval-clip.bend as Clip
import ./interval-walk-laws.bend as L
import ./interval-walk-proof.bend as Proof
import ./interval-walk-fixtures.bend as F
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region

def final_valid() -> {M.valid(M.clip_quad(F.box(),F.p(),F.q())) == True{} : Bool}: L.run_valid(M.quad_edges(F.box()),Clip.Span{F.p(),F.q()},{==})
def final_all_closed() -> {M.closed(M.quad_edges(F.box()),M.clip_quad(F.box(),F.p(),F.q())) == True{} : Bool}: L.run_closed(M.quad_edges(F.box()),Clip.Span{F.p(),F.q()},{==})
def prior_kept() -> {M.closed(F.prior(),M.clip_quad(F.box(),F.p(),F.q())) == True{} : Bool}: L.run_preserves(M.quad_edges(F.box()),F.prior(),Clip.Span{F.p(),F.q()},{==})
def unequal_denominators() -> {M.valid(M.clip_quad(F.box(),G.P{0n,4n,2n},G.P{12n,6n,3n})) == True{} : Bool} & {Clip.in_region(F.box(),M.clip_quad(F.box(),G.P{0n,4n,2n},G.P{12n,6n,3n})) == True{} : Bool}: L.quad_closed_valid(F.box(),G.P{0n,4n,2n},G.P{12n,6n,3n},{==},{==})
def closed_membership() -> {M.inside(G.P{1n,1n,1n},M.quad_edges(F.box())) == Region.contains(G.P{1n,1n,1n},F.box()) : Bool}: L.quad_membership_exact(G.P{1n,1n,1n},F.box())
