import Base
import ./corner-candidate.bend as M
import ./natural-cover.bend as N
import ./quad-geometry.bend as Q
import ./candidate-existence.bend as E
import ./intersection-search.bend as S
import ./quad-intersection.bend as I

# Strict orientation proves each embedded corner valid in its own region.
law corner_admission_exact:
  for +q:N.Quad
  for +r:N.Quad
  for hq:{Q.strict_quad(q) == True{} : Bool}
  {E.any_valid(S.vertices(q),q,r) == M.inside_other(q,r) : Bool}
# A contained corner forces a hit in the actual full candidate search.
law contained_corner_witness:
  for +q:N.Quad
  for +r:N.Quad
  for hq:{Q.strict_quad(q) == True{} : Bool}
  for h:{M.inside_other(q,r) == True{} : Bool}
  E.Witness(S.candidates(q,r),q,r)
# With both quads strict, the selected hit supplies actual hull weights.
law contained_corner_common:
  for +q:N.Quad
  for +r:N.Quad
  for +hq:{Q.strict_quad(q) == True{} : Bool}
  for hr:{Q.strict_quad(r) == True{} : Bool}
  for h:{M.inside_other(q,r) == True{} : Bool}
  I.CommonPoint(q,r)
law contained_corner_witness_right:
  for +q:N.Quad
  for +r:N.Quad
  for hr:{Q.strict_quad(r) == True{} : Bool}
  for h:{M.inside_other(r,q) == True{} : Bool}
  E.Witness(S.candidates(q,r),q,r)
