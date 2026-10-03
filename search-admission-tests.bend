import Base
import ./search-admission-laws.bend as L
import ./search-admission-proof.bend as Proof
import ./search-admission-fixtures.bend as F
import ./candidate-existence.bend as E
import ./intersection-search.bend as Search
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N

def boundary_actual_hit() -> E.Witness(Search.candidates(F.q(),F.r()),F.q(),F.r()): L.boundary_search_witness(F.a(),F.b(),F.c(),F.d(),F.q(),F.r(),F.point(),Inl{{==}},Inr{Inr{Inr{Inl{{==}}}}},{==},{==},{==},{==},{==})
def reverse_boundary_hit() -> E.Witness(Search.candidates(F.wide_q(),F.r()),F.wide_q(),F.r()): L.boundary_search_witness(F.a(),N.P{5n,1n},F.right_low(),F.right_high(),F.wide_q(),F.r(),F.right_point(),Inl{{==}},Inr{Inl{{==}}},{==},{==},{==},{==},{==})
def tail_candidate_hit() -> E.Witness([G.P{0n,0n,0n},F.point()],F.q(),F.r()): L.occurs_witness(F.point(),[G.P{0n,0n,0n},F.point()],F.q(),F.r(),Inr{Inl{{==}}},{==})
def scaled_admission() -> {Search.admit(F.point(),F.q(),F.r()) == Search.admit(G.P{16n,8n,8n},F.q(),F.r()) : Bool}: L.equivalent_admission(F.point(),G.P{16n,8n,8n},F.q(),F.r(),{==},{==},{==})
