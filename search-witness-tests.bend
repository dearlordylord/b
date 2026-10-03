import Base
import ./topology.bend as T
import ./search-witness.bend as M
import ./inside-arithmetic.bend as N
import ./source-cells.bend as S
import ./core.bend as C
import ./sat-arithmetic.bend as Sat
import ./edge-arithmetic.bend as Edge
import ./source-convexity.bend as Convex
import ./validation.bend as V
import ./validator-natural.bend as ValidatorNat
import ./cover-arithmetic.bend as Cover

def same(a: Bool, b: Bool) -> Bool:
  Bool.not(Bool.xor(a, b))

def box(+x: U32, +y: U32, +u: U32, +v: U32) -> T.Quad:
  T.Q{T.P{x, y}, T.P{u, y}, T.P{u, v}, T.P{x, v}}

def inside_box() -> T.Quad:
  box(0, 0, 8, 8)

def source_cases() -> Bool:
  S.envelope(12n, T.cells([])) && S.envelope(12n, T.cells([C.Section{C.Pt{0n, 0n}, C.Pt{32n, 0n}}])) && S.envelope(12n, T.cells([C.Section{C.Pt{0n, 0n}, C.Pt{32n, 0n}}, C.Section{C.Pt{0n, 32n}, C.Pt{32n, 32n}}])) && S.envelope(12n, T.cells([C.Section{C.Pt{0n, 32n}, C.Pt{32n, 32n}}, C.Section{C.Pt{0n, 0n}, C.Pt{32n, 0n}}]))

def filtered_cases() -> Bool:
  S.envelope(12n, List.append(&2, T.Quad, [inside_box()], [inside_box()])) && S.envelope(0n, T.neighbors(box(0, 0, 4, 4), [box(0, 0, 1, 1)])) && same(S.envelope(0n, [box(0, 0, 4, 4)]), False{}) && M.quad_envelope(12n, inside_box())

def classifier_cases() -> Bool:
  same(T.inside(T.W{2, 2, 1}, box(0, 0, 4, 4)), N.inside(T.W{2, 2, 1}, box(0, 0, 4, 4))) && N.inside(T.W{0, 0, 1}, box(0, 0, 4, 4)) && same(N.inside(T.W{0, 2, 1}, box(2, 0, 6, 4)), False{}) && N.inside(T.W{128, 128, 64}, box(0, 0, 4, 4)) && same(N.common(T.W{1, 1, 1}, box(0, 0, 4, 4), box(0, 0, 4, 4), box(10, 0, 14, 4)), False{})

def sat_cases() -> Bool:
  same(T.meets(box(0, 0, 4, 4), box(4, 0, 8, 4)), Sat.meets(box(0, 0, 4, 4), box(4, 0, 8, 4))) && same(T.meets(box(0, 0, 4, 4), box(5, 0, 8, 4)), Sat.meets(box(0, 0, 4, 4), box(5, 0, 8, 4))) && same(T.outside(box(0, 0, 4, 4), box(5, 0, 8, 4)), Sat.outside(box(0, 0, 4, 4), box(5, 0, 8, 4))) && same(T.strictly_convex(box(0, 0, 4, 4)), Sat.strictly_convex(box(0, 0, 4, 4))) && same(T.strictly_convex(T.reverse(box(0, 0, 4, 4))), Sat.strictly_convex(T.reverse(box(0, 0, 4, 4)))) && same(T.strictly_convex(box(0, 0, 0, 4)), Sat.strictly_convex(box(0, 0, 0, 4))) && same(T.orientation(box(0, 0, 4, 4)), Sat.orientation(box(0, 0, 4, 4))) && same(T.orientation(T.reverse(box(0, 0, 4, 4))), Sat.orientation(T.reverse(box(0, 0, 4, 4)))) && Sat.meets(box(0, 0, 4, 4), box(4, 0, 8, 4)) && Sat.meets(box(0, 0, 4, 4), box(4, 4, 8, 8)) && Bool.not(Sat.meets(box(0, 0, 4, 4), box(5, 0, 8, 4))) && Bool.not(Sat.strictly_convex(box(0, 0, 0, 4))) && Bool.not(Sat.strictly_convex(T.reverse(box(0, 0, 4, 4))))

