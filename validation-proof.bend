import Base
import ./core.bend as C
import ./validation.bend as V
import ./validation-laws.bend as L

def Truth(b: Bool) -> Type:
  match b:
    case False{}:
      Empty
    case True{}:
      Unit

def false_impossible(h: {False{} == True{} : Bool}) -> Empty:
  %Equal.sym(Bool, False{}, True{}, h) : Truth(_)
  Unit{}

def absurd(-A: Type, h: Empty) -> A:
  match h:

def and_split(a: Bool, +b: Bool, h: {Bool.and(a, b) == True{} : Bool}) -> {a == True{} : Bool} & {b == True{} : Bool}:
  match a:
    case False{}:
      absurd({False{} == True{} : Bool} & {b == True{} : Bool}, false_impossible(h))
    case True{}:
      ({==}, h)

def and_join(+a: Bool, +b: Bool, h: {a == True{} : Bool}, k: {b == True{} : Bool}) -> {Bool.and(a, b) == True{} : Bool}:
  %Equal.sym(Bool, a, True{}, h) : {Bool.and(_, b) == True{} : Bool}
  %Equal.sym(Bool, b, True{}, k) : {Bool.and(True{}, _) == True{} : Bool}
  {==}

def sound1(+a: Bool, h: {a == True{} : Bool}) -> {a == True{} : Bool}:
  h

def complete1(+a: Bool, conditions: {a == True{} : Bool}) -> {a == True{} : Bool}:
  conditions

def sound2(+a: Bool, +b: Bool, h: {a && (b) == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool}):
  match a:
    case False{}:
      absurd({False{} == True{} : Bool} & ({b == True{} : Bool}), false_impossible(h))
    case True{}:
      ({==}, sound1(b, h))

def complete2(+a: Bool, +b: Bool, conditions: {a == True{} : Bool} & ({b == True{} : Bool})) -> {a && (b) == True{} : Bool}:
  match conditions:
    case (head, tail):
      and_join(a, b, head, complete1(b, tail))

def sound3(+a: Bool, +b: Bool, +c: Bool, h: {a && (b && (c)) == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool})):
  match a:
    case False{}:
      absurd({False{} == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool})), false_impossible(h))
    case True{}:
      ({==}, sound2(b, c, h))

def complete3(+a: Bool, +b: Bool, +c: Bool, conditions: {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool}))) -> {a && (b && (c)) == True{} : Bool}:
  match conditions:
    case (head, tail):
      and_join(a, b && (c), head, complete2(b, c, tail))

def sound4(+a: Bool, +b: Bool, +c: Bool, +d: Bool, h: {a && (b && (c && (d))) == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool}))):
  match a:
    case False{}:
      absurd({False{} == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool}))), false_impossible(h))
    case True{}:
      ({==}, sound3(b, c, d, h))

def complete4(+a: Bool, +b: Bool, +c: Bool, +d: Bool, conditions: {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool})))) -> {a && (b && (c && (d))) == True{} : Bool}:
  match conditions:
    case (head, tail):
      and_join(a, b && (c && (d)), head, complete3(b, c, d, tail))

def sound5(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +e: Bool, h: {a && (b && (c && (d && (e)))) == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool} & ({e == True{} : Bool})))):
  match a:
    case False{}:
      absurd({False{} == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool} & ({e == True{} : Bool})))), false_impossible(h))
    case True{}:
      ({==}, sound4(b, c, d, e, h))

def complete5(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +e: Bool, conditions: {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool} & ({e == True{} : Bool}))))) -> {a && (b && (c && (d && (e)))) == True{} : Bool}:
  match conditions:
    case (head, tail):
      and_join(a, b && (c && (d && (e))), head, complete4(b, c, d, e, tail))

def six_sound(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +e: Bool, +f: Bool, h: {a && (b && (c && (d && (e && (f))))) == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool} & ({e == True{} : Bool} & ({f == True{} : Bool}))))):
  match a:
    case False{}:
      absurd({False{} == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool} & ({e == True{} : Bool} & ({f == True{} : Bool}))))), false_impossible(h))
    case True{}:
      ({==}, sound5(b, c, d, e, f, h))

def six_complete(+a: Bool, +b: Bool, +c: Bool, +d: Bool, +e: Bool, +f: Bool, conditions: {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & ({d == True{} : Bool} & ({e == True{} : Bool} & ({f == True{} : Bool})))))) -> {a && (b && (c && (d && (e && (f))))) == True{} : Bool}:
  match conditions:
    case (head, tail):
      and_join(a, b && (c && (d && (e && (f)))), head, complete5(b, c, d, e, f, tail))

