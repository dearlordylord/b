import Base
import ./search-membership.bend as M
import ./search-membership-laws.bend as L
import ./intersection-search.bend as Search
import ./interval-walk.bend as Walk
import ./tracked-origin.bend as Origin
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N
import ./boolean-reflection.bend as B

def L.point_empty(point,h): h
def L.point_head(point,head,rest,h): h
def L.edge_empty(edge,h): h
def append_pair(+point:G.Point,+head:G.Point,+rest:List<&2,G.Point>,+ys:List<&2,G.Point>,h:Or({point == head : G.Point},M.PointOccurs(point,rest)),ih:M.PointOccurs(point,rest) -> M.PointOccurs(point,List.append(&2,G.Point,rest,ys))) -> M.PointOccurs(point,List.append(&2,G.Point,head <> rest,ys)):
  match h:
    case Inl{eq}: Inl{eq}
    case Inr{tail}: Inr{ih(tail)}
def L.append_left(point,xs,ys,h):
  match xs:
    case []: B.absurd(M.PointOccurs(point,ys),h)
    case head <> +rest: append_pair(point,head,rest,ys,h,hr => L.append_left(point,rest,ys,hr))
def L.append_right(point,xs,ys,h):
  match xs:
    case []: h
    case head <> rest: Inr{L.append_right(point,rest,ys,h)}
def L.converted_quad(quad):
  match quad:
    case N.Q{a,b,c,d}: {==}
def convert_pair(+edge:Walk.Edge,+head:Walk.Edge,+rest:List<&2,Walk.Edge>,h:Or({edge == head : Walk.Edge},Origin.Occurs(edge,rest)),ih:Origin.Occurs(edge,rest) -> M.EdgeOccurs(M.convert(edge),M.converted(rest))) -> M.EdgeOccurs(M.convert(edge),M.converted(head <> rest)):
  match h:
    case Inl{eq}: Inl{Equal.cong(Walk.Edge,Search.Edge,e => M.convert(e),edge,head,eq)}
    case Inr{tail}: Inr{ih(tail)}
def L.converted_occurrence(edge,edges,h):
  match edges:
    case []: B.absurd(M.EdgeOccurs(M.convert(edge),[]),h)
    case head <> +rest: convert_pair(edge,head,rest,h,hr => L.converted_occurrence(edge,rest,hr))
def branch_cases(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,cp:Bool,cq:Bool,h:{Cross.different(cp,cq) == True{} : Bool}) -> M.PointOccurs(Boundary.choose(a,b,p,q,cp),Search.cut_branch(a,b,p,q,cp,cq)):
  match cp cq:
    case True{} False{}: Inl{{==}}
    case False{} True{}: Inl{{==}}
    case True{} True{}: B.absurd(M.PointOccurs(Boundary.choose(a,b,p,q,True{}),[]),B.false_impossible(h))
    case False{} False{}: B.absurd(M.PointOccurs(Boundary.choose(a,b,p,q,False{}),[]),B.false_impossible(h))
def L.crossing_branch(a,b,p,q,h):
  branch_cases(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q),h)
def L.edge_cut(a,b,c,d,h): L.crossing_branch(a,b,Q.embed(c),Q.embed(d),h)
def row_head(+point:G.Point,+line:Search.Edge,+segment:Search.Edge,+head:Search.Edge,+rest:List<&2,Search.Edge>,eq:{segment == head : Search.Edge},hp:M.PointOccurs(point,Search.edge_cut(line,segment))) -> M.PointOccurs(point,Search.row(line,head <> rest)):
  %eq : M.PointOccurs(point,List.append(&2,G.Point,Search.edge_cut(line,_),Search.row(line,rest)))
  L.append_left(point,Search.edge_cut(line,segment),Search.row(line,rest),hp)
