# SPDX-License-Identifier: Apache-2.0
# Selected cancellation facts derived from bendlib bend-mathlib/nat.bend.
# Copyright 2026 HigherOrderCO; original license: LICENSE.mathlib.
import Base
import ./facts.bend as F

def predecessor(n: Nat) -> Nat:
  match n:
    case 0n: 0n
    case 1n+p: p
law successor_injective:
  for +a: Nat
  for +b: Nat
  for e: {1n+a == 1n+b : Nat}
  {a == b : Nat}
def successor_injective(a, b, e):
  Equal.cong(Nat, Nat, z => predecessor(z), 1n+a, 1n+b, e)
law cancel_left:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for e: {Nat.add(a, b) == Nat.add(a, c) : Nat}
  {b == c : Nat}
def cancel_left(a, b, c, e):
  match a:
    case 0n: e
    case 1n+p:
      cancel_left(p, b, c, successor_injective(Nat.add(p, b), Nat.add(p, c), e))
law cancel_right:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for e: {Nat.add(a, b) == Nat.add(c, b) : Nat}
  {a == c : Nat}
def cancel_right(a, b, c, e):
  cancel_left(b, a, c, Equal.trans(Nat, Nat.add(b, a), Nat.add(a, b), Nat.add(b, c), F.add_comm(b, a), Equal.trans(Nat, Nat.add(a, b), Nat.add(c, b), Nat.add(b, c), e, F.add_comm(c, b))))
law sub_zero:
  for +n: Nat
  {Nat.sub(n, 0n) == n : Nat}
def sub_zero(n):
  match n:
    case 0n: {==}
    case 1n+p: {==}
law subtract_left_sum:
  for +a: Nat
  for +b: Nat
  {Nat.sub(Nat.add(a, b), a) == b : Nat}
def subtract_left_sum(a, b):
  match a:
    case 0n: sub_zero(b)
    case 1n+p: subtract_left_sum(p, b)
