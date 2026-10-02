import Base
import ./word-arithmetic.bend as W
import ./word-laws.bend as L
import ./facts.bend as F
import ./word-proof.bend as Existing
import ./validation-proof.bend as V

law double_add:
  for +a: Nat
  for +b: Nat
  {Nat.double(Nat.add(a, b)) == Nat.add(Nat.double(a), Nat.double(b)) : Nat}
def double_add(a, b):
  match a:
    case 0n: {==}
    case 1n+p:
      %double_add(p, b) : {2n+Nat.double(Nat.add(p, b)) == 2n+_ : Nat}
      {==}

law prepend_value:
  for +p: Nat
  for +s: Bool
  for +r: W.Carry<p>
  {W.carry_value(1n+p, W.prepend(p, s, r)) == Nat.add(W.bit_value(s), Nat.double(W.carry_value(p, r))) : Nat}
def prepend_value(p, s, r):
  match s r:
    case False{} W.Carry{c, w}: {==}
    case True{} W.Carry{c, w}: {==}

law lift_value:
  for +p: Nat
  for +s: Bool
  for +r: W.Carry<p>
  for +v: Nat
  for h: {W.carry_value(p, r) == v : Nat}
  {W.carry_value(1n+p, W.prepend(p, s, r)) == Nat.add(W.bit_value(s), Nat.double(v)) : Nat}
def lift_value(p, s, r, v, h):
  Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, s, r)), Nat.add(W.bit_value(s), Nat.double(W.carry_value(p, r))), Nat.add(W.bit_value(s), Nat.double(v)), prepend_value(p, s, r), Equal.cong(Nat, Nat, z => Nat.add(W.bit_value(s), Nat.double(z)), W.carry_value(p, r), v, h))

law output_normal:
  for +s: Bool
  for +k: Bool
  for +x: Nat
  for +y: Nat
  {Nat.add(W.bit_value(s), Nat.double(Nat.add(Nat.add(x, y), W.bit_value(k)))) == Nat.add(Nat.add(W.bit_value(s), Nat.double(W.bit_value(k))), Nat.double(Nat.add(x, y))) : Nat}
def output_normal(s, k, x, y):
  %Equal.sym(Nat, Nat.double(Nat.add(Nat.add(x, y), W.bit_value(k))), Nat.add(Nat.double(Nat.add(x, y)), Nat.double(W.bit_value(k))), double_add(Nat.add(x, y), W.bit_value(k))) : {Nat.add(W.bit_value(s), _) == Nat.add(Nat.add(W.bit_value(s), Nat.double(W.bit_value(k))), Nat.double(Nat.add(x, y))) : Nat}
  Equal.trans(Nat, Nat.add(W.bit_value(s), Nat.add(Nat.double(Nat.add(x, y)), Nat.double(W.bit_value(k)))), Nat.add(Nat.add(W.bit_value(s), Nat.double(Nat.add(x, y))), Nat.double(W.bit_value(k))), Nat.add(Nat.add(W.bit_value(s), Nat.double(W.bit_value(k))), Nat.double(Nat.add(x, y))), Equal.sym(Nat, Nat.add(Nat.add(W.bit_value(s), Nat.double(Nat.add(x, y))), Nat.double(W.bit_value(k))), Nat.add(W.bit_value(s), Nat.add(Nat.double(Nat.add(x, y)), Nat.double(W.bit_value(k)))), F.add_assoc(W.bit_value(s), Nat.double(Nat.add(x, y)), Nat.double(W.bit_value(k)))), F.add_right_comm(W.bit_value(s), Nat.double(Nat.add(x, y)), Nat.double(W.bit_value(k))))

law input_normal:
  for +a: Bool
  for +b: Bool
  for +c: Bool
  for +x: Nat
  for +y: Nat
  {Nat.add(Nat.add(Nat.add(W.bit_value(a), Nat.double(x)), Nat.add(W.bit_value(b), Nat.double(y))), W.bit_value(c)) == Nat.add(Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), W.bit_value(c)), Nat.double(Nat.add(x, y))) : Nat}
