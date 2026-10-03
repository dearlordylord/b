import Base
import ./corner-candidate.bend as M
import ./corner-candidate-laws.bend as L
import ./corner-candidate-proof.bend as Proof
import ./candidate-existence.bend as E
import ./intersection-search.bend as S
import ./natural-cover.bend as N

import ./corner-candidate-fixtures.bend as F

def right_contained() -> E.Witness(S.candidates(F.box(),F.small_a()),F.box(),F.small_a()):
  L.contained_corner_witness_right(F.box(),F.small_a(),{==},{==})