def row_pair(+point:G.Point,+line:Search.Edge,+segment:Search.Edge,+head:Search.Edge,+rest:List<&2,Search.Edge>,he:Or({segment == head : Search.Edge},M.EdgeOccurs(segment,rest)),hp:M.PointOccurs(point,Search.edge_cut(line,segment)),ih:M.EdgeOccurs(segment,rest) -> M.PointOccurs(point,Search.edge_cut(line,segment)) -> M.PointOccurs(point,Search.row(line,rest))) -> M.PointOccurs(point,Search.row(line,head <> rest)):
  match he:
    case Inl{eq}: row_head(point,line,segment,head,rest,eq,hp)
    case Inr{tail}: L.append_right(point,Search.edge_cut(line,head),Search.row(line,rest),ih(tail,hp))
def L.row_member(point,line,segment,segments,he,hp):
  match segments:
    case []: B.absurd(M.PointOccurs(point,[]),he)
    case head <> +rest: row_pair(point,line,segment,head,rest,he,hp,hr => hh => L.row_member(point,line,segment,rest,hr,hh))
def pairs_head(+point:G.Point,+line:Search.Edge,+head:Search.Edge,+rest:List<&2,Search.Edge>,+segments:List<&2,Search.Edge>,eq:{line == head : Search.Edge},hp:M.PointOccurs(point,Search.row(line,segments))) -> M.PointOccurs(point,Search.pairs(head <> rest,segments)):
  %eq : M.PointOccurs(point,List.append(&2,G.Point,Search.row(_,segments),Search.pairs(rest,segments)))
  L.append_left(point,Search.row(line,segments),Search.pairs(rest,segments),hp)
def pairs_pair(+point:G.Point,+line:Search.Edge,+head:Search.Edge,+rest:List<&2,Search.Edge>,+segments:List<&2,Search.Edge>,he:Or({line == head : Search.Edge},M.EdgeOccurs(line,rest)),hp:M.PointOccurs(point,Search.row(line,segments)),ih:M.EdgeOccurs(line,rest) -> M.PointOccurs(point,Search.row(line,segments)) -> M.PointOccurs(point,Search.pairs(rest,segments))) -> M.PointOccurs(point,Search.pairs(head <> rest,segments)):
  match he:
    case Inl{eq}: pairs_head(point,line,head,rest,segments,eq,hp)
    case Inr{tail}: L.append_right(point,Search.row(head,segments),Search.pairs(rest,segments),ih(tail,hp))
def L.pairs_member(point,line,lines,segments,he,hp):
  match lines:
    case []: B.absurd(M.PointOccurs(point,[]),he)
    case head <> +rest: pairs_pair(point,line,head,rest,segments,he,hp,hr => hh => L.pairs_member(point,line,rest,segments,hr,hh))
def L.candidate_member(a,b,c,d,q,r,hl,hs,hc):
  L.append_right(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),Search.vertices(q),List.append(&2,G.Point,Search.vertices(r),Search.pairs(Search.edges(q),Search.edges(r))),L.append_right(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),Search.vertices(r),Search.pairs(Search.edges(q),Search.edges(r)),L.pairs_member(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),Search.E{a,b},Search.edges(q),Search.edges(r),hl,L.row_member(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),Search.E{a,b},Search.E{c,d},Search.edges(r),hs,L.edge_cut(a,b,c,d,hc)))))
def L.quad_occurrence(edge,quad,h):
  %L.converted_quad(quad) : M.EdgeOccurs(M.convert(edge),_)
  L.converted_occurrence(edge,Walk.quad_edges(quad),h)
def L.boundary_from_origin(a,b,c,d,q,r,hl,hs,hc):
  L.candidate_member(a,b,c,d,q,r,L.quad_occurrence(Walk.Halfplane{a,b},q,hl),hs,hc)

def edge_first(edge:Search.Edge) -> G.Point:
  match edge:
    case Search.E{a,b}: Q.embed(a)
def edge_second(edge:Search.Edge) -> G.Point:
  match edge:
    case Search.E{a,b}: Q.embed(b)