def cell_sound(+cell: C.Cell, h: {V.cell_valid(cell) == True{} : Bool}) -> L.CellConditions(cell):
  six_sound(V.cell_convex(cell), V.cell_centroid_exact(cell), V.cell_endpoints_exact(cell), V.cell_transverse(cell), V.section_width(C.cell_start(cell)), V.section_width(C.cell_finish(cell)), h)

def cell_complete(+cell: C.Cell, conditions: L.CellConditions(cell)) -> {V.cell_valid(cell) == True{} : Bool}:
  six_complete(V.cell_convex(cell), V.cell_centroid_exact(cell), V.cell_endpoints_exact(cell), V.cell_transverse(cell), V.section_width(C.cell_start(cell)), V.section_width(C.cell_finish(cell)), conditions)

def pair_map(-A: Type, -B: Type, -D: Type, -E: Type, pair: A & B, f: A -> D, g: B -> E) -> D & E:
  match pair:
    case (a, b):
      (f(a), g(b))

def and_join_pair(+a: Bool, +b: Bool, pair: {a == True{} : Bool} & {b == True{} : Bool}) -> {a && b == True{} : Bool}:
  match pair:
    case (h, k):
      and_join(a, b, h, k)

def adjacent_sound(+sections: List<&2, C.Section>, +previous: C.Section, h: {V.cells_valid(sections, previous) == True{} : Bool}) -> L.AdjacentConditions(sections, previous):
  match sections:
    case Nil{}:
      Unit{}
    case Con{+head, +tail}:
      pair_map({V.cell_valid(C.Cell{previous, head}) == True{} : Bool},
        {V.cells_valid(tail, head) == True{} : Bool},
        L.CellConditions(C.Cell{previous, head}), L.AdjacentConditions(tail, head),
        and_split(V.cell_valid(C.Cell{previous, head}), V.cells_valid(tail, head), h),
        p => cell_sound(C.Cell{previous, head}, p),
        q => adjacent_sound(tail, head, q))

def adjacent_complete(+sections: List<&2, C.Section>, +previous: C.Section, conditions: L.AdjacentConditions(sections, previous)) -> {V.cells_valid(sections, previous) == True{} : Bool}:
  match sections:
    case Nil{}:
      {==}
    case Con{+head, +tail}:
      and_join_pair(V.cell_valid(C.Cell{previous, head}), V.cells_valid(tail, head),
        pair_map(L.CellConditions(C.Cell{previous, head}), L.AdjacentConditions(tail, head),
          {V.cell_valid(C.Cell{previous, head}) == True{} : Bool},
          {V.cells_valid(tail, head) == True{} : Bool}, conditions,
          p => cell_complete(C.Cell{previous, head}, p),
          q => adjacent_complete(tail, head, q)))

def nonempty_sound(+sections: List<&2, C.Section>, h: {V.nonempty_valid(sections) == True{} : Bool}) -> L.NonemptyConditions(sections):
  match sections:
    case Nil{}:
      false_impossible(h)
    case Con{+head, +tail}:
      pair_map({V.section_width(head) == True{} : Bool}, {V.cells_valid(tail, head) == True{} : Bool},
        {V.section_width(head) == True{} : Bool}, L.AdjacentConditions(tail, head),
        and_split(V.section_width(head), V.cells_valid(tail, head), h),
        p => p, q => adjacent_sound(tail, head, q))

def nonempty_complete(+sections: List<&2, C.Section>, conditions: L.NonemptyConditions(sections)) -> {V.nonempty_valid(sections) == True{} : Bool}:
  match sections:
    case Nil{}:
      absurd({False{} == True{} : Bool}, conditions)
    case Con{+head, +tail}:
      and_join_pair(V.section_width(head), V.cells_valid(tail, head),
        pair_map({V.section_width(head) == True{} : Bool}, L.AdjacentConditions(tail, head),
          {V.section_width(head) == True{} : Bool}, {V.cells_valid(tail, head) == True{} : Bool},
          conditions, p => p, q => adjacent_complete(tail, head, q)))

def gate_sound(+bounded: Bool, +sections: List<&2, C.Section>, h: {V.bounded_valid(bounded, sections) == True{} : Bool}) -> {bounded == True{} : Bool} & L.NonemptyConditions(sections):
  match bounded:
    case False{}:
      absurd({False{} == True{} : Bool} & L.NonemptyConditions(sections), false_impossible(h))
    case True{}:
      ({==}, nonempty_sound(sections, h))

def gate_complete(+bounded: Bool, +sections: List<&2, C.Section>, h: {bounded == True{} : Bool}, conditions: L.NonemptyConditions(sections)) -> {V.bounded_valid(bounded, sections) == True{} : Bool}:
  %Equal.sym(Bool, bounded, True{}, h) : {V.bounded_valid(_, sections) == True{} : Bool}
  nonempty_complete(sections, conditions)

