import Base
import ./topology.bend as T
import ./sample-arithmetic.bend as S
import ./witness-arithmetic.bend as A

def points(a: T.Point, b: T.Point, x: Nat, y: Nat, d: Nat) -> Cmp:
  match a b:
    case T.P{ax, ay} T.P{bx, by}:
      A.exact_side(U32.to_nat(ax), U32.to_nat(ay), U32.to_nat(bx), U32.to_nat(by), x, y, d)
def from_values(a: T.Point, b: T.Point, coordinates: Nat & (Nat & Nat)) -> Cmp:
  match coordinates:
    case (x, (y, d)): points(a, b, x, y, d)
def exact(a: T.Point, b: T.Point, w: T.Witness) -> Cmp:
  from_values(a, b, S.values(w))
