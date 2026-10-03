import Base
import ./interval-clip.bend as M
import ./interval-clip-laws.bend as L
import ./interval-clip-proof.bend as Proof
import ./interval-clip-fixtures.bend as F
import ./homogeneous-combination.bend as C

def forward_member() -> L.Member(M.clip(F.a(),F.b(),F.p(),F.q()),C.join(F.p(),F.q(),2n,4n)):
  L.retained_member(F.a(),F.b(),F.p(),F.q(),2n,4n,{==},{==},{==},{==})
def reversed_member() -> L.Member(M.clip(F.a(),F.b(),F.q(),F.p()),C.join(F.q(),F.p(),4n,2n)):
  L.retained_member(F.a(),F.b(),F.q(),F.p(),4n,2n,{==},{==},{==},{==})
def both_inside_member() -> L.Member(M.clip(F.a(),F.b(),F.p(),F.inside()),C.join(F.p(),F.inside(),1n,1n)):
  L.retained_member(F.a(),F.b(),F.p(),F.inside(),1n,1n,{==},{==},{==},{==})
