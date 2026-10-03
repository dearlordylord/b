# SPDX-License-Identifier: Apache-2.0
# Adapted from bend-mathlib/nat.bend le_of_not_lt and le_of_lt.
# Copyright 2026 HigherOrderCO; original license retained in LICENSE.mathlib.
import Base
import ./order-facts.bend as Order
import ./boolean-reflection.bend as V

law not_lt_ge:
  for +a: Nat
  for +b: Nat
  for h: {Nat.is_lt(a, b) == False{} : Bool}
  {Nat.is_ge(a, b) == True{} : Bool}
def not_lt_ge(a, b, h):
  match a b:
    case 0n 0n: {==}
    case 0n 1n+q:
      V.absurd({Nat.is_ge(0n, 1n+q) == True{} : Bool}, V.false_impossible(Equal.sym(Bool, True{}, False{}, h)))
    case 1n+p 0n: {==}
    case 1n+p 1n+q: not_lt_ge(p, q, h)

law lt_reverse_ge:
  for +a: Nat
  for +b: Nat
  for h: {Nat.is_lt(a, b) == True{} : Bool}
  {Nat.is_ge(b, a) == True{} : Bool}
def lt_reverse_ge(a, b, h):
  match a b:
    case 0n 0n:
      V.absurd({Nat.is_ge(0n, 0n) == True{} : Bool}, V.false_impossible(h))
    case 0n 1n+q: {==}
    case 1n+p 0n:
      V.absurd({Nat.is_ge(0n, 1n+p) == True{} : Bool}, V.false_impossible(h))
    case 1n+p 1n+q: lt_reverse_ge(p, q, h)

# Selected le_refl, le_succ and sub_le facts from the same mathlib source.

law le_refl:
  for +a: Nat
  {Nat.is_le(a, a) == True{} : Bool}
def le_refl(a):
  match a:
    case 0n: {==}
    case 1n+p: le_refl(p)

law le_succ:
  for +a: Nat
  {Nat.is_le(a, 1n+a) == True{} : Bool}
def le_succ(a):
  match a:
    case 0n: {==}
    case 1n+p: le_succ(p)

law sub_le:
  for +a: Nat
  for +b: Nat
  {Nat.is_le(Nat.sub(a, b), a) == True{} : Bool}
def sub_le(a, b):
  match a b:
    case 0n 0n: {==}
    case 0n 1n+q: {==}
    case 1n+p 0n: le_refl(1n+p)
    case 1n++p 1n++q:
      Order.le_trans(Nat.sub(p, q), p, 1n+p, sub_le(p, q), le_succ(p))