def input_normal(a, b, c, x, y):
  %Equal.sym(Nat, Nat.add(Nat.add(W.bit_value(a), Nat.double(x)), Nat.add(W.bit_value(b), Nat.double(y))), Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), Nat.add(Nat.double(x), Nat.double(y))), F.add_add_add_comm(W.bit_value(a), Nat.double(x), W.bit_value(b), Nat.double(y))) : {Nat.add(_, W.bit_value(c)) == Nat.add(Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), W.bit_value(c)), Nat.double(Nat.add(x, y))) : Nat}
  %double_add(x, y) : {Nat.add(Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), _), W.bit_value(c)) == Nat.add(Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), W.bit_value(c)), Nat.double(Nat.add(x, y))) : Nat}
  F.add_right_comm(Nat.add(W.bit_value(a), W.bit_value(b)), Nat.double(Nat.add(x, y)), W.bit_value(c))

law bit_step:
  for +a: Bool
  for +b: Bool
  for +c: Bool
  for +x: Nat
  for +y: Nat
  for +s: Bool
  for +k: Bool
  for h: {Nat.add(W.bit_value(s), Nat.double(W.bit_value(k))) == Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), W.bit_value(c)) : Nat}
  {Nat.add(W.bit_value(s), Nat.double(Nat.add(Nat.add(x, y), W.bit_value(k)))) == Nat.add(Nat.add(Nat.add(W.bit_value(a), Nat.double(x)), Nat.add(W.bit_value(b), Nat.double(y))), W.bit_value(c)) : Nat}
def bit_step(a, b, c, x, y, s, k, h):
  %Equal.sym(Nat, Nat.add(Nat.add(Nat.add(W.bit_value(a), Nat.double(x)), Nat.add(W.bit_value(b), Nat.double(y))), W.bit_value(c)), Nat.add(Nat.add(Nat.add(W.bit_value(a), W.bit_value(b)), W.bit_value(c)), Nat.double(Nat.add(x, y))), input_normal(a, b, c, x, y)) : {Nat.add(W.bit_value(s), Nat.double(Nat.add(Nat.add(x, y), W.bit_value(k)))) == _ : Nat}
  %h : {Nat.add(W.bit_value(s), Nat.double(Nat.add(Nat.add(x, y), W.bit_value(k)))) == Nat.add(_, Nat.double(Nat.add(x, y))) : Nat}
  output_normal(s, k, x, y)

