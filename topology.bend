import Base
import ./coordinate-limit.bend as Limit
import ./core.bend as Core

# Exact closed convex cover. Homogeneous witnesses have denominator 1 or 64.
# Original coordinates must be divisible by four and <=16000 before scaling.
# Every side of an orientation comparison is <=3*4000*4000*64 < 2^32.
# Witness search is conservative: a missed common intersection rejects input.
# Every accepted triangle clique has an explicit point in all three cells.
# Planar Helly then identifies the nerve with this graph's clique complex.
# Rejecting K5 makes V-E+T-Q its complete Euler characteristic. Together with
# connected ribbons, the convex nerve theorem and planar Euler relation give
# one component and two holes when V+T+1=E+Q. These topological theorems are
# a mathematical interpretation, not Bend theorems over a real-number type.
type Point is Data:
  P{x: U32, y: U32}
type Witness is Data:
  W{x: U32, y: U32, d: U32}
type Quad is Data:
  Q{a: Point, b: Point, c: Point, d: Point}
type CliqueCounts is Data:
  CC{edges: Nat, triangles: Nat, tetrahedra: Nat, witnessed: Bool, no_five: Bool}
type Counts is Data:
  Counts{vertices: Nat, edges: Nat, triangles: Nat, tetrahedra: Nat, connected: Bool, witnessed: Bool, no_five: Bool, ribbons: Bool}

def point_guard(p: Core.Point) -> Bool:
  match p:
    case Core.Pt{+x, +y}:
      Nat.is_le(x, Limit.maximum()) && Nat.is_le(y, Limit.maximum()) && Nat.is_eq(Nat.mod(x, 4n), 0n) && Nat.is_eq(Nat.mod(y, 4n), 0n)
