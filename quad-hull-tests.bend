import ./quad-hull-laws.bend as L
import ./quad-hull-proof.bend as Proof
import Base
import ./quad-hull.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region

def square() -> N.Quad:
  N.Q{N.P{1n, 1n}, N.P{3n, 1n}, N.P{3n, 3n}, N.P{1n, 3n}}
def asymmetric_weights() -> {M.weighted(square(), 1n, 2n, 3n, 4n) == G.P{20n, 24n, 10n} : G.Point}:
  {==}
def asymmetric_inside() -> {Region.contains(M.weighted(square(), 1n, 2n, 3n, 4n), square()) == True{} : Bool}:
  {==}
def fourth_only() -> {M.weighted(square(), 0n, 0n, 0n, 1n) == G.P{1n, 3n, 1n} : G.Point}:
  {==}
def first_pair_zero() -> {G.positive_denominator(M.weighted(square(), 0n, 0n, 1n, 2n)) == True{} : Bool}:
  {==}
def second_pair_zero() -> {G.positive_denominator(M.weighted(square(), 1n, 2n, 0n, 0n)) == True{} : Bool}:
  {==}
def zero_total_rejected() -> {G.positive_denominator(M.weighted(square(), 0n, 0n, 0n, 0n)) == False{} : Bool}:
  {==}
def alternate_fraction() -> {G.equivalent(G.P{10n, 12n, 5n}, M.weighted(square(), 1n, 2n, 3n, 4n)) == True{} : Bool}:
  {==}
def alternate_fraction_member() -> M.InHull(square(), G.P{10n, 12n, 5n}):
  (1n, (2n, (3n, (4n, ({==}, ({==}, {==}))))))
def reconstructed_point_inside() -> {Region.contains(G.P{10n, 12n, 5n}, square()) == True{} : Bool}:
  L.hull_point_inside(square(), G.P{10n, 12n, 5n}, {==}, alternate_fraction_member())
def member_denominator_positive() -> {G.positive_denominator(G.P{10n, 12n, 5n}) == True{} : Bool}:
  L.hull_point_positive(square(), G.P{10n, 12n, 5n}, alternate_fraction_member())
