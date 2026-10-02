import Base

type Carry<-n: Nat> is Data:
  Carry{carry: Bool, word: Word(n)}

# Addition retaining the carry discarded by Word.adc. No fixed width is
# assumed: proofs apply to every word width, including zero.
def bit_value(b: Bool) -> Nat:
  match b:
    case False{}: 0n
    case True{}: 1n
def bit_total(r: Bool & Bool) -> Nat:
  (s, c) = r
  Nat.add(bit_value(s), Nat.double(bit_value(c)))
def low(-n: Nat, r: Carry<n>) -> Word(n):
  match r:
    case Carry{c, w}: w
def prepend(-p: Nat, s: Bool, r: Carry<p>) -> Carry<1n+p>:
  match r:
    case Carry{c, w}: Carry{c, WCon{s, w}}
def add_carry(n: Nat, a: Word(n), b: Word(n), c: Bool) -> Carry<n>:
  match n:
    case 0n:
      Carry{c, WNil{}}
    case 1n+p:
      match a b c:
        case WCon{False{}, at} WCon{False{}, bt} False{}:
          prepend(p, False{}, add_carry(p, at, bt, False{}))
        case WCon{False{}, at} WCon{False{}, bt} True{}:
          prepend(p, True{}, add_carry(p, at, bt, False{}))
        case WCon{False{}, at} WCon{True{}, bt} False{}:
          prepend(p, True{}, add_carry(p, at, bt, False{}))
        case WCon{False{}, at} WCon{True{}, bt} True{}:
          prepend(p, False{}, add_carry(p, at, bt, True{}))
        case WCon{True{}, at} WCon{False{}, bt} False{}:
          prepend(p, True{}, add_carry(p, at, bt, False{}))
        case WCon{True{}, at} WCon{False{}, bt} True{}:
          prepend(p, False{}, add_carry(p, at, bt, True{}))
        case WCon{True{}, at} WCon{True{}, bt} False{}:
          prepend(p, False{}, add_carry(p, at, bt, True{}))
        case WCon{True{}, at} WCon{True{}, bt} True{}:
          prepend(p, True{}, add_carry(p, at, bt, True{}))

# Positional value including the bit beyond the declared word width.
def extended_value(n: Nat, c: Bool, w: Word(n)) -> Nat:
  match n:
    case 0n: bit_value(c)
    case 1n+p:
      match w:
        case WCon{False{}, t}: Nat.double(extended_value(p, c, t))
        case WCon{True{}, t}: 1n+Nat.double(extended_value(p, c, t))
def carry_value(n: Nat, r: Carry<n>) -> Nat:
  match r:
    case Carry{c, w}: extended_value(n, c, w)
def overflow(-n: Nat, r: Carry<n>) -> Bool:
  match r:
    case Carry{c, w}: c
