import Base
import ./segment-cut.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S

import ./segment-cut-fixtures.bend as F

def first_gap() -> {M.first_weight(F.a(), F.b(), F.q()) == 6n : Nat}: {==}
def second_gap() -> {M.second_weight(F.a(), F.b(), F.p()) == 12n : Nat}: {==}
def asymmetric_crossing() -> {M.point(F.a(), F.b(), F.p(), F.q()) == G.P{66n, 36n, 18n} : G.Point}: {==}
def unequal_denominator_point() -> {M.point(F.a(), F.b(), G.P{2n, 8n, 2n}, G.P{15n, 3n, 3n}) == G.P{396n, 216n, 108n} : G.Point}: {==}
def boundary_endpoint() -> {M.point(F.a(), F.b(), G.P{3n, 2n, 1n}, F.q()) == G.P{18n, 12n, 6n} : G.Point}: {==}
def reversed_orientation() -> {M.point(F.b(), F.a(), F.q(), F.p()) == G.P{66n, 36n, 18n} : G.Point}: {==}
def same_side_not_crossing() -> {S.negative(F.a(), F.b(), G.P{5n, 3n, 1n}) == False{} : Bool} & {M.on_line(F.a(), F.b(), M.point(F.a(), F.b(), F.p(), G.P{5n, 3n, 1n})) == False{} : Bool}:
  ({==}, {==})
def invalid_endpoint_domain() -> {G.positive_denominator(M.point(F.a(), F.b(), G.P{0n, 0n, 0n}, F.q())) == False{} : Bool} & {M.on_line(F.a(), F.b(), M.point(F.a(), F.b(), G.P{0n, 0n, 0n}, F.q())) == True{} : Bool}:
  ({==}, {==})
