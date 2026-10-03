import Base
import ./core.bend as C
import ./validation.bend as V
import ./validator-natural.bend as M

law bounded_cell_arithmetic_exact:
  for +lower: U32
  for +upper: U32
  for +hlower: {lower == 3240000 : U32}
  for +hupper: {upper == 6760000 : U32}
  for +cell: C.Cell
  for +hsl: {V.point_bounded(C.boundary_left(C.cell_start(cell))) == True{} : Bool}
  for +hsr: {V.point_bounded(C.boundary_right(C.cell_start(cell))) == True{} : Bool}
  for +hfl: {V.point_bounded(C.boundary_left(C.cell_finish(cell))) == True{} : Bool}
  for +hfr: {V.point_bounded(C.boundary_right(C.cell_finish(cell))) == True{} : Bool}
  {V.cell_valid(cell) == M.cell_valid(lower, upper, cell) : Bool}

law bounded_cells_arithmetic_exact:
  for +lower: U32
  for +upper: U32
  for +hlower: {lower == 3240000 : U32}
  for +hupper: {upper == 6760000 : U32}
  for +xs: List<&2, C.Section>
  for +previous: C.Section
  for +hp: {M.section_bounded(previous) == True{} : Bool}
  for +hx: {V.sections_bounded(xs) == True{} : Bool}
  {V.cells_valid(xs, previous) == M.cells_valid(xs, previous, lower, upper) : Bool}

law bounded_nonempty_arithmetic_exact:
  for +lower: U32
  for +upper: U32
  for +hlower: {lower == 3240000 : U32}
  for +hupper: {upper == 6760000 : U32}
  for +xs: List<&2, C.Section>
  for +hx: {V.sections_bounded(xs) == True{} : Bool}
  {V.nonempty_valid(xs) == M.nonempty_valid(xs, lower, upper) : Bool}

law validator_arithmetic_exact:
  for +lower: U32
  for +upper: U32
  for +hlower: {lower == 3240000 : U32}
  for +hupper: {upper == 6760000 : U32}
  for +xs: List<&2, C.Section>
  {V.validate(xs) == M.validate(xs, lower, upper) : Bool}
