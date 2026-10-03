import Base
import ./tracked-interval.bend as Trace
import ./intersection-search.bend as Search
import ./search-membership.bend as Member
import ./candidate-existence.bend as E
import ./quad-geometry.bend as Q
import ./natural-cover.bend as N
import ./interval-walk.bend as Walk
import ./interval-clip.bend as Clip
import ./segment-cut.bend as Cut
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region

law left_boundary_witness:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for +k:Nat
  for +l:Nat
  for +right:Trace.Endpoint
  for hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for hr:{Q.strict_quad(r) == True{} : Bool}
  for +h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{Trace.End{k,l,Trace.Boundary{a,b}},right} : Trace.Traced}
  E.Witness(Search.candidates(q,r),q,r)

law right_boundary_witness:
  for +a:N.Point
  for +b:N.Point
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for +k:Nat
  for +l:Nat
  for +left:Trace.Endpoint
  for hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for hr:{Q.strict_quad(r) == True{} : Bool}
  for +h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{left,Trace.End{k,l,Trace.Boundary{a,b}}} : Trace.Traced}
  E.Witness(Search.candidates(q,r),q,r)

# Every retained endpoint origin yields an actual selected search witness.
law retained_endpoint_witness:
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for +k:Nat
  for +l:Nat
  for +origin:Trace.Origin
  for +right:Trace.Endpoint
  for hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for hr:{Q.strict_quad(r) == True{} : Bool}
  for +h:{Trace.clip_quad(Q.embed(c),Q.embed(d),q) == Trace.Segment{Trace.End{k,l,origin},right} : Trace.Traced}
  E.Witness(Search.candidates(q,r),q,r)

# Nonempty clipping of an actual source edge guarantees an actual search hit.
law clipped_source_witness:
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for hr:{Q.strict_quad(r) == True{} : Bool}
  for hp:{Clip.present(Walk.clip_quad(q,Q.embed(c),Q.embed(d))) == True{} : Bool}
  E.Witness(Search.candidates(q,r),q,r)

# A common point on an actual source edge forces the complete search to hit.
law source_member_witness:
  for +c:N.Point
  for +d:N.Point
  for +q:N.Quad
  for +r:N.Quad
  for +point:G.Point
  for hs:Member.EdgeOccurs(Search.E{c,d},Search.edges(r))
  for hr:{Q.strict_quad(r) == True{} : Bool}
  for hm:Cut.InSegment(Q.embed(c),Q.embed(d),point)
  for hi:{Region.contains(point,q) == True{} : Bool}
  E.Witness(Search.candidates(q,r),q,r)
