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

def decoded_outside() -> {T.outside(F.native_q(), F.native_diamond()) == M.outside(F.q(), F.diamond()) : Bool}:
  {==}
def native_overlap_meets() -> {T.meets(F.native_q(), F.native_box(10, 10, 20, 20)) == True{} : Bool}:
  L.production_common_hull_meets(12n, {==}, F.native_q(), F.native_box(10, 10, 20, 20), {==}, {==}, {==}, {==}, F.common_at(F.q(), F.overlap(), G.P{12n, 12n, 1n}, {==}, {==}, {==}, {==}, {==}))
def native_rejection_excludes() -> M.CommonPoint(F.q(), F.diamond()) -> Empty:
  L.production_rejected_meets_excludes(12n, {==}, F.native_q(), F.native_diamond(), {==}, {==}, {==}, {==}, {==})
def native_order_symmetry() -> {T.meets(F.native_q(), F.native_diamond()) == T.meets(F.native_diamond(), F.native_q()) : Bool}:
  L.production_meets_symmetric(F.native_q(), F.native_diamond())
