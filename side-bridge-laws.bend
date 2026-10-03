import Base
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./sample-arithmetic.bend as S
import ./side-bridge.bend as M

law accepted_side_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +w: T.Witness
  for ha: {G.envelope(width, a) == True{} : Bool}
  for hb: {G.envelope(width, b) == True{} : Bool}
  for hwitness: {S.envelope(width, w) == True{} : Bool}
  {T.side(a, b, w) == M.exact(a, b, w) : Cmp}

law sampled_side_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +p: T.Point
  for +q: T.Point
  for +n: U32
  for ha: {G.envelope(width, a) == True{} : Bool}
  for hb: {G.envelope(width, b) == True{} : Bool}
  for +hp: {G.envelope(width, p) == True{} : Bool}
  for +hq: {G.envelope(width, q) == True{} : Bool}
  for +hn: {U32.is_le(n, 64) == True{} : Bool}
  {T.side(a, b, T.sample(p, q, n)) == M.from_values(a, b, S.exact_sample(p, q, n)) : Cmp}

law vertex_side_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Point
  for +b: T.Point
  for +p: T.Point
  for ha: {G.envelope(width, a) == True{} : Bool}
  for hb: {G.envelope(width, b) == True{} : Bool}
  for hp: {G.envelope(width, p) == True{} : Bool}
  {T.side(a, b, T.witness(p)) == M.from_values(a, b, S.vertex_values(p)) : Cmp}
