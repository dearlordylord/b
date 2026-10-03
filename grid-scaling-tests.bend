import Base
import ./core.bend as C
import ./topology.bend as T
import ./grid-scaling.bend as G
import ./grid-scaling-laws.bend as L
import ./grid-scaling-proof.bend as P

def exact_multiple() -> {Nat.mul(Nat.div(20n, 4n), 4n) == 20n : Nat}:
  L.grid_coordinate_exact(20n, {==})
def accepted_roundtrip() -> {G.restore(T.scaled(C.Pt{12n, 20n})) == C.Pt{12n, 20n} : C.Point}:
  L.accepted_point_unrounded(12n, 20n, {==})
def accepted_origin() -> {G.restore(T.scaled(C.Pt{0n, 0n})) == C.Pt{0n, 0n} : C.Point}:
  L.accepted_point_unrounded(0n, 0n, {==})
def accepted_envelope() -> {G.envelope(12n, T.scaled(C.Pt{12n, 20n})) == True{} : Bool}:
  L.accepted_scaled_envelope(12n, {==}, 12n, 20n, {==})
def x_nonmultiple_rejected() -> {T.point_guard(C.Pt{3n, 0n}) == False{} : Bool}:
  {==}
def y_nonmultiple_rejected() -> {T.point_guard(C.Pt{0n, 3n}) == False{} : Bool}:
  {==}
