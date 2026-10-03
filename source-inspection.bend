import Base
import ./core.bend as C
import ./topology.bend as T
import ./count-arithmetic.bend as Counts

def guarded(guard: Bool, a: List<&2, C.Section>, b: List<&2, C.Section>, c: List<&2, C.Section>) -> T.Counts:
  match guard:
    case False{}: T.Counts{0n, 0n, 0n, 0n, False{}, False{}, False{}, False{}}
    case True{}: Counts.inspect_cells(T.cells(a), T.cells(b), T.cells(c))
def inspect(+a: List<&2, C.Section>, +b: List<&2, C.Section>, +c: List<&2, C.Section>) -> T.Counts:
  guarded(T.sections_guard(a) && T.sections_guard(b) && T.sections_guard(c), a, b, c)
def valid(a: List<&2, C.Section>, b: List<&2, C.Section>, c: List<&2, C.Section>) -> Bool:
  T.counts_valid(inspect(a, b, c))
