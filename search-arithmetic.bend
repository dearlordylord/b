import Base
import ./topology.bend as T
import ./sample-arithmetic.bend as S
import ./side-bridge.bend as Side

def edge(a: T.Point, b: T.Point, x: Nat, y: Nat, d: Nat) -> Bool:
  Bool.not(Cmp.is_lt(Side.points(a, b, x, y, d)))
def inside_coords(+x: Nat, +y: Nat, +den: Nat, q: T.Quad) -> Bool:
  match q:
    case T.Q{+a, +b, +c, +d}: edge(a, b, x, y, den) && edge(b, c, x, y, den) && edge(c, d, x, y, den) && edge(d, a, x, y, den)
def inside(values: Nat & (Nat & Nat), q: T.Quad) -> Bool:
  match values:
    case (x, (y, d)): inside_coords(x, y, d, q)
def common_coords(+x: Nat, +y: Nat, +d: Nat, a: T.Quad, b: T.Quad, c: T.Quad) -> Bool:
  inside_coords(x, y, d, a) && inside_coords(x, y, d, b) && inside_coords(x, y, d, c)
def common(values: Nat & (Nat & Nat), a: T.Quad, b: T.Quad, c: T.Quad) -> Bool:
  match values:
    case (x, (y, d)): common_coords(x, y, d, a, b, c)
def sample(p: T.Point, q: T.Point, +n: Nat) -> Nat & (Nat & Nat):
  match p q:
    case T.P{x, y} T.P{u, v}: (S.numerator(U32.to_nat(x), U32.to_nat(u), n), (S.numerator(U32.to_nat(y), U32.to_nat(v), n), 64n))
def segment_search(fuel: Nat, +p: T.Point, +q: T.Point, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:
  match fuel:
    case Zero{}: False{}
    case Succ{+n}: common(sample(p, q, Succ{n}), a, b, c) || segment_search(n, p, q, a, b, c)
def pair_search(xs: List<&2, T.Point>, +p: T.Point, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: segment_search(63n, p, h, a, b, c) || pair_search(t, p, a, b, c)
def all_pairs(xs: List<&2, T.Point>, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, +t}: pair_search(t, h, a, b, c) || all_pairs(t, a, b, c)
def vertex_search(xs: List<&2, T.Point>, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: common(S.vertex_values(h), a, b, c) || vertex_search(t, a, b, c)
def triangle_search(+xs: List<&2, T.Point>, +a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:
  vertex_search(xs, a, b, c) || all_pairs(xs, a, b, c)
def triangle_witness(+a: T.Quad, +b: T.Quad, +c: T.Quad) -> Bool:
  triangle_search(List.append(&2, T.Point, T.vertices(a), List.append(&2, T.Point, T.vertices(b), T.vertices(c))), a, b, c)