def edge_cases() -> Bool:
  Edge.point_equal(T.P{4294967295, 0}, T.P{4294967295, 0}) && Bool.not(Edge.point_equal(T.P{4294967295, 0}, T.P{4294967294, 0})) && Bool.not(Edge.point_equal(T.P{0, 0}, T.P{0, 1})) && same(T.shared_edge(box(0, 0, 4, 4), box(4, 0, 8, 4)), Edge.shared_edge(box(0, 0, 4, 4), box(4, 0, 8, 4))) && Edge.shared_edge(box(0, 0, 4, 4), box(4, 0, 8, 4)) && Bool.not(Edge.shared_edge(box(0, 0, 4, 4), box(5, 0, 8, 4))) && Bool.not(Edge.shared_edge(box(0, 0, 4, 4), box(4, 4, 8, 8))) && Bool.not(Edge.shared_edge(box(0, 0, 4, 4), T.reverse(box(4, 0, 8, 4))))

def source_convexity_cases() -> Bool:
  Convex.positive_quad(C.Pt{0n, 0n}, C.Pt{4n, 0n}, C.Pt{4n, 4n}, C.Pt{0n, 4n}) && Convex.convex_quad(C.Pt{0n, 4n}, C.Pt{4n, 4n}, C.Pt{4n, 0n}, C.Pt{0n, 0n}) && Bool.not(Convex.convex_quad(C.Pt{0n, 0n}, C.Pt{4n, 0n}, C.Pt{4n, 0n}, C.Pt{0n, 4n})) && Bool.not(Convex.convex_quad(C.Pt{0n, 0n}, C.Pt{4n, 0n}, C.Pt{1n, 1n}, C.Pt{0n, 4n})) && same(V.cell_convex(C.Cell{C.Section{C.Pt{0n, 0n}, C.Pt{0n, 4n}}, C.Section{C.Pt{4n, 0n}, C.Pt{4n, 4n}}}), Convex.cell_convex(C.Cell{C.Section{C.Pt{0n, 0n}, C.Pt{0n, 4n}}, C.Section{C.Pt{4n, 0n}, C.Pt{4n, 4n}}})) && same(V.convex_quad(C.Pt{0n, 0n}, C.Pt{16000n, 0n}, C.Pt{16000n, 16000n}, C.Pt{0n, 16000n}), Convex.convex_quad(C.Pt{0n, 0n}, C.Pt{16000n, 0n}, C.Pt{16000n, 16000n}, C.Pt{0n, 16000n}))

def width_range_cases() -> Bool:
  Bool.not(V.width_in_range(3239999)) && V.width_in_range(3240000) && V.width_in_range(6760000) && Bool.not(V.width_in_range(6760001)) && V.section_width(C.Section{C.Pt{0n, 0n}, C.Pt{1800n, 0n}}) && V.section_width(C.Section{C.Pt{0n, 0n}, C.Pt{2600n, 0n}}) && Bool.not(V.section_width(C.Section{C.Pt{0n, 0n}, C.Pt{1799n, 0n}})) && Bool.not(V.section_width(C.Section{C.Pt{0n, 0n}, C.Pt{2601n, 0n}})) && Bool.not(V.section_width(C.Section{C.Pt{16000n, 0n}, C.Pt{16000n, 0n}}))

def validator_natural_cases() -> Bool:
  same(V.validate([]), ValidatorNat.validate([], 3240000, 6760000)) && same(V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 2000n}}]), ValidatorNat.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 2000n}}], 3240000, 6760000)) && same(V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 2000n}}, C.Section{C.Pt{2000n, 0n}, C.Pt{2000n, 2000n}}]), ValidatorNat.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 2000n}}, C.Section{C.Pt{2000n, 0n}, C.Pt{2000n, 2000n}}], 3240000, 6760000)) && same(V.validate([C.Section{C.Pt{16001n, 0n}, C.Pt{16001n, 2000n}}]), ValidatorNat.validate([C.Section{C.Pt{16001n, 0n}, C.Pt{16001n, 2000n}}], 3240000, 6760000)) && Bool.not(ValidatorNat.validate([], 3240000, 6760000)) && Bool.not(ValidatorNat.validate([C.Section{C.Pt{16001n, 0n}, C.Pt{16001n, 2000n}}], 3240000, 6760000))

