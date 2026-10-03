import Base
import ./source-boundary.bend as M
import ./source-crossing.bend as Cross
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut
import ./strict-halfplane.bend as S
import ./tracked-interval.bend as Trace

# The search representative always uses the closed source endpoint first.
law direct_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  {M.direct(a,b,p,q) == M.choose(a,b,p,q,Region.edge(a,b,p)) : G.Point}
law choose_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  {M.choose(a,b,p,q,True{}) == Cut.point(a,b,p,q) : G.Point} & {M.choose(a,b,p,q,False{}) == Cut.point(a,b,q,p) : G.Point}
# Any source combination on a crossed boundary equals the direct search cut,
# projectively; it need not have the same raw homogeneous coefficients.
law boundary_direct:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for hc:{Cross.crosses(a,b,p,q) == True{} : Bool}
  for hl:{Cut.on_line(a,b,C.join(p,q,k,l)) == True{} : Bool}
  {G.equivalent(C.join(p,q,k,l),M.direct(a,b,p,q)) == True{} : Bool}
# A real clipping step forces source crossing; arbitrary labels do not.
law traced_cut_crosses:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +left:Trace.Endpoint
  for +right:Trace.Endpoint
  for hv:{G.positive_denominator(Trace.point(p,q,left)) == True{} : Bool}
  for hi:{Region.edge(a,b,Trace.point(p,q,left)) == True{} : Bool}
  for ho:{S.negative(a,b,Trace.point(p,q,right)) == True{} : Bool}
  {Cross.crosses(a,b,p,q) == True{} : Bool}
# The actual newly clipped endpoint matches the source-search representative.
law traced_cut_direct:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +left:Trace.Endpoint
  for +right:Trace.Endpoint
  for hv:{G.positive_denominator(Trace.point(p,q,left)) == True{} : Bool}
  for +hi:{Region.edge(a,b,Trace.point(p,q,left)) == True{} : Bool}
  for +ho:{S.negative(a,b,Trace.point(p,q,right)) == True{} : Bool}
  {G.equivalent(Trace.point(p,q,Trace.cut_endpoint(a,b,p,q,left,right)),M.direct(a,b,p,q)) == True{} : Bool}
