import Base
import ./centroid.bend as M
import ./centroid-laws.bend as L
import ./core.bend as C
import ./validation.bend as V
import ./boolean-reflection.bend as BoolProof
import ./division-order-proof.bend as Division
import ./order-facts.bend as Order
import ./facts.bend as F
import ./arithmetic-product-proof.bend as A

law paired_double:
  for +a: Nat
  {Nat.add(Nat.add(a, a), Nat.add(a, a)) == Nat.double(Nat.double(a)) : Nat}
def paired_double(a):
  Equal.trans(Nat, Nat.add(Nat.add(a, a), Nat.add(a, a)), Nat.double(Nat.add(a, a)), Nat.double(Nat.double(a)), Equal.sym(Nat, Nat.double(Nat.add(a, a)), Nat.add(Nat.add(a, a), Nat.add(a, a)), A.double_eq_add(Nat.add(a, a))), Equal.cong(Nat, Nat, x => Nat.double(x), Nat.add(a, a), Nat.double(a), Equal.sym(Nat, Nat.double(a), Nat.add(a, a), A.double_eq_add(a))))

law quarter_four:
  for +q: Nat
  {Nat.div(Nat.double(Nat.double(q)), 4n) == q : Nat}
def quarter_four(q):
  match q:
    case 0n: {==}
    case 1n++p:
      Equal.trans(Nat, Nat.div(Nat.double(Nat.double(1n+p)), 4n), 1n+Nat.div(Nat.double(Nat.double(p)), 4n), 1n+p, Division.division4_block(Nat.double(Nat.double(p))), Equal.cong(Nat, Nat, z => 1n+z, Nat.div(Nat.double(Nat.double(p)), 4n), p, quarter_four(p)))

def L.mean_four_exact(a, b, c, d, q, h):
  %Equal.sym(Nat, M.sum(a, b, c, d), Nat.double(Nat.double(q)), h) : {Nat.div(_, 4n) == q : Nat}
  quarter_four(q)

def sum_bound(+a: Nat, +b: Nat, +c: Nat, +d: Nat, +limit: Nat, ha: {Nat.is_le(a, limit) == True{} : Bool}, hb: {Nat.is_le(b, limit) == True{} : Bool}, hc: {Nat.is_le(c, limit) == True{} : Bool}, hd: {Nat.is_le(d, limit) == True{} : Bool}) -> {Nat.is_le(M.sum(a, b, c, d), Nat.double(Nat.double(limit))) == True{} : Bool}:
  %paired_double(limit) : {Nat.is_le(M.sum(a, b, c, d), _) == True{} : Bool}
  Order.add_le_add(Nat.add(a, b), Nat.add(c, d), Nat.add(limit, limit), Nat.add(limit, limit), Order.add_le_add(a, b, limit, limit, ha, hb), Order.add_le_add(c, d, limit, limit, hc, hd))

def L.mean_four_bounded(a, b, c, d, limit, ha, hb, hc, hd):
  %quarter_four(limit) : {Nat.is_le(M.mean(a, b, c, d), _) == True{} : Bool}
  Division.div_le_div(M.sum(a, b, c, d), Nat.double(Nat.double(limit)), 3n, sum_bound(a, b, c, d, limit, ha, hb, hc, hd))

def L.cell_center_model(cell):
  match cell:
    case C.Cell{C.Section{C.Pt{x0, y0}, C.Pt{x1, y1}}, C.Section{C.Pt{x2, y2}, C.Pt{x3, y3}}}:
      {==}

def coordinate_bounds(+x0: Nat, +y0: Nat, +x1: Nat, +y1: Nat, +x2: Nat, +y2: Nat, +x3: Nat, +y3: Nat, hx0: {Nat.is_le(x0, 16000n) == True{} : Bool}, hy0: {Nat.is_le(y0, 16000n) == True{} : Bool}, hx1: {Nat.is_le(x1, 16000n) == True{} : Bool}, hy1: {Nat.is_le(y1, 16000n) == True{} : Bool}, hx2: {Nat.is_le(x2, 16000n) == True{} : Bool}, hy2: {Nat.is_le(y2, 16000n) == True{} : Bool}, hx3: {Nat.is_le(x3, 16000n) == True{} : Bool}, hy3: {Nat.is_le(y3, 16000n) == True{} : Bool}) -> {V.point_bounded(C.cell_center(C.Cell{C.Section{C.Pt{x0, y0}, C.Pt{x1, y1}}, C.Section{C.Pt{x2, y2}, C.Pt{x3, y3}}})) == True{} : Bool}:
  BoolProof.and_join(Nat.is_le(M.mean(x0, x1, x2, x3), 16000n), Nat.is_le(M.mean(y0, y1, y2, y3), 16000n), L.mean_four_bounded(x0, x1, x2, x3, 16000n, hx0, hx1, hx2, hx3), L.mean_four_bounded(y0, y1, y2, y3, 16000n, hy0, hy1, hy2, hy3))

