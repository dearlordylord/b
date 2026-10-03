import Base
import ./interval-walk.bend as M
import ./interval-walk-laws.bend as L
import ./interval-walk-proof.bend as Proof
import ./interval-clip.bend as Clip
import ./interval-walk-fixtures.bend as F
import ./homogeneous-geometry.bend as G

def middle_survives() -> {Clip.present(M.clip_quad(F.box(),F.p(),F.q())) == True{} : Bool}: L.quad_retained_present(F.box(),F.p(),F.q(),G.P{2n,2n,1n},(1n,(1n,({==},({==},({==},({==},{==})))))),{==})
def reverse_middle_survives() -> {Clip.present(M.clip_quad(F.box(),F.q(),F.p())) == True{} : Bool}: L.quad_retained_present(F.box(),F.q(),F.p(),G.P{8n,8n,4n},(1n,(1n,({==},({==},({==},({==},{==})))))),{==})
def boundary_survives() -> {Clip.present(M.clip_quad(F.box(),G.P{0n,1n,1n},G.P{1n,1n,1n})) == True{} : Bool}: L.quad_retained_present(F.box(),G.P{0n,1n,1n},G.P{1n,1n,1n},G.P{1n,1n,1n},(0n,(1n,({==},({==},({==},({==},{==})))))),{==})
