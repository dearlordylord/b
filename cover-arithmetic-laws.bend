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
