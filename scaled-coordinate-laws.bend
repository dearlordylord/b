import Base
import ./coordinate-limit.bend as Limit
import ./scaled-coordinate.bend as M
import ./topology.bend as T
import ./core.bend as C
import ./word-arithmetic.bend as W

# A source coordinate accepted at 16000 fits the scaled 12-bit envelope.
law scaled_coordinate_bound:
  for +width: Nat
  for hw: {width == 12n : Nat}
  for +x: Nat
  for h: {Nat.is_le(x, Limit.maximum()) == True{} : Bool}
  {Nat.is_le(Nat.div(x, 4n), W.capacity(width)) == True{} : Bool}

# The actual conversion and U32 division agree with natural division.
law scaled_coordinate_exact:
  for +x: Nat
  for +h: {Nat.is_le(x, Limit.maximum()) == True{} : Bool}
  {U32.to_nat(U32.div(U32.from_nat(x), 4)) == Nat.div(x, 4n) : Nat}

# Agreement of the actual production point conversion, coordinate by coordinate.
law topology_scaled_exact:
  for +x: Nat
  for +y: Nat
  for hx: {Nat.is_le(x, Limit.maximum()) == True{} : Bool}
  for hy: {Nat.is_le(y, Limit.maximum()) == True{} : Bool}
  {M.values(T.scaled(C.Pt{x, y})) == (Nat.div(x, 4n), Nat.div(y, 4n)) : Nat & Nat}
