import Base
import ./topology.bend as T
import ./edge-arithmetic.bend as M

law point_equal_arithmetic_exact:
  for +a: T.Point
  for +b: T.Point
  {T.point_equal(a, b) == M.point_equal(a, b) : Bool}

law reverse_edge_arithmetic_exact:
  for +a: T.Point
  for +b: T.Point
  for +q: T.Quad
  {T.reverse_edge(a, b, q) == M.reverse_edge(a, b, q) : Bool}

law shared_edge_arithmetic_exact:
  for +q: T.Quad
  for +r: T.Quad
  {T.shared_edge(q, r) == M.shared_edge(q, r) : Bool}
