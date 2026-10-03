import Base
import ./clip-halfplane.bend as M
import ./clip-halfplane-fixtures.bend as F
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region

def actual_components() -> {M.rebased(F.a(),F.b(),F.p(),F.q(),1n,1n) == G.P{72n,60n,24n} : G.Point}:
  {==}
def outside_old_point() -> {Region.edge(F.a(),F.b(),C.join(F.p(),F.q(),1n,3n)) == False{} : Bool}:
  {==}
def outside_breaks_balance() -> {M.balance(F.a(),F.b(),F.p(),F.q(),1n,3n) == False{} : Bool}:
  {==}
# The boundary branch uses a different certificate, avoiding zero-scale rebase.
def raw_boundary_rebase_invalid() -> {G.positive_denominator(M.rebased(F.a(),F.b(),F.boundary(),F.q(),1n,0n)) == False{} : Bool}:
  {==}
