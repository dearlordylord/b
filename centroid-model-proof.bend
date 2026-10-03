import Base
import ./coordinate-limit.bend as Limit
import ./centroid.bend as M
import ./centroid-model-laws.bend as L
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
