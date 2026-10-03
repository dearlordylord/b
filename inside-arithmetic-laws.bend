import Base
import ./topology.bend as T
import ./search-witness.bend as Search
import ./sample-arithmetic.bend as S
import ./inside-arithmetic.bend as M

law inside_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +w: T.Witness
  for +q: T.Quad
  for hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +henv: {S.envelope(width, w) == True{} : Bool}
  {T.inside(w, q) == M.inside(w, q) : Bool}

law common_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +w: T.Witness
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for +henv: {S.envelope(width, w) == True{} : Bool}
  {T.common(w, a, b, c) == M.common(w, a, b, c) : Bool}

law triangle_witness_natural:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: T.Quad
  for +b: T.Quad
  for +c: T.Quad
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  for +hc: {Search.quad_envelope(width, c) == True{} : Bool}
  for accepted: {T.triangle_witness(a, b, c) == True{} : Bool}
  M.Ready(width, a, b, c)
