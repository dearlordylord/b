import Base
import ./retained-witness-laws.bend as L
import ./retained-witness-proof.bend as Proof
import ./tracked-interval.bend as Trace
import ./tracked-interval-fixtures.bend as F
import ./intersection-search.bend as Search
import ./candidate-existence.bend as E
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

def c() -> N.Point: N.P{0n,2n}
def d() -> N.Point: N.P{4n,2n}
def source() -> N.Quad: N.Q{c(),d(),N.P{4n,4n},N.P{0n,4n}}
def actual_left_witness() -> E.Witness(Search.candidates(F.box(),source()),F.box(),source()):
  L.left_boundary_witness(N.P{3n,1n},N.P{3n,3n},c(),d(),F.box(),source(),2n,6n,Trace.End{36n,12n,Trace.Boundary{N.P{1n,3n},N.P{1n,1n}}},Inl{{==}},{==},{==})
def actual_right_witness() -> E.Witness(Search.candidates(F.box(),source()),F.box(),source()):
  L.right_boundary_witness(N.P{1n,3n},N.P{1n,1n},c(),d(),F.box(),source(),36n,12n,Trace.End{2n,6n,Trace.Boundary{N.P{3n,1n},N.P{3n,3n}}},Inl{{==}},{==},{==})

def two_cut_search_witness() -> E.Witness(Search.candidates(F.box(),source()),F.box(),source()):
  L.clipped_source_witness(c(),d(),F.box(),source(),Inl{{==}},{==},{==})
def enclosing() -> N.Quad: N.Q{N.P{0n,0n},N.P{5n,0n},N.P{5n,5n},N.P{0n,5n}}
def source_left_search_witness() -> E.Witness(Search.candidates(enclosing(),source()),enclosing(),source()):
  L.clipped_source_witness(c(),d(),enclosing(),source(),Inl{{==}},{==},{==})
def right_box() -> N.Quad: N.Q{N.P{3n,1n},N.P{5n,1n},N.P{5n,3n},N.P{3n,3n}}
def source_right_search_witness() -> E.Witness(Search.candidates(right_box(),source()),right_box(),source()):
  L.clipped_source_witness(c(),d(),right_box(),source(),Inl{{==}},{==},{==})

def common_source_point_witness() -> E.Witness(Search.candidates(F.box(),source()),F.box(),source()):
  L.source_member_witness(c(),d(),F.box(),source(),G.P{2n,2n,1n},Inl{{==}},{==},(1n,(1n,({==},({==},({==},({==},{==})))))),{==})
