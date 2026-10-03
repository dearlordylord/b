import Base
import ./centroid.bend as M
import ./core.bend as C
import ./validation.bend as V

law mean_four_exact:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +q: Nat
  for h: {M.sum(a, b, c, d) == Nat.double(Nat.double(q)) : Nat}
  {M.mean(a, b, c, d) == q : Nat}

law mean_four_bounded:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  for +d: Nat
  for +limit: Nat
  for ha: {Nat.is_le(a, limit) == True{} : Bool}
  for hb: {Nat.is_le(b, limit) == True{} : Bool}
  for hc: {Nat.is_le(c, limit) == True{} : Bool}
  for hd: {Nat.is_le(d, limit) == True{} : Bool}
  {Nat.is_le(M.mean(a, b, c, d), limit) == True{} : Bool}

law cell_center_model:
  for +cell: C.Cell
  {C.cell_center(cell) == M.center(cell) : C.Point}
