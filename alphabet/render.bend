import Base
import ../core.bend as C
import ../validation.bend as V
import ./model.bend as M

# SVG's nonzero fill of consistently oriented convex cells is their union.
# Paint borders first, then the full cover: internal cell/arm edges disappear.
# No Shapely outlines, clip masks, float geometry or rounded control points.
def quad_data(positive: Bool, +a: C.Point, +b: C.Point, +c: C.Point, +d: C.Point) -> String:
  match positive:
    case True{}: "M" ++ C.point_svg(a) ++ " L" ++ C.point_svg(b) ++ " L" ++ C.point_svg(c) ++ " L" ++ C.point_svg(d) ++ " Z"
    case False{}: "M" ++ C.point_svg(a) ++ " L" ++ C.point_svg(d) ++ " L" ++ C.point_svg(c) ++ " L" ++ C.point_svg(b) ++ " Z"

def oriented_quad(+a: C.Point, +b: C.Point, +c: C.Point, +d: C.Point) -> String:
  quad_data(V.positive_quad(a, b, c, d), a, b, c, d)

def cell_data(+a: C.Section, +b: C.Section) -> String:
  oriented_quad(C.boundary_left(a), C.boundary_left(b), C.boundary_right(b), C.boundary_right(a))

def shade_cell(+a: C.Section, +b: C.Section) -> String:
  oriented_quad(C.shade_point(a), C.shade_point(b), C.boundary_right(b), C.boundary_right(a))

def choose_cell(shade: Bool, a: C.Section, b: C.Section) -> String:
  match shade:
    case False{}: cell_data(a, b)
    case True{}: shade_cell(a, b)

def cells_data(xs: List<&2, C.Section>, +previous: C.Section, +shade: Bool) -> String:
  match xs:
    case Nil{}: ""
    case Con{+h, t}: choose_cell(shade, previous, h) ++ cells_data(t, h, shade)

def arm_sections_data(xs: List<&2, C.Section>, shade: Bool) -> String:
  match xs:
    case Nil{}: ""
    case Con{h, t}: cells_data(t, h, shade)

def arm_data(arm: M.Arm, shade: Bool) -> String:
  arm_sections_data(M.arm_sections(arm), shade)

def cover_data(arms: List<&2, M.Arm>, +shade: Bool) -> String:
  match arms:
    case Nil{}: ""
    case Con{h, t}: arm_data(h, shade) ++ cover_data(t, shade)

def flag(draw: Bool) -> String:
  match draw:
    case False{}: "0"
    case True{}: "1"

def flags(marks: List<&2, Bool>) -> String:
  match marks:
    case Nil{}: ""
    case Con{h, t}: flag(h) ++ flags(t)

def source(arm: M.Arm, id: String) -> String:
  match arm:
    case M.Arm{sections, marks, component, parent, join, root}:
      "<path id=\"" ++ id ++ "-source\" data-component=\"" ++ Nat.show(component) ++ "\" data-parent=\"" ++ Nat.show(parent) ++ "\" data-root=\"" ++ flag(root) ++ "\" data-join=\"" ++ C.point_svg(join) ++ "\" data-marks=\"" ++ flags(marks) ++ "\" d=\"" ++ C.outline_data(sections) ++ "\" fill=\"none\" stroke=\"none\"/>\n"

def seams_walk(xs: List<&2, C.Section>, marks: List<&2, Bool>, previous: C.Section, +index: Nat, +id: String) -> String:
  match xs marks:
    case Nil{} Nil{}: ""
    case Con{+h, t} Con{draw, rest}: C.selected_seam(draw, id, index, C.Cell{previous, h}) ++ seams_walk(t, rest, h, Nat.add(index, 1n), id)
    case Nil{} Con{draw, rest}: ""
    case Con{h, t} Nil{}: ""

def seams_sections(xs: List<&2, C.Section>, marks: List<&2, Bool>, id: String) -> String:
  match xs:
    case Nil{}: ""
    case Con{h, t}: seams_walk(t, marks, h, 0n, id)

def seams(arm: M.Arm, id: String) -> String:
  match arm:
    case M.Arm{sections, marks, component, parent, join, root}: seams_sections(sections, marks, id)

def sources(arms: List<&2, M.Arm>, +index: Nat, +id: String) -> String:
  match arms:
    case Nil{}: ""
    case Con{h, t}: source(h, id ++ "-arm-" ++ Nat.show(index)) ++ sources(t, Nat.add(index, 1n), id)

def all_seams(arms: List<&2, M.Arm>, +index: Nat, +id: String) -> String:
  match arms:
    case Nil{}: ""
    case Con{h, t}: seams(h, id ++ "-arm-" ++ Nat.show(index)) ++ all_seams(t, Nat.add(index, 1n), id)

