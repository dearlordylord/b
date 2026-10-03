import Base
import ./candidate-existence-laws.bend as L
import ./candidate-existence.bend as M
import ./intersection-search.bend as S
import ./intersection-search-laws.bend as SL
import ./intersection-search-proof.bend as SP
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./boolean-reflection.bend as B

def choice_found(+p:G.Point,+allowed:Bool,+rest:S.SearchResult) -> {M.found(S.choose(p,allowed,rest)) == Bool.or(allowed,M.found(rest)) : Bool}:
  match allowed:
    case False{}: {==}
    case True{}: {==}
def L.scan_found_exact(xs,q,r):
  match xs:
    case Nil{}: {==}
    case Con{+p,+t}:
      Equal.trans(Bool,M.found(S.scan(Con{p,t},q,r)),Bool.or(S.admit(p,q,r),M.found(S.scan(t,q,r))),M.any_valid(Con{p,t},q,r),choice_found(p,S.admit(p,q,r),S.scan(t,q,r)),Equal.cong(Bool,Bool,b => Bool.or(S.admit(p,q,r),b),M.found(S.scan(t,q,r)),M.any_valid(t,q,r),L.scan_found_exact(t,q,r)))
def result_witness(+xs:List<&2,G.Point>,+q:N.Quad,+r:N.Quad,result:S.SearchResult,+he:{S.scan(xs,q,r) == result : S.SearchResult},h:{M.found(result) == True{} : Bool}) -> M.Witness(xs,q,r):
  match result:
    case S.Miss{}: B.absurd(M.Witness(xs,q,r),B.false_impossible(h))
    case S.Hit{+p}: (p,(he,SL.scan_hit_sound(xs,q,r,p,he)))
def L.valid_candidate_witness(xs,q,r,h):
  result_witness(xs,q,r,S.scan(xs,q,r),{==},Equal.trans(Bool,M.found(S.scan(xs,q,r)),M.any_valid(xs,q,r),True{},L.scan_found_exact(xs,q,r),h))
def L.find_found_exact(q,r):
  L.scan_found_exact(S.candidates(q,r),q,r)
def or_associative(+a:Bool,+b:Bool,+c:Bool) -> {Bool.or(a,Bool.or(b,c)) == Bool.or(Bool.or(a,b),c) : Bool}:
  match a b:
    case False{} False{}: {==}
    case False{} True{}: {==}
    case True{} False{}: {==}
    case True{} True{}: {==}
def L.any_append(xs,ys,q,r):
  match xs:
    case Nil{}: {==}
    case Con{+p,+t}:
      Equal.trans(Bool,M.any_valid(List.append(&2,G.Point,Con{p,t},ys),q,r),Bool.or(S.admit(p,q,r),Bool.or(M.any_valid(t,q,r),M.any_valid(ys,q,r))),Bool.or(M.any_valid(Con{p,t},q,r),M.any_valid(ys,q,r)),Equal.cong(Bool,Bool,b => Bool.or(S.admit(p,q,r),b),M.any_valid(List.append(&2,G.Point,t,ys),q,r),Bool.or(M.any_valid(t,q,r),M.any_valid(ys,q,r)),L.any_append(t,ys,q,r)),or_associative(S.admit(p,q,r),M.any_valid(t,q,r),M.any_valid(ys,q,r)))
def L.miss_no_valid_candidate(xs,q,r,h):
  Equal.trans(Bool,M.any_valid(xs,q,r),M.found(S.scan(xs,q,r)),False{},Equal.sym(Bool,M.found(S.scan(xs,q,r)),M.any_valid(xs,q,r),L.scan_found_exact(xs,q,r)),Equal.cong(S.SearchResult,Bool,M.found,S.scan(xs,q,r),S.Miss{},h))
