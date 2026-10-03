import Base
import ./topology.bend as T
import ./count-arithmetic.bend as M
import ./source-cells.bend as Cells
import ./search-witness.bend as Search

law fourth_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Quad>
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.fourth(xs) == M.fourth(xs) : T.CliqueCounts}

law third_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Quad>
  for +a: T.Quad
  for +b: T.Quad
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  for +hb: {Search.quad_envelope(width, b) == True{} : Bool}
  {T.third(xs, a, b) == M.third(xs, a, b) : T.CliqueCounts}

law second_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Quad>
  for +a: T.Quad
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  for +ha: {Search.quad_envelope(width, a) == True{} : Bool}
  {T.second(xs, a) == M.second(xs, a) : T.CliqueCounts}

law first_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Quad>
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.first(xs) == M.first(xs) : T.CliqueCounts}

law inspect_cells_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: List<&2, T.Quad>
  for +b: List<&2, T.Quad>
  for +c: List<&2, T.Quad>
  for +ha: {Cells.envelope(width, a) == True{} : Bool}
  for +hb: {Cells.envelope(width, b) == True{} : Bool}
  for +hc: {Cells.envelope(width, c) == True{} : Bool}
  {T.inspect_cells(a, b, c) == M.inspect_cells(a, b, c) : T.Counts}
