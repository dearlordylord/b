import Base
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as M
import ./halfplane-region.bend as Region
import ./natural-cover.bend as N

def square() -> N.Quad:
  N.Q{N.P{0n, 0n}, N.P{4n, 0n}, N.P{4n, 4n}, N.P{0n, 4n}}
def unequal_denominators() -> {M.join(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 2n, 1n) == G.P{13n, 11n, 7n} : G.Point}:
  {==}
def unequal_denominators_inside() -> {Region.contains(M.join(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 2n, 1n), square()) == True{} : Bool}:
  {==}
def boundary_join() -> {Region.contains(M.join(G.P{0n, 0n, 1n}, G.P{4n, 0n, 1n}, 1n, 3n), square()) == True{} : Bool}:
  {==}
def zero_first_weight() -> {M.join(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 0n, 1n) == G.P{9n, 3n, 3n} : G.Point}:
  {==}
def zero_second_weight() -> {M.join(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 1n, 0n) == G.P{2n, 4n, 2n} : G.Point}:
  {==}
def positive_join() -> {G.positive_denominator(M.join(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 2n, 1n)) == True{} : Bool}:
  {==}
def both_weights_zero() -> {G.positive_denominator(M.join(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 0n, 0n)) == False{} : Bool}:
  {==}
def zero_denominator_polynomial() -> {Region.contains(M.join(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 0n, 0n), square()) == True{} : Bool}:
  {==}
def affine_mixture_unequal_denominators() -> {M.mix(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 2n, 1n) == G.P{30n, 30n, 18n} : G.Point}:
  {==}
def affine_mixture_inside() -> {Region.contains(M.mix(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 2n, 1n), square()) == True{} : Bool}:
  {==}
def affine_mixture_positive() -> {G.positive_denominator(M.mix(G.P{2n, 4n, 2n}, G.P{9n, 3n, 3n}, 2n, 1n)) == True{} : Bool}:
  {==}
