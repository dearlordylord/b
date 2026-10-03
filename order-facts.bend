# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 HigherOrderCO
# Selected order proofs from bendlib bend-mathlib/nat.bend.
# Original license retained in LICENSE.mathlib.
import Base
import ./facts.bend as F

def le(a: Nat, b: Nat) -> Data:
  {Nat.is_le(a, b) == True{} : Bool}

def lt(a: Nat, b: Nat) -> Data:
  {Nat.is_lt(a, b) == True{} : Bool}

def internal_false_ne_true(e: {False{} == True{} : Bool}) -> Empty:
  %e : Bool.pick(Type, _, Empty, Unit)
  Unit{}

law zero_le:
  for b: Nat
  {Nat.is_le(0n, b) == True{} : Bool}

def zero_le(b):
  match b:
    case 0n:
      {==}
    case 1n+p:
      {==}

law le_add_right:
  for n: Nat
  for k: Nat
  {Nat.is_le(n, Nat.add(n, k)) == True{} : Bool}

def le_add_right(n, k):
  match n:
    case 0n:
      zero_le(k)
    case 1n+p:
      le_add_right(p, k)

law le_trans:
  for a: Nat
  for b: Nat
  for c: Nat
  for ab: {Nat.is_le(a, b) == True{} : Bool}
  for bc: {Nat.is_le(b, c) == True{} : Bool}
  {Nat.is_le(a, c) == True{} : Bool}

def le_trans(a, b, c, ab, bc):
  match a b c:
    case 0n _ 0n:
      {==}
    case 0n _ 1n+r:
      {==}
    case 1n+p 0n _:
      Empty.absurd({Nat.is_le(1n+p, c) == True{} : Bool}, internal_false_ne_true(ab))
    case 1n+p 1n+q 0n:
      Empty.absurd({Nat.is_le(1n+p, 0n) == True{} : Bool}, internal_false_ne_true(bc))
    case 1n+p 1n+q 1n+r:
      le_trans(p, q, r, ab, bc)

law sub_add_cancel:
  for n: Nat
  for m: Nat
  for h: {Nat.is_le(m, n) == True{} : Bool}
  {Nat.add(Nat.sub(n, m), m) == n : Nat}

def sub_add_cancel(n, m, h):
  match n m:
    case 0n 0n:
      {==}
    case 0n 1n+q:
      Empty.absurd({1n+q == 0n : Nat}, internal_false_ne_true(h))
    case 1n++p 0n:
      %F.add_zero(p) : {1n+Nat.add(p, 0n) == 1n+_ : Nat}
      {==}
    case 1n++p 1n++q:
      %Equal.sym(Nat, Nat.add(Nat.sub(p, q), 1n+q), 1n+Nat.add(Nat.sub(p, q), q), F.add_succ(Nat.sub(p, q), q)) : {_ == 1n+p : Nat}
      %Equal.sym(Nat, Nat.add(Nat.sub(p, q), q), p, sub_add_cancel(p, q, h)) : {1n+_ == 1n+p : Nat}
      {==}

law lt_of_le_of_lt:
  for a: Nat
  for b: Nat
  for c: Nat
  for ab: {Nat.is_le(a, b) == True{} : Bool}
  for bc: {Nat.is_lt(b, c) == True{} : Bool}
  {Nat.is_lt(a, c) == True{} : Bool}

def lt_of_le_of_lt(a, b, c, ab, bc):
  match a b c:
    case 0n 0n 0n:
      Empty.absurd({Nat.is_lt(0n, 0n) == True{} : Bool}, internal_false_ne_true(bc))
    case 0n 1n+q 0n:
      Empty.absurd({Nat.is_lt(0n, 0n) == True{} : Bool}, internal_false_ne_true(bc))
    case 0n _ 1n+r:
      {==}
    case 1n+p 0n _:
      Empty.absurd({Nat.is_lt(1n+p, c) == True{} : Bool}, internal_false_ne_true(ab))
    case 1n+p 1n+q 0n:
      Empty.absurd({Nat.is_lt(1n+p, 0n) == True{} : Bool}, internal_false_ne_true(bc))
    case 1n+p 1n+q 1n+r:
      lt_of_le_of_lt(p, q, r, ab, bc)

