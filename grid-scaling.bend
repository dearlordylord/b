import Base
import ./core.bend as C
import ./topology.bend as T
import ./word-arithmetic.bend as W

def restore(point: T.Point) -> C.Point:
  match point:
    case T.P{x, y}: C.Pt{Nat.mul(U32.to_nat(x), 4n), Nat.mul(U32.to_nat(y), 4n)}
def envelope(+width: Nat, point: T.Point) -> Bool:
  match point:
    case T.P{x, y}: Nat.is_le(U32.to_nat(x), W.capacity(width)) && Nat.is_le(U32.to_nat(y), W.capacity(width))
