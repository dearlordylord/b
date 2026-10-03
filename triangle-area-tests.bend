import Base
import ./triangle-area.bend as M
import ./triangle-area-laws.bend as L
import ./triangle-area-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-diagonal.bend as D

def a() -> N.Point: N.P{1n, 1n}
def b() -> N.Point: N.P{5n, 1n}
def c() -> N.Point: N.P{1n, 5n}
def whole_area() -> {M.triangle_area(a(), b(), c()) == 16n : Nat}:
  {==}
def interior_weights() -> {M.area(b(), c(), G.P{2n, 2n, 1n}) == 8n : Nat} & ({M.area(c(), a(), G.P{2n, 2n, 1n}) == 4n : Nat} & {M.area(a(), b(), G.P{2n, 2n, 1n}) == 4n : Nat}):
  ({==}, ({==}, {==}))
def interior_total() -> {M.weights_total(a(), b(), c(), G.P{2n, 2n, 1n}) == 16n : Nat}:
  {==}
def boundary_weights() -> {M.area(b(), c(), G.P{5n, 1n, 1n}) == 0n : Nat} & ({M.area(c(), a(), G.P{5n, 1n, 1n}) == 16n : Nat} & {M.area(a(), b(), G.P{5n, 1n, 1n}) == 0n : Nat}):
  ({==}, ({==}, {==}))
def fractional_total() -> {M.weights_total(a(), b(), c(), G.P{4n, 4n, 2n}) == 32n : Nat}:
  {==}
def positive_total() -> {Nat.is_gt(M.weights_total(a(), b(), c(), G.P{4n, 4n, 2n}), 0n) == True{} : Bool}:
  L.triangle_weights_positive(a(), b(), c(), G.P{4n, 4n, 2n}, {==}, {==}, {==})
def outside_rejected() -> {D.triangle(a(), b(), c(), G.P{6n, 6n, 1n}) == False{} : Bool}:
  {==}
def outside_saturation() -> {M.weights_total(a(), b(), c(), G.P{6n, 6n, 1n}) == 40n : Nat}:
  {==}
def zero_denominator_total() -> {M.weights_total(a(), b(), c(), G.P{0n, 0n, 0n}) == 0n : Nat}:
  {==}
def zero_denominator_rejected() -> {G.positive_denominator(G.P{0n, 0n, 0n}) == False{} : Bool}:
  {==}
