import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./intersection-search.bend as S

def box() -> N.Quad:
  N.Q{N.P{0n, 0n}, N.P{2n, 0n}, N.P{2n, 2n}, N.P{0n, 2n}}
# The first corner is accepted, rather than an arbitrary later candidate.
law first_corner:
  {S.find(box(), box()) == S.Hit{G.P{0n, 0n, 1n}} : S.SearchResult}
def first_corner():
  {==}
# A zero denominator cannot be an accepted geometric witness.
law invalid_denominator:
  {S.scan([G.P{0n, 0n, 0n}], box(), box()) == S.Miss{} : S.SearchResult}
def invalid_denominator():
  {==}
# Reject an exterior point and preserve the first accepted successor.
law skip_exterior:
  {S.scan([G.P{3n, 3n, 1n}, G.P{1n, 1n, 1n}, G.P{2n, 2n, 1n}], box(), box()) == S.Hit{G.P{1n, 1n, 1n}} : S.SearchResult}
def skip_exterior():
  {==}
# Both sign orientations produce the same rational intersection.
law reverse_cut:
  {S.cut_branch(N.P{0n, 1n}, N.P{2n, 1n}, G.P{1n, 0n, 1n}, G.P{1n, 2n, 1n}, False{}, True{}) == [G.P{4n, 4n, 4n}] : List<&2, G.Point>}
def reverse_cut():
  {==}

def distant() -> N.Quad:
  N.Q{N.P{3n, 0n}, N.P{5n, 0n}, N.P{5n, 2n}, N.P{3n, 2n}}
law disjoint_boxes:
  {S.find(box(), distant()) == S.Miss{} : S.SearchResult}
def disjoint_boxes():
  {==}
# Closed boundaries retain a single shared vertex as a valid witness.
def diagonal_box() -> N.Quad:
  N.Q{N.P{2n, 2n}, N.P{4n, 2n}, N.P{4n, 4n}, N.P{2n, 4n}}
law vertex_contact:
  {S.find(box(), diagonal_box()) == S.Hit{G.P{2n, 2n, 1n}} : S.SearchResult}
def vertex_contact():
  {==}
