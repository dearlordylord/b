import Base
import ./quad-intersection.bend as M
import ./quad-intersection-laws.bend as L
import ./quad-intersection-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-hull.bend as H
import ./halfplane-region.bend as Region
import ./quad-barycentric-laws.bend as Bary
import ./topology.bend as T

import ./quad-intersection-fixtures.bend as F

def overlap_meets() -> {M.meets(F.q(), F.overlap()) == True{} : Bool}:
  L.common_hull_meets(F.q(), F.overlap(), {==}, {==}, F.common_at(F.q(), F.overlap(), G.P{12n, 12n, 1n}, {==}, {==}, {==}, {==}, {==}))
def unreduced_fraction_meets() -> {M.meets(F.q(), F.overlap()) == True{} : Bool}:
  L.common_hull_meets(F.q(), F.overlap(), {==}, {==}, F.common_at(F.q(), F.overlap(), G.P{24n, 24n, 2n}, {==}, {==}, {==}, {==}, {==}))
def edge_contact_meets() -> {M.meets(F.q(), F.box(15n, 5n, 25n, 15n)) == True{} : Bool}:
  L.common_hull_meets(F.q(), F.box(15n, 5n, 25n, 15n), {==}, {==}, F.common_at(F.q(), F.box(15n, 5n, 25n, 15n), G.P{15n, 10n, 1n}, {==}, {==}, {==}, {==}, {==}))
def corner_contact_meets() -> {M.meets(F.q(), F.box(15n, 15n, 25n, 25n)) == True{} : Bool}:
  L.common_hull_meets(F.q(), F.box(15n, 15n, 25n, 25n), {==}, {==}, F.common_at(F.q(), F.box(15n, 15n, 25n, 25n), G.P{15n, 15n, 1n}, {==}, {==}, {==}, {==}, {==}))
def hull_region_defeats_sides() -> {M.outside(F.q(), F.overlap()) == False{} : Bool}:
  L.hull_region_not_outside(F.q(), F.overlap(), G.P{12n, 12n, 1n}, {==}, Bary.region_point_in_hull(F.overlap(), G.P{12n, 12n, 1n}, {==}, {==}, {==}))
def same_quad_meets() -> {M.meets(F.q(), F.q()) == True{} : Bool}:
  L.common_hull_meets(F.q(), F.q(), {==}, {==}, F.common_at(F.q(), F.q(), G.P{10n, 10n, 1n}, {==}, {==}, {==}, {==}, {==}))
