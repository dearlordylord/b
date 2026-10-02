import Base
import ./word-arithmetic.bend as W
import ./word-laws.bend as L

def L.full_adder_value(a, b, c):
  match a b c:
    case False{} False{} False{}:
      {==}
    case False{} False{} True{}:
      {==}
    case False{} True{} False{}:
      {==}
    case False{} True{} True{}:
      {==}
    case True{} False{} False{}:
      {==}
    case True{} False{} True{}:
      {==}
    case True{} True{} False{}:
      {==}
    case True{} True{} True{}:
      {==}

law lift_low:
  for +p: Nat
  for +s: Bool
  for +r: W.Carry<p>
  for +t: Word(p)
  for h: {W.low(p, r) == t : Word(p)}
  {W.low(1n+p, W.prepend(p, s, r)) == WCon{s, t} : Word(1n+p)}
def lift_low(p, s, r, t, h):
  match r:
    case W.Carry{carry, w}:
      Equal.cong(Word(p), Word(1n+p), z => WCon{s, z}, w, t, h)

def L.low_word_agrees(n, a, b, c):
  match n:
    case 0n:
      {==}
    case 1n+p:
      match a b c:
        case WCon{False{}, at} WCon{False{}, bt} False{}:
          lift_low(p, False{}, W.add_carry(p, at, bt, False{}), Word.adc(p, at, bt, False{}, False{}), L.low_word_agrees(p, at, bt, False{}))
        case WCon{False{}, at} WCon{False{}, bt} True{}:
          lift_low(p, True{}, W.add_carry(p, at, bt, False{}), Word.adc(p, at, bt, False{}, False{}), L.low_word_agrees(p, at, bt, False{}))
        case WCon{False{}, at} WCon{True{}, bt} False{}:
          lift_low(p, True{}, W.add_carry(p, at, bt, False{}), Word.adc(p, at, bt, False{}, False{}), L.low_word_agrees(p, at, bt, False{}))
        case WCon{False{}, at} WCon{True{}, bt} True{}:
          lift_low(p, False{}, W.add_carry(p, at, bt, True{}), Word.adc(p, at, bt, False{}, True{}), L.low_word_agrees(p, at, bt, True{}))
        case WCon{True{}, at} WCon{False{}, bt} False{}:
          lift_low(p, True{}, W.add_carry(p, at, bt, False{}), Word.adc(p, at, bt, False{}, False{}), L.low_word_agrees(p, at, bt, False{}))
        case WCon{True{}, at} WCon{False{}, bt} True{}:
          lift_low(p, False{}, W.add_carry(p, at, bt, True{}), Word.adc(p, at, bt, False{}, True{}), L.low_word_agrees(p, at, bt, True{}))
        case WCon{True{}, at} WCon{True{}, bt} False{}:
          lift_low(p, False{}, W.add_carry(p, at, bt, True{}), Word.adc(p, at, bt, False{}, True{}), L.low_word_agrees(p, at, bt, True{}))
        case WCon{True{}, at} WCon{True{}, bt} True{}:
          lift_low(p, True{}, W.add_carry(p, at, bt, True{}), Word.adc(p, at, bt, False{}, True{}), L.low_word_agrees(p, at, bt, True{}))
