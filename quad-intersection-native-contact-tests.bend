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

def native_edge_contact_meets() -> {T.meets(F.native_q(), F.native_box(15, 5, 25, 15)) == True{} : Bool}:
  L.production_common_hull_meets(12n, {==}, F.native_q(), F.native_box(15, 5, 25, 15), {==}, {==}, {==}, {==}, F.common_at(F.q(), F.box(15n, 5n, 25n, 15n), G.P{15n, 10n, 1n}, {==}, {==}, {==}, {==}, {==}))
def native_corner_contact_meets() -> {T.meets(F.native_q(), F.native_box(15, 15, 25, 25)) == True{} : Bool}:
  L.production_common_hull_meets(12n, {==}, F.native_q(), F.native_box(15, 15, 25, 25), {==}, {==}, {==}, {==}, F.common_at(F.q(), F.box(15n, 15n, 25n, 25n), G.P{15n, 15n, 1n}, {==}, {==}, {==}, {==}, {==}))
