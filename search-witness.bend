import Base
import ./topology.bend as T
import ./sample-arithmetic.bend as S
import ./grid-scaling.bend as G

def denominator(w: T.Witness) -> U32:
  match w:
    case T.W{x, y, d}: d

# A native search hit with a proved arithmetic envelope and prescribed denominator.
def Hit(-width: Nat, -a: T.Quad, -b: T.Quad, -c: T.Quad, -d: U32) -> Type:
  &w:T.Witness -> {S.envelope(width, w) == True{} : Bool} & ({T.common(w, a, b, c) == True{} : Bool} & {denominator(w) == d : U32})

def Ready(-width: Nat, -a: T.Quad, -b: T.Quad, -c: T.Quad) -> Type:
  &w:T.Witness -> {S.envelope(width, w) == True{} : Bool} & ({T.common(w, a, b, c) == True{} : Bool} & {U32.is_gt(denominator(w), 0) == True{} : Bool})

def points_envelope(+width: Nat, xs: List<&2, T.Point>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: G.envelope(width, h) && points_envelope(width, t)

def quad_envelope(width: Nat, q: T.Quad) -> Bool:
  points_envelope(width, T.vertices(q))
