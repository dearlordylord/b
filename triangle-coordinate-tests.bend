import Base
import ./triangle-coordinate.bend as M
import ./triangle-coordinate-laws.bend as L
import ./triangle-coordinate-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-diagonal.bend as D

def a() -> N.Point: N.P{1n, 1n}
def b() -> N.Point: N.P{5n, 1n}
def c() -> N.Point: N.P{1n, 5n}
def asymmetric_x() -> {M.weighted(a(), b(), c(), G.P{3n, 2n, 1n}, False{}) == 48n : Nat}:
  L.weighted_coordinate_exact(a(), b(), c(), G.P{3n, 2n, 1n}, False{}, {==}, {==})
def asymmetric_y() -> {M.weighted(a(), b(), c(), G.P{3n, 2n, 1n}, True{}) == 32n : Nat}:
  L.weighted_coordinate_exact(a(), b(), c(), G.P{3n, 2n, 1n}, True{}, {==}, {==})
def asymmetric_point() -> {M.reconstruct(a(), b(), c(), G.P{3n, 2n, 1n}) == G.P{48n, 32n, 16n} : G.Point}:
  L.reconstructed_point_exact(a(), b(), c(), G.P{3n, 2n, 1n}, {==}, {==})
def asymmetric_valid() -> {G.positive_denominator(M.reconstruct(a(), b(), c(), G.P{3n, 2n, 1n})) == True{} : Bool} & {G.equivalent(G.P{3n, 2n, 1n}, M.reconstruct(a(), b(), c(), G.P{3n, 2n, 1n})) == True{} : Bool}:
  L.reconstructed_point_valid(a(), b(), c(), G.P{3n, 2n, 1n}, {==}, {==}, {==})
def fractional_point() -> {M.reconstruct(a(), b(), c(), G.P{6n, 4n, 2n}) == G.P{96n, 64n, 32n} : G.Point}:
  L.reconstructed_point_exact(a(), b(), c(), G.P{6n, 4n, 2n}, {==}, {==})
def vertex_point() -> {M.reconstruct(a(), b(), c(), G.P{1n, 1n, 1n}) == G.P{16n, 16n, 16n} : G.Point}:
  L.reconstructed_point_exact(a(), b(), c(), G.P{1n, 1n, 1n}, {==}, {==})
def zero_axis_point() -> {M.reconstruct(N.P{0n, 0n}, N.P{4n, 0n}, N.P{0n, 4n}, G.P{0n, 2n, 1n}) == G.P{0n, 32n, 16n} : G.Point}:
  L.reconstructed_point_exact(N.P{0n, 0n}, N.P{4n, 0n}, N.P{0n, 4n}, G.P{0n, 2n, 1n}, {==}, {==})
def outside_rejected() -> {D.triangle(a(), b(), c(), G.P{6n, 6n, 1n}) == False{} : Bool}:
  {==}
def outside_not_equivalent() -> {G.equivalent(G.P{6n, 6n, 1n}, M.reconstruct(a(), b(), c(), G.P{6n, 6n, 1n})) == False{} : Bool}:
  {==}
def zero_denominator_invalid() -> {G.positive_denominator(M.reconstruct(a(), b(), c(), G.P{0n, 0n, 0n})) == False{} : Bool}:
  {==}
