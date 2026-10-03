import Base
import ./grid-scaling.bend as G
import ./core.bend as C
import ./topology.bend as T

# Zero remainder means scaling by four has no rounding error.
law grid_coordinate_exact:
  for +x: Nat
  for accepted: {Nat.is_eq(Nat.mod(x, 4n), 0n) == True{} : Bool}
  {Nat.mul(Nat.div(x, 4n), 4n) == x : Nat}

# This uses the actual production grid/coordinate filter and scaler.
law accepted_point_unrounded:
  for +x: Nat
  for +y: Nat
  for accepted: {T.point_guard(C.Pt{x, y}) == True{} : Bool}
  {G.restore(T.scaled(C.Pt{x, y})) == C.Pt{x, y} : C.Point}

# Accepted scaled points satisfy the envelopes used by homogeneous side proofs.
law accepted_scaled_envelope:
  for +width: Nat
  for +hw: {width == 12n : Nat}
  for +x: Nat
  for +y: Nat
  for accepted: {T.point_guard(C.Pt{x, y}) == True{} : Bool}
  {G.envelope(width, T.scaled(C.Pt{x, y})) == True{} : Bool}
