import Base
import ./corner-candidate-laws.bend as L
import ./corner-candidate.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-geometry.bend as Q
import ./quad-geometry-laws.bend as QL
import ./quad-geometry-proof.bend as QP
import ./halfplane-region.bend as Region
import ./homogeneous-combination-proof.bend as CP
import ./candidate-existence.bend as E
import ./candidate-existence-laws.bend as EL
import ./candidate-existence-proof.bend as EP
import ./intersection-search.bend as S
import ./intersection-search-laws.bend as SL
import ./intersection-search-proof.bend as SP
import ./quad-intersection.bend as I

def embedded_positive(+p:N.Point) -> {G.positive_denominator(Q.embed(p)) == True{} : Bool}:
  match p:
    case N.P{x,y}: {==}
def own_admission(+p:G.Point,+q:N.Quad,+r:N.Quad,hp:{G.positive_denominator(p) == True{} : Bool},hq:{Region.contains(p,q) == True{} : Bool}) -> {S.admit(p,q,r) == Region.contains(p,r) : Bool}:
  %Equal.sym(Bool,G.positive_denominator(p),True{},hp) : {Bool.and(Bool.and(_,Region.contains(p,q)),Region.contains(p,r)) == Region.contains(p,r) : Bool}
  %Equal.sym(Bool,Region.contains(p,q),True{},hq) : {Bool.and(Bool.and(True{},_),Region.contains(p,r)) == Region.contains(p,r) : Bool}
  {==}
def or4(+a:Bool,+b:Bool,+c:Bool,+d:Bool) -> Bool:
  a || (b || (c || (d || False{})))
def or4_equal(+a:Bool,+b:Bool,+c:Bool,+d:Bool,+e:Bool,+f:Bool,+g:Bool,+h:Bool,ha:{a == e : Bool},hb:{b == f : Bool},hc:{c == g : Bool},hd:{d == h : Bool}) -> {or4(a,b,c,d) == or4(e,f,g,h) : Bool}:
  %Equal.sym(Bool,a,e,ha) : {or4(_,b,c,d) == or4(e,f,g,h) : Bool}
  %Equal.sym(Bool,b,f,hb) : {or4(e,_,c,d) == or4(e,f,g,h) : Bool}
  %Equal.sym(Bool,c,g,hc) : {or4(e,f,_,d) == or4(e,f,g,h) : Bool}
  %Equal.sym(Bool,d,h,hd) : {or4(e,f,g,_) == or4(e,f,g,h) : Bool}
  {==}
def corner_admissions(+a:N.Point,+b:N.Point,+c:N.Point,+d:N.Point,+r:N.Quad,facts:{Region.contains(Q.embed(a),N.Q{a,b,c,d}) == True{} : Bool} & ({Region.contains(Q.embed(b),N.Q{a,b,c,d}) == True{} : Bool} & ({Region.contains(Q.embed(c),N.Q{a,b,c,d}) == True{} : Bool} & {Region.contains(Q.embed(d),N.Q{a,b,c,d}) == True{} : Bool}))) -> {E.any_valid(S.vertices(N.Q{a,b,c,d}),N.Q{a,b,c,d},r) == M.inside_other(N.Q{a,b,c,d},r) : Bool}:
  match facts:
    case (ha,(hb,(hc,hd))):
      or4_equal(S.admit(Q.embed(a),N.Q{a,b,c,d},r),S.admit(Q.embed(b),N.Q{a,b,c,d},r),S.admit(Q.embed(c),N.Q{a,b,c,d},r),S.admit(Q.embed(d),N.Q{a,b,c,d},r),Region.contains(Q.embed(a),r),Region.contains(Q.embed(b),r),Region.contains(Q.embed(c),r),Region.contains(Q.embed(d),r),own_admission(Q.embed(a),N.Q{a,b,c,d},r,embedded_positive(a),ha),own_admission(Q.embed(b),N.Q{a,b,c,d},r,embedded_positive(b),hb),own_admission(Q.embed(c),N.Q{a,b,c,d},r,embedded_positive(c),hc),own_admission(Q.embed(d),N.Q{a,b,c,d},r,embedded_positive(d),hd))
def L.corner_admission_exact(q,r,hq):
  match q:
    case N.Q{+a,+b,+c,+d}: corner_admissions(a,b,c,d,r,CP.four_fields(Region.contains(Q.embed(a),N.Q{a,b,c,d}),Region.contains(Q.embed(b),N.Q{a,b,c,d}),Region.contains(Q.embed(c),N.Q{a,b,c,d}),Region.contains(Q.embed(d),N.Q{a,b,c,d}),QL.strict_quad_corners_inside(N.Q{a,b,c,d},hq)))
def or_left_true(+b:Bool) -> {Bool.or(True{},b) == True{} : Bool}:
  {==}
