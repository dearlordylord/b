import Base
import ./word-arithmetic.bend as W
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as L
import ./word-bounds-laws.bend as B
import ./word-bounds-proof.bend as Bounds
import ./facts.bend as F
import ./boolean-reflection.bend as V

def L.zero_word_value(n):
  match n:
    case 0n: {==}
    case 1n+p:
      Equal.cong(Nat, Nat, z => Nat.double(z), Word.to_nat(p, Word.zero(p)), 0n, L.zero_word_value(p))

law adc_zero:
  for +n: Nat
  for +w: Word(n)
  {Word.adc(n, w, Word.zero(n), False{}, False{}) == w : Word(n)}
def adc_zero(n, w):
  match n:
    case 0n:
      match w:
        case WNil{}: {==}
    case 1n+p:
      match w:
        case WCon{False{}, t}:
          Equal.cong(Word(p), Word(1n+p), z => WCon{False{}, z}, Word.adc(p, t, Word.zero(p), False{}, False{}), t, adc_zero(p, t))
        case WCon{True{}, t}:
          Equal.cong(Word(p), Word(1n+p), z => WCon{True{}, z}, Word.adc(p, t, Word.zero(p), False{}, False{}), t, adc_zero(p, t))

def L.increment_agrees(n, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{False{}, t}:
          Equal.cong(Word(p), Word(1n+p), z => WCon{True{}, z}, t, Word.adc(p, t, Word.zero(p), False{}, False{}), Equal.sym(Word(p), Word.adc(p, t, Word.zero(p), False{}, False{}), t, adc_zero(p, t)))
        case WCon{True{}, t}:
          Equal.cong(Word(p), Word(1n+p), z => WCon{False{}, z}, Word.inc(p, t), Word.adc(p, t, Word.zero(p), False{}, True{}), L.increment_agrees(p, t))

law predecessor_lt:
  for +p: Nat
  for +b: Nat
  for h: {Nat.is_lt(1n+p, b) == True{} : Bool}
  {Nat.is_lt(p, b) == True{} : Bool}
def predecessor_lt(p, b, h):
  match p b:
    case 0n 0n:
      V.absurd({Nat.is_lt(0n, 0n) == True{} : Bool}, V.false_impossible(h))
    case 0n 1n+q: {==}
    case 1n+r 0n:
      V.absurd({Nat.is_lt(1n+r, 0n) == True{} : Bool}, V.false_impossible(h))
    case 1n+r 1n+q:
      predecessor_lt(r, q, h)

law increment_sum:
  for +n: Nat
  for +w: Word(n)
  {Nat.add(Nat.add(Word.to_nat(n, w), Word.to_nat(n, Word.zero(n))), 1n) == 1n+Word.to_nat(n, w) : Nat}
def increment_sum(n, w):
  %Equal.sym(Nat, Word.to_nat(n, Word.zero(n)), 0n, L.zero_word_value(n)) : {Nat.add(Nat.add(Word.to_nat(n, w), _), 1n) == 1n+Word.to_nat(n, w) : Nat}
  Equal.trans(Nat, Nat.add(Nat.add(Word.to_nat(n, w), 0n), 1n), 1n+Nat.add(Nat.add(Word.to_nat(n, w), 0n), 0n), 1n+Word.to_nat(n, w), F.add_succ(Nat.add(Word.to_nat(n, w), 0n), 0n), Equal.cong(Nat, Nat, z => 1n+z, Nat.add(Nat.add(Word.to_nat(n, w), 0n), 0n), Word.to_nat(n, w), Equal.trans(Nat, Nat.add(Nat.add(Word.to_nat(n, w), 0n), 0n), Nat.add(Word.to_nat(n, w), 0n), Word.to_nat(n, w), F.add_zero(Nat.add(Word.to_nat(n, w), 0n)), F.add_zero(Word.to_nat(n, w)))))

law increment_exact:
  for +n: Nat
  for +w: Word(n)
  for h: {Nat.is_lt(1n+Word.to_nat(n, w), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, Word.inc(n, w)) == 1n+Word.to_nat(n, w) : Nat}
def increment_exact(n, w, h):
  %Equal.sym(Word(n), Word.inc(n, w), Word.adc(n, w, Word.zero(n), False{}, True{}), L.increment_agrees(n, w)) : {Word.to_nat(n, _) == 1n+Word.to_nat(n, w) : Nat}
  Equal.trans(Nat, Word.to_nat(n, Word.adc(n, w, Word.zero(n), False{}, True{})), Nat.add(Nat.add(Word.to_nat(n, w), Word.to_nat(n, Word.zero(n))), 1n), 1n+Word.to_nat(n, w), B.bounded_addition_exact(n, w, Word.zero(n), True{}, Equal.trans(Bool, Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, w), Word.to_nat(n, Word.zero(n))), 1n), W.capacity(n)), Nat.is_lt(1n+Word.to_nat(n, w), W.capacity(n)), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(z, W.capacity(n)), Nat.add(Nat.add(Word.to_nat(n, w), Word.to_nat(n, Word.zero(n))), 1n), 1n+Word.to_nat(n, w), increment_sum(n, w)), h)), increment_sum(n, w))

