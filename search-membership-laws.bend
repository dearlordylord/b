import Base
import ./search-membership.bend as M
import ./intersection-search.bend as Search
import ./interval-walk.bend as Walk
import ./tracked-origin.bend as Origin
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./halfplane-region.bend as Region
import ./quad-geometry.bend as Q
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N

law point_empty:
  for +point:G.Point
  for h:M.PointOccurs(point,[])
  Empty
law point_head:
  for +point:G.Point
  for +head:G.Point
  for +rest:List<&2,G.Point>
  for h:M.PointOccurs(point,head <> rest)
  Or({point == head : G.Point},M.PointOccurs(point,rest))
law edge_empty:
  for +edge:Search.Edge
  for h:M.EdgeOccurs(edge,[])
  Empty
law append_left:
  for +point:G.Point
  for +xs:List<&2,G.Point>
  for +ys:List<&2,G.Point>
  for h:M.PointOccurs(point,xs)
  M.PointOccurs(point,List.append(&2,G.Point,xs,ys))
law append_right:
  for +point:G.Point
  for +xs:List<&2,G.Point>
  for +ys:List<&2,G.Point>
  for h:M.PointOccurs(point,ys)
  M.PointOccurs(point,List.append(&2,G.Point,xs,ys))
law converted_quad:
  for +quad:N.Quad
  {M.converted(Walk.quad_edges(quad)) == Search.edges(quad) : List<&2,Search.Edge>}
law converted_occurrence:
  for +edge:Walk.Edge
  for +edges:List<&2,Walk.Edge>
  for h:Origin.Occurs(edge,edges)
  M.EdgeOccurs(M.convert(edge),M.converted(edges))
law crossing_branch:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for h:{Cross.crosses(a,b,p,q) == True{} : Bool}
  M.PointOccurs(Boundary.direct(a,b,p,q),Search.cut_branch(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q)))
law edge_cut:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  for h:{Cross.crosses(a,b,Q.embed(c),Q.embed(d)) == True{} : Bool}
  M.PointOccurs(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),Search.edge_cut(Search.E{a,b},Search.E{c,d}))
# Actual row/pair assembly preserves a specified exact candidate occurrence.
law row_member:
  for +point:G.Point
  for +line:Search.Edge
  for +segment:Search.Edge
  for +segments:List<&2,Search.Edge>
  for he:M.EdgeOccurs(segment,segments)
  for hp:M.PointOccurs(point,Search.edge_cut(line,segment))
  M.PointOccurs(point,Search.row(line,segments))
law pairs_member:
  for +point:G.Point
  for +line:Search.Edge
  for +lines:List<&2,Search.Edge>
  for +segments:List<&2,Search.Edge>
  for he:M.EdgeOccurs(line,lines)
  for hp:M.PointOccurs(point,Search.row(line,segments))
  M.PointOccurs(point,Search.pairs(lines,segments))
law candidate_member:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for hl:M.EdgeOccurs(Search.E{a,b},Search.edges(q))
  for hs:M.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for hc:{Cross.crosses(a,b,Q.embed(c),Q.embed(d)) == True{} : Bool}
  M.PointOccurs(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),Search.candidates(q,r))
# A retained walk label uses the exact directed search edge, not a new list.
law quad_occurrence:
  for +edge:Walk.Edge
  for +quad:N.Quad
  for h:Origin.Occurs(edge,Walk.quad_edges(quad))
  M.EdgeOccurs(M.convert(edge),Search.edges(quad))
law boundary_from_origin:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for hl:Origin.Occurs(Walk.Halfplane{a,b},Walk.quad_edges(q))
  for hs:M.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for hc:{Cross.crosses(a,b,Q.embed(c),Q.embed(d)) == True{} : Bool}
  M.PointOccurs(Boundary.direct(a,b,Q.embed(c),Q.embed(d)),Search.candidates(q,r))

# Both endpoints of an actual directed source edge are actual search vertices.
law source_edge_vertices:
  for +a:N.Point
  for +b:N.Point
  for +quad:N.Quad
  for h:M.EdgeOccurs(Search.E{a,b},Search.edges(quad))
  M.PointOccurs(Q.embed(a),Search.vertices(quad)) & M.PointOccurs(Q.embed(b),Search.vertices(quad))