def append_hit(+xs:List<&2,G.Point>,+ys:List<&2,G.Point>,+q:N.Quad,+r:N.Quad,h:{E.any_valid(xs,q,r) == True{} : Bool}) -> {E.any_valid(List.append(&2,G.Point,xs,ys),q,r) == True{} : Bool}:
  Equal.trans(Bool,E.any_valid(List.append(&2,G.Point,xs,ys),q,r),Bool.or(E.any_valid(xs,q,r),E.any_valid(ys,q,r)),True{},EL.any_append(xs,ys,q,r),Equal.trans(Bool,Bool.or(E.any_valid(xs,q,r),E.any_valid(ys,q,r)),Bool.or(True{},E.any_valid(ys,q,r)),True{},Equal.cong(Bool,Bool,a => Bool.or(a,E.any_valid(ys,q,r)),E.any_valid(xs,q,r),True{},h),or_left_true(E.any_valid(ys,q,r))))
def L.contained_corner_witness(q,r,hq,h):
  EL.valid_candidate_witness(S.candidates(q,r),q,r,append_hit(S.vertices(q),List.append(&2,G.Point,S.vertices(r),S.pairs(S.edges(q),S.edges(r))),q,r,Equal.trans(Bool,E.any_valid(S.vertices(q),q,r),M.inside_other(q,r),True{},L.corner_admission_exact(q,r,hq),h)))
def hull_from_witness(+q:N.Quad,+r:N.Quad,hq:{Q.strict_quad(q) == True{} : Bool},hr:{Q.strict_quad(r) == True{} : Bool},w:E.Witness(S.candidates(q,r),q,r)) -> I.CommonPoint(q,r):
  match w:
    case (+p,(he,ha)): SL.find_hit_common_hull(q,r,p,hq,hr,he)
def L.contained_corner_common(q,r,hq,hr,h):
  hull_from_witness(q,r,hq,hr,L.contained_corner_witness(q,r,hq,h))
def swap_regions(+a:Bool,+b:Bool,+c:Bool) -> {a && b && c == a && c && b : Bool}:
  match a b c:
    case False{} False{} False{}: {==}
    case False{} False{} True{}: {==}
    case False{} True{} False{}: {==}
    case False{} True{} True{}: {==}
    case True{} False{} False{}: {==}
    case True{} False{} True{}: {==}
    case True{} True{} False{}: {==}
    case True{} True{} True{}: {==}
def any_swap(xs:List<&2,G.Point>,+q:N.Quad,+r:N.Quad) -> {E.any_valid(xs,q,r) == E.any_valid(xs,r,q) : Bool}:
  match xs:
    case Nil{}: {==}
    case Con{+p,+t}:
      Equal.trans(Bool,E.any_valid(Con{p,t},q,r),Bool.or(S.admit(p,r,q),E.any_valid(t,q,r)),E.any_valid(Con{p,t},r,q),Equal.cong(Bool,Bool,a => Bool.or(a,E.any_valid(t,q,r)),S.admit(p,q,r),S.admit(p,r,q),swap_regions(G.positive_denominator(p),Region.contains(p,q),Region.contains(p,r))),Equal.cong(Bool,Bool,b => Bool.or(S.admit(p,r,q),b),E.any_valid(t,q,r),E.any_valid(t,r,q),any_swap(t,q,r)))
def or_right_true(a:Bool) -> {Bool.or(a,True{}) == True{} : Bool}:
  match a:
    case False{}: {==}
    case True{}: {==}
def prepend_hit(+xs:List<&2,G.Point>,+ys:List<&2,G.Point>,+q:N.Quad,+r:N.Quad,h:{E.any_valid(ys,q,r) == True{} : Bool}) -> {E.any_valid(List.append(&2,G.Point,xs,ys),q,r) == True{} : Bool}:
  Equal.trans(Bool,E.any_valid(List.append(&2,G.Point,xs,ys),q,r),Bool.or(E.any_valid(xs,q,r),E.any_valid(ys,q,r)),True{},EL.any_append(xs,ys,q,r),Equal.trans(Bool,Bool.or(E.any_valid(xs,q,r),E.any_valid(ys,q,r)),Bool.or(E.any_valid(xs,q,r),True{}),True{},Equal.cong(Bool,Bool,b => Bool.or(E.any_valid(xs,q,r),b),E.any_valid(ys,q,r),True{},h),or_right_true(E.any_valid(xs,q,r))))
def L.contained_corner_witness_right(q,r,hr,h):
  EL.valid_candidate_witness(S.candidates(q,r),q,r,prepend_hit(S.vertices(q),List.append(&2,G.Point,S.vertices(r),S.pairs(S.edges(q),S.edges(r))),q,r,append_hit(S.vertices(r),S.pairs(S.edges(q),S.edges(r)),q,r,Equal.trans(Bool,E.any_valid(S.vertices(r),q,r),E.any_valid(S.vertices(r),r,q),True{},any_swap(S.vertices(r),q,r),Equal.trans(Bool,E.any_valid(S.vertices(r),r,q),M.inside_other(r,q),True{},L.corner_admission_exact(r,q,hr),h)))))
