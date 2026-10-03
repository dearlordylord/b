import Base
import ./core.bend as C
import ./validation.bend as V
import ./cell-transverse.bend as M

def same(a: Bool, b: Bool) -> Bool:
  Bool.not(Bool.xor(a, b))

def example(+cell: C.Cell, +expected: Bool) -> Bool:
  V.point_bounded(C.boundary_left(C.cell_start(cell))) && V.point_bounded(C.boundary_right(C.cell_start(cell))) && V.point_bounded(C.boundary_left(C.cell_finish(cell))) && V.point_bounded(C.boundary_right(C.cell_finish(cell))) && same(V.cell_transverse(cell), expected) && same(M.exact(cell), expected)

def tests() -> Bool:
  example(C.Cell{C.Section{C.Pt{0n, 0n}, C.Pt{4n, 0n}}, C.Section{C.Pt{0n, 8n}, C.Pt{4n, 8n}}}, True{}) && example(C.Cell{C.Section{C.Pt{0n, 0n}, C.Pt{4n, 0n}}, C.Section{C.Pt{8n, 8n}, C.Pt{12n, 8n}}}, False{}) && example(C.Cell{C.Section{C.Pt{0n, 0n}, C.Pt{0n, 0n}}, C.Section{C.Pt{0n, 8n}, C.Pt{0n, 8n}}}, False{}) && example(C.Cell{C.Section{C.Pt{15992n, 15992n}, C.Pt{16000n, 15992n}}, C.Section{C.Pt{15992n, 16000n}, C.Pt{16000n, 16000n}}}, True{}) && same(V.point_bounded(C.Pt{16001n, 0n}), False{}) && same(V.point_bounded(C.Pt{0n, 16001n}), False{})

def main() -> IO(Unit):
  do IO<Unit>:
    IO.print("cell-transverse-tests: " ++ Bool.show(tests()))
