import Base

# Little-endian quotient model: discard the two low bits and pad with zeros.
def head(n: Nat, w: Word(n)) -> Bool:
  match n:
    case 0n: False{}
    case 1n+p:
      match w:
        case WCon{b, t}: b
def second(n: Nat, w: Word(n)) -> Bool:
  match n:
    case 0n: False{}
    case 1n+p:
      match w:
        case WCon{b, t}: head(p, t)
def quotient(n: Nat, w: Word(n)) -> Word(n):
  match n:
    case 0n: WNil{}
    case 1n++p:
      match w:
        case WCon{b, +t}: WCon{second(p, t), quotient(p, t)}
def remainder_bits(a: Bool, b: Bool) -> U32:
  match a b:
    case False{} False{}: 0
    case True{} False{}: 1
    case False{} True{}: 2
    case True{} True{}: 3
def remainder(n: Nat, w: Word(n)) -> U32:
  match n:
    case 0n: 0
    case 1n+p:
      match w:
        case WCon{b, t}: remainder_bits(b, head(p, t))
