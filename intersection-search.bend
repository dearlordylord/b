import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut

# Exact rational candidates; no fixed denominator grid is used.
type Edge is Data:
  E{a: N.Point, b: N.Point}
type SearchResult is Data:
  Miss{}
  Hit{point: G.Point}

def vertices(q: N.Quad) -> List<&2, G.Point>:
  match q:
    case N.Q{a, b, c, d}: [Q.embed(a), Q.embed(b), Q.embed(c), Q.embed(d)]
def edges(q: N.Quad) -> List<&2, Edge>:
  match q:
    case N.Q{+a, +b, +c, +d}: [E{a, b}, E{b, c}, E{c, d}, E{d, a}]
def cut_branch(a: N.Point, b: N.Point, p: G.Point, q: G.Point, cp: Bool, cq: Bool) -> List<&2, G.Point>:
  match cp cq:
    case True{} False{}: [Cut.point(a, b, p, q)]
    case False{} True{}: [Cut.point(a, b, q, p)]
    case True{} True{}: []
    case False{} False{}: []
def edge_cut(line: Edge, segment: Edge) -> List<&2, G.Point>:
  match line segment:
    case E{+a, +b} E{+c, +d}: cut_branch(a, b, Q.embed(c), Q.embed(d), Region.edge(a, b, Q.embed(c)), Region.edge(a, b, Q.embed(d)))
def row(+line: Edge, segments: List<&2, Edge>) -> List<&2, G.Point>:
  match segments:
    case Nil{}: []
    case Con{h, t}: List.append(&2, G.Point, edge_cut(line, h), row(line, t))
def pairs(lines: List<&2, Edge>, +segments: List<&2, Edge>) -> List<&2, G.Point>:
  match lines:
    case Nil{}: []
    case Con{h, t}: List.append(&2, G.Point, row(h, segments), pairs(t, segments))
def candidates(+q: N.Quad, +r: N.Quad) -> List<&2, G.Point>:
  List.append(&2, G.Point, vertices(q), List.append(&2, G.Point, vertices(r), pairs(edges(q), edges(r))))
def admit(+p: G.Point, q: N.Quad, r: N.Quad) -> Bool:
  G.positive_denominator(p) && Region.contains(p, q) && Region.contains(p, r)
def choose(p: G.Point, allowed: Bool, fallback: SearchResult) -> SearchResult:
  match allowed:
    case True{}: Hit{p}
    case False{}: fallback
def scan(xs: List<&2, G.Point>, +q: N.Quad, +r: N.Quad) -> SearchResult:
  match xs:
    case Nil{}: Miss{}
    case Con{+h, t}: choose(h, admit(h, q, r), scan(t, q, r))
def find(+q: N.Quad, +r: N.Quad) -> SearchResult:
  scan(candidates(q, r), q, r)
