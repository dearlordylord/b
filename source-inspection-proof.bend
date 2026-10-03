import Base
import ./core.bend as C
import ./topology.bend as T
import ./source-inspection.bend as M
import ./source-inspection-laws.bend as L
import ./source-cells-laws.bend as Source
import ./source-cells-proof.bend as SourceProof
import ./count-arithmetic-laws.bend as Counts
import ./count-arithmetic-proof.bend as CountsProof
import ./boolean-reflection.bend as B

def guard_fields(+a: Bool, +b: Bool, +c: Bool, h: {a && b && c == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & {c == True{} : Bool}):
  match a b c:
    case False{} False{} False{}: B.absurd({False{} == True{} : Bool} & ({False{} == True{} : Bool} & {False{} == True{} : Bool}), B.false_impossible(h))
    case False{} False{} True{}: B.absurd({False{} == True{} : Bool} & ({False{} == True{} : Bool} & {True{} == True{} : Bool}), B.false_impossible(h))
    case False{} True{} False{}: B.absurd({False{} == True{} : Bool} & ({True{} == True{} : Bool} & {False{} == True{} : Bool}), B.false_impossible(h))
    case False{} True{} True{}: B.absurd({False{} == True{} : Bool} & ({True{} == True{} : Bool} & {True{} == True{} : Bool}), B.false_impossible(h))
    case True{} False{} False{}: B.absurd({True{} == True{} : Bool} & ({False{} == True{} : Bool} & {False{} == True{} : Bool}), B.false_impossible(h))
    case True{} False{} True{}: B.absurd({True{} == True{} : Bool} & ({False{} == True{} : Bool} & {True{} == True{} : Bool}), B.false_impossible(h))
    case True{} True{} False{}: B.absurd({True{} == True{} : Bool} & ({True{} == True{} : Bool} & {False{} == True{} : Bool}), B.false_impossible(h))
    case True{} True{} True{}: ({==}, ({==}, {==}))
def source_accepted_fields(+width: Nat, +hw: {width == 12n : Nat}, +a: List<&2, C.Section>, +b: List<&2, C.Section>, +c: List<&2, C.Section>, hs: {T.sections_guard(a) == True{} : Bool} & ({T.sections_guard(b) == True{} : Bool} & {T.sections_guard(c) == True{} : Bool})) -> {T.inspect_guard(True{}, a, b, c) == M.guarded(True{}, a, b, c) : T.Counts}:
  match hs:
    case (ha, (hb, hc)):
      Counts.inspect_cells_arithmetic_exact(width, hw, T.cells(a), T.cells(b), T.cells(c), Source.cells_envelope(width, hw, a, ha), Source.cells_envelope(width, hw, b, hb), Source.cells_envelope(width, hw, c, hc))
def source_gate_exact(+width: Nat, +hw: {width == 12n : Nat}, +a: List<&2, C.Section>, +b: List<&2, C.Section>, +c: List<&2, C.Section>, guard: Bool, h: {T.sections_guard(a) && T.sections_guard(b) && T.sections_guard(c) == guard : Bool}) -> {T.inspect_guard(guard, a, b, c) == M.guarded(guard, a, b, c) : T.Counts}:
  match guard:
    case False{}: {==}
    case True{}: source_accepted_fields(width, hw, a, b, c, guard_fields(T.sections_guard(a), T.sections_guard(b), T.sections_guard(c), h))
def L.source_inspect_arithmetic_exact(width, hw, a, b, c):
  source_gate_exact(width, hw, a, b, c, T.sections_guard(a) && T.sections_guard(b) && T.sections_guard(c), {==})
def L.source_valid_arithmetic_exact(width, hw, a, b, c):
  Equal.cong(T.Counts, Bool, report => T.counts_valid(report), T.inspect(a, b, c), M.inspect(a, b, c), L.source_inspect_arithmetic_exact(width, hw, a, b, c))
def L.source_inspection_closed_guard(a, b, c):
  {==}
