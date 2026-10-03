import Base
import ./core.bend as Core
import ./validation.bend as V
import ./coordinate-transverse.bend as T

def same(a: Bool, b: Bool) -> Bool:
  Bool.not(Bool.xor(a, b))

# Finite native examples; the proof roots establish the universal laws.
def example(+lx: Nat, +ly: Nat, +cx: Nat, +cy: Nat, +rx: Nat, +ry: Nat, +expected: Bool) -> Bool:
  V.point_bounded(Core.Pt{lx, ly}) && V.point_bounded(Core.Pt{cx, cy}) && V.point_bounded(Core.Pt{rx, ry}) && same(V.transverse_points(Core.Pt{lx, ly}, Core.Pt{cx, cy}, Core.Pt{rx, ry}), expected) && same(T.exact(lx, ly, cx, cy, rx, ry), expected)
def tests() -> Bool:
  example(1n, 1n, 2n, 1n, 3n, 1n, True{}) && example(1n, 1n, 0n, 1n, 3n, 1n, False{}) && example(1n, 1n, 4n, 1n, 3n, 1n, False{})
def main() -> IO(Unit):
  do IO<Unit>:
    IO.print("transverse-tests: " ++ Bool.show(tests()))
