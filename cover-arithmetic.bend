import Base
import ./topology.bend as T
import ./sat-arithmetic.bend as Sat
import ./edge-arithmetic.bend as Edge

def disjoint_all(+q: T.Quad, xs: List<&2, T.Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: Bool.not(Sat.meets(q, h)) && disjoint_all(q, t)
def disjoint_nonadjacent(q: T.Quad, xs: List<&2, T.Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: disjoint_all(q, t)
def adjacent(q: T.Quad, xs: List<&2, T.Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: Edge.shared_edge(q, h)
def ribbon_walk(xs: List<&2, T.Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{+h, +t}: Sat.strictly_convex(h) && adjacent(h, t) && disjoint_nonadjacent(h, t) && ribbon_walk(t)
def ribbon(+xs: List<&2, T.Quad>) -> Bool:
  Bool.not(List.is_empty(&2, T.Quad, xs)) && ribbon_walk(xs)
def overlaps_one(+q: T.Quad, xs: List<&2, T.Quad>) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: Sat.meets(q, h) || overlaps_one(q, t)
def overlaps(xs: List<&2, T.Quad>, +ys: List<&2, T.Quad>) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: overlaps_one(h, ys) || overlaps(t, ys)
