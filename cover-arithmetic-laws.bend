import Base
import ./topology.bend as T
import ./cover-arithmetic.bend as M
import ./source-cells.bend as Cells
import ./search-witness.bend as Search

law disjoint_all_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +xs: List<&2, T.Quad>
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.disjoint_all(q, xs) == M.disjoint_all(q, xs) : Bool}

law disjoint_nonadjacent_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +xs: List<&2, T.Quad>
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.disjoint_nonadjacent(q, xs) == M.disjoint_nonadjacent(q, xs) : Bool}

law overlaps_one_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +xs: List<&2, T.Quad>
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.overlaps_one(q, xs) == M.overlaps_one(q, xs) : Bool}

law overlaps_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Quad>
  for +ys: List<&2, T.Quad>
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  for +hy: {Cells.envelope(width, ys) == True{} : Bool}
  {T.overlaps(xs, ys) == M.overlaps(xs, ys) : Bool}

law adjacent_arithmetic_exact:
  for +q: T.Quad
  for +xs: List<&2, T.Quad>
  {T.adjacent(q, xs) == M.adjacent(q, xs) : Bool}

law ribbon_walk_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Quad>
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.ribbon_walk(xs) == M.ribbon_walk(xs) : Bool}

law ribbon_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +xs: List<&2, T.Quad>
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.ribbon(xs) == M.ribbon(xs) : Bool}

law neighbors_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +xs: List<&2, T.Quad>
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {T.neighbors(q, xs) == M.neighbors(q, xs) : List<&2, T.Quad>}

law natural_neighbors_envelope:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +q: T.Quad
  for +xs: List<&2, T.Quad>
  for +hq: {Search.quad_envelope(width, q) == True{} : Bool}
  for +hx: {Cells.envelope(width, xs) == True{} : Bool}
  {Cells.envelope(width, M.neighbors(q, xs)) == True{} : Bool}

law connected_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: List<&2, T.Quad>
  for +b: List<&2, T.Quad>
  for +c: List<&2, T.Quad>
  for +ha: {Cells.envelope(width, a) == True{} : Bool}
  for +hb: {Cells.envelope(width, b) == True{} : Bool}
  for +hc: {Cells.envelope(width, c) == True{} : Bool}
  {T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)) == M.connected(a, b, c) : Bool}

law ribbons_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: List<&2, T.Quad>
  for +b: List<&2, T.Quad>
  for +c: List<&2, T.Quad>
  for +ha: {Cells.envelope(width, a) == True{} : Bool}
  for +hb: {Cells.envelope(width, b) == True{} : Bool}
  for +hc: {Cells.envelope(width, c) == True{} : Bool}
  {T.ribbon(a) && T.ribbon(b) && T.ribbon(c) == M.ribbons(a, b, c) : Bool}

law inspect_connected_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: List<&2, T.Quad>
  for +b: List<&2, T.Quad>
  for +c: List<&2, T.Quad>
  for +ha: {Cells.envelope(width, a) == True{} : Bool}
  for +hb: {Cells.envelope(width, b) == True{} : Bool}
  for +hc: {Cells.envelope(width, c) == True{} : Bool}
  {M.report_connected(T.inspect_cells(a, b, c)) == M.connected(a, b, c) : Bool}

law inspect_ribbons_arithmetic_exact:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +a: List<&2, T.Quad>
  for +b: List<&2, T.Quad>
  for +c: List<&2, T.Quad>
  for +ha: {Cells.envelope(width, a) == True{} : Bool}
  for +hb: {Cells.envelope(width, b) == True{} : Bool}
  for +hc: {Cells.envelope(width, c) == True{} : Bool}
  {M.report_ribbons(T.inspect_cells(a, b, c)) == M.ribbons(a, b, c) : Bool}
