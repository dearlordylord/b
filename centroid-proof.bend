import Base
import ./coordinate-limit.bend as Limit
import ./centroid-laws.bend as L
import ./core.bend as C
import ./validation.bend as V
import ./boolean-reflection.bend as BoolProof
import ./centroid-bounds-proof.bend as Bounds

def L.bounded_cell_center(cell, h0, h1, h2, h3):
  Bounds.bounded_center(Limit.maximum(), {==}, cell, h0, h1, h2, h3)

def point_equal_fields(+x: Nat, +y: Nat, +z: Nat, +w: Nat, hs: {Nat.is_eq(x, z) == True{} : Bool} & {Nat.is_eq(y, w) == True{} : Bool}) -> {C.Pt{x, y} == C.Pt{z, w} : C.Point}:
  match hs:
    case (hx, hy):
      %BoolProof.nat_eq_sound(x, z, hx) : {C.Pt{x, y} == C.Pt{_, w} : C.Point}
      %BoolProof.nat_eq_sound(y, w, hy) : {C.Pt{x, y} == C.Pt{x, _} : C.Point}
      {==}
def point_equal_sound(+a: C.Point, +b: C.Point, h: {V.point_equal(a, b) == True{} : Bool}) -> {a == b : C.Point}:
  match a b:
    case C.Pt{+x, +y} C.Pt{+z, +w}:
      point_equal_fields(x, y, z, w, BoolProof.and_split(Nat.is_eq(x, z), Nat.is_eq(y, w), h))

def L.validated_centroid_mean(cell, accepted):
  point_equal_sound(V.point_four(C.cell_center(cell)), C.point_add(C.point_add(C.boundary_left(C.cell_start(cell)), C.boundary_right(C.cell_start(cell))), C.point_add(C.boundary_left(C.cell_finish(cell)), C.boundary_right(C.cell_finish(cell)))), accepted)
