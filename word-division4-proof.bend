# SPDX-License-Identifier: Apache-2.0
# quotient_shift follows bend-mathlib/nat.bend internal_div_go_shift.
# Copyright 2026 HigherOrderCO; original license retained in LICENSE.mathlib.
import Base
import ./word-arithmetic.bend as W
import ./word-division4.bend as D
import ./word-division4-laws.bend as L
import ./word-subtraction-proof.bend as Arithmetic
import ./facts.bend as F

law remainder_signature:
  for +n: Nat
  for +w: Word(n)
  {D.remainder(n, w) == D.remainder_bits(D.head(n, w), D.second(n, w)) : U32}
def remainder_signature(n, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{b, t}: {==}

law bit_division_step:
  for +p: Nat
  for +a: Bool
  for +b: Bool
  for +c: Bool
  for +q: Word(p)
  {U32.divmod.go.rec(p, a, 4, (q, D.remainder_bits(b, c))) == (WCon{c, q}, D.remainder_bits(a, b)) : Word(1n+p) & U32}
def bit_division_step(p, a, b, c, q):
  match a b c:
    case False{} False{} False{}: {==}
    case False{} False{} True{}: {==}
    case False{} True{} False{}: {==}
    case False{} True{} True{}: {==}
    case True{} False{} False{}: {==}
    case True{} False{} True{}: {==}
    case True{} True{} False{}: {==}
    case True{} True{} True{}: {==}

law quotient_step:
  for +p: Nat
  for +a: Bool
  for +t: Word(p)
  {U32.divmod.go.rec(p, a, 4, (D.quotient(p, t), D.remainder(p, t))) == (WCon{D.second(p, t), D.quotient(p, t)}, D.remainder_bits(a, D.head(p, t))) : Word(1n+p) & U32}
def quotient_step(p, a, t):
  %Equal.sym(U32, D.remainder(p, t), D.remainder_bits(D.head(p, t), D.second(p, t)), remainder_signature(p, t)) : {U32.divmod.go.rec(p, a, 4, (D.quotient(p, t), _)) == (WCon{D.second(p, t), D.quotient(p, t)}, D.remainder_bits(a, D.head(p, t))) : Word(1n+p) & U32}
  bit_division_step(p, a, D.head(p, t), D.second(p, t), D.quotient(p, t))

def L.division4_loop_bits(n, w):
  match n:
    case 0n:
      match w:
        case WNil{}: {==}
    case 1n+p:
      match w:
        case WCon{a, t}:
          Equal.trans(Word(1n+p) & U32, U32.divmod.go.rec(p, a, 4, U32.divmod.go(p, t, 4)), U32.divmod.go.rec(p, a, 4, (D.quotient(p, t), D.remainder(p, t))), (D.quotient(1n+p, WCon{a, t}), D.remainder(1n+p, WCon{a, t})), Equal.cong(Word(p) & U32, Word(1n+p) & U32, qr => U32.divmod.go.rec(p, a, 4, qr), U32.divmod.go(p, t, 4), (D.quotient(p, t), D.remainder(p, t)), L.division4_loop_bits(p, t)), quotient_step(p, a, t))

def L.u32_division4_bits(w):
  Equal.cong(Word(32n) & U32, U32, qr => U32.div.fin(qr), U32.divmod.go(32n, w, 4), (D.quotient(32n, w), D.remainder(32n, w)), L.division4_loop_bits(32n, w))

law bit_remainder_bound:
  for +a: Bool
  for +b: Bool
  {U32.is_lt(D.remainder_bits(a, b), 4) == True{} : Bool}
def bit_remainder_bound(a, b):
  match a b:
    case False{} False{}: {==}
    case True{} False{}: {==}
    case False{} True{}: {==}
    case True{} True{}: {==}

def L.remainder4_bound(n, w):
  %Equal.sym(U32, D.remainder(n, w), D.remainder_bits(D.head(n, w), D.second(n, w)), remainder_signature(n, w)) : {U32.is_lt(_, 4) == True{} : Bool}
  bit_remainder_bound(D.head(n, w), D.second(n, w))

law partition_bits:
  for +a: Bool
  for +b: Bool
  for +c: Bool
  for +q: Nat
  {Nat.add(W.bit_value(a), Nat.double(Nat.add(Nat.double(Nat.double(q)), U32.to_nat(D.remainder_bits(b, c))))) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(c), Nat.double(q)))), U32.to_nat(D.remainder_bits(a, b))) : Nat}
