import Base
import ./coordinate-limit.bend as Limit
import ./grid-scaling.bend as G
import ./grid-scaling-laws.bend as L
import ./core.bend as C
import ./topology.bend as T
import ./word-arithmetic.bend as W
import ./scaled-coordinate-laws.bend as S
import ./scaled-coordinate-proof.bend as ScaledProof
import ./division-partition-proof.bend as Partition
import ./boolean-reflection.bend as B
import ./facts.bend as F

def no_remainder(+x: Nat, h: {Nat.mod(x, 4n) == 0n : Nat}) -> {Nat.mul(Nat.div(x, 4n), 4n) == x : Nat}:
  %F.add_zero(Nat.mul(Nat.div(x, 4n), 4n)) : {_ == x : Nat}
  %h : {Nat.add(Nat.mul(Nat.div(x, 4n), 4n), _) == x : Nat}
  Partition.div_mod_eq(x, 3n)
def L.grid_coordinate_exact(x, accepted):
  no_remainder(x, B.nat_eq_sound(Nat.mod(x, 4n), 0n, accepted))

def guard_fields(+a: Bool, +b: Bool, +c: Bool, +d: Bool, h: {a && b && c && d == True{} : Bool}) -> {a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})):
  match a b c d:
    case False{} _ _ _:
      B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} False{} _ _:
      B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} False{} _:
      B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} True{} False{}:
      B.absurd({a == True{} : Bool} & ({b == True{} : Bool} & ({c == True{} : Bool} & {d == True{} : Bool})), B.false_impossible(h))
    case True{} True{} True{} True{}:
      ({==}, ({==}, ({==}, {==})))

def unrounded_point(+x: Nat, +y: Nat, hx: {Nat.is_le(x, Limit.maximum()) == True{} : Bool}, hy: {Nat.is_le(y, Limit.maximum()) == True{} : Bool}, gx: {Nat.is_eq(Nat.mod(x, 4n), 0n) == True{} : Bool}, gy: {Nat.is_eq(Nat.mod(y, 4n), 0n) == True{} : Bool}) -> {G.restore(T.scaled(C.Pt{x, y})) == C.Pt{x, y} : C.Point}:
  %Equal.sym(Nat, U32.to_nat(U32.div(U32.from_nat(x), 4)), Nat.div(x, 4n), S.scaled_coordinate_exact(x, hx)) : {C.Pt{Nat.mul(_, 4n), Nat.mul(U32.to_nat(U32.div(U32.from_nat(y), 4)), 4n)} == C.Pt{x, y} : C.Point}
  %Equal.sym(Nat, U32.to_nat(U32.div(U32.from_nat(y), 4)), Nat.div(y, 4n), S.scaled_coordinate_exact(y, hy)) : {C.Pt{Nat.mul(Nat.div(x, 4n), 4n), Nat.mul(_, 4n)} == C.Pt{x, y} : C.Point}
  %Equal.sym(Nat, Nat.mul(Nat.div(x, 4n), 4n), x, L.grid_coordinate_exact(x, gx)) : {C.Pt{_, Nat.mul(Nat.div(y, 4n), 4n)} == C.Pt{x, y} : C.Point}
  %Equal.sym(Nat, Nat.mul(Nat.div(y, 4n), 4n), y, L.grid_coordinate_exact(y, gy)) : {C.Pt{x, _} == C.Pt{x, y} : C.Point}
  {==}

def point_fields(+x: Nat, +y: Nat, hs: {Nat.is_le(x, Limit.maximum()) == True{} : Bool} & ({Nat.is_le(y, Limit.maximum()) == True{} : Bool} & ({Nat.is_eq(Nat.mod(x, 4n), 0n) == True{} : Bool} & {Nat.is_eq(Nat.mod(y, 4n), 0n) == True{} : Bool}))) -> {G.restore(T.scaled(C.Pt{x, y})) == C.Pt{x, y} : C.Point}:
  match hs:
    case (hx, (hy, (gx, gy))): unrounded_point(x, y, hx, hy, gx, gy)
def L.accepted_point_unrounded(x, y, accepted):
  point_fields(x, y, guard_fields(Nat.is_le(x, Limit.maximum()), Nat.is_le(y, Limit.maximum()), Nat.is_eq(Nat.mod(x, 4n), 0n), Nat.is_eq(Nat.mod(y, 4n), 0n), accepted))

def scaled_envelope(+width: Nat, +hw: {width == 12n : Nat}, +x: Nat, +y: Nat, +hx: {Nat.is_le(x, Limit.maximum()) == True{} : Bool}, +hy: {Nat.is_le(y, Limit.maximum()) == True{} : Bool}) -> {G.envelope(width, T.scaled(C.Pt{x, y})) == True{} : Bool}:
  %Equal.sym(Nat, U32.to_nat(U32.div(U32.from_nat(x), 4)), Nat.div(x, 4n), S.scaled_coordinate_exact(x, hx)) : {Nat.is_le(_, W.capacity(width)) && Nat.is_le(U32.to_nat(U32.div(U32.from_nat(y), 4)), W.capacity(width)) == True{} : Bool}
  %Equal.sym(Nat, U32.to_nat(U32.div(U32.from_nat(y), 4)), Nat.div(y, 4n), S.scaled_coordinate_exact(y, hy)) : {Nat.is_le(Nat.div(x, 4n), W.capacity(width)) && Nat.is_le(_, W.capacity(width)) == True{} : Bool}
  B.and_join(Nat.is_le(Nat.div(x, 4n), W.capacity(width)), Nat.is_le(Nat.div(y, 4n), W.capacity(width)), S.scaled_coordinate_bound(width, hw, x, hx), S.scaled_coordinate_bound(width, hw, y, hy))

def envelope_fields(+width: Nat, +hw: {width == 12n : Nat}, +x: Nat, +y: Nat, hs: {Nat.is_le(x, Limit.maximum()) == True{} : Bool} & ({Nat.is_le(y, Limit.maximum()) == True{} : Bool} & ({Nat.is_eq(Nat.mod(x, 4n), 0n) == True{} : Bool} & {Nat.is_eq(Nat.mod(y, 4n), 0n) == True{} : Bool}))) -> {G.envelope(width, T.scaled(C.Pt{x, y})) == True{} : Bool}:
  match hs:
    case (hx, (hy, (gx, gy))): scaled_envelope(width, hw, x, y, hx, hy)
def L.accepted_scaled_envelope(width, hw, x, y, accepted):
  envelope_fields(width, hw, x, y, guard_fields(Nat.is_le(x, Limit.maximum()), Nat.is_le(y, Limit.maximum()), Nat.is_eq(Nat.mod(x, 4n), 0n), Nat.is_eq(Nat.mod(y, 4n), 0n), accepted))
