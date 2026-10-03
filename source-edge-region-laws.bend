import Base
import ./source-edge-region.bend as M
import ./search-membership.bend as Member
import ./intersection-search.bend as Search
import ./quad-geometry.bend as Q
import ./halfplane-region.bend as Region
import ./homogeneous-combination.bend as C
import ./natural-cover.bend as N

law edge_exact:
  for +a:N.Point
  for +b:N.Point
  for +quad:N.Quad
  {M.edge_inside(Search.E{a,b},quad) == Region.contains(Q.embed(a),quad) && Region.contains(Q.embed(b),quad) : Bool}
law all_nil:
  for +quad:N.Quad
  {M.all_inside([],quad) == True{} : Bool}
law all_cons:
  for +edge:Search.Edge
  for +rest:List<&2,Search.Edge>
  for +quad:N.Quad
  {M.all_inside(edge <> rest,quad) == M.edge_inside(edge,quad) && M.all_inside(rest,quad) : Bool}
law member_inside:
  for +edge:Search.Edge
  for +edges:List<&2,Search.Edge>
  for +quad:N.Quad
  for he:Member.EdgeOccurs(edge,edges)
  for hi:{M.all_inside(edges,quad) == True{} : Bool}
  {M.edge_inside(edge,quad) == True{} : Bool}
law quad_edges_inside:
  for +quad:N.Quad
  for h:{Q.strict_quad(quad) == True{} : Bool}
  {M.all_inside(Search.edges(quad),quad) == True{} : Bool}
law source_endpoints_inside:
  for +a:N.Point
  for +b:N.Point
  for +quad:N.Quad
  for he:Member.EdgeOccurs(Search.E{a,b},Search.edges(quad))
  for hq:{Q.strict_quad(quad) == True{} : Bool}
  {Region.contains(Q.embed(a),quad) == True{} : Bool} & {Region.contains(Q.embed(b),quad) == True{} : Bool}
# The source's actual nonnegative endpoint coefficients preserve its region.
law weighted_source_inside:
  for +a:N.Point
  for +b:N.Point
  for +quad:N.Quad
  for +k:Nat
  for +l:Nat
  for he:Member.EdgeOccurs(Search.E{a,b},Search.edges(quad))
  for hq:{Q.strict_quad(quad) == True{} : Bool}
  {Region.contains(C.join(Q.embed(a),Q.embed(b),k,l),quad) == True{} : Bool}