def partition_bits(a, b, c, q):
  match a b c:
    case False{} False{} False{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 0n), Nat.add(0n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 0n)) : {Nat.add(W.bit_value(False{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 0n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 0n), Nat.add(0n, Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 0n)) : {Nat.add(W.bit_value(False{}), Nat.double(Nat.add(0n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}
    case False{} False{} True{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 2n), Nat.add(2n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 2n)) : {Nat.add(W.bit_value(False{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 0n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 0n), Nat.add(0n, Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 0n)) : {Nat.add(W.bit_value(False{}), Nat.double(Nat.add(2n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}
    case False{} True{} False{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 1n), Nat.add(1n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 1n)) : {Nat.add(W.bit_value(False{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 2n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 2n), Nat.add(2n, Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 2n)) : {Nat.add(W.bit_value(False{}), Nat.double(Nat.add(1n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}
    case False{} True{} True{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 3n), Nat.add(3n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 3n)) : {Nat.add(W.bit_value(False{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 2n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 2n), Nat.add(2n, Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 2n)) : {Nat.add(W.bit_value(False{}), Nat.double(Nat.add(3n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}
    case True{} False{} False{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 0n), Nat.add(0n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 0n)) : {Nat.add(W.bit_value(True{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 1n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 1n), Nat.add(1n, Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 1n)) : {Nat.add(W.bit_value(True{}), Nat.double(Nat.add(0n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}
    case True{} False{} True{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 2n), Nat.add(2n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 2n)) : {Nat.add(W.bit_value(True{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 1n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 1n), Nat.add(1n, Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 1n)) : {Nat.add(W.bit_value(True{}), Nat.double(Nat.add(2n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}
    case True{} True{} False{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 1n), Nat.add(1n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 1n)) : {Nat.add(W.bit_value(True{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 3n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 3n), Nat.add(3n, Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(False{}), Nat.double(q)))), 3n)) : {Nat.add(W.bit_value(True{}), Nat.double(Nat.add(1n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}
    case True{} True{} True{}:
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(q)), 3n), Nat.add(3n, Nat.double(Nat.double(q))), F.add_comm(Nat.double(Nat.double(q)), 3n)) : {Nat.add(W.bit_value(True{}), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 3n) : Nat}
      %Equal.sym(Nat, Nat.add(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 3n), Nat.add(3n, Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q))))), F.add_comm(Nat.double(Nat.double(Nat.add(W.bit_value(True{}), Nat.double(q)))), 3n)) : {Nat.add(W.bit_value(True{}), Nat.double(Nat.add(3n, Nat.double(Nat.double(q))))) == _ : Nat}
      {==}

law word_bit_value:
  for +p: Nat
  for +b: Bool
  for +w: Word(p)
  {Word.to_nat(1n+p, WCon{b, w}) == Nat.add(W.bit_value(b), Nat.double(Word.to_nat(p, w))) : Nat}
def word_bit_value(p, b, w):
  match b:
    case False{}: {==}
    case True{}: {==}

law partition_step:
  for +p: Nat
  for +a: Bool
  for +t: Word(p)
  for h: {Word.to_nat(p, t) == Nat.add(Nat.double(Nat.double(Word.to_nat(p, D.quotient(p, t)))), U32.to_nat(D.remainder(p, t))) : Nat}
  {Nat.add(W.bit_value(a), Nat.double(Word.to_nat(p, t))) == Nat.add(Nat.double(Nat.double(Word.to_nat(1n+p, WCon{D.second(p, t), D.quotient(p, t)}))), U32.to_nat(D.remainder_bits(a, D.head(p, t)))) : Nat}
def partition_step(p, a, t, h):
  %Equal.sym(Nat, Word.to_nat(p, t), Nat.add(Nat.double(Nat.double(Word.to_nat(p, D.quotient(p, t)))), U32.to_nat(D.remainder(p, t))), h) : {Nat.add(W.bit_value(a), Nat.double(_)) == Nat.add(Nat.double(Nat.double(Word.to_nat(1n+p, WCon{D.second(p, t), D.quotient(p, t)}))), U32.to_nat(D.remainder_bits(a, D.head(p, t)))) : Nat}
  %Equal.sym(U32, D.remainder(p, t), D.remainder_bits(D.head(p, t), D.second(p, t)), remainder_signature(p, t)) : {Nat.add(W.bit_value(a), Nat.double(Nat.add(Nat.double(Nat.double(Word.to_nat(p, D.quotient(p, t)))), U32.to_nat(_)))) == Nat.add(Nat.double(Nat.double(Word.to_nat(1n+p, WCon{D.second(p, t), D.quotient(p, t)}))), U32.to_nat(D.remainder_bits(a, D.head(p, t)))) : Nat}
  %Equal.sym(Nat, Word.to_nat(1n+p, WCon{D.second(p, t), D.quotient(p, t)}), Nat.add(W.bit_value(D.second(p, t)), Nat.double(Word.to_nat(p, D.quotient(p, t)))), word_bit_value(p, D.second(p, t), D.quotient(p, t))) : {Nat.add(W.bit_value(a), Nat.double(Nat.add(Nat.double(Nat.double(Word.to_nat(p, D.quotient(p, t)))), U32.to_nat(D.remainder_bits(D.head(p, t), D.second(p, t)))))) == Nat.add(Nat.double(Nat.double(_)), U32.to_nat(D.remainder_bits(a, D.head(p, t)))) : Nat}
  partition_bits(a, D.head(p, t), D.second(p, t), Word.to_nat(p, D.quotient(p, t)))

def L.division4_partition(n, w):
  match n:
    case 0n:
      match w:
        case WNil{}: {==}
    case 1n+p:
      match w:
        case WCon{False{}, t}: partition_step(p, False{}, t, L.division4_partition(p, t))
        case WCon{True{}, t}: partition_step(p, True{}, t, L.division4_partition(p, t))

# The unary Base division loop increments its quotient once per block.
law quotient_shift:
  for +n: Nat
  for +m: Nat
  for +d: Nat
  for +r: Nat
  {1n+Pair.fst(Nat, Nat, Nat.divmod.go(n, m, d, r)) == Pair.fst(Nat, Nat, Nat.divmod.go(n, m, 1n+d, r)) : Nat}
def quotient_shift(n, m, d, r):
  match n m:
    case 0n _: {==}
    case 1n+p 0n: quotient_shift(p, r, 1n+d, 0n)
    case 1n+p 1n+q: quotient_shift(p, q, d, 1n+r)

law division4_block:
  for +a: Nat
  {Nat.div(4n+a, 4n) == 1n+Nat.div(a, 4n) : Nat}
def division4_block(a):
  Equal.sym(Nat, 1n+Pair.fst(Nat, Nat, Nat.divmod.go(a, 3n, 0n, 0n)), Pair.fst(Nat, Nat, Nat.divmod.go(a, 3n, 1n, 0n)), quotient_shift(a, 3n, 0n, 0n))

law natural_quotient4:
  for +q: Nat
  for +a: Bool
  for +b: Bool
  {Nat.div(Nat.add(Nat.double(Nat.double(q)), U32.to_nat(D.remainder_bits(a, b))), 4n) == q : Nat}
def natural_quotient4(q, a, b):
  match q:
    case 0n:
      match a b:
        case False{} False{}: {==}
        case False{} True{}: {==}
        case True{} False{}: {==}
        case True{} True{}: {==}
    case 1n+p:
      Equal.trans(Nat, Nat.div(4n+Nat.add(Nat.double(Nat.double(p)), U32.to_nat(D.remainder_bits(a, b))), 4n), 1n+Nat.div(Nat.add(Nat.double(Nat.double(p)), U32.to_nat(D.remainder_bits(a, b))), 4n), 1n+p, division4_block(Nat.add(Nat.double(Nat.double(p)), U32.to_nat(D.remainder_bits(a, b)))), Equal.cong(Nat, Nat, z => 1n+z, Nat.div(Nat.add(Nat.double(Nat.double(p)), U32.to_nat(D.remainder_bits(a, b))), 4n), p, natural_quotient4(p, a, b)))

def L.quotient4_value(n, w):
  %Equal.sym(Nat, Word.to_nat(n, w), Nat.add(Nat.double(Nat.double(Word.to_nat(n, D.quotient(n, w)))), U32.to_nat(D.remainder(n, w))), L.division4_partition(n, w)) : {Word.to_nat(n, D.quotient(n, w)) == Nat.div(_, 4n) : Nat}
  %Equal.sym(U32, D.remainder(n, w), D.remainder_bits(D.head(n, w), D.second(n, w)), remainder_signature(n, w)) : {Word.to_nat(n, D.quotient(n, w)) == Nat.div(Nat.add(Nat.double(Nat.double(Word.to_nat(n, D.quotient(n, w)))), U32.to_nat(_)), 4n) : Nat}
  Equal.sym(Nat, Nat.div(Nat.add(Nat.double(Nat.double(Word.to_nat(n, D.quotient(n, w)))), U32.to_nat(D.remainder_bits(D.head(n, w), D.second(n, w)))), 4n), Word.to_nat(n, D.quotient(n, w)), natural_quotient4(Word.to_nat(n, D.quotient(n, w)), D.head(n, w), D.second(n, w)))

def L.u32_division4_value(w):
  Equal.trans(Nat, U32.to_nat(U32.div(U32{w}, 4)), Word.to_nat(32n, D.quotient(32n, w)), Nat.div(Word.to_nat(32n, w), 4n), Equal.cong(U32, Nat, z => U32.to_nat(z), U32.div(U32{w}, 4), U32{D.quotient(32n, w)}, L.u32_division4_bits(w)), L.quotient4_value(32n, w))
