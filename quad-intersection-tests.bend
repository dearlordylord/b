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

def only_first_quad_separates() -> {M.outside(F.q(), F.diamond()) == True{} : Bool} & {M.outside(F.diamond(), F.q()) == False{} : Bool}:
  ({==}, {==})
def only_second_quad_separates() -> {M.outside(F.diamond(), F.q()) == False{} : Bool} & {M.outside(F.q(), F.diamond()) == True{} : Bool}:
  ({==}, {==})
def decoded_meets() -> {M.meets(F.q(), F.diamond()) == False{} : Bool}:
  {==}
def reversed_order() -> {M.meets(F.q(), F.diamond()) == M.meets(F.diamond(), F.q()) : Bool}:
  L.meets_symmetric(F.q(), F.diamond())
def rejection_excludes() -> M.CommonPoint(F.q(), F.diamond()) -> Empty:
  L.rejected_meets_excludes(F.q(), F.diamond(), {==}, {==}, {==})
def invalid_projective_origin() -> {Region.contains(G.P{0n, 0n, 0n}, F.q()) && Region.contains(G.P{0n, 0n, 0n}, F.diamond()) == True{} : Bool} & {G.positive_denominator(G.P{0n, 0n, 0n}) == False{} : Bool}:
  ({==}, {==})