def bounds_step(+head: C.Section, +tail: List<&2, C.Section>, pair: {V.point_bounded(C.boundary_left(head)) == True{} : Bool} & ({V.point_bounded(C.boundary_right(head)) == True{} : Bool} & {V.sections_bounded(tail) == True{} : Bool}), recurse: {V.sections_bounded(tail) == True{} : Bool} -> L.BoundedPoints(tail)) -> L.BoundedPoints(Con{head, tail}):
  match pair:
    case (left, (right, remaining)):
      (left, (right, recurse(remaining)))

def bounds_sound(+sections: List<&2, C.Section>, h: {V.sections_bounded(sections) == True{} : Bool}) -> L.BoundedPoints(sections):
  match sections:
    case Nil{}:
      Unit{}
    case Con{+head, +tail}:
      bounds_step(head, tail,
        sound3(V.point_bounded(C.boundary_left(head)), V.point_bounded(C.boundary_right(head)), V.sections_bounded(tail), h),
        p => bounds_sound(tail, p))

def bounds_join(+head: C.Section, +tail: List<&2, C.Section>, conditions: L.BoundedPoints(Con{head, tail}), recurse: L.BoundedPoints(tail) -> {V.sections_bounded(tail) == True{} : Bool}) -> {V.sections_bounded(Con{head, tail}) == True{} : Bool}:
  match conditions:
    case (left, (right, remaining)):
      and_join(V.point_bounded(C.boundary_left(head)), V.point_bounded(C.boundary_right(head)) && V.sections_bounded(tail), left,
        and_join(V.point_bounded(C.boundary_right(head)), V.sections_bounded(tail), right, recurse(remaining)))

def bounds_complete(+sections: List<&2, C.Section>, conditions: L.BoundedPoints(sections)) -> {V.sections_bounded(sections) == True{} : Bool}:
  match sections:
    case Nil{}:
      {==}
    case Con{+head, +tail}:
      bounds_join(head, tail, conditions, p => bounds_complete(tail, p))


def L.validator_sound(sections, accepted):
  pair_map({V.sections_bounded(sections) == True{} : Bool}, L.NonemptyConditions(sections),
    L.BoundedPoints(sections), L.NonemptyConditions(sections),
    gate_sound(V.sections_bounded(sections), sections, accepted),
    p => bounds_sound(sections, p), q => q)

def complete_pair(+sections: List<&2, C.Section>, conditions: L.TubeConditions(sections)) -> {V.validate(sections) == True{} : Bool}:
  match conditions:
    case (bounded, nonempty):
      gate_complete(V.sections_bounded(sections), sections, bounds_complete(sections, bounded), nonempty)

def L.validator_complete(sections, conditions):
  complete_pair(sections, conditions)

def L.closed_bounds_gate(sections):
  {==}

def nat_eq_sound(+a: Nat, +b: Nat, h: {Nat.is_eq(a, b) == True{} : Bool}) -> {a == b : Nat}:
  match a b:
    case 0n 0n:
      {==}
    case 0n 1n+bp:
      absurd({0n == 1n+bp : Nat}, false_impossible(h))
    case 1n+ap 0n:
      absurd({1n+ap == 0n : Nat}, false_impossible(h))
    case 1n+ap 1n+bp:
      Equal.cong(Nat, Nat, p => 1n+p, ap, bp, nat_eq_sound(ap, bp, h))

def nat_eq_reflexive(+a: Nat) -> {Nat.is_eq(a, a) == True{} : Bool}:
  match a:
    case 0n:
      {==}
    case 1n+ap:
      nat_eq_reflexive(ap)

def nat_eq_complete(+a: Nat, +b: Nat, h: {a == b : Nat}) -> {Nat.is_eq(a, b) == True{} : Bool}:
  %h : {Nat.is_eq(a, _) == True{} : Bool}
  nat_eq_reflexive(a)


def L.artwork_gate_sound(sections, accepted):
  pair_map({Nat.is_eq(V.section_count(sections), 33n) == True{} : Bool},
    {V.validate(sections) == True{} : Bool},
    {V.section_count(sections) == 33n : Nat}, L.TubeConditions(sections),
    and_split(Nat.is_eq(V.section_count(sections), 33n), V.validate(sections), accepted),
    p => nat_eq_sound(V.section_count(sections), 33n, p), q => L.validator_sound(sections, q))

def L.validator_rejects_unbounded(sections, outside):
  %Equal.sym(Bool, V.sections_bounded(sections), False{}, outside) : {V.bounded_valid(_, sections) == False{} : Bool}
  {==}

def L.artwork_gate_complete(sections, count, conditions):
  and_join(Nat.is_eq(V.section_count(sections), 33n), V.validate(sections), nat_eq_complete(V.section_count(sections), 33n, count), L.validator_complete(sections, conditions))
