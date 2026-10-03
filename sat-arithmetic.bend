import Base
import ./topology.bend as T
import ./side-bridge.bend as Side
import ./sample-arithmetic.bend as S

def vertex(a: T.Point, b: T.Point, p: T.Point) -> Cmp:
  Side.from_values(a, b, S.vertex_values(p))
def negative(a: T.Point, b: T.Point, p: T.Point) -> Bool:
  Cmp.is_lt(vertex(a, b, p))
def positive(a: T.Point, b: T.Point, p: T.Point) -> Bool:
  Cmp.is_gt(vertex(a, b, p))
