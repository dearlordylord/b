# SPDX-License-Identifier: Apache-2.0
# Selected positive-divisor partition proof from bend-mathlib/nat.bend.
# Copyright 2026 HigherOrderCO; original license retained in LICENSE.mathlib.
import Base
import ./facts.bend as F

def internal_div_block_start(-bp: Nat, +r: Nat, h: {bp == Nat.add(r, 0n) : Nat}) -> {bp == r : Nat}:
  %F.add_zero(r) : {bp == _ : Nat}
  h

def internal_div_block_step(-bp: Nat, r: Nat, -mp: Nat, h: {bp == Nat.add(r, 1n+mp) : Nat}) -> {bp == 1n+Nat.add(r, mp) : Nat}:
  %F.add_succ(r, mp) : {bp == _ : Nat}
  h

def internal_div_go_eq(n: Nat, m: Nat, +bp: Nat, +d: Nat, +r: Nat, +h: {bp == Nat.add(r, m) : Nat}) -> {Nat.add(Nat.mul(Pair.fst(Nat, Nat, Nat.divmod.go(n, m, d, r)), 1n+bp), Pair.snd(Nat, Nat, Nat.divmod.go(n, m, d, r))) == Nat.add(n, Nat.add(Nat.mul(d, 1n+bp), r)) : Nat}:
  match n m:
    case 0n _:
      {==}
    case 1n++np 0n:
      %F.add_succ(np, Nat.add(Nat.mul(d, 1n+bp), r)) : {Nat.add(Nat.mul(Pair.fst(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n)), 1n+bp), Pair.snd(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n))) == _ : Nat}
      %F.add_comm(r, Nat.mul(d, 1n+bp)) : {Nat.add(Nat.mul(Pair.fst(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n)), 1n+bp), Pair.snd(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n))) == Nat.add(np, 1n+_) : Nat}
      %internal_div_block_start(bp, r, h) : {Nat.add(Nat.mul(Pair.fst(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n)), 1n+bp), Pair.snd(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n))) == Nat.add(np, 1n+Nat.add(_, Nat.mul(d, 1n+bp))) : Nat}
      %F.add_zero(Nat.add(bp, Nat.mul(d, 1n+bp))) : {Nat.add(Nat.mul(Pair.fst(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n)), 1n+bp), Pair.snd(Nat, Nat, Nat.divmod.go(np, r, 1n+d, 0n))) == Nat.add(np, 1n+_) : Nat}
      internal_div_go_eq(np, r, bp, 1n+d, 0n, internal_div_block_start(bp, r, h))
    case 1n++np 1n++mp:
      %F.add_succ(np, Nat.add(Nat.mul(d, 1n+bp), r)) : {Nat.add(Nat.mul(Pair.fst(Nat, Nat, Nat.divmod.go(np, mp, d, 1n+r)), 1n+bp), Pair.snd(Nat, Nat, Nat.divmod.go(np, mp, d, 1n+r))) == _ : Nat}
      %F.add_succ(Nat.mul(d, 1n+bp), r) : {Nat.add(Nat.mul(Pair.fst(Nat, Nat, Nat.divmod.go(np, mp, d, 1n+r)), 1n+bp), Pair.snd(Nat, Nat, Nat.divmod.go(np, mp, d, 1n+r))) == Nat.add(np, _) : Nat}
      internal_div_go_eq(np, mp, bp, d, 1n+r, internal_div_block_step(bp, r, mp, h))

# The division equation, for a positive divisor 1 + b: (a / (1 + b)) * (1 + b) + a % (1 + b) = a.
law div_mod_eq:
  for +a: Nat
  for +b: Nat
  {Nat.add(Nat.mul(Nat.div(a, 1n+b), 1n+b), Nat.mod(a, 1n+b)) == a : Nat}

def div_mod_eq(a, b):
  %F.add_zero(a) : {Nat.add(Nat.mul(Nat.div(a, 1n+b), 1n+b), Nat.mod(a, 1n+b)) == _ : Nat}
  internal_div_go_eq(a, b, b, 0n, 0n, {==})

