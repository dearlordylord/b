import Base
import ./search-admission-laws.bend as L
import ./search-membership.bend as Member
import ./search-membership-laws.bend as MemberL
import ./search-membership-proof.bend as MemberProof
import ./tracked-origin.bend as Origin
import ./candidate-existence.bend as E
import ./candidate-existence-laws.bend as EL
import ./candidate-existence-proof.bend as EProof
import ./intersection-search.bend as Search
import ./interval-walk.bend as Walk
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./quad-geometry.bend as Q
import ./halfplane-region.bend as Region
import ./halfplane-equivalence-proof.bend as Equiv
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N
import ./segment-cut.bend as Cut
import ./segment-cut-laws.bend as CutL
import ./segment-cut-proof.bend as CutProof
import ./strict-complement-proof.bend as SP
import ./boolean-reflection.bend as B

def or_right_true(value:Bool) -> {Bool.or(value,True{}) == True{} : Bool}:
  match value:
    case True{}: {==}
    case False{}: {==}
def admitted_head(+point:G.Point,+head:G.Point,+rest:List<&2,G.Point>,+q:N.Quad,+r:N.Quad,eq:{point == head : G.Point},ha:{Search.admit(point,q,r) == True{} : Bool}) -> {E.any_valid(head <> rest,q,r) == True{} : Bool}:
  %eq : {E.any_valid(_ <> rest,q,r) == True{} : Bool}
  B.or_two(Search.admit(point,q,r),E.any_valid(rest,q,r),True{},E.any_valid(rest,q,r),ha,{==})
def admitted_pair(+point:G.Point,+head:G.Point,+rest:List<&2,G.Point>,+q:N.Quad,+r:N.Quad,hm:Or({point == head : G.Point},Member.PointOccurs(point,rest)),ha:{Search.admit(point,q,r) == True{} : Bool},ih:Member.PointOccurs(point,rest) -> {Search.admit(point,q,r) == True{} : Bool} -> {E.any_valid(rest,q,r) == True{} : Bool}) -> {E.any_valid(head <> rest,q,r) == True{} : Bool}:
  match hm:
    case Inl{eq}: admitted_head(point,head,rest,q,r,eq,ha)
    case Inr{tail}: Equal.trans(Bool,E.any_valid(head <> rest,q,r),Bool.or(Search.admit(head,q,r),True{}),True{},B.or_two(Search.admit(head,q,r),E.any_valid(rest,q,r),Search.admit(head,q,r),True{},{==},ih(tail,ha)),or_right_true(Search.admit(head,q,r)))
def L.occurs_any_valid(point,points,q,r,hm,ha):
  match points:
    case []: B.absurd({E.any_valid([],q,r) == True{} : Bool},hm)
    case head <> +rest: admitted_pair(point,head,rest,q,r,hm,ha,ht => hh => L.occurs_any_valid(point,rest,q,r,ht,hh))
def L.occurs_witness(point,points,q,r,hm,ha):
  EL.valid_candidate_witness(points,q,r,L.occurs_any_valid(point,points,q,r,hm,ha))
def L.search_witness(point,q,r,hm,ha):
  L.occurs_witness(point,Search.candidates(q,r),q,r,hm,ha)
def admission_fields(+point:G.Point,+other:G.Point,+q:N.Quad,+r:N.Quad,hp:{G.positive_denominator(point) == G.positive_denominator(other) : Bool},hq:{Region.contains(point,q) == Region.contains(other,q) : Bool},hr:{Region.contains(point,r) == Region.contains(other,r) : Bool}) -> {Search.admit(point,q,r) == Search.admit(other,q,r) : Bool}:
  Equal.trans(Bool,Search.admit(point,q,r),G.positive_denominator(other) && Region.contains(point,q) && Region.contains(point,r),Search.admit(other,q,r),Equal.cong(Bool,Bool,d => d && Region.contains(point,q) && Region.contains(point,r),G.positive_denominator(point),G.positive_denominator(other),hp),Equal.trans(Bool,G.positive_denominator(other) && Region.contains(point,q) && Region.contains(point,r),G.positive_denominator(other) && Region.contains(other,q) && Region.contains(point,r),Search.admit(other,q,r),Equal.cong(Bool,Bool,b => G.positive_denominator(other) && b && Region.contains(point,r),Region.contains(point,q),Region.contains(other,q),hq),Equal.cong(Bool,Bool,b => G.positive_denominator(other) && Region.contains(other,q) && b,Region.contains(point,r),Region.contains(other,r),hr)))
def L.equivalent_admission(point,other,q,r,hp,ho,he):
  admission_fields(point,other,q,r,Equal.trans(Bool,G.positive_denominator(point),True{},G.positive_denominator(other),hp,Equal.sym(Bool,G.positive_denominator(other),True{},ho)),Equiv.region_equivalent_point(point,other,q,hp,ho,he),Equiv.region_equivalent_point(point,other,r,hp,ho,he))
def valid_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,cp:Bool,cq:Bool,hp:{G.positive_denominator(p) == True{} : Bool},hq:{G.positive_denominator(q) == True{} : Bool},hi:{Region.edge(a,b,p) == cp : Bool},ho:{Region.edge(a,b,q) == cq : Bool},hc:{Cross.different(cp,cq) == True{} : Bool}) -> {G.positive_denominator(Boundary.choose(a,b,p,q,cp)) == True{} : Bool}:
  match cp cq:
    case True{} False{}: CutL.crossing_denominator_positive(a,b,p,q,hp,hq,SP.negative_from_false(a,b,q,ho))
    case False{} True{}: CutL.crossing_denominator_positive(a,b,q,p,hq,hp,SP.negative_from_false(a,b,p,hi))
    case True{} True{}: B.absurd({G.positive_denominator(Boundary.choose(a,b,p,q,True{})) == True{} : Bool},B.false_impossible(hc))
    case False{} False{}: B.absurd({G.positive_denominator(Boundary.choose(a,b,p,q,False{})) == True{} : Bool},B.false_impossible(hc))
def L.direct_valid(a,b,p,q,hp,hq,hc):
  valid_cases(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q),hp,hq,{==},{==},hc)
def embedded_positive(point:N.Point) -> {G.positive_denominator(Q.embed(point)) == True{} : Bool}:
  match point:
    case N.P{x,y}: {==}
def common_admission(+point:G.Point,+q:N.Quad,+r:N.Quad,hp:{G.positive_denominator(point) == True{} : Bool},hi:{Region.contains(point,q) == True{} : Bool},hj:{Region.contains(point,r) == True{} : Bool}) -> {Search.admit(point,q,r) == True{} : Bool}:
  B.and_join(G.positive_denominator(point) && Region.contains(point,q),Region.contains(point,r),B.and_join(G.positive_denominator(point),Region.contains(point,q),hp,hi),hj)
def L.boundary_search_witness(a,b,c,d,q,r,point,hl,hs,hc,hp,he,hi,hj):
  L.search_witness(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),q,r,MemberL.boundary_from_origin(a,b,c,d,q,r,hl,hs,hc),Equal.trans(Bool,Search.admit(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),q,r),Search.admit(point,q,r),True{},Equal.sym(Bool,Search.admit(point,q,r),Search.admit(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),q,r),L.equivalent_admission(point,Boundary.direct(a,b,Q.embed(c),Q.embed(d)),q,r,hp,L.direct_valid(a,b,Q.embed(c),Q.embed(d),embedded_positive(c),embedded_positive(d),hc),he)),common_admission(point,q,r,hp,hi,hj)))
