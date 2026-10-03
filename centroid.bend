import Base
import ./core.bend as C

def sum(a: Nat, b: Nat, c: Nat, d: Nat) -> Nat:
  Nat.add(Nat.add(a, b), Nat.add(c, d))
def mean(a: Nat, b: Nat, c: Nat, d: Nat) -> Nat:
  Nat.div(sum(a, b, c, d), 4n)
def center(cell: C.Cell) -> C.Point:
  match cell:
    case C.Cell{C.Section{C.Pt{x0, y0}, C.Pt{x1, y1}}, C.Section{C.Pt{x2, y2}, C.Pt{x3, y3}}}:
      C.Pt{mean(x0, x1, x2, x3), mean(y0, y1, y2, y3)}
