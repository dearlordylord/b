import Base
import ./intersection-search-laws.bend as L
import ./intersection-search.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./boolean-reflection.bend as B
import ./quad-geometry.bend as Q
import ./halfplane-region.bend as Region
import ./quad-intersection.bend as Intersection
import ./quad-intersection-laws.bend as IL
import ./quad-intersection-proof.bend as IP
import ./quad-barycentric-laws.bend as BL
import ./quad-barycentric-proof.bend as BP
import ./source-cells-proof.bend as Fields

def is_hit(result: M.SearchResult) -> Bool:
  match result:
    case M.Miss{}: False{}
    case M.Hit{p}: True{}
def payload(result: M.SearchResult) -> G.Point:
  match result:
    case M.Miss{}: G.P{0n, 0n, 0n}
    case M.Hit{p}: p

def choice_sound(+head: G.Point, +p: G.Point, +q: N.Quad, +r: N.Quad, allowed: Bool, +fallback: M.SearchResult, he: {allowed == M.admit(head, q, r) : Bool}, ih: {fallback == M.Hit{p} : M.SearchResult} -> {M.admit(p, q, r) == True{} : Bool}, accepted: {M.choose(head, allowed, fallback) == M.Hit{p} : M.SearchResult}) -> {M.admit(p, q, r) == True{} : Bool}:
  match allowed:
    case False{}: ih(accepted)
    case True{}:
      Equal.trans(Bool, M.admit(p, q, r), M.admit(head, q, r), True{}, Equal.cong(G.Point, Bool, x => M.admit(x, q, r), p, head, Equal.sym(G.Point, head, p, Equal.cong(M.SearchResult, G.Point, payload, M.Hit{head}, M.Hit{p}, accepted))), Equal.sym(Bool, True{}, M.admit(head, q, r), he))

def L.scan_hit_sound(xs, q, r, p, h):
  match xs:
    case Nil{}:
      B.absurd({M.admit(p, q, r) == True{} : Bool}, B.false_impossible(Equal.cong(M.SearchResult, Bool, is_hit, M.Miss{}, M.Hit{p}, h)))
    case Con{+head, +tail}:
      choice_sound(head, p, q, r, M.admit(head, q, r), M.scan(tail, q, r), {==}, ht => L.scan_hit_sound(tail, q, r, p, ht), h)

def L.find_hit_sound(q, r, p, h):
  L.scan_hit_sound(M.candidates(q, r), q, r, p, h)


def accepted_hulls(+q: N.Quad, +r: N.Quad, +p: G.Point, hq: {Q.strict_quad(q) == True{} : Bool}, hr: {Q.strict_quad(r) == True{} : Bool}, facts: {G.positive_denominator(p) == True{} : Bool} & ({Region.contains(p, q) == True{} : Bool} & {Region.contains(p, r) == True{} : Bool})) -> Intersection.CommonPoint(q, r):
  match facts:
    case (+hp, (inside_q, inside_r)):
      (p, (BL.region_point_in_hull(q, p, hq, hp, inside_q), BL.region_point_in_hull(r, p, hr, hp, inside_r)))
def L.find_hit_common_hull(q, r, p, hq, hr, h):
  accepted_hulls(q, r, p, hq, hr, Fields.three_fields(G.positive_denominator(p), Region.contains(p, q), Region.contains(p, r), L.find_hit_sound(q, r, p, h)))
def L.find_hit_meets(q, r, p, hq, hr, h):
  IL.common_hull_meets(q, r, hq, hr, L.find_hit_common_hull(q, r, p, hq, hr, h))

def choose_reference(+p: G.Point, allowed: Bool, +rest: M.SearchResult) -> {M.choose(p, allowed, rest) == L.select_reference(p, allowed, rest) : M.SearchResult}:
  match allowed:
    case False{}: {==}
    case True{}: {==}
def L.scan_reference(xs, q, r):
  match xs:
    case Nil{}: {==}
    case Con{+p, +t}:
      Equal.trans(M.SearchResult, M.scan(Con{p, t}, q, r), M.choose(p, M.admit(p, q, r), L.first_reference(t, q, r)), L.first_reference(Con{p, t}, q, r), Equal.cong(M.SearchResult, M.SearchResult, rest => M.choose(p, M.admit(p, q, r), rest), M.scan(t, q, r), L.first_reference(t, q, r), L.scan_reference(t, q, r)), choose_reference(p, M.admit(p, q, r), L.first_reference(t, q, r)))

def L.vertices_exact(a,b,c,d):
  {==}
def L.edges_exact(a,b,c,d):
  {==}
def L.cut_branch_exact(a,b,p,q,cp,cq):
  match cp cq:
    case False{} False{}: {==}
    case True{} True{}: {==}
    case False{} True{}: {==}
    case True{} False{}: {==}
def L.edge_cut_exact(line,segment):
  match line segment:
    case M.E{+a,+b} M.E{+c,+d}: L.cut_branch_exact(a,b,Q.embed(c),Q.embed(d),Region.edge(a,b,Q.embed(c)),Region.edge(a,b,Q.embed(d)))
def append_equal(+xs:List<&2,G.Point>,+ys:List<&2,G.Point>,+us:List<&2,G.Point>,+vs:List<&2,G.Point>,hx:{xs == us : List<&2,G.Point>},hy:{ys == vs : List<&2,G.Point>}) -> {List.append(&2,G.Point,xs,ys) == List.append(&2,G.Point,us,vs) : List<&2,G.Point>}:
  Equal.trans(List<&2,G.Point>,List.append(&2,G.Point,xs,ys),List.append(&2,G.Point,us,ys),List.append(&2,G.Point,us,vs),Equal.cong(List<&2,G.Point>,List<&2,G.Point>,x => List.append(&2,G.Point,x,ys),xs,us,hx),Equal.cong(List<&2,G.Point>,List<&2,G.Point>,y => List.append(&2,G.Point,us,y),ys,vs,hy))
def L.row_exact(line,segments):
  match segments:
    case Nil{}: {==}
    case Con{+h,+t}: append_equal(M.edge_cut(line,h),M.row(line,t),L.edge_reference(line,h),L.row_reference(line,t),L.edge_cut_exact(line,h),L.row_exact(line,t))
def L.pairs_exact(lines,segments):
  match lines:
    case Nil{}: {==}
    case Con{+h,+t}: append_equal(M.row(h,segments),M.pairs(t,segments),L.row_reference(h,segments),L.pairs_reference(t,segments),L.row_exact(h,segments),L.pairs_exact(t,segments))
def L.candidates_layout(a,b,c,d,e,f,g,h):
  Equal.cong(List<&2,G.Point>,List<&2,G.Point>,xs => List.append(&2,G.Point,[Q.embed(a),Q.embed(b),Q.embed(c),Q.embed(d)],List.append(&2,G.Point,[Q.embed(e),Q.embed(f),Q.embed(g),Q.embed(h)],xs)),M.pairs([M.E{a,b},M.E{b,c},M.E{c,d},M.E{d,a}],[M.E{e,f},M.E{f,g},M.E{g,h},M.E{h,e}]),L.pairs_reference([M.E{a,b},M.E{b,c},M.E{c,d},M.E{d,a}],[M.E{e,f},M.E{f,g},M.E{g,h},M.E{h,e}]),L.pairs_exact([M.E{a,b},M.E{b,c},M.E{c,d},M.E{d,a}],[M.E{e,f},M.E{f,g},M.E{g,h},M.E{h,e}]))
def L.find_reference(q,r):
  L.scan_reference(M.candidates(q,r),q,r)
