import Base
import ./intersection-search.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q
import ./quad-intersection.bend as Intersection
import ./segment-cut.bend as Cut

# Independent list specification: the first valid point in input order.
def select_reference(p: G.Point, accepted: Bool, rest: M.SearchResult) -> M.SearchResult:
  match accepted:
    case False{}: rest
    case True{}: M.Hit{p}
def first_reference(xs: List<&2, G.Point>, +q: N.Quad, +r: N.Quad) -> M.SearchResult:
  match xs:
    case Nil{}: M.Miss{}
    case Con{+p, t}: select_reference(p, G.positive_denominator(p) && Region.contains(p, q) && Region.contains(p, r), first_reference(t, q, r))
law scan_reference:
  for +xs: List<&2, G.Point>
  for +q: N.Quad
  for +r: N.Quad
  {M.scan(xs, q, r) == first_reference(xs, q, r) : M.SearchResult}

# Every returned hit passes the actual validity and both-region predicate.
# This is soundness only; the empty-search implementation would also satisfy it.
law scan_hit_sound:
  for +xs: List<&2, G.Point>
  for +q: N.Quad
  for +r: N.Quad
  for +p: G.Point
  for h: {M.scan(xs, q, r) == M.Hit{p} : M.SearchResult}
  {M.admit(p, q, r) == True{} : Bool}
law find_hit_sound:
  for +q: N.Quad
  for +r: N.Quad
  for +p: G.Point
  for h: {M.find(q, r) == M.Hit{p} : M.SearchResult}
  {M.admit(p, q, r) == True{} : Bool}

# Returned points have actual independent nonnegative four-corner weights.
law find_hit_common_hull:
  for +q: N.Quad
  for +r: N.Quad
  for +p: G.Point
  for hq: {Q.strict_quad(q) == True{} : Bool}
  for hr: {Q.strict_quad(r) == True{} : Bool}
  for h: {M.find(q, r) == M.Hit{p} : M.SearchResult}
  Intersection.CommonPoint(q, r)
law find_hit_meets:
  for +q: N.Quad
  for +r: N.Quad
  for +p: G.Point
  for +hq: {Q.strict_quad(q) == True{} : Bool}
  for +hr: {Q.strict_quad(r) == True{} : Bool}
  for h: {M.find(q, r) == M.Hit{p} : M.SearchResult}
  {Intersection.meets(q, r) == True{} : Bool}

# Every original directed side, including the closing side, is prescribed.
law vertices_exact:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +d: N.Point
  {M.vertices(N.Q{a,b,c,d}) == [Q.embed(a),Q.embed(b),Q.embed(c),Q.embed(d)] : List<&2,G.Point>}
law edges_exact:
  for +a: N.Point
  for +b: N.Point
  for +c: N.Point
  for +d: N.Point
  {M.edges(N.Q{a,b,c,d}) == [M.E{a,b},M.E{b,c},M.E{c,d},M.E{d,a}] : List<&2,M.Edge>}
def cut_reference(a:N.Point,b:N.Point,p:G.Point,q:G.Point,cp:Bool,cq:Bool) -> List<&2,G.Point>:
  match cp cq:
    case False{} False{}: []
    case True{} True{}: []
    case False{} True{}: [Cut.point(a,b,q,p)]
    case True{} False{}: [Cut.point(a,b,p,q)]
law cut_branch_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +cp:Bool
  for +cq:Bool
  {M.cut_branch(a,b,p,q,cp,cq) == cut_reference(a,b,p,q,cp,cq) : List<&2,G.Point>}
def edge_reference(line:M.Edge,segment:M.Edge) -> List<&2,G.Point>:
  match line segment:
    case M.E{+a,+b} M.E{+c,+d}: cut_reference(a,b,Q.embed(c),Q.embed(d),Region.edge(a,b,Q.embed(c)),Region.edge(a,b,Q.embed(d)))
law edge_cut_exact:
  for +line:M.Edge
  for +segment:M.Edge
  {M.edge_cut(line,segment) == edge_reference(line,segment) : List<&2,G.Point>}
def row_reference(+line:M.Edge,segments:List<&2,M.Edge>) -> List<&2,G.Point>:
  match segments:
    case Nil{}: []
    case Con{h,t}: List.append(&2,G.Point,edge_reference(line,h),row_reference(line,t))
law row_exact:
  for +line:M.Edge
  for +segments:List<&2,M.Edge>
  {M.row(line,segments) == row_reference(line,segments) : List<&2,G.Point>}
def pairs_reference(lines:List<&2,M.Edge>,+segments:List<&2,M.Edge>) -> List<&2,G.Point>:
  match lines:
    case Nil{}: []
    case Con{h,t}: List.append(&2,G.Point,row_reference(h,segments),pairs_reference(t,segments))
law pairs_exact:
  for +lines:List<&2,M.Edge>
  for +segments:List<&2,M.Edge>
  {M.pairs(lines,segments) == pairs_reference(lines,segments) : List<&2,G.Point>}
# The two corner lists precede the full Cartesian product of the side lists.
law candidates_layout:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  for +e:N.Point
  for +f:N.Point
  for +g:N.Point
  for +h:N.Point
  {M.candidates(N.Q{a,b,c,d},N.Q{e,f,g,h}) == List.append(&2,G.Point,[Q.embed(a),Q.embed(b),Q.embed(c),Q.embed(d)],List.append(&2,G.Point,[Q.embed(e),Q.embed(f),Q.embed(g),Q.embed(h)],pairs_reference([M.E{a,b},M.E{b,c},M.E{c,d},M.E{d,a}],[M.E{e,f},M.E{f,g},M.E{g,h},M.E{h,e}]))) : List<&2,G.Point>}
law find_reference:
  for +q:N.Quad
  for +r:N.Quad
  {M.find(q,r) == first_reference(M.candidates(q,r),q,r) : M.SearchResult}
