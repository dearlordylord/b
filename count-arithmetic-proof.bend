import Base
import ./topology.bend as T
import ./count-arithmetic.bend as M
import ./count-arithmetic-laws.bend as L
import ./cover-arithmetic.bend as Cover
import ./cover-arithmetic-laws.bend as CoverLaw
import ./cover-arithmetic-proof.bend as CoverProof
import ./source-cells.bend as Cells
import ./source-cells-laws.bend as Source
import ./source-cells-proof.bend as SourceProof
import ./search-witness.bend as Envelope
import ./search-arithmetic.bend as Search
import ./search-arithmetic-laws.bend as SearchLaw
import ./search-arithmetic-proof.bend as SearchProof

def sum_exact(+a: T.CliqueCounts, +b: T.CliqueCounts, +p: T.CliqueCounts, +q: T.CliqueCounts, ha: {a == p : T.CliqueCounts}, hb: {b == q : T.CliqueCounts}) -> {T.sum_counts(a, b) == T.sum_counts(p, q) : T.CliqueCounts}:
  %ha : {T.sum_counts(a, b) == T.sum_counts(_, q) : T.CliqueCounts}
  %hb : {T.sum_counts(a, b) == T.sum_counts(a, _) : T.CliqueCounts}
  {==}
def third_step_exact(+w: Bool, +v: Bool, +a: T.CliqueCounts, +b: T.CliqueCounts, hw: {w == v : Bool}, ha: {a == b : T.CliqueCounts}) -> {T.third_step(w, a) == T.third_step(v, b) : T.CliqueCounts}:
  %hw : {T.third_step(w, a) == T.third_step(_, b) : T.CliqueCounts}
  %ha : {T.third_step(w, a) == T.third_step(w, _) : T.CliqueCounts}
  {==}
