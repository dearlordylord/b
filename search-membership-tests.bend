import Base
import ./search-membership.bend as M
import ./search-membership-laws.bend as L
import ./search-membership-proof.bend as Proof
import ./intersection-search.bend as Search
import ./interval-walk.bend as Walk
import ./tracked-origin.bend as Origin
import ./tracked-origin-laws.bend as OriginL
import ./tracked-origin-proof.bend as OriginProof
import ./tracked-interval.bend as Trace
import ./source-boundary.bend as Boundary
import ./quad-geometry.bend as Q
import ./natural-cover.bend as N

def a() -> N.Point: N.P{1n,1n}
def b() -> N.Point: N.P{3n,1n}
def c() -> N.Point: N.P{2n,4n}
def d() -> N.Point: N.P{2n,0n}
def q() -> N.Quad: N.Q{a(),b(),N.P{3n,3n},N.P{1n,3n}}
def r() -> N.Quad: N.Q{d(),N.P{4n,0n},N.P{4n,4n},c()}
def reversed_r() -> N.Quad: N.Q{d(),c(),N.P{4n,4n},N.P{4n,0n}}
def bottom_occurs() -> M.EdgeOccurs(Search.E{a(),b()},Search.edges(q())): Inl{{==}}
def fourth_source_occurs() -> M.EdgeOccurs(Search.E{c(),d()},Search.edges(r())): Inr{Inr{Inr{Inl{{==}}}}}
def actual_candidate() -> M.PointOccurs(Boundary.direct(a(),b(),Q.embed(c()),Q.embed(d())),Search.candidates(q(),r())): L.candidate_member(a(),b(),c(),d(),q(),r(),bottom_occurs(),fourth_source_occurs(),{==})
def reverse_candidate() -> M.PointOccurs(Boundary.direct(a(),b(),Q.embed(d()),Q.embed(c())),Search.candidates(q(),reversed_r())): L.candidate_member(a(),b(),d(),c(),q(),reversed_r(),bottom_occurs(),Inl{{==}},{==})
def converted_second_edge() -> M.EdgeOccurs(M.convert(Walk.Halfplane{b(),N.P{3n,3n}}),M.converted(Walk.quad_edges(q()))): L.converted_occurrence(Walk.Halfplane{b(),N.P{3n,3n}},Walk.quad_edges(q()),Inr{Inl{{==}}})
def boundary_contact_candidate() -> M.PointOccurs(Boundary.direct(a(),b(),Q.embed(N.P{2n,1n}),Q.embed(d())),Search.edge_cut(Search.E{a(),b()},Search.E{N.P{2n,1n},d()})): L.edge_cut(a(),b(),N.P{2n,1n},d(),{==})

def cut_occurrence() -> Origin.Occurs(Walk.Halfplane{a(),b()},Walk.quad_edges(q())): OriginL.cut_allowed(Walk.quad_edges(q()),a(),b(),Q.embed(c()),Q.embed(d()),Trace.End{1n,0n,Trace.SourceLeft{}},Trace.End{0n,1n,Trace.SourceRight{}},Inl{{==}})
def actual_origin_candidate() -> M.PointOccurs(Boundary.direct(a(),b(),Q.embed(c()),Q.embed(d())),Search.candidates(q(),r())): L.boundary_from_origin(a(),b(),c(),d(),q(),r(),cut_occurrence(),fourth_source_occurs(),{==})

def source_vertices_0() -> M.PointOccurs(Q.embed(a()),Search.vertices(q())) & M.PointOccurs(Q.embed(b()),Search.vertices(q())): L.source_edge_vertices(a(),b(),q(),Inl{{==}})

def source_vertices_1() -> M.PointOccurs(Q.embed(b()),Search.vertices(q())) & M.PointOccurs(Q.embed(N.P{3n,3n}),Search.vertices(q())): L.source_edge_vertices(b(),N.P{3n,3n},q(),Inr{Inl{{==}}})

def source_vertices_2() -> M.PointOccurs(Q.embed(N.P{3n,3n}),Search.vertices(q())) & M.PointOccurs(Q.embed(N.P{1n,3n}),Search.vertices(q())): L.source_edge_vertices(N.P{3n,3n},N.P{1n,3n},q(),Inr{Inr{Inl{{==}}}})

def source_vertices_3() -> M.PointOccurs(Q.embed(N.P{1n,3n}),Search.vertices(q())) & M.PointOccurs(Q.embed(a()),Search.vertices(q())): L.source_edge_vertices(N.P{1n,3n},a(),q(),Inr{Inr{Inr{Inl{{==}}}}})
