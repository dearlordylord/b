import Base
import ./core.bend as C
import ./topology.bend as T
import ./search-witness.bend as M

def section_guard(+s: C.Section) -> Bool:
  T.point_guard(C.boundary_left(s)) && T.point_guard(C.boundary_right(s))

def envelope(+width: Nat, xs: List<&2, T.Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: M.quad_envelope(width, h) && envelope(width, t)
