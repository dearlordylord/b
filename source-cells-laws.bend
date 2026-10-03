import Base
import ./core.bend as C
import ./topology.bend as T
import ./search-witness.bend as M
import ./source-cells.bend as S

law raw_cell_envelope:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: C.Section
  for +b: C.Section
  for +ha: {S.section_guard(a) == True{} : Bool}
  for +hb: {S.section_guard(b) == True{} : Bool}
  {M.quad_envelope(width, T.raw_cell(a, b)) == True{} : Bool}

law oriented_envelope:
  for +width: Nat
  for +sign: Bool
  for +q: T.Quad
  for hq: {M.quad_envelope(width, q) == True{} : Bool}
  {M.quad_envelope(width, T.orient(sign, q)) == True{} : Bool}

law cells_envelope:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, C.Section>
  for +hx: {T.sections_guard(xs) == True{} : Bool}
  {S.envelope(width, T.cells(xs)) == True{} : Bool}
