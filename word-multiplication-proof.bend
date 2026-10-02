import Base
import ./word-arithmetic.bend as W
import ./word-multiplication.bend as M
import ./word-multiplication-laws.bend as L
import ./word-bounds-laws.bend as B
import ./word-shift-laws.bend as S
import ./word-range-proof.bend as Range
import ./word-conversion-laws.bend as C
import ./word-conversion-proof.bend as CP
import ./arithmetic-order-proof.bend as O
import ./arithmetic-product-proof.bend as A
import ./facts.bend as F

# Transport a strict bound across an independently proved arithmetic equality.
def bound(+x: Nat, +y: Nat, +limit: Nat, e: {x == y : Nat}, h: {Nat.is_lt(y, limit) == True{} : Bool}) -> {Nat.is_lt(x, limit) == True{} : Bool}:
  Equal.trans(Bool, Nat.is_lt(x, limit), Nat.is_lt(y, limit), True{}, Equal.cong(Nat, Bool, z => Nat.is_lt(z, limit), x, y, e), h)

law shifted_product:
  for +v: Nat
  for +n: Nat
  for +b: Word(n)
  for +acc: Nat
  for h: {Nat.is_lt(Nat.add(Nat.mul(v, Nat.double(Word.to_nat(n, b))), acc), W.capacity(n)) == True{} : Bool}
  {Nat.mul(v, Word.to_nat(n, Word.shl(n, b))) == Nat.mul(v, Nat.double(Word.to_nat(n, b))) : Nat}
def shifted_product(v, n, b, acc, h):
  match v:
    case 0n: {==}
    case 1n+p:
      Equal.cong(Nat, Nat, z => Nat.mul(1n+p, z), Word.to_nat(n, Word.shl(n, b)), Nat.double(Word.to_nat(n, b)), S.bounded_shift(n, b, O.summand_bound(Nat.double(Word.to_nat(n, b)), Nat.add(Nat.mul(p, Nat.double(Word.to_nat(n, b))), acc), W.capacity(n), bound(Nat.add(Nat.double(Word.to_nat(n, b)), Nat.add(Nat.mul(p, Nat.double(Word.to_nat(n, b))), acc)), Nat.add(Nat.add(Nat.double(Word.to_nat(n, b)), Nat.mul(p, Nat.double(Word.to_nat(n, b)))), acc), W.capacity(n), Equal.sym(Nat, Nat.add(Nat.add(Nat.double(Word.to_nat(n, b)), Nat.mul(p, Nat.double(Word.to_nat(n, b)))), acc), Nat.add(Nat.double(Word.to_nat(n, b)), Nat.add(Nat.mul(p, Nat.double(Word.to_nat(n, b))), acc)), F.add_assoc(Nat.double(Word.to_nat(n, b)), Nat.mul(p, Nat.double(Word.to_nat(n, b))), acc)), h))))

law false_normal:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  {Nat.add(Nat.mul(Nat.double(a), b), c) == Nat.add(Nat.mul(a, Nat.double(b)), c) : Nat}
def false_normal(a, b, c):
  Equal.cong(Nat, Nat, z => Nat.add(z, c), Nat.mul(Nat.double(a), b), Nat.mul(a, Nat.double(b)), A.double_mul(a, b))

law true_normal:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  {Nat.add(Nat.add(b, Nat.mul(Nat.double(a), b)), c) == Nat.add(Nat.mul(a, Nat.double(b)), Nat.add(c, b)) : Nat}
def true_normal(a, b, c):
  %Equal.sym(Nat, Nat.mul(Nat.double(a), b), Nat.mul(a, Nat.double(b)), A.double_mul(a, b)) : {Nat.add(Nat.add(b, _), c) == Nat.add(Nat.mul(a, Nat.double(b)), Nat.add(c, b)) : Nat}
  Equal.trans(Nat, Nat.add(Nat.add(b, Nat.mul(a, Nat.double(b))), c), Nat.add(Nat.add(b, c), Nat.mul(a, Nat.double(b))), Nat.add(Nat.mul(a, Nat.double(b)), Nat.add(c, b)), F.add_right_comm(b, Nat.mul(a, Nat.double(b)), c), Equal.trans(Nat, Nat.add(Nat.add(b, c), Nat.mul(a, Nat.double(b))), Nat.add(Nat.mul(a, Nat.double(b)), Nat.add(b, c)), Nat.add(Nat.mul(a, Nat.double(b)), Nat.add(c, b)), F.add_comm(Nat.add(b, c), Nat.mul(a, Nat.double(b))), Equal.cong(Nat, Nat, z => Nat.add(Nat.mul(a, Nat.double(b)), z), Nat.add(b, c), Nat.add(c, b), F.add_comm(b, c))))