def duplicate_bool(+b: Bool, h: {b == True{} : Bool}) -> {b == True{} : Bool} & {b == True{} : Bool}:
  %Equal.sym(Bool, b, True{}, h) : {_ == True{} : Bool} & {_ == True{} : Bool}
  ({==}, {==})
def duplicate_nat(+a: Nat, +b: Nat, h: {a == b : Nat}) -> {a == b : Nat} & {a == b : Nat}:
  %h : {a == _ : Nat} & {a == _ : Nat}
  ({==}, {==})
def conversion_step(+p: Nat, +n: Nat, h: {Nat.is_lt(1n+p, W.capacity(n)) == True{} : Bool}, ihs: {Word.to_nat(n, C.from_nat(p, n)) == p : Nat} & {Word.to_nat(n, C.from_nat(p, n)) == p : Nat}) -> {Word.to_nat(n, Word.inc(n, C.from_nat(p, n))) == 1n+p : Nat}:
  (ih1, ih2) = ihs
  %ih1 : {Word.to_nat(n, Word.inc(n, C.from_nat(p, n))) == 1n+_ : Nat}
  increment_exact(n, C.from_nat(p, n), Equal.trans(Bool, Nat.is_lt(1n+Word.to_nat(n, C.from_nat(p, n)), W.capacity(n)), Nat.is_lt(1n+p, W.capacity(n)), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(1n+z, W.capacity(n)), Word.to_nat(n, C.from_nat(p, n)), p, ih2), h))
def conversion_bounds(+p: Nat, +n: Nat, hs: {Nat.is_lt(1n+p, W.capacity(n)) == True{} : Bool} & {Nat.is_lt(1n+p, W.capacity(n)) == True{} : Bool}, ih: {Nat.is_lt(p, W.capacity(n)) == True{} : Bool} -> {Word.to_nat(n, C.from_nat(p, n)) == p : Nat}) -> {Word.to_nat(n, Word.inc(n, C.from_nat(p, n))) == 1n+p : Nat}:
  (h1, h2) = hs
  conversion_step(p, n, h2, duplicate_nat(Word.to_nat(n, C.from_nat(p, n)), p, ih(predecessor_lt(p, W.capacity(n), h1))))
def L.bounded_conversion(k, n, h):
  match k:
    case 0n: L.zero_word_value(n)
    case 1n+p:
      conversion_bounds(p, n, duplicate_bool(Nat.is_lt(1n+p, W.capacity(n)), h), hp => L.bounded_conversion(p, n, hp))

def L.u32_conversion_agrees(k):
  match k:
    case 0n: {==}
    case 1n+p:
      %Equal.sym(U32, U32.from_nat(p), U32{C.from_nat(p, 32n)}, L.u32_conversion_agrees(p)) : {U32.inc(_) == U32{Word.inc(32n, C.from_nat(p, 32n))} : U32}
      {==}

def L.bounded_u32_conversion(k, h):
  %Equal.sym(U32, U32.from_nat(k), U32{C.from_nat(k, 32n)}, L.u32_conversion_agrees(k)) : {U32.to_nat(_) == k : Nat}
  L.bounded_conversion(k, 32n, h)
