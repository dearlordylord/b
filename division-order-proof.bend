# SPDX-License-Identifier: Apache-2.0
# Selected positive-division monotonicity proofs from bend-mathlib/nat.bend.
# Copyright 2026 HigherOrderCO; original license retained in LICENSE.mathlib.
import Base
import ./order-facts.bend as Order
import ./absolute-order-proof.bend as Reflexive

def le(a: Nat, b: Nat) -> Data:
  {Nat.is_le(a, b) == True{} : Bool}
def internal_false_ne_true(h: {False{} == True{} : Bool}) -> Empty:
  Order.internal_false_ne_true(h)
def le_refl(a: Nat) -> {Nat.is_le(a, a) == True{} : Bool}:
  Reflexive.le_refl(a)

def internal_div_true_ne_false(h: {True{} == False{} : Bool}) -> Empty:
  internal_false_ne_true(Equal.sym(Bool, True{}, False{}, h))

def internal_div_le_refl(a: Nat) -> {True{} == Nat.is_le(a, a) : Bool}:
  Equal.sym(Bool, Nat.is_le(a, a), True{}, le_refl(a))

def internal_div_wit_succ(+ap: Nat, +bq: Nat, w: &k:Nat -> {Nat.add(ap, k) == bq : Nat}) -> &k:Nat -> {Nat.add(1n+ap, k) == 1n+bq : Nat}:
  match w:
    case (k, e):
      (k, Equal.cong(Nat, Nat, x => 1n+x, Nat.add(ap, k), bq, e))

def internal_div_le_wit(a: Nat, b: Nat, h: {Nat.is_le(a, b) == True{} : Bool}) -> &k:Nat -> {Nat.add(a, k) == b : Nat}:
  match a b:
    case 0n y:
      (y, {==})
    case 1n+ap 0n:
      Empty.absurd(&k:Nat -> {Nat.add(1n+ap, k) == 0n : Nat}, internal_false_ne_true(h))
    case 1n++ap 1n++bq:
      internal_div_wit_succ(ap, bq, internal_div_le_wit(ap, bq, h))

def internal_div_le_succ_r(j: Nat, d: Nat, h: {True{} == Nat.is_le(j, d) : Bool}) -> {True{} == Nat.is_le(j, 1n+d) : Bool}:
  match j d:
    case 0n _:
      {==}
    case 1n+i 0n:
      Empty.absurd({True{} == Nat.is_le(1n+i, 1n) : Bool}, internal_div_true_ne_false(h))
    case 1n+i 1n+e:
      internal_div_le_succ_r(i, e, h)

def internal_div_go_d_ge(+j: Nat, n: Nat, m: Nat, +d: Nat, r: Nat, h: {True{} == Nat.is_le(j, d) : Bool}) -> {True{} == Nat.is_le(j, Pair.fst(Nat, Nat, Nat.divmod.go(n, m, d, r))) : Bool}:
  match n m:
    case 0n _:
      h
    case 1n+np 0n:
      internal_div_go_d_ge(j, np, r, 1n+d, 0n, internal_div_le_succ_r(j, d, h))
    case 1n+np 1n+mp:
      internal_div_go_d_ge(j, np, mp, d, 1n+r, h)

def internal_div_mono_go(a: Nat, m: Nat, +d: Nat, r: Nat, +k: Nat) -> {True{} == Nat.is_le(Pair.fst(Nat, Nat, Nat.divmod.go(a, m, d, r)), Pair.fst(Nat, Nat, Nat.divmod.go(Nat.add(a, k), m, d, r))) : Bool}:
  match a m:
    case 0n _:
      internal_div_go_d_ge(d, k, m, d, r, internal_div_le_refl(d))
    case 1n+ap 0n:
      internal_div_mono_go(ap, r, 1n+d, 0n, k)
    case 1n+ap 1n+mp:
      internal_div_mono_go(ap, mp, d, 1n+r, k)

def internal_div_mono_wit(+a: Nat, +c: Nat, b: Nat, w: &k:Nat -> {Nat.add(a, k) == c : Nat}) -> le(Nat.div(a, 1n+b), Nat.div(c, 1n+b)):
  match w:
    case (+k, e):
      %e : le(Nat.div(a, 1n+b), Nat.div(_, 1n+b))
      Equal.sym(Bool, True{}, Nat.is_le(Nat.div(a, 1n+b), Nat.div(Nat.add(a, k), 1n+b)), internal_div_mono_go(a, b, 0n, 0n, k))

law div_le_div:
  for +a: Nat
  for +c: Nat
  for b: Nat
  for h: le(a, c)
  le(Nat.div(a, 1n+b), Nat.div(c, 1n+b))

def div_le_div(a, c, b, h):
  internal_div_mono_wit(a, c, b, internal_div_le_wit(a, c, h))

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

