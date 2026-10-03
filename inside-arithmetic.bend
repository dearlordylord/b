import Base
import ./topology.bend as T
import ./side-bridge.bend as Side
import ./search-witness.bend as Search
import ./sample-arithmetic.bend as S

def edge(a: T.Point, b: T.Point, w: T.Witness) -> Bool:
  Bool.not(Cmp.is_lt(Side.exact(a, b, w)))
def inside(+w: T.Witness, q: T.Quad) -> Bool:
  match q:
    case T.Q{+a, +b, +c, +d}:
      edge(a, b, w) && edge(b, c, w) && edge(c, d, w) && edge(d, a, w)
def common(+w: T.Witness, a: T.Quad, b: T.Quad, c: T.Quad) -> Bool:
  inside(w, a) && inside(w, b) && inside(w, c)
def Ready(-width: Nat, -a: T.Quad, -b: T.Quad, -c: T.Quad) -> Type:
  &w:T.Witness -> {S.envelope(width, w) == True{} : Bool} & ({common(w, a, b, c) == True{} : Bool} & {Nat.is_gt(U32.to_nat(Search.denominator(w)), 0n) == True{} : Bool})
