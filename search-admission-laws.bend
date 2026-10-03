import Base
import ./search-membership.bend as Member
import ./tracked-origin.bend as Origin
import ./candidate-existence.bend as E
import ./intersection-search.bend as Search
import ./interval-walk.bend as Walk
import ./source-crossing.bend as Cross
import ./source-boundary.bend as Boundary
import ./quad-geometry.bend as Q
import ./halfplane-region.bend as Region
import ./homogeneous-geometry.bend as G
import ./natural-cover.bend as N

# Occurrence plus actual admission forces the list's existence predicate.
law occurs_any_valid:
  for +point:G.Point
  for +points:List<&2,G.Point>
  for +q:N.Quad
  for +r:N.Quad
  for hm:Member.PointOccurs(point,points)
  for ha:{Search.admit(point,q,r) == True{} : Bool}
  {E.any_valid(points,q,r) == True{} : Bool}
law occurs_witness:
  for +point:G.Point
  for +points:List<&2,G.Point>
  for +q:N.Quad
  for +r:N.Quad
  for hm:Member.PointOccurs(point,points)
  for ha:{Search.admit(point,q,r) == True{} : Bool}
  E.Witness(points,q,r)
law search_witness:
  for +point:G.Point
  for +q:N.Quad
  for +r:N.Quad
  for hm:Member.PointOccurs(point,Search.candidates(q,r))
  for ha:{Search.admit(point,q,r) == True{} : Bool}
  E.Witness(Search.candidates(q,r),q,r)
# Valid projective representatives have identical common-region admission.
law equivalent_admission:
  for +point:G.Point
  for +other:G.Point
  for +q:N.Quad
  for +r:N.Quad
  for +hp:{G.positive_denominator(point) == True{} : Bool}
  for +ho:{G.positive_denominator(other) == True{} : Bool}
  for +he:{G.equivalent(point,other) == True{} : Bool}
  {Search.admit(point,q,r) == Search.admit(other,q,r) : Bool}
law direct_valid:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for hp:{G.positive_denominator(p) == True{} : Bool}
  for hq:{G.positive_denominator(q) == True{} : Bool}
  for hc:{Cross.crosses(a,b,p,q) == True{} : Bool}
  {G.positive_denominator(Boundary.direct(a,b,p,q)) == True{} : Bool}
# A valid retained common point, its geometric cut correspondence and its
# directed source/line occurrences construct the actual selected search hit.
law boundary_search_witness:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for +point:G.Point
  for hl:Origin.Occurs(Walk.Halfplane{a,b},Walk.quad_edges(q))
  for hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for +hc:{Cross.crosses(a,b,Q.embed(c),Q.embed(d)) == True{} : Bool}
  for +hp:{G.positive_denominator(point) == True{} : Bool}
  for he:{G.equivalent(point,Boundary.direct(a,b,Q.embed(c),Q.embed(d))) == True{} : Bool}
  for hi:{Region.contains(point,q) == True{} : Bool}
  for hj:{Region.contains(point,r) == True{} : Bool}
  E.Witness(Search.candidates(q,r),q,r)
