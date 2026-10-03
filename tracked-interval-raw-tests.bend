import Base
import ./tracked-interval.bend as M
import ./tracked-interval-fixtures.bend as F
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./interval-walk.bend as Walk

def two_cut_coefficients_and_labels() -> {M.clip_quad(F.p(),F.q(),F.box()) == M.Segment{M.End{2n,6n,M.Boundary{N.P{3n,1n},N.P{3n,3n}}},M.End{36n,12n,M.Boundary{N.P{1n,3n},N.P{1n,1n}}}} : M.Traced}: {==}
def right_cut_coefficients() -> {M.step(F.p(),F.q(),F.right_edge(),M.initial()) == M.Segment{M.End{1n,0n,M.SourceLeft{}},M.End{2n,6n,M.Boundary{N.P{3n,1n},N.P{3n,3n}}}} : M.Traced}: {==}
def reversed_right_cut_swaps_source() -> {M.step(F.q(),F.p(),F.right_edge(),M.initial()) == M.Segment{M.End{0n,1n,M.SourceRight{}},M.End{6n,2n,M.Boundary{N.P{3n,1n},N.P{3n,3n}}}} : M.Traced}: {==}
def late_empty() -> {M.clip_quad(G.P{0n,4n,1n},G.P{4n,4n,1n},F.box()) == M.Lost{} : M.Traced}: {==}
def original_start_kept() -> {M.clip_quad(G.P{2n,2n,1n},G.P{4n,2n,1n},F.box()) == M.Segment{M.End{1n,0n,M.SourceLeft{}},M.End{2n,2n,M.Boundary{N.P{3n,1n},N.P{3n,3n}}}} : M.Traced}: {==}
def wrong_source_label_rejected() -> {M.endpoint_honest(F.p(),F.q(),M.End{0n,1n,M.SourceLeft{}}) == False{} : Bool}: {==}
def wrong_boundary_label_rejected() -> {M.endpoint_honest(F.p(),F.q(),M.End{1n,0n,M.Boundary{N.P{1n,3n},N.P{1n,1n}}}) == False{} : Bool}: {==}
def zero_denominator_report() -> {G.positive_denominator(M.point(F.p(),F.q(),M.End{0n,0n,M.SourceLeft{}})) == False{} : Bool}: {==}