def L.fourth_arithmetic_exact(width, hw, xs, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      sum_exact(T.fourth_step(List.is_empty(&2, T.Quad, T.neighbors(h, t))), T.fourth(t), T.fourth_step(List.is_empty(&2, T.Quad, Cover.neighbors(h, t))), M.fourth(t), Equal.cong(List<&2, T.Quad>, T.CliqueCounts, ys => T.fourth_step(List.is_empty(&2, T.Quad, ys)), T.neighbors(h, t), Cover.neighbors(h, t), CoverLaw.neighbors_arithmetic_exact(width, hw, h, t, SourceProof.cell_head(width, h, t, hx), SourceProof.cell_tail(width, h, t, hx))), L.fourth_arithmetic_exact(width, hw, t, SourceProof.cell_tail(width, h, t, hx)))
def filtered_fourth(+width: Nat, +hw: {width == 12n : Nat}, +q: T.Quad, +xs: List<&2, T.Quad>, +hq: {Envelope.quad_envelope(width, q) == True{} : Bool}, +hx: {Cells.envelope(width, xs) == True{} : Bool}) -> {T.fourth(T.neighbors(q, xs)) == M.fourth(Cover.neighbors(q, xs)) : T.CliqueCounts}:
  Equal.trans(T.CliqueCounts, T.fourth(T.neighbors(q, xs)), M.fourth(T.neighbors(q, xs)), M.fourth(Cover.neighbors(q, xs)), L.fourth_arithmetic_exact(width, hw, T.neighbors(q, xs), Source.neighbors_envelope(width, q, xs, hx)), Equal.cong(List<&2, T.Quad>, T.CliqueCounts, ys => M.fourth(ys), T.neighbors(q, xs), Cover.neighbors(q, xs), CoverLaw.neighbors_arithmetic_exact(width, hw, q, xs, hq, hx)))
def L.third_arithmetic_exact(width, hw, xs, a, b, hx, ha, hb):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      sum_exact(T.third_step(T.triangle_witness(a, b, h), T.fourth(T.neighbors(h, t))), T.third(t, a, b), T.third_step(Search.triangle_witness(a, b, h), M.fourth(Cover.neighbors(h, t))), M.third(t, a, b), third_step_exact(T.triangle_witness(a, b, h), Search.triangle_witness(a, b, h), T.fourth(T.neighbors(h, t)), M.fourth(Cover.neighbors(h, t)), SearchLaw.triangle_witness_arithmetic_exact(width, hw, a, b, h, ha, hb, SourceProof.cell_head(width, h, t, hx)), filtered_fourth(width, hw, h, t, SourceProof.cell_head(width, h, t, hx), SourceProof.cell_tail(width, h, t, hx))), L.third_arithmetic_exact(width, hw, t, a, b, SourceProof.cell_tail(width, h, t, hx), ha, hb))
def filtered_third(+width: Nat, +hw: {width == 12n : Nat}, +q: T.Quad, +xs: List<&2, T.Quad>, +a: T.Quad, +b: T.Quad, +hq: {Envelope.quad_envelope(width, q) == True{} : Bool}, +hx: {Cells.envelope(width, xs) == True{} : Bool}, +ha: {Envelope.quad_envelope(width, a) == True{} : Bool}, +hb: {Envelope.quad_envelope(width, b) == True{} : Bool}) -> {T.third(T.neighbors(q, xs), a, b) == M.third(Cover.neighbors(q, xs), a, b) : T.CliqueCounts}:
  Equal.trans(T.CliqueCounts, T.third(T.neighbors(q, xs), a, b), M.third(T.neighbors(q, xs), a, b), M.third(Cover.neighbors(q, xs), a, b), L.third_arithmetic_exact(width, hw, T.neighbors(q, xs), a, b, Source.neighbors_envelope(width, q, xs, hx), ha, hb), Equal.cong(List<&2, T.Quad>, T.CliqueCounts, ys => M.third(ys, a, b), T.neighbors(q, xs), Cover.neighbors(q, xs), CoverLaw.neighbors_arithmetic_exact(width, hw, q, xs, hq, hx)))
def L.second_arithmetic_exact(width, hw, xs, a, hx, ha):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      sum_exact(T.CC{1n, 0n, 0n, True{}, True{}}, T.sum_counts(T.third(T.neighbors(h, t), a, h), T.second(t, a)), T.CC{1n, 0n, 0n, True{}, True{}}, T.sum_counts(M.third(Cover.neighbors(h, t), a, h), M.second(t, a)), {==}, sum_exact(T.third(T.neighbors(h, t), a, h), T.second(t, a), M.third(Cover.neighbors(h, t), a, h), M.second(t, a), filtered_third(width, hw, h, t, a, h, SourceProof.cell_head(width, h, t, hx), SourceProof.cell_tail(width, h, t, hx), ha, SourceProof.cell_head(width, h, t, hx)), L.second_arithmetic_exact(width, hw, t, a, SourceProof.cell_tail(width, h, t, hx), ha)))
def filtered_second(+width: Nat, +hw: {width == 12n : Nat}, +q: T.Quad, +xs: List<&2, T.Quad>, +hq: {Envelope.quad_envelope(width, q) == True{} : Bool}, +hx: {Cells.envelope(width, xs) == True{} : Bool}) -> {T.second(T.neighbors(q, xs), q) == M.second(Cover.neighbors(q, xs), q) : T.CliqueCounts}:
  Equal.trans(T.CliqueCounts, T.second(T.neighbors(q, xs), q), M.second(T.neighbors(q, xs), q), M.second(Cover.neighbors(q, xs), q), L.second_arithmetic_exact(width, hw, T.neighbors(q, xs), q, Source.neighbors_envelope(width, q, xs, hx), hq), Equal.cong(List<&2, T.Quad>, T.CliqueCounts, ys => M.second(ys, q), T.neighbors(q, xs), Cover.neighbors(q, xs), CoverLaw.neighbors_arithmetic_exact(width, hw, q, xs, hq, hx)))
def L.first_arithmetic_exact(width, hw, xs, hx):
  match xs:
    case Nil{}: {==}
    case Con{+h, +t}:
      sum_exact(T.second(T.neighbors(h, t), h), T.first(t), M.second(Cover.neighbors(h, t), h), M.first(t), filtered_second(width, hw, h, t, SourceProof.cell_head(width, h, t, hx), SourceProof.cell_tail(width, h, t, hx)), L.first_arithmetic_exact(width, hw, t, SourceProof.cell_tail(width, h, t, hx)))
def assembled_exact(+v: Nat, +a: T.CliqueCounts, +b: T.CliqueCounts, +connected: Bool, +natural_connected: Bool, +ribbons: Bool, +natural_ribbons: Bool, counts: {a == b : T.CliqueCounts}, con: {connected == natural_connected : Bool}, rib: {ribbons == natural_ribbons : Bool}) -> {T.assemble(v, a, connected, ribbons) == T.assemble(v, b, natural_connected, natural_ribbons) : T.Counts}:
  %counts : {T.assemble(v, a, connected, ribbons) == T.assemble(v, _, natural_connected, natural_ribbons) : T.Counts}
  %con : {T.assemble(v, a, connected, ribbons) == T.assemble(v, a, _, natural_ribbons) : T.Counts}
  %rib : {T.assemble(v, a, connected, ribbons) == T.assemble(v, a, connected, _) : T.Counts}
  {==}
def L.inspect_cells_arithmetic_exact(width, hw, a, b, c, ha, hb, hc):
  assembled_exact(List.length(&2, T.Quad, List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))), T.first(List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))), M.first(List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c))), T.connected_edges(T.overlaps(a, b), T.overlaps(a, c), T.overlaps(b, c)), Cover.connected(a, b, c), T.ribbon(a) && T.ribbon(b) && T.ribbon(c), Cover.ribbons(a, b, c), L.first_arithmetic_exact(width, hw, List.append(&2, T.Quad, a, List.append(&2, T.Quad, b, c)), Source.appended_envelope(width, a, List.append(&2, T.Quad, b, c), ha, Source.appended_envelope(width, b, c, hb, hc))), CoverLaw.connected_arithmetic_exact(width, hw, a, b, c, ha, hb, hc), CoverLaw.ribbons_arithmetic_exact(width, hw, a, b, c, ha, hb, hc))
