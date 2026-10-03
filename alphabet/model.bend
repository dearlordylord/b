import Base
import ../core.bend as C
import ../validation.bend as V
import ../topology.bend as T

# Local source geometry stays inside the existing guarded arithmetic domain.
# Marks select cells, not arbitrary SVG control points. The existing universal
# LAWS/PROOF apply to C.seam for every selected validated convex cell.
type Arm is Data:
  Arm{sections: List<&2, C.Section>, marks: List<&2, Bool>, component: Nat, parent: Nat, join: C.Point, root: Bool}
type Glyph is Data:
  Glyph{key: Nat, advance: Nat, offset: Nat, components: Nat, holes: Nat, arms: List<&2, Arm>, painting: List<&2, Nat>}

def arm_sections(arm: Arm) -> List<&2, C.Section>:
  match arm:
    case Arm{sections, marks, component, parent, join, root}: sections
def arm_marks(arm: Arm) -> List<&2, Bool>:
  match arm:
    case Arm{sections, marks, component, parent, join, root}: marks
def arm_component(arm: Arm) -> Nat:
  match arm:
    case Arm{sections, marks, component, parent, join, root}: component

def has_cells(sections: List<&2, C.Section>) -> Bool:
  Nat.is_gt(V.section_count(sections), 1n)

def arm_valid(+arm: Arm) -> Bool:
  +sections = arm_sections(arm)
  has_cells(sections) && V.validate(sections) && T.sections_guard(sections) && Nat.is_eq(Nat.add(List.length(&2, Bool, arm_marks(arm)), 1n), V.section_count(sections))

def arms_tail_valid(arms: List<&2, Arm>) -> Bool:
  match arms:
    case Nil{}: True{}
    case Con{h, t}: arm_valid(h) && arms_tail_valid(t)

def arms_valid(arms: List<&2, Arm>) -> Bool:
  match arms:
    case Nil{}: False{}
    case Con{h, t}: arm_valid(h) && arms_tail_valid(t)

def inside_strict(+p: T.Witness, q: T.Quad) -> Bool:
  match q:
    case T.Q{+a, +b, +c, +d}:
      T.positive(T.side(a, b, p)) && T.positive(T.side(b, c, p)) && T.positive(T.side(c, d, p)) && T.positive(T.side(d, a, p))

def contains(xs: List<&2, T.Quad>, +p: T.Witness) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: T.inside(p, h) || contains(t, p)

def interiors(xs: List<&2, T.Quad>, +p: T.Witness) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: inside_strict(p, h) || interiors(t, p)

def all_cells(arms: List<&2, Arm>) -> List<&2, T.Quad>:
  match arms:
    case Nil{}: Nil{}
    case Con{h, t}: List.append(&2, T.Quad, T.cells(arm_sections(h)), all_cells(t))

def parent_valid(parent: Maybe<&2, Arm>, component: Nat, +join: C.Point, own: List<&2, C.Section>) -> Bool:
  match parent:
    case None{}: False{}
    case Some{+arm}: Nat.is_eq(component, arm_component(arm)) && contains(T.cells(own), T.witness(T.scaled(join))) && contains(T.cells(arm_sections(arm)), T.witness(T.scaled(join)))

def attach_guard(guard: Bool, all: List<&2, Arm>, parent: Nat, component: Nat, join: C.Point, own: List<&2, C.Section>) -> Bool:
  match guard:
    case False{}: False{}
    case True{}: parent_valid(List.get(&2, Arm, all, parent), component, join, own)

def attachment(root: Bool, +index: Nat, +parent: Nat, component: Nat, +join: C.Point, own: List<&2, C.Section>, all: List<&2, Arm>) -> Bool:
  match root:
    case True{}: Nat.is_eq(component, index)
    case False{}: attach_guard(Nat.is_lt(parent, index) && T.point_guard(join), all, parent, component, join, own)

def attachment_one(arm: Arm, index: Nat, all: List<&2, Arm>) -> Bool:
  match arm:
    case Arm{sections, marks, component, parent, join, root}: attachment(root, index, parent, component, join, sections, all)

def attachments(arms: List<&2, Arm>, +index: Nat, +all: List<&2, Arm>) -> Bool:
  match arms:
    case Nil{}: True{}
    case Con{h, t}: attachment_one(h, index, all) && attachments(t, Nat.add(index, 1n), all)

