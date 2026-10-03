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
def neighbors(+q: T.Quad, xs: List<&2, T.Quad>) -> List<&2, T.Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{+h, t}: T.keep(Sat.meets(q, h), h, neighbors(q, t))
def connected(+a: List<&2, T.Quad>, +b: List<&2, T.Quad>, +c: List<&2, T.Quad>) -> Bool:
  T.connected_edges(overlaps(a, b), overlaps(a, c), overlaps(b, c))
def ribbons(a: List<&2, T.Quad>, b: List<&2, T.Quad>, c: List<&2, T.Quad>) -> Bool:
  ribbon(a) && ribbon(b) && ribbon(c)
def report_connected(report: T.Counts) -> Bool:
  match report:
    case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}: connected
def report_ribbons(report: T.Counts) -> Bool:
  match report:
    case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}: ribbons