def edge_vertex_equal(+a:N.Point,+b:N.Point,+edge:Search.Edge,+vertices:List<&2,G.Point>,+eq:{Search.E{a,b} == edge : Search.Edge},h:M.PointOccurs(edge_first(edge),vertices) & M.PointOccurs(edge_second(edge),vertices)) -> M.PointOccurs(Q.embed(a),vertices) & M.PointOccurs(Q.embed(b),vertices):
  %Equal.sym(G.Point,Q.embed(a),edge_first(edge),Equal.cong(Search.Edge,G.Point,e => edge_first(e),Search.E{a,b},edge,eq)) : M.PointOccurs(_,vertices) & M.PointOccurs(Q.embed(b),vertices)
  %Equal.sym(G.Point,Q.embed(b),edge_second(edge),Equal.cong(Search.Edge,G.Point,e => edge_second(e),Search.E{a,b},edge,eq)) : M.PointOccurs(edge_first(edge),vertices) & M.PointOccurs(_,vertices)
  h
def edge_vertices_3(+a:N.Point,+b:N.Point,+w:N.Point,+x:N.Point,+y:N.Point,+z:N.Point,h:M.EdgeOccurs(Search.E{a,b},[Search.E{z,w}])) -> M.PointOccurs(Q.embed(a),Search.vertices(N.Q{w,x,y,z})) & M.PointOccurs(Q.embed(b),Search.vertices(N.Q{w,x,y,z})):
  match h:
    case Inl{eq}: edge_vertex_equal(a,b,Search.E{z,w},Search.vertices(N.Q{w,x,y,z}),eq,(Inr{Inr{Inr{Inl{{==}}}}},Inl{{==}}))
    case Inr{empty}: B.absurd(M.PointOccurs(Q.embed(a),Search.vertices(N.Q{w,x,y,z})) & M.PointOccurs(Q.embed(b),Search.vertices(N.Q{w,x,y,z})),empty)
def edge_vertices_2(+a:N.Point,+b:N.Point,+w:N.Point,+x:N.Point,+y:N.Point,+z:N.Point,h:M.EdgeOccurs(Search.E{a,b},[Search.E{y,z},Search.E{z,w}])) -> M.PointOccurs(Q.embed(a),Search.vertices(N.Q{w,x,y,z})) & M.PointOccurs(Q.embed(b),Search.vertices(N.Q{w,x,y,z})):
  match h:
    case Inl{eq}: edge_vertex_equal(a,b,Search.E{y,z},Search.vertices(N.Q{w,x,y,z}),eq,(Inr{Inr{Inl{{==}}}},Inr{Inr{Inr{Inl{{==}}}}}))
    case Inr{tail}: edge_vertices_3(a,b,w,x,y,z,tail)
def edge_vertices_1(+a:N.Point,+b:N.Point,+w:N.Point,+x:N.Point,+y:N.Point,+z:N.Point,h:M.EdgeOccurs(Search.E{a,b},[Search.E{x,y},Search.E{y,z},Search.E{z,w}])) -> M.PointOccurs(Q.embed(a),Search.vertices(N.Q{w,x,y,z})) & M.PointOccurs(Q.embed(b),Search.vertices(N.Q{w,x,y,z})):
  match h:
    case Inl{eq}: edge_vertex_equal(a,b,Search.E{x,y},Search.vertices(N.Q{w,x,y,z}),eq,(Inr{Inl{{==}}},Inr{Inr{Inl{{==}}}}))
    case Inr{tail}: edge_vertices_2(a,b,w,x,y,z,tail)
def edge_vertices_0(+a:N.Point,+b:N.Point,+w:N.Point,+x:N.Point,+y:N.Point,+z:N.Point,h:M.EdgeOccurs(Search.E{a,b},[Search.E{w,x},Search.E{x,y},Search.E{y,z},Search.E{z,w}])) -> M.PointOccurs(Q.embed(a),Search.vertices(N.Q{w,x,y,z})) & M.PointOccurs(Q.embed(b),Search.vertices(N.Q{w,x,y,z})):
  match h:
    case Inl{eq}: edge_vertex_equal(a,b,Search.E{w,x},Search.vertices(N.Q{w,x,y,z}),eq,(Inl{{==}},Inr{Inl{{==}}}))
    case Inr{tail}: edge_vertices_1(a,b,w,x,y,z,tail)
def L.source_edge_vertices(a,b,quad,h):
  match quad:
    case N.Q{+w,+x,+y,+z}: edge_vertices_0(a,b,w,x,y,z,h)
