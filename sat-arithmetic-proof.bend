import Base
import ./sat-arithmetic-laws.bend as L
import ./sat-arithmetic.bend as M
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./side-bridge.bend as Side
import ./side-bridge-laws.bend as SideLaw
import ./side-bridge-proof.bend as SideProof
import ./sample-arithmetic.bend as S

def negative_cmp_exact(+x: Cmp) -> {T.negative(x) == Cmp.is_lt(x) : Bool}:
  match x:
    case LT{}: {==}
    case EQ{}: {==}
    case GT{}: {==}
def L.negative_vertex_exact(width, hw, a, b, p, ha, hb, hp):
  Equal.trans(Bool, T.negative(T.side(a, b, T.witness(p))), T.negative(M.vertex(a, b, p)), M.negative(a, b, p), Equal.cong(Cmp, Bool, x => T.negative(x), T.side(a, b, T.witness(p)), M.vertex(a, b, p), SideLaw.vertex_side_exact(width, hw, a, b, p, ha, hb, hp)), negative_cmp_exact(M.vertex(a, b, p)))

def positive_cmp_exact(+x: Cmp) -> {T.positive(x) == Cmp.is_gt(x) : Bool}:
  match x:
    case LT{}: {==}
    case EQ{}: {==}
    case GT{}: {==}
def L.positive_vertex_exact(width, hw, a, b, p, ha, hb, hp):
  Equal.trans(Bool, T.positive(T.side(a, b, T.witness(p))), T.positive(M.vertex(a, b, p)), M.positive(a, b, p), Equal.cong(Cmp, Bool, x => T.positive(x), T.side(a, b, T.witness(p)), M.vertex(a, b, p), SideLaw.vertex_side_exact(width, hw, a, b, p, ha, hb, hp)), positive_cmp_exact(M.vertex(a, b, p)))