law add_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for h: {Nat.is_lt(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, Word.add(n, a, b)) == Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)) : Nat}
def add_exact(n, a, b, h):
  Equal.trans(Nat, Word.to_nat(n, Word.add(n, a, b)), Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), 0n), Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), B.bounded_addition_exact(n, a, b, False{}, bound(Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), 0n), Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), W.capacity(n), F.add_zero(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b))), h)), F.add_zero(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b))))

law false_step_eq:
  for +m: Nat
  for +n: Nat
  for +a: Word(m)
  for +b: Word(n)
  for +acc: Word(n)
  for h: {Nat.is_lt(Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), W.capacity(n)) == True{} : Bool}
  {M.total(m, n, a, Word.shl(n, b), acc) == Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)) : Nat}
def false_step_eq(m, n, a, b, acc, h):
  Equal.trans(Nat, M.total(m, n, a, Word.shl(n, b), acc), Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Word.to_nat(n, acc)), Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), Equal.cong(Nat, Nat, t => Nat.add(t, Word.to_nat(n, acc)), Nat.mul(Word.to_nat(m, a), Word.to_nat(n, Word.shl(n, b))), Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), shifted_product(Word.to_nat(m, a), n, b, Word.to_nat(n, acc), bound(Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Word.to_nat(n, acc)), Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), W.capacity(n), Equal.sym(Nat, Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Word.to_nat(n, acc)), false_normal(Word.to_nat(m, a), Word.to_nat(n, b), Word.to_nat(n, acc))), h))), Equal.sym(Nat, Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Word.to_nat(n, acc)), false_normal(Word.to_nat(m, a), Word.to_nat(n, b), Word.to_nat(n, acc))))

law true_step_eq:
  for +m: Nat
  for +n: Nat
  for +a: Word(m)
  for +b: Word(n)
  for +acc: Word(n)
  for hs: {Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n)) == True{} : Bool} & {Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n)) == True{} : Bool}
  {M.total(m, n, a, Word.shl(n, b), Word.add(n, acc, b)) == Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)) : Nat}
def true_step_eq(m, n, a, b, acc, hs):
  (h1, h2) = hs
  Equal.trans(Nat, M.total(m, n, a, Word.shl(n, b), Word.add(n, acc, b)), Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Word.to_nat(n, Word.add(n, acc, b))), Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), Equal.cong(Nat, Nat, t => Nat.add(t, Word.to_nat(n, Word.add(n, acc, b))), Nat.mul(Word.to_nat(m, a), Word.to_nat(n, Word.shl(n, b))), Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), shifted_product(Word.to_nat(m, a), n, b, Nat.add(Word.to_nat(n, acc), Word.to_nat(n, b)), bound(Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Nat.add(Word.to_nat(n, acc), Word.to_nat(n, b))), Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n), Equal.sym(Nat, Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Nat.add(Word.to_nat(n, acc), Word.to_nat(n, b))), true_normal(Word.to_nat(m, a), Word.to_nat(n, b), Word.to_nat(n, acc))), h1))), Equal.trans(Nat, Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Word.to_nat(n, Word.add(n, acc, b))), Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Nat.add(Word.to_nat(n, acc), Word.to_nat(n, b))), Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), Equal.cong(Nat, Nat, t => Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), t), Word.to_nat(n, Word.add(n, acc, b)), Nat.add(Word.to_nat(n, acc), Word.to_nat(n, b)), add_exact(n, acc, b, bound(Nat.add(Word.to_nat(n, acc), Word.to_nat(n, b)), Nat.add(Word.to_nat(n, b), Word.to_nat(n, acc)), W.capacity(n), F.add_comm(Word.to_nat(n, acc), Word.to_nat(n, b)), O.summand_bound(Nat.add(Word.to_nat(n, b), Word.to_nat(n, acc)), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), W.capacity(n), bound(Nat.add(Nat.add(Word.to_nat(n, b), Word.to_nat(n, acc)), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n), Equal.sym(Nat, Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), Nat.add(Nat.add(Word.to_nat(n, b), Word.to_nat(n, acc)), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), F.add_right_comm(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc))), h2))))), Equal.sym(Nat, Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), Nat.add(Nat.mul(Word.to_nat(m, a), Nat.double(Word.to_nat(n, b))), Nat.add(Word.to_nat(n, acc), Word.to_nat(n, b))), true_normal(Word.to_nat(m, a), Word.to_nat(n, b), Word.to_nat(n, acc)))))

