import Base
import ./core.bend as Core
import ./topology.bend as T
import ./artwork.bend as Artwork

# Exact integer fixtures. These exercise closed contact, empty triple
# intersection despite pairwise overlap, filled cycles, and the K5 bound.
def box(+x: U32, +y: U32, +u: U32, +v: U32) -> T.Quad:
  T.Q{T.P{x, y}, T.P{u, y}, T.P{u, v}, T.P{x, v}}
def empty_triangle() -> Bool:
  +a = box(0, 0, 10, 2)
  +b = box(0, 0, 2, 10)
  +c: T.Quad = T.Q{T.P{0, 8}, T.P{8, 0}, T.P{10, 0}, T.P{0, 10}}
  T.meets(a, b) && T.meets(a, c) && T.meets(b, c) && Bool.not(T.triangle_witness(a, b, c)) && Bool.not(T.counts_valid(T.inspect_cells([a], [b], [c])))
def filled_triangle() -> Bool:
  +a = box(0, 0, 8, 8)
  T.triangle_witness(a, a, a) && Bool.not(T.counts_valid(T.inspect_cells([a], [a], [a])))
def disconnected() -> Bool:
  Bool.not(T.counts_valid(T.inspect_cells([box(0, 0, 4, 4)], [box(8, 0, 12, 4)], [box(16, 0, 20, 4)])))
def no_five(c: T.CliqueCounts) -> Bool:
  match c:
    case T.CC{e, t, q, w, f}: f
def five_clique() -> Bool:
  +a = box(0, 0, 8, 8)
  Bool.not(no_five(T.first([a, a, a, a, a])))
def touching() -> Bool:
  +a = box(0, 0, 4, 4)
  T.meets(a, box(4, 4, 8, 8)) && Bool.not(T.meets(a, box(5, 5, 9, 9)))
def guards() -> Bool:
  Bool.not(T.point_guard(Core.Pt{1n, 4n})) && Bool.not(T.point_guard(Core.Pt{16004n, 4n})) && T.point_guard(Core.Pt{16000n, 0n})
def bad_ribbons() -> Bool:
  +a = box(0, 0, 8, 8)
  Bool.not(T.ribbon([a, a, a])) && Bool.not(T.ribbon([T.reverse(a)])) && Bool.not(T.ribbon([])) && Bool.not(T.ribbon([a, box(12, 0, 16, 4)])) && T.ribbon([box(0, 0, 4, 4), box(4, 0, 8, 4)])
def expected(c: T.Counts) -> Bool:
  match c:
    case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}:
      Nat.is_eq(v, 96n) && Nat.is_eq(e, 146n) && Nat.is_eq(t, 64n) && Nat.is_eq(q, 15n) && connected && witnessed && no_five && ribbons
def tests() -> Bool:
  +actual = T.inspect(Artwork.upper(), Artwork.lower(), Artwork.stem())
  expected(actual) && T.counts_valid(actual) && empty_triangle() && filled_triangle() && disconnected() && five_clique() && touching() && guards() && bad_ribbons()
def main() -> IO(Unit):
  do IO<Unit>:
    IO.print("topology-tests: " ++ Bool.show(tests()))
