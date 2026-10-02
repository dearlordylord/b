import Base
import ./word-arithmetic.bend as W

# Shift into the low end, retaining the bit that leaves the high end.
def shift(n: Nat, c: Bool, w: Word(n)) -> W.Carry<n>:
  match n:
    case 0n: W.Carry{c, WNil{}}
    case 1n+p:
      match w:
        case WCon{b, t}: W.prepend(p, c, shift(p, b, t))
