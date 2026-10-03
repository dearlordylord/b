import Base
import ./coordinate-limit.bend as Limit
import ./natural-squares.bend as S
import ./word-arithmetic.bend as W

law guarded_squares_bound:
  for +a: Nat
  for +b: Nat
  for +ha: {Nat.is_le(a, Limit.maximum()) == True{} : Bool}
  for +hb: {Nat.is_le(b, Limit.maximum()) == True{} : Bool}
  {Nat.is_lt(S.exact(a, b), W.capacity(32n)) == True{} : Bool}
