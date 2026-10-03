import Base
import ./source-edge-region.bend as M
import ./search-admission-fixtures.bend as F
import ./intersection-search.bend as Search
import ./homogeneous-combination.bend as C
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./natural-cover.bend as N

def outside_edge_rejected() -> {M.edge_inside(Search.E{N.P{9n,9n},F.c()},F.r()) == False{} : Bool}: {==}
def clockwise_all_edges_rejected() -> {M.all_inside(Search.edges(F.reversed_r()),F.reversed_r()) == False{} : Bool}: {==}
def zero_mixture_invalid() -> {G.positive_denominator(C.join(Q.embed(F.c()),Q.embed(F.d()),0n,0n)) == False{} : Bool}: {==}
