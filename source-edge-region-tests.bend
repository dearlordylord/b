import Base
import ./source-edge-region.bend as M
import ./source-edge-region-laws.bend as L
import ./source-edge-region-proof.bend as Proof
import ./search-admission-fixtures.bend as F
import ./search-membership.bend as Member
import ./intersection-search.bend as Search
import ./quad-geometry.bend as Q
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./natural-cover.bend as N

def all_real_edges_inside() -> {M.all_inside(Search.edges(F.r()),F.r()) == True{} : Bool}: L.quad_edges_inside(F.r(),{==})
def fourth_source_inside() -> {Region.contains(Q.embed(F.c()),F.r()) == True{} : Bool} & {Region.contains(Q.embed(F.d()),F.r()) == True{} : Bool}: L.source_endpoints_inside(F.c(),F.d(),F.r(),Inr{Inr{Inr{Inl{{==}}}}},{==})
def positive_source_mixture() -> {Region.contains(C.join(Q.embed(F.c()),Q.embed(F.d()),2n,6n),F.r()) == True{} : Bool}: L.weighted_source_inside(F.c(),F.d(),F.r(),2n,6n,Inr{Inr{Inr{Inl{{==}}}}},{==})
def zero_first_weight() -> {Region.contains(C.join(Q.embed(F.c()),Q.embed(F.d()),0n,1n),F.r()) == True{} : Bool}: L.weighted_source_inside(F.c(),F.d(),F.r(),0n,1n,Inr{Inr{Inr{Inl{{==}}}}},{==})
