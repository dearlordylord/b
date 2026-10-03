import Base
import ./core.bend as C
import ./validation.bend as V
import ./centroid.bend as M
import ./centroid-laws.bend as L
import ./centroid-model-laws.bend as Mean
import ./centroid-proof.bend as P

def cell() -> C.Cell:
  C.Cell{C.Section{C.Pt{0n, 0n}, C.Pt{2n, 4n}}, C.Section{C.Pt{4n, 0n}, C.Pt{6n, 4n}}}
def mean_exact() -> {M.mean(0n, 2n, 4n, 6n) == 3n : Nat}:
  Mean.mean_four_exact(0n, 2n, 4n, 6n, 3n, {==})
def mean_bounded() -> {Nat.is_le(M.mean(0n, 2n, 4n, 6n), 6n) == True{} : Bool}:
  Mean.mean_four_bounded(0n, 2n, 4n, 6n, 6n, {==}, {==}, {==}, {==})
def actual_center() -> {C.cell_center(cell()) == C.Pt{3n, 2n} : C.Point}:
  Mean.cell_center_model(cell())
def center_bounded() -> {V.point_bounded(C.cell_center(cell())) == True{} : Bool}:
  L.bounded_cell_center(cell(), {==}, {==}, {==}, {==})
def accepted_average() -> {V.point_four(C.cell_center(cell())) == C.Pt{12n, 8n} : C.Point}:
  L.validated_centroid_mean(cell(), {==})
def rounded_cell() -> C.Cell:
  C.Cell{C.Section{C.Pt{0n, 0n}, C.Pt{1n, 0n}}, C.Section{C.Pt{1n, 0n}, C.Pt{1n, 0n}}}
def rounded_rejected() -> {V.cell_centroid_exact(rounded_cell()) == False{} : Bool}:
  {==}
