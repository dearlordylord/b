import Base
import ./strict-halfplane.bend as M
import ./strict-halfplane-laws.bend as L
import ./strict-halfplane-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./quad-hull.bend as Hull
import ./topology.bend as T

def a() -> N.Point: N.P{0n, 2n}
def b() -> N.Point: N.P{6n, 2n}
def box() -> N.Quad:
  N.Q{N.P{1n, 0n}, N.P{4n, 0n}, N.P{4n, 1n}, N.P{1n, 1n}}
def native_box() -> T.Quad:
  T.Q{T.P{1, 0}, T.P{4, 0}, T.P{4, 1}, T.P{1, 1}}
def strict_complement() -> {M.negative(a(), b(), G.P{3n, 1n, 1n}) == Bool.not(Region.edge(a(), b(), G.P{3n, 1n, 1n})) : Bool}:
  L.negative_closed_complement(a(), b(), G.P{3n, 1n, 1n})
def boundary_is_closed() -> {M.negative(a(), b(), G.P{3n, 2n, 1n}) == False{} : Bool} & {Region.edge(a(), b(), G.P{3n, 2n, 1n}) == True{} : Bool}:
  ({==}, {==})
def unequal_fraction_join() -> {M.negative(a(), b(), C.join(G.P{2n, 1n, 2n}, G.P{8n, 3n, 4n}, 1n, 1n)) == True{} : Bool}:
  L.negative_weighted_join(a(), b(), G.P{2n, 1n, 2n}, G.P{8n, 3n, 4n}, 1n, 1n, {==}, {==}, {==})
def zero_first_join_weight() -> {M.negative(a(), b(), C.join(G.P{2n, 1n, 2n}, G.P{8n, 3n, 4n}, 0n, 3n)) == True{} : Bool}:
  L.negative_weighted_join(a(), b(), G.P{2n, 1n, 2n}, G.P{8n, 3n, 4n}, 0n, 3n, {==}, {==}, {==})
def first_only() -> {M.negative(a(), b(), Hull.weighted(box(), 1n, 0n, 0n, 0n)) == True{} : Bool}:
  L.separated_weighted_quad(a(), b(), box(), 1n, 0n, 0n, 0n, {==}, {==})
def second_only() -> {M.negative(a(), b(), Hull.weighted(box(), 0n, 1n, 0n, 0n)) == True{} : Bool}:
  L.separated_weighted_quad(a(), b(), box(), 0n, 1n, 0n, 0n, {==}, {==})
def third_only() -> {M.negative(a(), b(), Hull.weighted(box(), 0n, 0n, 1n, 0n)) == True{} : Bool}:
  L.separated_weighted_quad(a(), b(), box(), 0n, 0n, 1n, 0n, {==}, {==})
def fourth_only() -> {M.negative(a(), b(), Hull.weighted(box(), 0n, 0n, 0n, 1n)) == True{} : Bool}:
  L.separated_weighted_quad(a(), b(), box(), 0n, 0n, 0n, 1n, {==}, {==})
def all_weights() -> {M.negative(a(), b(), Hull.weighted(box(), 2n, 3n, 4n, 5n)) == True{} : Bool}:
  L.separated_weighted_quad(a(), b(), box(), 2n, 3n, 4n, 5n, {==}, {==})
def alternate_fraction_hull_point() -> {M.negative(a(), b(), G.P{5n, 1n, 2n}) == True{} : Bool}:
  L.separated_hull_point(a(), b(), box(), G.P{5n, 1n, 2n}, {==}, (1n, (1n, (1n, (1n, ({==}, ({==}, {==})))))))
def closed_point_excluded() -> Hull.InHull(box(), G.P{3n, 3n, 1n}) -> Empty:
  L.separated_region_exclusion(a(), b(), box(), G.P{3n, 3n, 1n}, {==}, {==})
def decoded_separator() -> {T.separated(T.P{0, 2}, T.P{6, 2}, native_box()) == M.separated(a(), b(), box()) : Bool}:
  L.production_separated_exact(12n, {==}, T.P{0, 2}, T.P{6, 2}, native_box(), {==}, {==}, {==})
def native_closed_point_excluded() -> Hull.InHull(box(), G.P{3n, 3n, 1n}) -> Empty:
  L.production_separated_region_exclusion(12n, {==}, T.P{0, 2}, T.P{6, 2}, native_box(), G.P{3n, 3n, 1n}, {==}, {==}, {==}, {==}, {==})
def contact_not_separated() -> {M.separated(a(), b(), N.Q{N.P{1n, 0n}, N.P{4n, 0n}, N.P{4n, 2n}, N.P{1n, 1n}}) == False{} : Bool}:
  {==}
def fourth_corner_blocks() -> {M.separated(a(), b(), N.Q{N.P{1n, 0n}, N.P{4n, 0n}, N.P{4n, 1n}, N.P{1n, 3n}}) == False{} : Bool}:
  {==}
def zero_total_not_strict() -> {M.negative(a(), b(), Hull.weighted(box(), 0n, 0n, 0n, 0n)) == False{} : Bool}:
  {==}
def reversed_orientation() -> {M.negative(b(), a(), G.P{3n, 3n, 1n}) == True{} : Bool}:
  {==}
