import Base
import ./topology.bend as T
import ./cover-arithmetic.bend as M
import ./cover-arithmetic-laws.bend as L
import ./source-cells-proof.bend as Cells
import ./source-cells.bend as Source
import ./source-cells-laws.bend as SourceLaw
import ./sat-arithmetic.bend as SatModel
import ./sat-arithmetic-laws.bend as Sat
import ./sat-arithmetic-proof.bend as SatProof
import ./edge-arithmetic-proof.bend as EdgeProof
import ./edge-arithmetic-laws.bend as Edge

def or_two(+a: Bool, +b: Bool, +p: Bool, +q: Bool, ha: {a == p : Bool}, hb: {b == q : Bool}) -> {a || b == p || q : Bool}:
  %ha : {a || b == _ || q : Bool}
  %hb : {a || b == a || _ : Bool}
  {==}
def L.disjoint_all_arithmetic_exact(width, hw, q, xs, hq, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      EdgeProof.and_two(Bool.not(T.meets(q, h)), T.disjoint_all(q, t), Bool.not(SatModel.meets(q, h)), M.disjoint_all(q, t), Equal.cong(Bool, Bool, b => Bool.not(b), T.meets(q, h), SatModel.meets(q, h), Sat.meets_arithmetic_exact(width, hw, q, h, hq, Cells.cell_head(width, h, t, hx))), L.disjoint_all_arithmetic_exact(width, hw, q, t, hq, Cells.cell_tail(width, h, t, hx)))
def L.disjoint_nonadjacent_arithmetic_exact(width, hw, q, xs, hq, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}: L.disjoint_all_arithmetic_exact(width, hw, q, t, hq, Cells.cell_tail(width, h, t, hx))
def L.overlaps_one_arithmetic_exact(width, hw, q, xs, hq, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      or_two(T.meets(q, h), T.overlaps_one(q, t), SatModel.meets(q, h), M.overlaps_one(q, t), Sat.meets_arithmetic_exact(width, hw, q, h, hq, Cells.cell_head(width, h, t, hx)), L.overlaps_one_arithmetic_exact(width, hw, q, t, hq, Cells.cell_tail(width, h, t, hx)))
def L.overlaps_arithmetic_exact(width, hw, xs, ys, hx, hy):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      or_two(T.overlaps_one(h, ys), T.overlaps(t, ys), M.overlaps_one(h, ys), M.overlaps(t, ys), L.overlaps_one_arithmetic_exact(width, hw, h, ys, Cells.cell_head(width, h, t, hx), hy), L.overlaps_arithmetic_exact(width, hw, t, ys, Cells.cell_tail(width, h, t, hx), hy))
def L.adjacent_arithmetic_exact(q, xs):
  match xs:
    case Nil{}: {==}
    case Con{h, t}: Edge.shared_edge_arithmetic_exact(q, h)
def L.ribbon_walk_arithmetic_exact(width, hw, xs, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      SatProof.and_four(T.strictly_convex(h), T.adjacent(h, t), T.disjoint_nonadjacent(h, t), T.ribbon_walk(t), SatModel.strictly_convex(h), M.adjacent(h, t), M.disjoint_nonadjacent(h, t), M.ribbon_walk(t), Sat.strictly_convex_arithmetic_exact(width, hw, h, Cells.cell_head(width, h, t, hx)), L.adjacent_arithmetic_exact(h, t), L.disjoint_nonadjacent_arithmetic_exact(width, hw, h, t, Cells.cell_head(width, h, t, hx), Cells.cell_tail(width, h, t, hx)), L.ribbon_walk_arithmetic_exact(width, hw, t, Cells.cell_tail(width, h, t, hx)))
def L.ribbon_arithmetic_exact(width, hw, xs, hx):
  EdgeProof.and_two(Bool.not(List.is_empty(&2, T.Quad, xs)), T.ribbon_walk(xs), Bool.not(List.is_empty(&2, T.Quad, xs)), M.ribbon_walk(xs), {==}, L.ribbon_walk_arithmetic_exact(width, hw, xs, hx))

def L.neighbors_arithmetic_exact(width, hw, q, xs, hq, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      %Sat.meets_arithmetic_exact(width, hw, q, h, hq, Cells.cell_head(width, h, t, hx)) : {T.neighbors(q, Con{h, t}) == T.keep(_, h, M.neighbors(q, t)) : List<&2, T.Quad>}
      %L.neighbors_arithmetic_exact(width, hw, q, t, hq, Cells.cell_tail(width, h, t, hx)) : {T.neighbors(q, Con{h, t}) == T.keep(T.meets(q, h), h, _) : List<&2, T.Quad>}
      {==}
def L.natural_neighbors_envelope(width, hw, q, xs, hq, hx):
  Equal.trans(Bool, Source.envelope(width, M.neighbors(q, xs)), Source.envelope(width, T.neighbors(q, xs)), True{}, Equal.cong(List<&2, T.Quad>, Bool, ys => Source.envelope(width, ys), M.neighbors(q, xs), T.neighbors(q, xs), Equal.sym(List<&2, T.Quad>, T.neighbors(q, xs), M.neighbors(q, xs), L.neighbors_arithmetic_exact(width, hw, q, xs, hq, hx))), SourceLaw.neighbors_envelope(width, q, xs, hx))
def L.connected_arithmetic_exact(width, hw, a, b, c, ha, hb, hc):
  %L.overlaps_arithmetic_exact(width, hw, a, b, ha, hb) : {T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)) == T.connected_edges(_, M.overlaps(a, c), M.overlaps(b, c)) : Bool}
  %L.overlaps_arithmetic_exact(width, hw, a, c, ha, hc) : {T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)) == T.connected_edges(T.overlaps(a, b), _, M.overlaps(b, c)) : Bool}
  %L.overlaps_arithmetic_exact(width, hw, b, c, hb, hc) : {T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)) == T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), _) : Bool}
  {==}
