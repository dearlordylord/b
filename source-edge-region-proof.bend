import Base
import ./source-edge-region.bend as M
import ./source-edge-region-laws.bend as L
import ./search-membership.bend as Member
import ./intersection-search.bend as Search
import ./quad-geometry.bend as Q
import ./quad-geometry-laws.bend as QL
import ./quad-geometry-proof.bend as QProof
import ./halfplane-region.bend as Region
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N
import ./boolean-reflection.bend as B

def L.edge_exact(a,b,quad): {==}
def L.all_nil(quad): {==}
def L.all_cons(edge,rest,quad): {==}
def member_pair(+edge:Search.Edge,+head:Search.Edge,+rest:List<&2,Search.Edge>,+quad:N.Quad,he:Or({edge == head : Search.Edge},Member.EdgeOccurs(edge,rest)),hi:{M.edge_inside(head,quad) == True{} : Bool} & {M.all_inside(rest,quad) == True{} : Bool},ih:Member.EdgeOccurs(edge,rest) -> {M.all_inside(rest,quad) == True{} : Bool} -> {M.edge_inside(edge,quad) == True{} : Bool}) -> {M.edge_inside(edge,quad) == True{} : Bool}:
  match he:
    case Inl{eq}: Equal.trans(Bool,M.edge_inside(edge,quad),M.edge_inside(head,quad),True{},Equal.cong(Search.Edge,Bool,e => M.edge_inside(e,quad),edge,head,eq),Pair.fst({M.edge_inside(head,quad) == True{} : Bool},{M.all_inside(rest,quad) == True{} : Bool},hi))
    case Inr{tail}: ih(tail,Pair.snd({M.edge_inside(head,quad) == True{} : Bool},{M.all_inside(rest,quad) == True{} : Bool},hi))
def L.member_inside(edge,edges,quad,he,hi):
  match edges:
    case []: B.absurd({M.edge_inside(edge,quad) == True{} : Bool},he)
    case +head <> +rest: member_pair(edge,head,rest,quad,he,B.and_split(M.edge_inside(head,quad),M.all_inside(rest,quad),hi),ht => hh => L.member_inside(edge,rest,quad,ht,hh))
def edges_valid(+a:N.Point,+b:N.Point,+c:N.Point,+d:N.Point,+ha:{Region.contains(Q.embed(a),N.Q{a,b,c,d}) == True{} : Bool},+hb:{Region.contains(Q.embed(b),N.Q{a,b,c,d}) == True{} : Bool},+hc:{Region.contains(Q.embed(c),N.Q{a,b,c,d}) == True{} : Bool},+hd:{Region.contains(Q.embed(d),N.Q{a,b,c,d}) == True{} : Bool}) -> {M.all_inside(Search.edges(N.Q{a,b,c,d}),N.Q{a,b,c,d}) == True{} : Bool}:
  B.and_join(M.edge_inside(Search.E{a,b},N.Q{a,b,c,d}),M.all_inside([Search.E{b,c},Search.E{c,d},Search.E{d,a}],N.Q{a,b,c,d}),B.and_join(Region.contains(Q.embed(a),N.Q{a,b,c,d}),Region.contains(Q.embed(b),N.Q{a,b,c,d}),ha,hb),B.and_join(M.edge_inside(Search.E{b,c},N.Q{a,b,c,d}),M.all_inside([Search.E{c,d},Search.E{d,a}],N.Q{a,b,c,d}),B.and_join(Region.contains(Q.embed(b),N.Q{a,b,c,d}),Region.contains(Q.embed(c),N.Q{a,b,c,d}),hb,hc),B.and_join(M.edge_inside(Search.E{c,d},N.Q{a,b,c,d}),M.all_inside([Search.E{d,a}],N.Q{a,b,c,d}),B.and_join(Region.contains(Q.embed(c),N.Q{a,b,c,d}),Region.contains(Q.embed(d),N.Q{a,b,c,d}),hc,hd),B.and_join(M.edge_inside(Search.E{d,a},N.Q{a,b,c,d}),True{},B.and_join(Region.contains(Q.embed(d),N.Q{a,b,c,d}),Region.contains(Q.embed(a),N.Q{a,b,c,d}),hd,ha),{==}))))
def corners_edges(+a:N.Point,+b:N.Point,+c:N.Point,+d:N.Point,h:{Region.contains(Q.embed(a),N.Q{a,b,c,d}) == True{} : Bool} & ({Region.contains(Q.embed(b),N.Q{a,b,c,d}) == True{} : Bool} & ({Region.contains(Q.embed(c),N.Q{a,b,c,d}) == True{} : Bool} & {Region.contains(Q.embed(d),N.Q{a,b,c,d}) == True{} : Bool}))) -> {M.all_inside(Search.edges(N.Q{a,b,c,d}),N.Q{a,b,c,d}) == True{} : Bool}:
  match h:
    case (ha,(hb,(hc,hd))): edges_valid(a,b,c,d,ha,hb,hc,hd)
def L.quad_edges_inside(quad,h):
  match quad:
    case N.Q{+a,+b,+c,+d}: corners_edges(a,b,c,d,CP.four_fields(Region.contains(Q.embed(a),N.Q{a,b,c,d}),Region.contains(Q.embed(b),N.Q{a,b,c,d}),Region.contains(Q.embed(c),N.Q{a,b,c,d}),Region.contains(Q.embed(d),N.Q{a,b,c,d}),QL.strict_quad_corners_inside(N.Q{a,b,c,d},h)))
def L.source_endpoints_inside(a,b,quad,he,hq):
  B.and_split(Region.contains(Q.embed(a),quad),Region.contains(Q.embed(b),quad),L.member_inside(Search.E{a,b},Search.edges(quad),quad,he,L.quad_edges_inside(quad,hq)))
def weighted_pair(+a:N.Point,+b:N.Point,+quad:N.Quad,+k:Nat,+l:Nat,h:{Region.contains(Q.embed(a),quad) == True{} : Bool} & {Region.contains(Q.embed(b),quad) == True{} : Bool}) -> {Region.contains(C.join(Q.embed(a),Q.embed(b),k,l),quad) == True{} : Bool}:
  match h:
    case (ha,hb): CL.region_weighted_join(Q.embed(a),Q.embed(b),quad,k,l,ha,hb)
def L.weighted_source_inside(a,b,quad,k,l,he,hq):
  weighted_pair(a,b,quad,k,l,L.source_endpoints_inside(a,b,quad,he,hq))