def L.whole_word_value(n, a, b, c):
  match n:
    case 0n:
      {==}
    case 1n+p:
      match a b c:
        case WCon{False{}, at} WCon{False{}, bt} False{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, False{}, W.add_carry(p, at, bt, False{}))), Nat.add(W.bit_value(False{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})))), Nat.add(Nat.add(Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(False{})), lift_value(p, False{}, W.add_carry(p, at, bt, False{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})), L.whole_word_value(p, at, bt, False{})), bit_step(False{}, False{}, False{}, Word.to_nat(p, at), Word.to_nat(p, bt), False{}, False{}, {==}))
        case WCon{False{}, at} WCon{False{}, bt} True{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, True{}, W.add_carry(p, at, bt, False{}))), Nat.add(W.bit_value(True{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})))), Nat.add(Nat.add(Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(True{})), lift_value(p, True{}, W.add_carry(p, at, bt, False{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})), L.whole_word_value(p, at, bt, False{})), bit_step(False{}, False{}, True{}, Word.to_nat(p, at), Word.to_nat(p, bt), True{}, False{}, {==}))
        case WCon{False{}, at} WCon{True{}, bt} False{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, True{}, W.add_carry(p, at, bt, False{}))), Nat.add(W.bit_value(True{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})))), Nat.add(Nat.add(Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(False{})), lift_value(p, True{}, W.add_carry(p, at, bt, False{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})), L.whole_word_value(p, at, bt, False{})), bit_step(False{}, True{}, False{}, Word.to_nat(p, at), Word.to_nat(p, bt), True{}, False{}, {==}))
        case WCon{False{}, at} WCon{True{}, bt} True{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, False{}, W.add_carry(p, at, bt, True{}))), Nat.add(W.bit_value(False{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})))), Nat.add(Nat.add(Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(True{})), lift_value(p, False{}, W.add_carry(p, at, bt, True{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})), L.whole_word_value(p, at, bt, True{})), bit_step(False{}, True{}, True{}, Word.to_nat(p, at), Word.to_nat(p, bt), False{}, True{}, {==}))
        case WCon{True{}, at} WCon{False{}, bt} False{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, True{}, W.add_carry(p, at, bt, False{}))), Nat.add(W.bit_value(True{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})))), Nat.add(Nat.add(Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(False{})), lift_value(p, True{}, W.add_carry(p, at, bt, False{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(False{})), L.whole_word_value(p, at, bt, False{})), bit_step(True{}, False{}, False{}, Word.to_nat(p, at), Word.to_nat(p, bt), True{}, False{}, {==}))
        case WCon{True{}, at} WCon{False{}, bt} True{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, False{}, W.add_carry(p, at, bt, True{}))), Nat.add(W.bit_value(False{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})))), Nat.add(Nat.add(Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(False{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(True{})), lift_value(p, False{}, W.add_carry(p, at, bt, True{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})), L.whole_word_value(p, at, bt, True{})), bit_step(True{}, False{}, True{}, Word.to_nat(p, at), Word.to_nat(p, bt), False{}, True{}, {==}))
        case WCon{True{}, at} WCon{True{}, bt} False{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, False{}, W.add_carry(p, at, bt, True{}))), Nat.add(W.bit_value(False{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})))), Nat.add(Nat.add(Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(False{})), lift_value(p, False{}, W.add_carry(p, at, bt, True{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})), L.whole_word_value(p, at, bt, True{})), bit_step(True{}, True{}, False{}, Word.to_nat(p, at), Word.to_nat(p, bt), False{}, True{}, {==}))
        case WCon{True{}, at} WCon{True{}, bt} True{}:
          Equal.trans(Nat, W.carry_value(1n+p, W.prepend(p, True{}, W.add_carry(p, at, bt, True{}))), Nat.add(W.bit_value(True{}), Nat.double(Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})))), Nat.add(Nat.add(Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, at))), Nat.add(W.bit_value(True{}), Nat.double(Word.to_nat(p, bt)))), W.bit_value(True{})), lift_value(p, True{}, W.add_carry(p, at, bt, True{}), Nat.add(Nat.add(Word.to_nat(p, at), Word.to_nat(p, bt)), W.bit_value(True{})), L.whole_word_value(p, at, bt, True{})), bit_step(True{}, True{}, True{}, Word.to_nat(p, at), Word.to_nat(p, bt), True{}, True{}, {==}))

def L.zero_carry_value(n, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{False{}, t}:
          Equal.cong(Nat, Nat, z => Nat.double(z), W.extended_value(p, False{}, t), Word.to_nat(p, t), L.zero_carry_value(p, t))
        case WCon{True{}, t}:
          Equal.cong(Nat, Nat, z => 1n+Nat.double(z), W.extended_value(p, False{}, t), Word.to_nat(p, t), L.zero_carry_value(p, t))

law false_carry:
  for +n: Nat
  for +r: W.Carry<n>
  for h: {W.overflow(n, r) == False{} : Bool}
  {W.carry_value(n, r) == Word.to_nat(n, W.low(n, r)) : Nat}
def false_carry(n, r, h):
  match r:
    case W.Carry{False{}, w}: L.zero_carry_value(n, w)
    case W.Carry{True{}, w}:
      V.absurd({W.extended_value(n, True{}, w) == Word.to_nat(n, w) : Nat}, V.false_impossible(Equal.sym(Bool, True{}, False{}, h)))

def L.addition_without_overflow(n, a, b, c, h):
  %L.low_word_agrees(n, a, b, c) : {Word.to_nat(n, _) == Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)) : Nat}
  %false_carry(n, W.add_carry(n, a, b, c), h) : {_ == Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.bit_value(c)) : Nat}
  L.whole_word_value(n, a, b, c)
