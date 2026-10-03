import Base
import ./interval-clip.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./halfplane-region.bend as Region
import ./segment-cut.bend as Cut

# Reference choices are independent of the implementation's branch selection.
def reference(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,cp:Bool,cq:Bool) -> M.ClipResult:
  match cp cq:
    case True{} True{}: M.Span{p,q}
    case True{} False{}: M.Span{p,Cut.point(a,b,p,q)}
    case False{} True{}: M.Span{q,Cut.point(a,b,q,p)}
    case False{} False{}: M.Gone{}
def spec(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point) -> M.ClipResult:
  reference(a,b,p,q,Region.edge(a,b,p),Region.edge(a,b,q))
def closed_spec(+a:N.Point,+b:N.Point,result:M.ClipResult) -> Bool:
  match result:
    case M.Gone{}: True{}
    case M.Span{+p,+q}: (G.positive_denominator(p) && G.positive_denominator(q)) && (Region.edge(a,b,p) && Region.edge(a,b,q))
def region_spec(+r:N.Quad,result:M.ClipResult) -> Bool:
  match result:
    case M.Gone{}: True{}
    case M.Span{p,q}: Region.contains(p,r) && Region.contains(q,r)
def present_spec(result:M.ClipResult) -> Bool:
  match result:
    case M.Gone{}: False{}
    case M.Span{p,q}: True{}
# The specification, not an implementation report, owns constructive membership.
def Member(result:M.ClipResult,-r:G.Point) -> Type:
  match result:
    case M.Gone{}: Empty
    case M.Span{p,q}: Cut.InSegment(p,q,r)

law choose_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +cp:Bool
  for +cq:Bool
  {M.choose(a,b,p,q,cp,cq) == reference(a,b,p,q,cp,cq) : M.ClipResult}

law clip_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  {M.clip(a,b,p,q) == spec(a,b,p,q) : M.ClipResult}

law closed_report_exact:
  for +a:N.Point
  for +b:N.Point
  for +result:M.ClipResult
  {M.closed_valid(a,b,result) == closed_spec(a,b,result) : Bool}

law region_report_exact:
  for +r:N.Quad
  for +result:M.ClipResult
  {M.in_region(r,result) == region_spec(r,result) : Bool}

law present_report_exact:
  for +result:M.ClipResult
  {M.present(result) == present_spec(result) : Bool}

law clip_closed_valid:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  {M.closed_valid(a,b,M.clip(a,b,p,q)) == True{} : Bool}

law clip_region_preserved:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +r:N.Quad
  for hp:{Region.contains(p,r) == True{} : Bool}
  for hq:{Region.contains(q,r) == True{} : Bool}
  {M.in_region(r,M.clip(a,b,p,q)) == True{} : Bool}

law clip_present_exact:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  {M.present(M.clip(a,b,p,q)) == Region.edge(a,b,p) || Region.edge(a,b,q) : Bool}

law retained_present:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  {M.present(M.clip(a,b,p,q)) == True{} : Bool}

law retained_member:
  for +a:N.Point
  for +b:N.Point
  for +p:G.Point
  for +q:G.Point
  for +k:Nat
  for +l:Nat
  for +hp:{G.positive_denominator(p) == True{} : Bool}
  for +hq:{G.positive_denominator(q) == True{} : Bool}
  for +hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}
  for h:{Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}
  Member(M.clip(a,b,p,q),C.join(p,q,k,l))
