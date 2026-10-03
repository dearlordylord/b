import Base
import ./core.bend as C
import ./topology.bend as T
import ./natural-cover.bend as M
import ./source-cells.bend as Source

law scaled_point_decoded:
  for +p: C.Point
  for hp: {T.point_guard(p) == True{} : Bool}
  {M.decode_point(T.scaled(p)) == M.scaled(p) : M.Point}

law raw_cell_decoded:
  for +a: C.Section
  for +b: C.Section
  for +ha: {Source.section_guard(a) == True{} : Bool}
  for +hb: {Source.section_guard(b) == True{} : Bool}
  {M.decode_quad(T.raw_cell(a, b)) == M.raw_cell(a, b) : M.Quad}

law raw_orientation_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: C.Section
  for +b: C.Section
  for +ha: {Source.section_guard(a) == True{} : Bool}
  for +hb: {Source.section_guard(b) == True{} : Bool}
  {T.orientation(T.raw_cell(a, b)) == M.orientation(M.raw_cell(a, b)) : Bool}

law cells_walk_decoded:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, C.Section>
  for +previous: C.Section
  for +hp: {Source.section_guard(previous) == True{} : Bool}
  for +sign: Bool
  for +hx: {T.sections_guard(xs) == True{} : Bool}
  {M.decode_cells(T.cells_walk(xs, previous, sign)) == M.cells_walk(xs, previous, sign) : List<&2, M.Quad>}

law cells_tail_decoded:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, C.Section>
  for +previous: C.Section
  for +hp: {Source.section_guard(previous) == True{} : Bool}
  for +hx: {T.sections_guard(xs) == True{} : Bool}
  {M.decode_cells(T.cells_tail(xs, previous)) == M.cells_tail(xs, previous) : List<&2, M.Quad>}

law cells_decoded:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, C.Section>
  for +hx: {T.sections_guard(xs) == True{} : Bool}
  {M.decode_cells(T.cells(xs)) == M.cells(xs) : List<&2, M.Quad>}