def paired_bounds(+x0: Nat, +y0: Nat, +x1: Nat, +y1: Nat, +x2: Nat, +y2: Nat, +x3: Nat, +y3: Nat, hs: ({Nat.is_le(x0, 16000n) == True{} : Bool} & {Nat.is_le(y0, 16000n) == True{} : Bool}) & (({Nat.is_le(x1, 16000n) == True{} : Bool} & {Nat.is_le(y1, 16000n) == True{} : Bool}) & (({Nat.is_le(x2, 16000n) == True{} : Bool} & {Nat.is_le(y2, 16000n) == True{} : Bool}) & ({Nat.is_le(x3, 16000n) == True{} : Bool} & {Nat.is_le(y3, 16000n) == True{} : Bool})))) -> {V.point_bounded(C.cell_center(C.Cell{C.Section{C.Pt{x0, y0}, C.Pt{x1, y1}}, C.Section{C.Pt{x2, y2}, C.Pt{x3, y3}}})) == True{} : Bool}:
  match hs:
    case ((hx0, hy0), ((hx1, hy1), ((hx2, hy2), (hx3, hy3)))):
      coordinate_bounds(x0, y0, x1, y1, x2, y2, x3, y3, hx0, hy0, hx1, hy1, hx2, hy2, hx3, hy3)

def L.bounded_cell_center(cell, h0, h1, h2, h3):
  match cell:
    case C.Cell{C.Section{C.Pt{+x0, +y0}, C.Pt{+x1, +y1}}, C.Section{C.Pt{+x2, +y2}, C.Pt{+x3, +y3}}}:
      paired_bounds(x0, y0, x1, y1, x2, y2, x3, y3, (BoolProof.and_split(Nat.is_le(x0, 16000n), Nat.is_le(y0, 16000n), h0), (BoolProof.and_split(Nat.is_le(x1, 16000n), Nat.is_le(y1, 16000n), h1), (BoolProof.and_split(Nat.is_le(x2, 16000n), Nat.is_le(y2, 16000n), h2), BoolProof.and_split(Nat.is_le(x3, 16000n), Nat.is_le(y3, 16000n), h3)))))

def point_equal_fields(+x: Nat, +y: Nat, +z: Nat, +w: Nat, hs: {Nat.is_eq(x, z) == True{} : Bool} & {Nat.is_eq(y, w) == True{} : Bool}) -> {C.Pt{x, y} == C.Pt{z, w} : C.Point}:
  match hs:
    case (hx, hy):
      %BoolProof.nat_eq_sound(x, z, hx) : {C.Pt{x, y} == C.Pt{_, w} : C.Point}
      %BoolProof.nat_eq_sound(y, w, hy) : {C.Pt{x, y} == C.Pt{x, _} : C.Point}
      {==}
def point_equal_sound(+a: C.Point, +b: C.Point, h: {V.point_equal(a, b) == True{} : Bool}) -> {a == b : C.Point}:
  match a b:
    case C.Pt{+x, +y} C.Pt{+z, +w}:
      point_equal_fields(x, y, z, w, BoolProof.and_split(Nat.is_eq(x, z), Nat.is_eq(y, w), h))

def L.validated_centroid_mean(cell, accepted):
  point_equal_sound(V.point_four(C.cell_center(cell)), C.point_add(C.point_add(C.boundary_left(C.cell_start(cell)), C.boundary_right(C.cell_start(cell))), C.point_add(C.boundary_left(C.cell_finish(cell)), C.boundary_right(C.cell_finish(cell)))), accepted)