def same_section(+a: C.Section, +b: C.Section) -> Bool:
  V.point_equal(C.boundary_left(a), C.boundary_left(b)) && V.point_equal(C.boundary_right(a), C.boundary_right(b))

def closes(xs: List<&2, C.Section>, +first: C.Section, previous: C.Section) -> Bool:
  match xs:
    case Nil{}: same_section(first, previous)
    case Con{+h, t}: closes(t, first, h)

def contour_choice(closed: Bool, +first: C.Section, +rest: List<&2, C.Section>) -> String:
  match closed:
    case False{}: C.outline_data(Con{first, rest})
    case True{}: "M" ++ C.point_svg(C.boundary_left(first)) ++ C.boundary_forward(rest) ++ " Z M" ++ C.point_svg(C.boundary_right(first)) ++ C.boundary_reverse(rest) ++ " Z"

def contour(xs: List<&2, C.Section>) -> String:
  match xs:
    case Nil{}: ""
    case Con{+h, +t}: contour_choice(closes(t, h, h), h, t)

def layered_arm(+arm: M.Arm, +id: String) -> String:
  "<path id=\"" ++ id ++ "-fill\" d=\"" ++ arm_data(arm, False{}) ++ "\" fill=\"#7593A7\" fill-rule=\"nonzero\"/>\n" ++
    "<path id=\"" ++ id ++ "-shade\" d=\"" ++ arm_data(arm, True{}) ++ "\" fill=\"#476579\" fill-rule=\"nonzero\"/>\n" ++ seams(arm, id) ++
    "<path id=\"" ++ id ++ "-outline\" d=\"" ++ contour(M.arm_sections(arm)) ++ "\" fill=\"none\" stroke=\"#17272F\" stroke-width=\"280\" stroke-linejoin=\"round\"/>\n"

def paint_some(arm: Maybe<&2, M.Arm>, id: String) -> String:
  match arm:
    case None{}: ""
    case Some{h}: layered_arm(h, id)

def paint_order(order: List<&2, Nat>, +arms: List<&2, M.Arm>, +id: String) -> String:
  match order:
    case Nil{}: ""
    case Con{+h, t}: paint_some(List.get(&2, M.Arm, arms, h), id ++ "-arm-" ++ Nat.show(h)) ++ paint_order(t, arms, id)

def order_data(order: List<&2, Nat>) -> String:
  match order:
    case Nil{}: ""
    case Con{h, t}: Nat.show(h) ++ " " ++ order_data(t)

def glyph_body(+id: String, +arms: List<&2, M.Arm>) -> String:
  +cover = cover_data(arms, False{})
  sources(arms, 0n, id) ++
    "<path id=\"" ++ id ++ "-border\" d=\"" ++ cover ++ "\" fill=\"#17272F\" fill-rule=\"nonzero\" stroke=\"#17272F\" stroke-width=\"560\" stroke-linejoin=\"round\"/>\n" ++
    "<path id=\"" ++ id ++ "-fill\" d=\"" ++ cover ++ "\" fill=\"#7593A7\" fill-rule=\"nonzero\"/>\n" ++
    "<path id=\"" ++ id ++ "-shade\" d=\"" ++ cover_data(arms, True{}) ++ "\" fill=\"#476579\" fill-rule=\"nonzero\"/>\n" ++
    all_seams(arms, 0n, id)

def body_choice(joined: Bool, +id: String, +arms: List<&2, M.Arm>, painting: List<&2, Nat>) -> String:
  match joined:
    case False{}: sources(arms, 0n, id) ++ paint_order(painting, arms, id)
    case True{}: glyph_body(id, arms)

def glyph(glyph: M.Glyph) -> String:
  match glyph:
    case M.Glyph{+key, advance, +offset, components, holes, arms, +painting}:
      +id = "glyph-" ++ Nat.show(key)
      "<g id=\"" ++ id ++ "\" data-key=\"" ++ Nat.show(key) ++ "\" data-advance=\"" ++ Nat.show(advance) ++ "\" data-offset=\"" ++ Nat.show(offset) ++ "\" data-components=\"" ++ Nat.show(components) ++ "\" data-holes=\"" ++ Nat.show(holes) ++ "\" data-painting=\"" ++ order_data(painting) ++ "\"><g transform=\"translate(0 " ++ Nat.show(offset) ++ ")\">\n" ++ body_choice(Nat.is_eq(key, 97n) || Nat.is_eq(key, 101n), id, arms, painting) ++ "</g></g>\n"

def standalone(+item: M.Glyph) -> String:
  match item:
    case M.Glyph{key, +advance, offset, components, holes, arms, painting}:
      "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"" ++ Nat.show(Nat.div(advance, 100n)) ++ "\" height=\"190\" viewBox=\"0 0 " ++ Nat.show(advance) ++ " 19000\">\n" ++ glyph(item) ++ "</svg>\n"
