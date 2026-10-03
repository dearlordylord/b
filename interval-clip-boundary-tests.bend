import Base
import ./interval-clip.bend as M
import ./interval-clip-laws.bend as L
import ./interval-clip-proof.bend as Proof
import ./interval-clip-fixtures.bend as F
import ./homogeneous-combination.bend as C

def zero_gap_member() -> L.Member(M.clip(F.a(),F.b(),F.boundary(),F.q()),C.join(F.boundary(),F.q(),2n,0n)):
  L.retained_member(F.a(),F.b(),F.boundary(),F.q(),2n,0n,{==},{==},{==},{==})
def reversed_zero_gap_member() -> L.Member(M.clip(F.a(),F.b(),F.q(),F.boundary()),C.join(F.q(),F.boundary(),0n,2n)):
  L.retained_member(F.a(),F.b(),F.q(),F.boundary(),0n,2n,{==},{==},{==},{==})
def retained_is_present() -> {M.present(M.clip(F.a(),F.b(),F.p(),F.q())) == True{} : Bool}:
  L.retained_present(F.a(),F.b(),F.p(),F.q(),2n,4n,{==},{==})
