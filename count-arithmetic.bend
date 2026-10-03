import Base
import ./topology.bend as T
import ./cover-arithmetic.bend as Cover
import ./search-arithmetic.bend as Search

def fourth(xs: List<&2, T.Quad>) -> T.CliqueCounts:
  match xs:
    case Nil{}: T.empty_counts()
    case Con{h, +t}: T.sum_counts(T.fourth_step(List.is_empty(&2, T.Quad, Cover.neighbors(h, t))), fourth(t))
def third(xs: List<&2, T.Quad>, +a: T.Quad, +b: T.Quad) -> T.CliqueCounts:
  match xs:
    case Nil{}: T.empty_counts()
    case Con{+h, +t}: T.sum_counts(T.third_step(Search.triangle_witness(a, b, h), fourth(Cover.neighbors(h, t))), third(t, a, b))
def second(xs: List<&2, T.Quad>, +a: T.Quad) -> T.CliqueCounts:
  match xs:
    case Nil{}: T.empty_counts()
    case Con{+h, +t}: T.sum_counts(T.CC{1n, 0n, 0n, True{}, True{}}, T.sum_counts(third(Cover.neighbors(h, t), a, h), second(t, a)))
def first(xs: List<&2, T.Quad>) -> T.CliqueCounts:
  match xs:
    case Nil{}: T.empty_counts()
    case Con{+h, +t}: T.sum_counts(second(Cover.neighbors(h, t), h), first(t))
def inspect_cells(+a: List<&2, T.Quad>, +b: List<&2, T.Quad>, +c: List<&2, T.Quad>) -> T.Counts:
  +all = List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))
  T.assemble(List.length(&2, T.Quad, all), first(all), Cover.connected(a, b, c), Cover.ribbons(a, b, c))
