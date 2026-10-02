import Base

# Exact coordinates in hundredths of a pixel. The SVG viewBox uses the same units.
type Point is Data:
  Pt{x: Nat, y: Nat}

type Section is Data:
  Section{left: Point, right: Point}

type Cell is Data:
  Cell{start: Section, finish: Section}

type Seam is Data:
  Seam{start: Point, control: Point, end: Point}

def boundary_left(section: Section) -> Point:
  match section:
    case Section{left, right}:
      left

def boundary_right(section: Section) -> Point:
  match section:
    case Section{left, right}:
      right

def cell_start(cell: Cell) -> Section:
  match cell:
    case Cell{start, finish}:
      start

def cell_finish(cell: Cell) -> Section:
  match cell:
    case Cell{start, finish}:
      finish

def point_add(a: Point, b: Point) -> Point:
  match a b:
    case Pt{x, y} Pt{z, w}:
      Pt{Nat.add(x, z), Nat.add(y, w)}

def point_quarter(p: Point) -> Point:
  match p:
    case Pt{x, y}:
      Pt{Nat.div(x, 4n), Nat.div(y, 4n)}

def cell_center(+cell: Cell) -> Point:
  +a = cell_start(cell)
  +b = cell_finish(cell)
  point_quarter(point_add(point_add(boundary_left(a), boundary_right(a)), point_add(boundary_left(b), boundary_right(b))))

def seam(+cell: Cell) -> Seam:
  Seam{boundary_left(cell_start(cell)), cell_center(cell), boundary_right(cell_start(cell))}

def seam_start(s: Seam) -> Point:
  match s:
    case Seam{start, control, end}:
      start

def seam_control(s: Seam) -> Point:
  match s:
    case Seam{start, control, end}:
      control

def seam_end(s: Seam) -> Point:
  match s:
    case Seam{start, control, end}:
      end

def point_svg(p: Point) -> String:
  match p:
    case Pt{x, y}:
      Nat.show(x) ++ " " ++ Nat.show(y)

def section_sum(+s: Section) -> Point:
  point_add(boundary_left(s), boundary_right(s))

def shade_point(+s: Section) -> Point:
  point_quarter(point_add(section_sum(s), point_add(boundary_right(s), boundary_right(s))))

def boundary_forward(sections: List<&2, Section>) -> String:
  match sections:
    case Nil{}:
      ""
    case Con{h, t}:
      " L" ++ point_svg(boundary_left(h)) ++ boundary_forward(t)

def boundary_reverse(sections: List<&2, Section>) -> String:
  match sections:
    case Nil{}:
      ""
    case Con{h, t}:
      boundary_reverse(t) ++ " L" ++ point_svg(boundary_right(h))

def outline_data(sections: List<&2, Section>) -> String:
  match sections:
    case Nil{}:
      ""
    case Con{+h, +t}:
      "M" ++ point_svg(boundary_left(h)) ++ boundary_forward(t) ++ boundary_reverse(Con{h, t}) ++ " Z"

def shade_forward(sections: List<&2, Section>) -> String:
  match sections:
    case Nil{}:
      ""
    case Con{h, t}:
      " L" ++ point_svg(shade_point(h)) ++ shade_forward(t)

def shade_data(sections: List<&2, Section>) -> String:
  match sections:
    case Nil{}:
      ""
    case Con{+h, +t}:
      "M" ++ point_svg(shade_point(h)) ++ shade_forward(t) ++ boundary_reverse(Con{h, t}) ++ " Z"

def seam_data(+s: Seam) -> String:
  "M" ++ point_svg(seam_start(s)) ++ " Q" ++ point_svg(seam_control(s)) ++ " " ++ point_svg(seam_end(s))

def seam_element(id: String, +index: Nat, cell: Cell) -> String:
  "<path id=\"" ++ id ++ "-seam-" ++ Nat.show(index) ++ "\" data-cell=\"" ++ Nat.show(index) ++ "\" d=\"" ++ seam_data(seam(cell)) ++ "\" fill=\"none\" stroke=\"#17272F\" stroke-width=\"150\" stroke-linecap=\"butt\"/>\n"

def selected_seam(draw: Bool, id: String, index: Nat, cell: Cell) -> String:
  match draw:
    case False{}:
      ""
    case True{}:
      seam_element(id, index, cell)

def seam_walk(sections: List<&2, Section>, previous: Section, +index: Nat, +id: String) -> String:
  match sections:
    case Nil{}:
      ""
    case Con{+h, t}:
      selected_seam(Nat.is_eq(Nat.mod(index, 4n), 2n), id, index, Cell{previous, h}) ++ seam_walk(t, h, Nat.add(index, 1n), id)

def seams_svg(sections: List<&2, Section>, id: String) -> String:
  match sections:
    case Nil{}:
      ""
    case Con{h, t}:
      seam_walk(t, h, 0n, id)

def tube_svg(+id: String, +sections: List<&2, Section>) -> String:
  "<g id=\"" ++ id ++ "\">\n" ++ "<path id=\"" ++ id ++ "-fill\" d=\"" ++ outline_data(sections) ++ "\" fill=\"#7593A7\"/>\n" ++ "<path id=\"" ++ id ++ "-shade\" d=\"" ++ shade_data(sections) ++ "\" fill=\"#476579\"/>\n" ++ seams_svg(sections, id) ++ "<path id=\"" ++ id ++ "-outline\" d=\"" ++ outline_data(sections) ++ "\" fill=\"none\" stroke=\"#17272F\" stroke-width=\"280\" stroke-linejoin=\"round\"/>\n</g>\n"