def root_number(root: Bool) -> Nat:
  match root:
    case False{}: 0n
    case True{}: 1n

def arm_roots(arm: Arm) -> Nat:
  match arm:
    case Arm{sections, marks, component, parent, join, root}: root_number(root)

def roots(arms: List<&2, Arm>) -> Nat:
  match arms:
    case Nil{}: 0n
    case Con{h, t}: Nat.add(arm_roots(h), roots(t))

def mark_valid(draw: Bool, +cell: C.Cell, +cover: List<&2, T.Quad>) -> Bool:
  match draw:
    case False{}: True{}
    case True{}: Bool.not(interiors(cover, T.witness(T.scaled(C.boundary_left(C.cell_start(cell)))))) && Bool.not(interiors(cover, T.witness(T.scaled(C.boundary_right(C.cell_start(cell))))))

def marks_walk(sections: List<&2, C.Section>, marks: List<&2, Bool>, previous: C.Section, +cover: List<&2, T.Quad>) -> Bool:
  match sections marks:
    case Nil{} Nil{}: True{}
    case Con{+h, t} Con{draw, rest}: mark_valid(draw, C.Cell{previous, h}, cover) && marks_walk(t, rest, h, cover)
    case Nil{} Con{draw, rest}: False{}
    case Con{h, t} Nil{}: False{}

def marks_valid(sections: List<&2, C.Section>, marks: List<&2, Bool>, cover: List<&2, T.Quad>) -> Bool:
  match sections:
    case Nil{}: False{}
    case Con{h, t}: marks_walk(t, marks, h, cover)

def all_marks(arms: List<&2, Arm>, +cover: List<&2, T.Quad>) -> Bool:
  match arms:
    case Nil{}: True{}
    case Con{+h, t}: marks_valid(arm_sections(h), arm_marks(h), cover) && all_marks(t, cover)

def separate_pair(+a: Arm, +b: Arm) -> Bool:
  Nat.is_eq(arm_component(a), arm_component(b)) || Bool.not(T.overlaps(T.cells(arm_sections(a)), T.cells(arm_sections(b))))

def separate_one(+a: Arm, rest: List<&2, Arm>) -> Bool:
  match rest:
    case Nil{}: True{}
    case Con{h, t}: separate_pair(a, h) && separate_one(a, t)

def separate_components(arms: List<&2, Arm>) -> Bool:
  match arms:
    case Nil{}: True{}
    case Con{+h, +t}: separate_one(h, t) && separate_components(t)

def glyph_guard(valid: Bool, +arms: List<&2, Arm>, components: Nat) -> Bool:
  match valid:
    case False{}: False{}
    case True{}: Nat.is_eq(roots(arms), components) && attachments(arms, 0n, arms) && separate_components(arms) && all_marks(arms, all_cells(arms))

def indices(arms: List<&2, Arm>, +index: Nat) -> List<&2, Nat>:
  match arms:
    case Nil{}: Nil{}
    case Con{h, t}: Con{index, indices(t, Nat.add(index, 1n))}

def distinct_from(+index: Nat, rest: List<&2, Nat>) -> Bool:
  match rest:
    case Nil{}: True{}
    case Con{h, t}: Nat.is_ne(index, h) && distinct_from(index, t)

def painting_indices(order: List<&2, Nat>, +count: Nat) -> Bool:
  match order:
    case Nil{}: True{}
    case Con{+h, +t}: Nat.is_lt(h, count) && distinct_from(h, t) && painting_indices(t, count)

def painting_valid(+order: List<&2, Nat>, +arms: List<&2, Arm>) -> Bool:
  Nat.is_eq(List.length(&2, Nat, order), List.length(&2, Arm, arms)) && painting_indices(order, List.length(&2, Arm, arms))

def glyph_valid(glyph: Glyph) -> Bool:
  match glyph:
    case Glyph{key, +advance, offset, components, holes, +arms, painting}:
      glyph_guard(arms_valid(arms), arms, components) && painting_valid(painting, arms) && Nat.is_gt(advance, 0n) && Nat.is_le(advance, 19000n) && Nat.is_le(offset, 3000n)

def valid(glyphs: List<&2, Glyph>) -> Bool:
  match glyphs:
    case Nil{}: True{}
    case Con{h, t}: glyph_valid(h) && valid(t)
