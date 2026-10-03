import Base
import ./intersection-search.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./boolean-reflection.bend as B

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

def scan_hit_sound(xs:List<&2,G.Point>,+q:N.Quad,+r:N.Quad,+p:G.Point,h:{M.scan(xs,q,r) == M.Hit{p} : M.SearchResult}) -> {M.admit(p,q,r) == True{} : Bool}:
  match xs:
    case Nil{}:
      B.absurd({M.admit(p, q, r) == True{} : Bool}, B.false_impossible(Equal.cong(M.SearchResult, Bool, is_hit, M.Miss{}, M.Hit{p}, h)))
    case Con{+head, +tail}:
      choice_sound(head, p, q, r, M.admit(head, q, r), M.scan(tail, q, r), {==}, ht => scan_hit_sound(tail, q, r, p, ht), h)

