import Base
import ./segment-cut.bend as M
import ./segment-cut-laws.bend as L
import ./segment-cut-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S

import ./segment-cut-fixtures.bend as F

def exact_line() -> {M.on_line(F.a(), F.b(), M.point(F.a(), F.b(), F.p(), F.q())) == True{} : Bool}:
  L.crossing_on_line(F.a(), F.b(), F.p(), F.q(), {==}, {==})
def valid_denominator() -> {G.positive_denominator(M.point(F.a(), F.b(), F.p(), F.q())) == True{} : Bool}:
  L.crossing_denominator_positive(F.a(), F.b(), F.p(), F.q(), {==}, {==}, {==})
def containing_region() -> {Region.contains(M.point(F.a(), F.b(), F.p(), F.q()), F.box()) == True{} : Bool}:
  L.crossing_region_preserved(F.a(), F.b(), F.p(), F.q(), F.box(), {==}, {==})
def actual_segment_member() -> M.InSegment(F.p(), F.q(), M.point(F.a(), F.b(), F.p(), F.q())):
  L.crossing_in_segment(F.a(), F.b(), F.p(), F.q(), {==}, {==}, {==})
def unequal_denominator_line() -> {M.on_line(F.a(), F.b(), M.point(F.a(), F.b(), G.P{2n, 8n, 2n}, G.P{15n, 3n, 3n})) == True{} : Bool}:
  L.crossing_on_line(F.a(), F.b(), G.P{2n, 8n, 2n}, G.P{15n, 3n, 3n}, {==}, {==})
def boundary_member() -> M.InSegment(G.P{3n, 2n, 1n}, F.q(), M.point(F.a(), F.b(), G.P{3n, 2n, 1n}, F.q())):
  L.crossing_in_segment(F.a(), F.b(), G.P{3n, 2n, 1n}, F.q(), {==}, {==}, {==})
