import Base
import ./tracked-candidates.bend as M
import ./tracked-interval.bend as Trace
import ./tracked-interval-fixtures.bend as F
import ./homogeneous-geometry.bend as G

def complete_walk() -> {M.candidates(F.p(),F.q(),Trace.clip_quad(F.p(),F.q(),F.box())) == True{} : Bool}: {==}

def unequal_denominators() -> {M.candidates(G.P{0n,4n,2n},G.P{12n,6n,3n},Trace.clip_quad(G.P{0n,4n,2n},G.P{12n,6n,3n},F.box())) == True{} : Bool}: {==}

# Preserve the original quantified law's validity premises for these fixtures.
def complete_walk_sources_valid() -> {G.positive_denominator(F.p()) && G.positive_denominator(F.q()) == True{} : Bool}: {==}
def fraction_sources_valid() -> {G.positive_denominator(G.P{0n,4n,2n}) && G.positive_denominator(G.P{12n,6n,3n}) == True{} : Bool}: {==}
