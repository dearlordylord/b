import Base
import ./topology.bend as T
import ./topology-laws.bend as L
import ./validation-proof.bend as V

def positive_sound(+v: Nat, h: {Nat.is_gt(v, 0n) == True{} : Bool}) -> L.PositiveVertices(v):
  match v:
    case 0n: V.false_impossible(h)
    case 1n+p: Unit{}

def positive_complete(+v: Nat, h: L.PositiveVertices(v)) -> {Nat.is_gt(v, 0n) == True{} : Bool}:
  match v:
    case 0n: V.absurd({Nat.is_gt(0n, 0n) == True{} : Bool}, h)
    case 1n+p: {==}

def tail_sound(+v: Nat, +e: Nat, +t: Nat, +q: Nat,
  h: {Nat.is_gt(v, 0n) == True{} : Bool} &
     {Nat.is_eq(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q)) == True{} : Bool}) ->
  L.PositiveVertices(v) & {Nat.add(Nat.add(v, t), 1n) == Nat.add(e, q) : Nat}:
  match h:
    case (positive, equation):
      (positive_sound(v, positive), V.nat_eq_sound(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q), equation))

def tail_complete(+v: Nat, +e: Nat, +t: Nat, +q: Nat,
  h: L.PositiveVertices(v) & {Nat.add(Nat.add(v, t), 1n) == Nat.add(e, q) : Nat}) ->
  {Nat.is_gt(v, 0n) == True{} : Bool} &
  {Nat.is_eq(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q)) == True{} : Bool}:
  match h:
    case (positive, equation):
      (positive_complete(v, positive), V.nat_eq_complete(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q), equation))

def map_sound(+v: Nat, +e: Nat, +t: Nat, +q: Nat,
  +a: Bool, +b: Bool, +c: Bool, +d: Bool,
  h: {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} &
     ({d == True{} : Bool} & ({Nat.is_gt(v, 0n) == True{} : Bool} &
     {Nat.is_eq(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q)) == True{} : Bool}))))) ->
  L.Conditions(T.Counts{v, e, t, q, a, b, c, d}):
  match h:
    case (ha, (hb, (hc, (hd, tail)))):
      (ha, (hb, (hc, (hd, tail_sound(v, e, t, q, tail)))))

def map_complete(+v: Nat, +e: Nat, +t: Nat, +q: Nat,
  +a: Bool, +b: Bool, +c: Bool, +d: Bool,
  h: L.Conditions(T.Counts{v, e, t, q, a, b, c, d})) ->
  {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} &
  ({d == True{} : Bool} & ({Nat.is_gt(v, 0n) == True{} : Bool} &
  {Nat.is_eq(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q)) == True{} : Bool})))):
  match h:
    case (ha, (hb, (hc, (hd, tail)))):
      (ha, (hb, (hc, (hd, tail_complete(v, e, t, q, tail)))))

def L.topology_report_sound(report, accepted):
  match report:
    case T.Counts{+v, +e, +t, +q, +a, +b, +c, +d}:
      map_sound(v, e, t, q, a, b, c, d,
        V.six_sound(a, b, c, d, Nat.is_gt(v, 0n),
          Nat.is_eq(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q)), accepted))

def L.topology_report_complete(report, conditions):
  match report:
    case T.Counts{+v, +e, +t, +q, +a, +b, +c, +d}:
      V.six_complete(a, b, c, d, Nat.is_gt(v, 0n),
        Nat.is_eq(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q)),
        map_complete(v, e, t, q, a, b, c, d, conditions))

def L.topology_guard_closed(a, b, c):
  {==}

def L.three_ribbons_connected(ab, ac, bc):
  match ab ac bc:
    case False{} False{} False{}: {==}
    case False{} False{} True{}: {==}
    case False{} True{} False{}: {==}
    case False{} True{} True{}: {==}
    case True{} False{} False{}: {==}
    case True{} False{} True{}: {==}
    case True{} True{} False{}: {==}
    case True{} True{} True{}: {==}
