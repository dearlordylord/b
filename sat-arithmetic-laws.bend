import Base
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./sat-arithmetic.bend as M

law negative_vertex_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +p: T.Point
  for ha: {G.envelope(width, a) == True{} : Bool}
  for hb: {G.envelope(width, b) == True{} : Bool}
  for hp: {G.envelope(width, p) == True{} : Bool}
  {T.negative(T.side(a, b, T.witness(p))) == M.negative(a, b, p) : Bool}

law positive_vertex_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +p: T.Point
  for ha: {G.envelope(width, a) == True{} : Bool}
  for hb: {G.envelope(width, b) == True{} : Bool}
  for hp: {G.envelope(width, p) == True{} : Bool}
  {T.positive(T.side(a, b, T.witness(p))) == M.positive(a, b, p) : Bool}