def finish(+m: Nat, +n: Nat, +a: Word(m), +b: Word(n), +acc: Word(n), +old: Nat, es: {M.total(m, n, a, b, acc) == old : Nat} & {M.total(m, n, a, b, acc) == old : Nat}, h: {Nat.is_lt(old, W.capacity(n)) == True{} : Bool}, ih: {Nat.is_lt(M.total(m, n, a, b, acc), W.capacity(n)) == True{} : Bool} -> {Word.to_nat(n, M.loop(m, n, a, b, acc)) == M.total(m, n, a, b, acc) : Nat}) -> {Word.to_nat(n, M.loop(m, n, a, b, acc)) == old : Nat}:
  (e1, e2) = es
  Equal.trans(Nat, Word.to_nat(n, M.loop(m, n, a, b, acc)), M.total(m, n, a, b, acc), old, ih(bound(M.total(m, n, a, b, acc), old, W.capacity(n), e1, h)), e2)

def false_step(+m: Nat, +n: Nat, +a: Word(m), +b: Word(n), +acc: Word(n), hs: {Nat.is_lt(Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), W.capacity(n)) == True{} : Bool} & {Nat.is_lt(Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), W.capacity(n)) == True{} : Bool}, ih: {Nat.is_lt(M.total(m, n, a, Word.shl(n, b), acc), W.capacity(n)) == True{} : Bool} -> {Word.to_nat(n, M.loop(m, n, a, Word.shl(n, b), acc)) == M.total(m, n, a, Word.shl(n, b), acc) : Nat}) -> {Word.to_nat(n, M.loop(m, n, a, Word.shl(n, b), acc)) == Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)) : Nat}:
  (h1, h2) = hs
  finish(m, n, a, Word.shl(n, b), acc, Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), CP.duplicate_nat(M.total(m, n, a, Word.shl(n, b), acc), Nat.add(Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b)), Word.to_nat(n, acc)), false_step_eq(m, n, a, b, acc, h1)), h2, ih)

def true_step(+m: Nat, +n: Nat, +a: Word(m), +b: Word(n), +acc: Word(n), hs: {Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n)) == True{} : Bool} & {Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n)) == True{} : Bool}, ih: {Nat.is_lt(M.total(m, n, a, Word.shl(n, b), Word.add(n, acc, b)), W.capacity(n)) == True{} : Bool} -> {Word.to_nat(n, M.loop(m, n, a, Word.shl(n, b), Word.add(n, acc, b))) == M.total(m, n, a, Word.shl(n, b), Word.add(n, acc, b)) : Nat}) -> {Word.to_nat(n, M.loop(m, n, a, Word.shl(n, b), Word.add(n, acc, b))) == Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)) : Nat}:
  (h1, h2) = hs
  finish(m, n, a, Word.shl(n, b), Word.add(n, acc, b), Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), CP.duplicate_nat(M.total(m, n, a, Word.shl(n, b), Word.add(n, acc, b)), Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), true_step_eq(m, n, a, b, acc, CP.duplicate_bool(Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(m, a)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n)), h1))), h2, ih)

def L.loop_exact(m, n, a, b, acc, h):
  match m:
    case 0n:
      match a:
        case WNil{}: {==}
    case 1n+p:
      match a:
        case WCon{False{}, at}:
          false_step(p, n, at, b, acc, CP.duplicate_bool(Nat.is_lt(Nat.add(Nat.mul(Nat.double(Word.to_nat(p, at)), Word.to_nat(n, b)), Word.to_nat(n, acc)), W.capacity(n)), h), hp => L.loop_exact(p, n, at, Word.shl(n, b), acc, hp))
        case WCon{True{}, at}:
          true_step(p, n, at, b, acc, CP.duplicate_bool(Nat.is_lt(Nat.add(Nat.add(Word.to_nat(n, b), Nat.mul(Nat.double(Word.to_nat(p, at)), Word.to_nat(n, b))), Word.to_nat(n, acc)), W.capacity(n)), h), hp => L.loop_exact(p, n, at, Word.shl(n, b), Word.add(n, acc, b), hp))

law initial_total:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  {M.total(n, n, a, b, Word.zero(n)) == Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)) : Nat}
def initial_total(n, a, b):
  %Equal.sym(Nat, Word.to_nat(n, Word.zero(n)), 0n, C.zero_word_value(n)) : {Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), _) == Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)) : Nat}
  F.add_zero(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)))

def L.bounded_multiplication(n, a, b, h):
  Equal.trans(Nat, Word.to_nat(n, M.multiply(n, a, b)), M.total(n, n, a, b, Word.zero(n)), Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), L.loop_exact(n, n, a, b, Word.zero(n), bound(M.total(n, n, a, b, Word.zero(n)), Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), W.capacity(n), initial_total(n, a, b), h)), initial_total(n, a, b))

def L.bounded_u32_multiplication(x, y, h):
  L.bounded_multiplication(32n, x, y, h)

def L.bounded_u32_addition(x, y, h):
  add_exact(32n, x, y, h)
