import Base
import ./topology.bend as T

def values(point: T.Point) -> Nat & Nat:
  match point:
    case T.P{x, y}: (U32.to_nat(x), U32.to_nat(y))
