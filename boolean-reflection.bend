import Base

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
