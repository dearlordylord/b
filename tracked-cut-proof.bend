import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region
import ./strict-halfplane.bend as S
import ./segment-cut.bend as Cut
import ./segment-cut-laws.bend as CutL
import ./segment-cut-proof.bend as CutProof
import ./segment-provenance-laws.bend as SourceL
import ./segment-provenance-proof.bend as SourceProof
import ./tracked-interval.bend as Trace

def cut_point_exact(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,left:Trace.Endpoint,right:Trace.Endpoint) -> {Trace.point(p,q,Trace.cut_endpoint(a,b,p,q,left,right)) == Cut.point(a,b,Trace.point(p,q,left),Trace.point(p,q,right)) : G.Point}:
  match left right:
    case Trace.End{k,l,lo} Trace.End{m,n,ro}: SourceL.source_cut_exact(a,b,p,q,k,l,m,n)
def cut_line(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+left:Trace.Endpoint,+right:Trace.Endpoint,hi:{Region.edge(a,b,Trace.point(p,q,left)) == True{} : Bool},ho:{S.negative(a,b,Trace.point(p,q,right)) == True{} : Bool}) -> {Cut.on_line(a,b,Trace.point(p,q,Trace.cut_endpoint(a,b,p,q,left,right))) == True{} : Bool}:
  Equal.trans(Bool,Cut.on_line(a,b,Trace.point(p,q,Trace.cut_endpoint(a,b,p,q,left,right))),Cut.on_line(a,b,Cut.point(a,b,Trace.point(p,q,left),Trace.point(p,q,right))),True{},Equal.cong(G.Point,Bool,r => Cut.on_line(a,b,r),Trace.point(p,q,Trace.cut_endpoint(a,b,p,q,left,right)),Cut.point(a,b,Trace.point(p,q,left),Trace.point(p,q,right)),cut_point_exact(a,b,p,q,left,right)),CutL.crossing_on_line(a,b,Trace.point(p,q,left),Trace.point(p,q,right),hi,ho))