def sections_guard(xs: List<&2, Core.Section>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{+h, t}: point_guard(Core.boundary_left(h)) && point_guard(Core.boundary_right(h)) && sections_guard(t)
def scaled(p: Core.Point) -> Point:
  match p:
    case Core.Pt{x, y}: P{U32.div(U32.from_nat(x), 4), U32.div(U32.from_nat(y), 4)}
def witness(p: Point) -> Witness:
  match p:
    case P{x, y}: W{x, y, 1}
def side(a: Point, b: Point, w: Witness) -> Cmp:
  match a b w:
    case P{+ax, +ay} P{+bx, +by} W{+x, +y, +d}:
      U32.cmp((ax * by * d + bx * y + x * ay : U32), (ay * bx * d + by * x + y * ax : U32))
def nonnegative(c: Cmp) -> Bool:
  match c:
    case LT{}: False{}
    case EQ{}: True{}
    case GT{}: True{}
def negative(c: Cmp) -> Bool:
  match c:
    case LT{}: True{}
    case EQ{}: False{}
    case GT{}: False{}
def positive(c: Cmp) -> Bool:
  match c:
    case LT{}: False{}
    case EQ{}: False{}
    case GT{}: True{}
def inside(+w: Witness, q: Quad) -> Bool:
  match q:
    case Q{+a, +b, +c, +d}:
      nonnegative(side(a, b, w)) && nonnegative(side(b, c, w)) && nonnegative(side(c, d, w)) && nonnegative(side(d, a, w))
def strictly_convex(q: Quad) -> Bool:
  match q:
    case Q{+a, +b, +c, +d}:
      positive(side(a, b, witness(c))) && positive(side(b, c, witness(d))) && positive(side(c, d, witness(a))) && positive(side(d, a, witness(b)))
def reverse(q: Quad) -> Quad:
  match q:
    case Q{a, b, c, d}: Q{d, c, b, a}
def orient(sign: Bool, q: Quad) -> Quad:
  match sign:
    case False{}: reverse(q)
    case True{}: q
def raw_cell(+a: Core.Section, +b: Core.Section) -> Quad:
  Q{scaled(Core.boundary_left(a)), scaled(Core.boundary_left(b)), scaled(Core.boundary_right(b)), scaled(Core.boundary_right(a))}
def orientation(q: Quad) -> Bool:
  match q:
    case Q{a, b, c, d}: positive(side(a, b, witness(c)))
def cells_walk(xs: List<&2, Core.Section>, previous: Core.Section, +sign: Bool) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{+h, t}: Con{orient(sign, raw_cell(previous, h)), cells_walk(t, h, sign)}
def cells_tail(xs: List<&2, Core.Section>, +first: Core.Section) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{+h, +t}: cells_walk(Con{h, t}, first, orientation(raw_cell(first, h)))
def cells(xs: List<&2, Core.Section>) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{h, t}: cells_tail(t, h)

def separated(+a: Point, +b: Point, q: Quad) -> Bool:
  match q:
    case Q{p, q, r, s}:
      negative(side(a, b, witness(p))) && negative(side(a, b, witness(q))) && negative(side(a, b, witness(r))) && negative(side(a, b, witness(s)))
def outside(q: Quad, +r: Quad) -> Bool:
  match q:
    case Q{+a, +b, +c, +d}:
      separated(a, b, r) || separated(b, c, r) || separated(c, d, r) || separated(d, a, r)
def meets(+q: Quad, +r: Quad) -> Bool:
  Bool.not(outside(q, r) || outside(r, q))
def disjoint_all(+q: Quad, xs: List<&2, Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: Bool.not(meets(q, h)) && disjoint_all(q, t)
def disjoint_nonadjacent(q: Quad, xs: List<&2, Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: disjoint_all(q, t)
def point_equal(a: Point, b: Point) -> Bool:
  match a b:
    case P{x, y} P{u, v}: U32.is_eq(x, u) && U32.is_eq(y, v)
def reverse_edge(+a: Point, +b: Point, q: Quad) -> Bool:
  match q:
    case Q{+p, +q, +r, +s}:
      (point_equal(a, q) && point_equal(b, p)) || (point_equal(a, r) && point_equal(b, q)) || (point_equal(a, s) && point_equal(b, r)) || (point_equal(a, p) && point_equal(b, s))
def shared_edge(q: Quad, +r: Quad) -> Bool:
  match q:
    case Q{+a, +b, +c, +d}:
      reverse_edge(a, b, r) || reverse_edge(b, c, r) || reverse_edge(c, d, r) || reverse_edge(d, a, r)
def adjacent(q: Quad, xs: List<&2, Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{h, t}: shared_edge(q, h)
def ribbon_walk(xs: List<&2, Quad>) -> Bool:
  match xs:
    case Nil{}: True{}
    case Con{+h, +t}: strictly_convex(h) && adjacent(h, t) && disjoint_nonadjacent(h, t) && ribbon_walk(t)
def ribbon(+xs: List<&2, Quad>) -> Bool:
  Bool.not(List.is_empty(&2, Quad, xs)) && ribbon_walk(xs)
def overlaps_one(+q: Quad, xs: List<&2, Quad>) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: meets(q, h) || overlaps_one(q, t)
def overlaps(xs: List<&2, Quad>, +ys: List<&2, Quad>) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: overlaps_one(h, ys) || overlaps(t, ys)
def connected_edges(+ab: Bool, +ac: Bool, +bc: Bool) -> Bool:
  (ab && ac) || (ab && bc) || (ac && bc)

def vertices(q: Quad) -> List<&2, Point>:
  match q:
    case Q{a, b, c, d}: [a, b, c, d]
def common(+w: Witness, a: Quad, b: Quad, c: Quad) -> Bool:
  inside(w, a) && inside(w, b) && inside(w, c)
def vertex_search(xs: List<&2, Point>, +a: Quad, +b: Quad, +c: Quad) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: common(witness(h), a, b, c) || vertex_search(t, a, b, c)
def sample(p: Point, q: Point, +n: U32) -> Witness:
  match p q:
    case P{x, y} P{u, v}:
      +m = U32.sub(64, n)
      W{(x * m + u * n : U32), (y * m + v * n : U32), 64}
def segment_search(fuel: Nat, +p: Point, +q: Point, +a: Quad, +b: Quad, +c: Quad) -> Bool:
  match fuel:
    case Zero{}: False{}
    case Succ{+n}: common(sample(p, q, U32.from_nat(Succ{n})), a, b, c) || segment_search(n, p, q, a, b, c)
def pair_search(xs: List<&2, Point>, +p: Point, +a: Quad, +b: Quad, +c: Quad) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, t}: segment_search(63n, p, h, a, b, c) || pair_search(t, p, a, b, c)
def all_pairs(xs: List<&2, Point>, +a: Quad, +b: Quad, +c: Quad) -> Bool:
  match xs:
    case Nil{}: False{}
    case Con{h, +t}: pair_search(t, h, a, b, c) || all_pairs(t, a, b, c)
def triangle_search(+points: List<&2, Point>, +a: Quad, +b: Quad, +c: Quad) -> Bool:
  vertex_search(points, a, b, c) || all_pairs(points, a, b, c)
def triangle_witness(+a: Quad, +b: Quad, +c: Quad) -> Bool:
  triangle_search(List.append(&2, Point, vertices(a), List.append(&2, Point, vertices(b), vertices(c))), a, b, c)

def keep(hit: Bool, q: Quad, rest: List<&2, Quad>) -> List<&2, Quad>:
  match hit:
    case False{}: rest
    case True{}: Con{q, rest}
def neighbors(+q: Quad, xs: List<&2, Quad>) -> List<&2, Quad>:
  match xs:
    case Nil{}: Nil{}
    case Con{+h, t}: keep(meets(q, h), h, neighbors(q, t))
def empty_counts() -> CliqueCounts:
  CC{0n, 0n, 0n, True{}, True{}}
def sum_counts(a: CliqueCounts, b: CliqueCounts) -> CliqueCounts:
  match a b:
    case CC{e, t, q, w, f} CC{ee, tt, qq, ww, ff}:
      CC{Nat.add(e, ee), Nat.add(t, tt), Nat.add(q, qq), w && ww, f && ff}
def fourth_step(no_five: Bool) -> CliqueCounts:
  CC{0n, 0n, 1n, True{}, no_five}
def fourth(xs: List<&2, Quad>) -> CliqueCounts:
  match xs:
    case Nil{}: empty_counts()
    case Con{h, +t}:
      sum_counts(fourth_step(List.is_empty(&2, Quad, neighbors(h, t))), fourth(t))
def third_step(w: Bool, rest: CliqueCounts) -> CliqueCounts:
  sum_counts(CC{0n, 1n, 0n, w, True{}}, rest)
def third(xs: List<&2, Quad>, +a: Quad, +b: Quad) -> CliqueCounts:
  match xs:
    case Nil{}: empty_counts()
    case Con{+h, +t}:
      sum_counts(third_step(triangle_witness(a, b, h), fourth(neighbors(h, t))), third(t, a, b))
def second(xs: List<&2, Quad>, +a: Quad) -> CliqueCounts:
  match xs:
    case Nil{}: empty_counts()
    case Con{+h, +t}:
      sum_counts(CC{1n, 0n, 0n, True{}, True{}}, sum_counts(third(neighbors(h, t), a, h), second(t, a)))
def first(xs: List<&2, Quad>) -> CliqueCounts:
  match xs:
    case Nil{}: empty_counts()
    case Con{+h, +t}: sum_counts(second(neighbors(h, t), h), first(t))
def assemble(v: Nat, cc: CliqueCounts, connected: Bool, ribbons: Bool) -> Counts:
  match cc:
    case CC{e, t, q, w, f}: Counts{v, e, t, q, connected, w, f, ribbons}
def inspect_cells(+a: List<&2, Quad>, +b: List<&2, Quad>, +c: List<&2, Quad>) -> Counts:
  +all = List.append(&2, Quad, a, List.append(&2, Quad, b, c))
  assemble(List.length(&2, Quad, all), first(all), connected_edges(overlaps(a, b), overlaps(a, c), overlaps(b, c)), ribbon(a) && ribbon(b) && ribbon(c))
def inspect_guard(guard: Bool, a: List<&2, Core.Section>, b: List<&2, Core.Section>, c: List<&2, Core.Section>) -> Counts:
  match guard:
    case False{}: Counts{0n, 0n, 0n, 0n, False{}, False{}, False{}, False{}}
    case True{}: inspect_cells(cells(a), cells(b), cells(c))
def inspect(+a: List<&2, Core.Section>, +b: List<&2, Core.Section>, +c: List<&2, Core.Section>) -> Counts:
  inspect_guard(sections_guard(a) && sections_guard(b) && sections_guard(c), a, b, c)
def counts_valid(c: Counts) -> Bool:
  match c:
    case Counts{+v, e, t, q, connected, witnessed, no_five, ribbons}:
      connected && (witnessed && (no_five && (ribbons && (Nat.is_gt(v, 0n) && Nat.is_eq(Nat.add(Nat.add(v, t), 1n), Nat.add(e, q))))))
def valid(a: List<&2, Core.Section>, b: List<&2, Core.Section>, c: List<&2, Core.Section>) -> Bool:
  counts_valid(inspect(a, b, c))
