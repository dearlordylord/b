import Base
import ../core.bend as C
import ../validation.bend as V
import ./model.bend as M

def first() -> C.Section:
  C.Section{C.Pt{1000n, 1000n}, C.Pt{1000n, 3000n}}
def last() -> C.Section:
  C.Section{C.Pt{2000n, 1000n}, C.Pt{2000n, 3000n}}
def arm() -> M.Arm:
  M.Arm{[first(), last()], [True{}], 0n, 0n, C.Pt{0n, 0n}, True{}}
def glyph(+arms: List<&2, M.Arm>, components: Nat, offset: Nat) -> M.Glyph:
  M.Glyph{97n, 10000n, offset, components, 0n, arms, M.indices(arms, 0n)}
def bad_cell(section: C.Section) -> M.Glyph:
  glyph([M.Arm{[first(), section], [True{}], 0n, 0n, C.Pt{0n, 0n}, True{}}], 1n, 0n)
def bad_join(+parent: Nat, join: C.Point) -> M.Glyph:
  glyph([arm(), M.Arm{[first(), last()], [False{}], 0n, parent, join, False{}}], 1n, 0n)
def hidden() -> M.Glyph:
  glyph([arm(), M.Arm{[C.Section{C.Pt{900n, 996n}, C.Pt{900n, 3004n}}, C.Section{C.Pt{2100n, 996n}, C.Pt{2100n, 3004n}}], [False{}], 0n, 0n, C.Pt{1500n, 1500n}, False{}}], 1n, 0n)

def cases() -> Bool:
  M.glyph_valid(glyph([arm()], 1n, 0n)) &&
    Bool.not(M.glyph_valid(glyph([], 0n, 0n))) &&
    Bool.not(M.glyph_valid(glyph([M.Arm{[first()], [], 0n, 0n, C.Pt{0n, 0n}, True{}}], 1n, 0n))) &&
    Bool.not(M.glyph_valid(bad_cell(C.Section{C.Pt{16004n, 1000n}, C.Pt{16004n, 3000n}}))) &&
    Bool.not(M.glyph_valid(bad_cell(C.Section{C.Pt{2000n, 1000n}, C.Pt{2000n, 2000n}}))) &&
    Bool.not(M.glyph_valid(bad_cell(C.Section{C.Pt{2000n, 1000n}, C.Pt{2000n, 4000n}}))) &&
    Bool.not(M.glyph_valid(bad_cell(C.Section{C.Pt{2000n, 3000n}, C.Pt{2000n, 1000n}}))) &&
    Bool.not(M.glyph_valid(bad_cell(C.Section{C.Pt{2001n, 1000n}, C.Pt{2000n, 3000n}}))) &&
    Bool.not(M.glyph_valid(glyph([M.Arm{[first(), last()], [], 0n, 0n, C.Pt{0n, 0n}, True{}}], 1n, 0n))) &&
    Bool.not(M.glyph_valid(glyph([arm()], 2n, 0n))) &&
    Bool.not(M.glyph_valid(glyph([arm()], 1n, 3004n))) &&
    Bool.not(M.glyph_valid(bad_join(0n, C.Pt{0n, 0n}))) &&
    Bool.not(M.glyph_valid(bad_join(1n, C.Pt{1500n, 1500n}))) &&
    Bool.not(M.glyph_valid(glyph([arm(), M.Arm{[first(), last()], [False{}], 1n, 0n, C.Pt{0n, 0n}, True{}}], 2n, 0n))) &&
    Bool.not(M.glyph_valid(hidden())) &&
    Bool.not(M.painting_valid([], [arm()])) &&
    Bool.not(M.painting_valid([1n], [arm()])) &&
    Bool.not(M.painting_valid([0n, 0n], [arm(), arm()]))

def main() -> IO(Unit):
  IO.print("alphabet-tests: " ++ Bool.show(cases()))