def cover_arithmetic_cases() -> Bool:
  Bool.not(Cover.ribbon([])) && Cover.ribbon([box(0, 0, 4, 4)]) && Cover.ribbon([box(0, 0, 4, 4), box(4, 0, 8, 4), box(8, 0, 12, 4)]) && same(T.ribbon([box(0, 0, 4, 4), box(4, 0, 8, 4), box(8, 0, 12, 4)]), Cover.ribbon([box(0, 0, 4, 4), box(4, 0, 8, 4), box(8, 0, 12, 4)])) && Bool.not(Cover.ribbon([box(0, 0, 4, 4), box(4, 4, 8, 8)])) && Bool.not(Cover.ribbon([box(0, 0, 4, 4), box(5, 0, 8, 4)])) && same(T.overlaps([box(0, 0, 4, 4)], [box(10, 0, 14, 4), box(4, 4, 8, 8)]), Cover.overlaps([box(0, 0, 4, 4)], [box(10, 0, 14, 4), box(4, 4, 8, 8)])) && Cover.overlaps([box(0, 0, 4, 4)], [box(10, 0, 14, 4), box(4, 4, 8, 8)]) && Cover.disjoint_nonadjacent(box(0, 0, 4, 4), [box(4, 0, 8, 4), box(8, 0, 12, 4)]) && Bool.not(Cover.disjoint_all(box(0, 0, 4, 4), [box(4, 0, 8, 4), box(8, 0, 12, 4)])) && Bool.not(Cover.overlaps([], [box(0, 0, 4, 4)])) && Bool.not(Cover.ribbon([T.reverse(box(0, 0, 4, 4))]))

def filter_inspection_cases() -> Bool:
  Nat.is_eq(List.length(&2, T.Quad, Cover.neighbors(box(0, 0, 4, 4), [box(0, 0, 4, 4), box(8, 0, 12, 4), box(4, 0, 8, 4), box(4, 4, 8, 8)])), 3n) && Nat.is_eq(List.length(&2, T.Quad, T.neighbors(box(0, 0, 4, 4), [box(0, 0, 4, 4), box(8, 0, 12, 4), box(4, 0, 8, 4), box(4, 4, 8, 8)])), 3n) && S.envelope(12n, Cover.neighbors(box(0, 0, 4, 4), [box(0, 0, 4, 4), box(8, 0, 12, 4), box(4, 0, 8, 4)])) && Cover.report_connected(T.inspect_cells([box(0, 0, 4, 4)], [box(4, 0, 8, 4)], [box(8, 0, 12, 4)])) && same(Cover.report_connected(T.inspect_cells([box(0, 0, 4, 4)], [box(4, 0, 8, 4)], [box(8, 0, 12, 4)])), Cover.connected([box(0, 0, 4, 4)], [box(4, 0, 8, 4)], [box(8, 0, 12, 4)])) && Cover.report_ribbons(T.inspect_cells([box(0, 0, 4, 4)], [box(4, 0, 8, 4)], [box(8, 0, 12, 4)])) && Bool.not(Cover.report_connected(T.inspect_cells([box(0, 0, 4, 4)], [box(8, 0, 12, 4)], [box(16, 0, 20, 4)]))) && Bool.not(Cover.report_ribbons(T.inspect_cells([], [box(0, 0, 4, 4)], [box(4, 0, 8, 4)])))

def cases() -> Bool:
  filter_inspection_cases() && cover_arithmetic_cases() && validator_natural_cases() && width_range_cases() && source_convexity_cases() && edge_cases() && sat_cases() && classifier_cases() && source_cases() && filtered_cases() && same(T.segment_search(0n, T.P{0, 0}, T.P{8, 8}, inside_box(), inside_box(), inside_box()), False{}) && T.segment_search(1n, T.P{0, 0}, T.P{8, 8}, inside_box(), inside_box(), inside_box()) && T.segment_search(63n, T.P{0, 0}, T.P{8, 8}, inside_box(), inside_box(), inside_box()) && T.pair_search([T.P{8, 8}], T.P{0, 0}, inside_box(), inside_box(), inside_box()) && T.all_pairs([T.P{0, 0}, T.P{8, 8}], inside_box(), inside_box(), inside_box()) && T.vertex_search([T.P{4, 4}], inside_box(), inside_box(), inside_box()) && same(T.triangle_search([], inside_box(), inside_box(), inside_box()), False{}) && T.triangle_witness(inside_box(), inside_box(), inside_box()) && same(T.triangle_witness(box(0, 0, 2, 2), box(10, 0, 12, 2), box(20, 0, 22, 2)), False{}) && M.quad_envelope(12n, inside_box()) && same(U32.is_gt(M.denominator(T.sample(T.P{0, 0}, T.P{8, 8}, 1)), 0), True{}) && U32.is_eq(M.denominator(T.witness(T.P{4, 4})), 1)

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print("search-witness-tests: " ++ Bool.show(cases()))
