import Base
import ./core.bend as C
import ./validation.bend as V
import ./source-convexity.bend as M
import ./source-convexity-laws.bend as L
import ./coordinate-runtime-laws.bend as Runtime
import ./coordinate-runtime-proof.bend as RuntimeProof
import ./sat-arithmetic-proof.bend as Sat

def determinant_exact(+a: C.Point, +b: C.Point, +c: C.Point, ha: {V.point_bounded(a) == True{} : Bool}, hb: {V.point_bounded(b) == True{} : Bool}, hc: {V.point_bounded(c) == True{} : Bool}) -> {V.determinant_positive(a, b, c) == M.determinant_positive(a, b, c) : Bool}:
  match a b c:
    case C.Pt{ax, ay} C.Pt{bx, by} C.Pt{cx, cy}:
      Runtime.accepted_points_determinant(ax, ay, bx, by, cx, cy, ha, hb, hc)
def L.positive_quad_arithmetic_exact(a, b, c, d, ha, hb, hc, hd):
  Sat.and_four(V.determinant_positive(a, b, c), V.determinant_positive(b, c, d), V.determinant_positive(c, d, a), V.determinant_positive(d, a, b), M.determinant_positive(a, b, c), M.determinant_positive(b, c, d), M.determinant_positive(c, d, a), M.determinant_positive(d, a, b), determinant_exact(a, b, c, ha, hb, hc), determinant_exact(b, c, d, hb, hc, hd), determinant_exact(c, d, a, hc, hd, ha), determinant_exact(d, a, b, hd, ha, hb))
def L.convex_quad_arithmetic_exact(a, b, c, d, ha, hb, hc, hd):
  %L.positive_quad_arithmetic_exact(a, b, c, d, ha, hb, hc, hd) : {V.convex_quad(a, b, c, d) == _ || M.positive_quad(d, c, b, a) : Bool}
  %L.positive_quad_arithmetic_exact(d, c, b, a, hd, hc, hb, ha) : {V.convex_quad(a, b, c, d) == V.positive_quad(a, b, c, d) || _ : Bool}
  {==}
def L.cell_convex_arithmetic_exact(cell, hsl, hsr, hfl, hfr):
  match cell:
    case C.Cell{C.Section{a, d}, C.Section{b, c}}:
      L.convex_quad_arithmetic_exact(a, b, c, d, hsl, hfl, hfr, hsr)
