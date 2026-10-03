import Base
import ./interval-clip.bend as M
import ./interval-clip-laws.bend as L
import ./interval-clip-proof.bend as Proof
import ./interval-clip-fixtures.bend as F

def forward_closed() -> {M.closed_valid(F.a(),F.b(),M.clip(F.a(),F.b(),F.p(),F.q())) == True{} : Bool}:
  L.clip_closed_valid(F.a(),F.b(),F.p(),F.q(),{==},{==})
def reversed_closed() -> {M.closed_valid(F.a(),F.b(),M.clip(F.a(),F.b(),F.q(),F.p())) == True{} : Bool}:
  L.clip_closed_valid(F.a(),F.b(),F.q(),F.p(),{==},{==})
def other_region_preserved() -> {M.in_region(F.box(),M.clip(F.a(),F.b(),F.p(),F.q())) == True{} : Bool}:
  L.clip_region_preserved(F.a(),F.b(),F.p(),F.q(),F.box(),{==},{==})
def actual_selection() -> {M.clip(F.a(),F.b(),F.q(),F.p()) == L.spec(F.a(),F.b(),F.q(),F.p()) : M.ClipResult}:
  L.clip_exact(F.a(),F.b(),F.q(),F.p())
