import Base
import ./core.bend as C
import ./topology.bend as T
import ./source-inspection.bend as M

law source_inspect_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: List<&2, C.Section>
  for +b: List<&2, C.Section>
  for +c: List<&2, C.Section>
  {T.inspect(a, b, c) == M.inspect(a, b, c) : T.Counts}

law source_valid_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: List<&2, C.Section>
  for +b: List<&2, C.Section>
  for +c: List<&2, C.Section>
  {T.valid(a, b, c) == M.valid(a, b, c) : Bool}

law source_inspection_closed_guard:
  for a: List<&2, C.Section>
  for b: List<&2, C.Section>
  for c: List<&2, C.Section>
  {M.guarded(False{}, a, b, c) == T.Counts{0n, 0n, 0n, 0n, False{}, False{}, False{}, False{}} : T.Counts}
