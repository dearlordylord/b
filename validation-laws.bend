import Base
import ./core.bend as C
import ./validation.bend as V

# Independent structural predicate: each adjacent pair has the scalar cell
# checks, with a witness for every pair rather than a Boolean fold result.
# These laws prove traversal/guard correctness; scalar U32 predicates themselves
# are primitives here, not an asserted proof of their Nat arithmetic meaning.
def CellConditions(+cell: C.Cell) -> Type:
  {V.cell_convex(cell) == True{} : Bool} &
  ({V.cell_centroid_exact(cell) == True{} : Bool} &
  ({V.cell_endpoints_exact(cell) == True{} : Bool} &
  ({V.cell_transverse(cell) == True{} : Bool} &
  ({V.section_width(C.cell_start(cell)) == True{} : Bool} &
   {V.section_width(C.cell_finish(cell)) == True{} : Bool}))))

def AdjacentConditions(sections: List<&2, C.Section>, previous: C.Section) -> Type:
  match sections:
    case Nil{}:
      Unit
    case Con{+h, t}:
      CellConditions(C.Cell{previous, h}) & AdjacentConditions(t, h)

def NonemptyConditions(sections: List<&2, C.Section>) -> Type:
  match sections:
    case Nil{}:
      Empty
    case Con{+h, t}:
      {V.section_width(h) == True{} : Bool} & AdjacentConditions(t, h)

# Every boundary point is bounded, witnessed independently at each section.
def BoundedPoints(sections: List<&2, C.Section>) -> Type:
  match sections:
    case Nil{}:
      Unit
    case Con{+h, t}:
      {V.point_bounded(C.boundary_left(h)) == True{} : Bool} &
      ({V.point_bounded(C.boundary_right(h)) == True{} : Bool} & BoundedPoints(t))

def TubeConditions(+sections: List<&2, C.Section>) -> Type:
  BoundedPoints(sections) & NonemptyConditions(sections)

# Acceptance implies all section and consecutive-cell conditions, for arbitrary
# length, including the rejection of the empty tube.
law validator_sound:
  for +sections: List<&2, C.Section>
  for accepted: {V.validate(sections) == True{} : Bool}
  TubeConditions(sections)

# Every bounded nonempty tube satisfying the structural conditions is accepted.
# This rules out a reject-everything validator.
law validator_complete:
  for +sections: List<&2, C.Section>
  for conditions: TubeConditions(sections)
  {V.validate(sections) == True{} : Bool}

# A false bounds gate returns False without calling nonempty_valid, regardless
# of the supplied section geometry. This is a definitional branch guarantee.
law closed_bounds_gate:
  for sections: List<&2, C.Section>
  {V.bounded_valid(False{}, sections) == False{} : Bool}

# The artwork gate also requires precisely 33 cross sections.
law artwork_gate_sound:
  for +sections: List<&2, C.Section>
  for accepted: {V.expected_artwork(sections) == True{} : Bool}
  {V.section_count(sections) == 33n : Nat} & TubeConditions(sections)

# No out-of-bounds list can pass the validator, for arbitrary coordinates.
law validator_rejects_unbounded:
  for +sections: List<&2, C.Section>
  for outside: {V.sections_bounded(sections) == False{} : Bool}
  {V.validate(sections) == False{} : Bool}

# Exactly the requested artwork size plus tube conditions suffice for acceptance.
law artwork_gate_complete:
  for +sections: List<&2, C.Section>
  for count: {V.section_count(sections) == 33n : Nat}
  for conditions: TubeConditions(sections)
  {V.expected_artwork(sections) == True{} : Bool}