law add_le_add_left:
  for -a: Nat
  for -b: Nat
  for k: Nat
  for h: {Nat.is_le(a, b) == True{} : Bool}
  {Nat.is_le(Nat.add(k, a), Nat.add(k, b)) == True{} : Bool}

def add_le_add_left(a, b, k, h):
  match k:
    case 0n:
      h
    case 1n+p:
      add_le_add_left(a, b, p, h)

law add_le_add_right:
  for +a: Nat
  for +b: Nat
  for +k: Nat
  for h: {Nat.is_le(a, b) == True{} : Bool}
  {Nat.is_le(Nat.add(a, k), Nat.add(b, k)) == True{} : Bool}

def add_le_add_right(a, b, k, h):
  %F.add_comm(k, a) : {Nat.is_le(_, Nat.add(b, k)) == True{} : Bool}
  %F.add_comm(k, b) : {Nat.is_le(Nat.add(k, a), _) == True{} : Bool}
  add_le_add_left(a, b, k, h)

law add_le_add:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for h1: {Nat.is_le(a, c) == True{} : Bool}
  for h2: {Nat.is_le(b, d) == True{} : Bool}
  {Nat.is_le(Nat.add(a, b), Nat.add(c, d)) == True{} : Bool}

def add_le_add(a, b, c, d, h1, h2):
  le_trans(Nat.add(a, b), Nat.add(c, b), Nat.add(c, d), add_le_add_right(a, c, b, h1), add_le_add_left(b, d, c, h2))

law mul_le_mul_right:
  for +a: Nat
  for +b: Nat
  for +k: Nat
  for h: {Nat.is_le(a, b) == True{} : Bool}
  {Nat.is_le(Nat.mul(a, k), Nat.mul(b, k)) == True{} : Bool}

def mul_le_mul_right(a, b, k, h):
  %sub_add_cancel(b, a, h) : {Nat.is_le(Nat.mul(a, k), Nat.mul(_, k)) == True{} : Bool}
  %Equal.sym(Nat, Nat.mul(Nat.add(Nat.sub(b, a), a), k), Nat.add(Nat.mul(Nat.sub(b, a), k), Nat.mul(a, k)), F.add_mul(Nat.sub(b, a), a, k)) : {Nat.is_le(Nat.mul(a, k), _) == True{} : Bool}
  %F.add_comm(Nat.mul(a, k), Nat.mul(Nat.sub(b, a), k)) : {Nat.is_le(Nat.mul(a, k), _) == True{} : Bool}
  le_add_right(Nat.mul(a, k), Nat.mul(Nat.sub(b, a), k))

law mul_le_mul_left:
  for a: Nat
  for b: Nat
  for k: Nat
  for h: {Nat.is_le(a, b) == True{} : Bool}
  {Nat.is_le(Nat.mul(k, a), Nat.mul(k, b)) == True{} : Bool}

def mul_le_mul_left(a, b, k, h):
  +a = a
  +b = b
  +k = k
  %F.mul_comm(a, k) : {Nat.is_le(_, Nat.mul(k, b)) == True{} : Bool}
  %F.mul_comm(b, k) : {Nat.is_le(Nat.mul(a, k), _) == True{} : Bool}
  mul_le_mul_right(a, b, k, h)

law mul_le_mul:
  for a: Nat
  for b: Nat
  for c: Nat
  for d: Nat
  for h1: {Nat.is_le(a, c) == True{} : Bool}
  for h2: {Nat.is_le(b, d) == True{} : Bool}
  {Nat.is_le(Nat.mul(a, b), Nat.mul(c, d)) == True{} : Bool}

def mul_le_mul(a, b, c, d, h1, h2):
  +a = a
  +b = b
  +c = c
  +d = d
  le_trans(Nat.mul(a, b), Nat.mul(c, b), Nat.mul(c, d), mul_le_mul_right(a, c, b, h1), mul_le_mul_left(b, d, c, h2))

law le_of_lt:
  for a: Nat
  for b: Nat
  for h: {Nat.is_lt(a, b) == True{} : Bool}
  {Nat.is_le(a, b) == True{} : Bool}

def le_of_lt(a, b, h):
  match a b:
    case 0n 0n:
      {==}
    case 0n 1n+q:
      {==}
    case 1n+p 0n:
      Empty.absurd({Nat.is_le(1n+p, 0n) == True{} : Bool}, internal_false_ne_true(h))
    case 1n+p 1n+q:
      le_of_lt(p, q, h)

