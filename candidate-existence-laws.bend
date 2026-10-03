import Base
import ./candidate-existence.bend as M
import ./intersection-search.bend as S
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G

# List-level completeness and soundness, with no geometry assumptions.
law scan_found_exact:
  for +xs:List<&2,G.Point>
  for +q:N.Quad
  for +r:N.Quad
  {M.found(S.scan(xs,q,r)) == M.any_valid(xs,q,r) : Bool}
# A true list predicate constructs the actual returned rational witness.
law valid_candidate_witness:
  for +xs:List<&2,G.Point>
  for +q:N.Quad
  for +r:N.Quad
  for h:{M.any_valid(xs,q,r) == True{} : Bool}
  M.Witness(xs,q,r)
# Public geometry search inherits the exact list-level decision.
law find_found_exact:
  for +q:N.Quad
  for +r:N.Quad
  {M.found(S.find(q,r)) == M.any_valid(S.candidates(q,r),q,r) : Bool}
# Candidate groups may be assembled without losing existence information.
law any_append:
  for +xs:List<&2,G.Point>
  for +ys:List<&2,G.Point>
  for +q:N.Quad
  for +r:N.Quad
  {M.any_valid(List.append(&2,G.Point,xs,ys),q,r) == Bool.or(M.any_valid(xs,q,r),M.any_valid(ys,q,r)) : Bool}
# An actual Miss certifies absence of acceptable points in this list only.
law miss_no_valid_candidate:
  for +xs:List<&2,G.Point>
  for +q:N.Quad
  for +r:N.Quad
  for h:{S.scan(xs,q,r) == S.Miss{} : S.SearchResult}
  {M.any_valid(xs,q,r) == False{} : Bool}
