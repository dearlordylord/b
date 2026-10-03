import Base
import ./core.bend as C
import ./topology.bend as T
import ./witness-arithmetic.bend as Side

type Point is Data:
  P{x: Nat, y: Nat}
type Quad is Data:
  Q{a: Point, b: Point, c: Point, d: Point}
def decode_point(p: T.Point) -> Point:
  match p:
    case T.P{x, y}: P{U32.to_nat(x), U32.to_nat(y)}
def decode_quad(q: T.Quad) -> Quad:
  match q:
    case T.Q{a, b, c, d}: Q{decode_point(a), decode_point(b), decode_point(c), decode_point(d)}
def decode_cells(xs: List<&2, T.Quad>) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{h, t}: Con{decode_quad(h), decode_cells(t)}
def scaled(p: C.Point) -> Point:
  match p:
    case C.Pt{x, y}: P{Nat.div(x, 4n), Nat.div(y, 4n)}
def raw_cell(+a: C.Section, +b: C.Section) -> Quad:
  Q{scaled(C.boundary_left(a)), scaled(C.boundary_left(b)), scaled(C.boundary_right(b)), scaled(C.boundary_right(a))}
def orientation(q: Quad) -> Bool:
  match q:
    case Q{P{ax, ay}, P{bx, by}, P{cx, cy}, d}: Cmp.is_gt(Side.exact_side(ax, ay, bx, by, cx, cy, 1n))
def reverse(q: Quad) -> Quad:
  match q:
    case Q{a, b, c, d}: Q{d, c, b, a}
def orient(sign: Bool, q: Quad) -> Quad:
  match sign:
    case False{}: reverse(q)
    case True{}: q
def cells_walk(xs: List<&2, C.Section>, previous: C.Section, +sign: Bool) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{+h, t}: Con{orient(sign, raw_cell(previous, h)), cells_walk(t, h, sign)}
def cells_tail(xs: List<&2, C.Section>, +first: C.Section) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{+h, +t}: cells_walk(Con{h, t}, first, orientation(raw_cell(first, h)))
def cells(xs: List<&2, C.Section>) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{h, t}: cells_tail(t, h)