def L.ribbons_arithmetic_exact(width, hw, a, b, c, ha, hb, hc):
  %L.ribbon_arithmetic_exact(width, hw, a, ha) : {T.ribbon(a) && T.ribbon(b) && T.ribbon(c) == _ && M.ribbon(b) && M.ribbon(c) : Bool}
  %L.ribbon_arithmetic_exact(width, hw, b, hb) : {T.ribbon(a) && T.ribbon(b) && T.ribbon(c) == T.ribbon(a) && _ && M.ribbon(c) : Bool}
  %L.ribbon_arithmetic_exact(width, hw, c, hc) : {T.ribbon(a) && T.ribbon(b) && T.ribbon(c) == T.ribbon(a) && T.ribbon(b) && _ : Bool}
  {==}
def assembled_connected(v: Nat, cc: T.CliqueCounts, +connected: Bool, ribbons: Bool) -> {M.report_connected(T.assemble(v, cc, connected, ribbons)) == connected : Bool}:
  match cc:
    case T.CC{e, t, q, w, f}: {==}
def assembled_ribbons(v: Nat, cc: T.CliqueCounts, connected: Bool, +ribbons: Bool) -> {M.report_ribbons(T.assemble(v, cc, connected, ribbons)) == ribbons : Bool}:
  match cc:
    case T.CC{e, t, q, w, f}: {==}
def L.inspect_connected_arithmetic_exact(width, hw, a, b, c, ha, hb, hc):
  Equal.trans(Bool, M.report_connected(T.inspect_cells(a, b, c)), T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)), M.connected(a, b, c), assembled_connected(List.length(&2, T.Quad, List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))), T.first(List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))), T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)), T.ribbon(a) && T.ribbon(b) && T.ribbon(c)), L.connected_arithmetic_exact(width, hw, a, b, c, ha, hb, hc))
def L.inspect_ribbons_arithmetic_exact(width, hw, a, b, c, ha, hb, hc):
  Equal.trans(Bool, M.report_ribbons(T.inspect_cells(a, b, c)), T.ribbon(a) && T.ribbon(b) && T.ribbon(c), M.ribbons(a, b, c), assembled_ribbons(List.length(&2, T.Quad, List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))), T.first(List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))), T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)), T.ribbon(a) && T.ribbon(b) && T.ribbon(c)), L.ribbons_arithmetic_exact(width, hw, a, b, c, ha, hb, hc))
