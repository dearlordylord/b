import Base
import ./interval-walk.bend as M
import ./interval-walk-laws.bend as L
import ./interval-clip.bend as Clip
import ./interval-clip-laws.bend as ClipL
import ./interval-clip-proof.bend as ClipP
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./homogeneous-combination.bend as C
import ./homogeneous-combination-laws.bend as CL
import ./homogeneous-combination-proof.bend as CP
import ./halfplane-region.bend as Region
import ./halfplane-equivalence-proof.bend as RP
import ./segment-cut.bend as Cut
import ./boolean-reflection.bend as B

def L.accepts_exact(edge,p):
  match edge:
    case M.Halfplane{a,b}: {==}
def L.inside_exact(p,edges):
  match edges:
    case []: {==}
    case +edge <> +rest:
      %L.accepts_exact(edge,p) : {M.accepts(edge,p) && M.inside(p,rest) == _ && L.reference_inside(p,rest) : Bool}
      %L.inside_exact(p,rest) : {M.accepts(edge,p) && M.inside(p,rest) == M.accepts(edge,p) && _ : Bool}
      {==}
def L.valid_exact(result):
  match result:
    case Clip.Gone{}: {==}
    case Clip.Span{p,q}: {==}
def L.closed_exact(edges,result):
  match result:
    case Clip.Gone{}: {==}
    case Clip.Span{+p,+q}:
      %L.inside_exact(p,edges) : {M.inside(p,edges) && M.inside(q,edges) == _ && L.reference_inside(q,edges) : Bool}
      %L.inside_exact(q,edges) : {M.inside(p,edges) && M.inside(q,edges) == M.inside(p,edges) && _ : Bool}
      {==}
def L.step_exact(edge,result):
  match edge result:
    case M.Halfplane{a,b} Clip.Gone{}: {==}
    case M.Halfplane{a,b} Clip.Span{p,q}: ClipL.clip_exact(a,b,p,q)
def L.run_nil(result):
  {==}
def L.run_cons(edge,rest,result):
  {==}
def four_bool(+a:Bool,+b:Bool,+c:Bool,+d:Bool) -> {a && (b && (c && (d && True{}))) == ((a && b) && c) && d : Bool}:
  match a b c d:
    case False{} x y z: {==}
    case True{} False{} y z: {==}
    case True{} True{} False{} z: {==}
    case True{} True{} True{} False{}: {==}
    case True{} True{} True{} True{}: {==}
def L.quad_membership_exact(p,q):
  match q:
    case N.Q{a,b,c,d}: four_bool(Region.edge(a,b,p),Region.edge(b,c,p),Region.edge(c,d,p),Region.edge(d,a,p))
def first_truth(+a:Bool,+b:Bool,h:{a && b == True{} : Bool}) -> {a == True{} : Bool}:
  match a:
    case False{}: B.absurd({False{} == True{} : Bool},B.false_impossible(h))
    case True{}: {==}
def valid_from_closed(+a:N.Point,+b:N.Point,result:Clip.ClipResult,h:{Clip.closed_valid(a,b,result) == True{} : Bool}) -> {M.valid(result) == True{} : Bool}:
  match result:
    case Clip.Gone{}: {==}
    case Clip.Span{+p,+q}: first_truth(G.positive_denominator(p) && G.positive_denominator(q),Region.edge(a,b,p) && Region.edge(a,b,q),h)

def valid_step_pair(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,h:{G.positive_denominator(p) == True{} : Bool} & {G.positive_denominator(q) == True{} : Bool}) -> {M.valid(Clip.clip(a,b,p,q)) == True{} : Bool}:
  match h:
    case (hp,hq): valid_from_closed(a,b,Clip.clip(a,b,p,q),ClipL.clip_closed_valid(a,b,p,q,hp,hq))
def valid_step_span(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,h:{M.valid(Clip.Span{p,q}) == True{} : Bool}) -> {M.valid(Clip.clip(a,b,p,q)) == True{} : Bool}:
  valid_step_pair(a,b,p,q,B.and_split(G.positive_denominator(p),G.positive_denominator(q),h))
def L.step_valid(edge,result,h):
  match edge result:
    case M.Halfplane{a,b} Clip.Gone{}: {==}
    case M.Halfplane{a,b} Clip.Span{p,q}: valid_step_span(a,b,p,q,h)

def second_truth(+a:Bool,+b:Bool,h:{a && b == True{} : Bool}) -> {b == True{} : Bool}:
  match a:
    case False{}: B.absurd({b == True{} : Bool},B.false_impossible(h))
    case True{}: h
def singleton_point(+a:N.Point,+b:N.Point,+p:G.Point,h:{Region.edge(a,b,p) == True{} : Bool}) -> {M.inside(p,[M.Halfplane{a,b}]) == True{} : Bool}:
  B.and_join(Region.edge(a,b,p),True{},h,{==})
def closed_single_pair(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,h:{Region.edge(a,b,p) == True{} : Bool} & {Region.edge(a,b,q) == True{} : Bool}) -> {M.closed([M.Halfplane{a,b}],Clip.Span{p,q}) == True{} : Bool}:
  match h:
    case (hp,hq): B.and_join(M.inside(p,[M.Halfplane{a,b}]),M.inside(q,[M.Halfplane{a,b}]),singleton_point(a,b,p,hp),singleton_point(a,b,q,hq))
def closed_single(+a:N.Point,+b:N.Point,result:Clip.ClipResult,h:{Clip.closed_valid(a,b,result) == True{} : Bool}) -> {M.closed([M.Halfplane{a,b}],result) == True{} : Bool}:
  match result:
    case Clip.Gone{}: {==}
    case Clip.Span{+p,+q}: closed_single_pair(a,b,p,q,B.and_split(Region.edge(a,b,p),Region.edge(a,b,q),second_truth(G.positive_denominator(p) && G.positive_denominator(q),Region.edge(a,b,p) && Region.edge(a,b,q),h)))

def closed_step_pair(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,h:{G.positive_denominator(p) == True{} : Bool} & {G.positive_denominator(q) == True{} : Bool}) -> {M.closed([M.Halfplane{a,b}],Clip.clip(a,b,p,q)) == True{} : Bool}:
  match h:
    case (hp,hq): closed_single(a,b,Clip.clip(a,b,p,q),ClipL.clip_closed_valid(a,b,p,q,hp,hq))
def L.step_closed(edge,result,h):
  match edge result:
    case M.Halfplane{a,b} Clip.Gone{}: {==}
    case M.Halfplane{a,b} Clip.Span{+p,+q}: closed_step_pair(a,b,p,q,B.and_split(G.positive_denominator(p),G.positive_denominator(q),h))
def region_join(a:N.Point,b:N.Point,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,hp:{Region.edge(a,b,p) == True{} : Bool},hq:{Region.edge(a,b,q) == True{} : Bool}) -> {Region.edge(a,b,C.join(p,q,k,l)) == True{} : Bool}:
  match a b:
    case N.P{ax,ay} N.P{bx,by}: CL.halfplane_weighted_join(ax,ay,bx,by,p,q,k,l,hp,hq)
def edge_join(edge:M.Edge,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,hp:{M.accepts(edge,p) == True{} : Bool},hq:{M.accepts(edge,q) == True{} : Bool}) -> {M.accepts(edge,C.join(p,q,k,l)) == True{} : Bool}:
  match edge:
    case M.Halfplane{a,b}: region_join(a,b,p,q,k,l,hp,hq)

def join_inside(+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,edges:List<&2,M.Edge>,+hp:{M.inside(p,edges) == True{} : Bool},+hq:{M.inside(q,edges) == True{} : Bool}) -> {M.inside(C.join(p,q,k,l),edges) == True{} : Bool}:
  match edges:
    case []: {==}
    case +edge <> +rest: B.and_join(M.accepts(edge,C.join(p,q,k,l)),M.inside(C.join(p,q,k,l),rest),edge_join(edge,p,q,k,l,first_truth(M.accepts(edge,p),M.inside(p,rest),hp),first_truth(M.accepts(edge,q),M.inside(q,rest),hq)),join_inside(p,q,k,l,rest,second_truth(M.accepts(edge,p),M.inside(p,rest),hp),second_truth(M.accepts(edge,q),M.inside(q,rest),hq)))
def choose_preserves(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+edges:List<&2,M.Edge>,cp:Bool,cq:Bool,+hp:{M.inside(p,edges) == True{} : Bool},+hq:{M.inside(q,edges) == True{} : Bool}) -> {M.closed(edges,Clip.choose(a,b,p,q,cp,cq)) == True{} : Bool}:
  match cp cq:
    case True{} True{}: B.and_join(M.inside(p,edges),M.inside(q,edges),hp,hq)
    case True{} False{}: B.and_join(M.inside(p,edges),M.inside(Cut.point(a,b,p,q),edges),hp,join_inside(p,q,Cut.first_weight(a,b,q),Cut.second_weight(a,b,p),edges,hp,hq))
    case False{} True{}: B.and_join(M.inside(q,edges),M.inside(Cut.point(a,b,q,p),edges),hq,join_inside(q,p,Cut.first_weight(a,b,p),Cut.second_weight(a,b,q),edges,hq,hp))
    case False{} False{}: {==}
def preserves_pair(+a:N.Point,+b:N.Point,+p:G.Point,+q:G.Point,+edges:List<&2,M.Edge>,h:{M.inside(p,edges) == True{} : Bool} & {M.inside(q,edges) == True{} : Bool}) -> {M.closed(edges,Clip.clip(a,b,p,q)) == True{} : Bool}:
  match h:
    case (hp,hq): choose_preserves(a,b,p,q,edges,Region.edge(a,b,p),Region.edge(a,b,q),hp,hq)
def L.step_preserves(edge,edges,result,h):
  match edge result:
    case M.Halfplane{a,b} Clip.Gone{}: {==}
    case M.Halfplane{a,b} Clip.Span{+p,+q}: preserves_pair(a,b,p,q,edges,B.and_split(M.inside(p,edges),M.inside(q,edges),h))
def L.run_valid(edges,result,h):
  match edges:
    case []: h
    case +edge <> rest: L.run_valid(rest,M.step(edge,result),L.step_valid(edge,result,h))
def L.run_preserves(edges,prior,result,h):
  match edges:
    case []: h
    case +edge <> rest: L.run_preserves(rest,prior,M.step(edge,result),L.step_preserves(edge,prior,result,h))
def closed_nil(result:Clip.ClipResult) -> {M.closed([],result) == True{} : Bool}:
  match result:
    case Clip.Gone{}: {==}
    case Clip.Span{p,q}: {==}
def combine_point(+edge:M.Edge,+rest:List<&2,M.Edge>,+p:G.Point,h:{M.inside(p,[edge]) == True{} : Bool},k:{M.inside(p,rest) == True{} : Bool}) -> {M.inside(p,edge <> rest) == True{} : Bool}:
  B.and_join(M.accepts(edge,p),M.inside(p,rest),first_truth(M.accepts(edge,p),True{},h),k)
def combine_closed(+edge:M.Edge,+rest:List<&2,M.Edge>,result:Clip.ClipResult,+h:{M.closed([edge],result) == True{} : Bool},+k:{M.closed(rest,result) == True{} : Bool}) -> {M.closed(edge <> rest,result) == True{} : Bool}:
  match result:
    case Clip.Gone{}: {==}
    case Clip.Span{+p,+q}: B.and_join(M.inside(p,edge <> rest),M.inside(q,edge <> rest),combine_point(edge,rest,p,first_truth(M.inside(p,[edge]),M.inside(q,[edge]),h),first_truth(M.inside(p,rest),M.inside(q,rest),k)),combine_point(edge,rest,q,second_truth(M.inside(p,[edge]),M.inside(q,[edge]),h),second_truth(M.inside(p,rest),M.inside(q,rest),k)))
def L.run_closed(edges,result,h):
  match edges:
    case []: closed_nil(result)
    case +edge <> +rest: combine_closed(edge,rest,M.run(rest,M.step(edge,result)),L.run_preserves(rest,[edge],M.step(edge,result),L.step_closed(edge,result,h)),L.run_closed(rest,M.step(edge,result),L.step_valid(edge,result,h)))

def inside_equivalent_edge(+p:G.Point,+q:G.Point,edge:M.Edge,+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},+hs:{G.equivalent(p,q) == True{} : Bool}) -> {M.accepts(edge,p) == M.accepts(edge,q) : Bool}:
  match edge:
    case M.Halfplane{a,b}: RP.edge_equivalent(p,q,a,b,hp,hq,hs)
def inside_equivalent(+p:G.Point,+q:G.Point,edges:List<&2,M.Edge>,+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},+hs:{G.equivalent(p,q) == True{} : Bool}) -> {M.inside(p,edges) == M.inside(q,edges) : Bool}:
  match edges:
    case []: {==}
    case +edge <> +rest:
      %inside_equivalent_edge(p,q,edge,hp,hq,hs) : {M.accepts(edge,p) && M.inside(p,rest) == _ && M.inside(q,rest) : Bool}
      %inside_equivalent(p,q,rest,hp,hq,hs) : {M.accepts(edge,p) && M.inside(p,rest) == M.accepts(edge,p) && _ : Bool}
      {==}
def advance_closed(+a:N.Point,+b:N.Point,+rest:List<&2,M.Edge>,+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,+hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},+h:{M.inside(C.join(p,q,k,l),M.Halfplane{a,b} <> rest) == True{} : Bool},ih:@next:Clip.ClipResult -> @s:G.Point -> ClipL.Member(next,s) -> {M.inside(s,rest) == True{} : Bool} -> {Clip.present(M.run(rest,next)) == True{} : Bool}) -> {Clip.present(M.run(rest,Clip.clip(a,b,p,q))) == True{} : Bool}:
  ih(Clip.clip(a,b,p,q),C.join(p,q,k,l),ClipL.retained_member(a,b,p,q,k,l,hp,hq,hs,first_truth(Region.edge(a,b,C.join(p,q,k,l)),M.inside(C.join(p,q,k,l),rest),h)),second_truth(Region.edge(a,b,C.join(p,q,k,l)),M.inside(C.join(p,q,k,l),rest),h))
def advance(+a:N.Point,+b:N.Point,+rest:List<&2,M.Edge>,+p:G.Point,+q:G.Point,+r:G.Point,+k:Nat,+l:Nat,+hs:{Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool},+hp:{G.positive_denominator(p) == True{} : Bool},+hq:{G.positive_denominator(q) == True{} : Bool},hr:{G.positive_denominator(r) == True{} : Bool},same:{G.equivalent(r,C.join(p,q,k,l)) == True{} : Bool},h:{M.inside(r,M.Halfplane{a,b} <> rest) == True{} : Bool},ih:@next:Clip.ClipResult -> @s:G.Point -> ClipL.Member(next,s) -> {M.inside(s,rest) == True{} : Bool} -> {Clip.present(M.run(rest,next)) == True{} : Bool}) -> {Clip.present(M.run(rest,Clip.clip(a,b,p,q))) == True{} : Bool}:
  advance_closed(a,b,rest,p,q,k,l,hs,hp,hq,Equal.trans(Bool,M.inside(C.join(p,q,k,l),M.Halfplane{a,b} <> rest),M.inside(r,M.Halfplane{a,b} <> rest),True{},Equal.sym(Bool,M.inside(r,M.Halfplane{a,b} <> rest),M.inside(C.join(p,q,k,l),M.Halfplane{a,b} <> rest),inside_equivalent(r,C.join(p,q,k,l),M.Halfplane{a,b} <> rest,hr,CL.joined_denominator_positive(p,q,k,l,hp,hq,hs),same)),h),ih)
def span_member(+a:N.Point,+b:N.Point,+rest:List<&2,M.Edge>,+p:G.Point,+q:G.Point,+r:G.Point,member:Cut.InSegment(p,q,r),h:{M.inside(r,M.Halfplane{a,b} <> rest) == True{} : Bool},ih:@next:Clip.ClipResult -> @s:G.Point -> ClipL.Member(next,s) -> {M.inside(s,rest) == True{} : Bool} -> {Clip.present(M.run(rest,next)) == True{} : Bool}) -> {Clip.present(M.run(rest,Clip.clip(a,b,p,q))) == True{} : Bool}:
  match member:
    case (+k,(+l,(+hs,(+hp,(+hq,(hr,same)))))): advance(a,b,rest,p,q,r,k,l,hs,hp,hq,hr,same,h,ih)
def span_edge(edge:M.Edge,+rest:List<&2,M.Edge>,+p:G.Point,+q:G.Point,+r:G.Point,member:Cut.InSegment(p,q,r),h:{M.inside(r,edge <> rest) == True{} : Bool},ih:@next:Clip.ClipResult -> @s:G.Point -> ClipL.Member(next,s) -> {M.inside(s,rest) == True{} : Bool} -> {Clip.present(M.run(rest,next)) == True{} : Bool}) -> {Clip.present(M.run(rest,M.step(edge,Clip.Span{p,q}))) == True{} : Bool}:
  match edge:
    case M.Halfplane{a,b}: span_member(a,b,rest,p,q,r,member,h,ih)
def walk_member(edges:List<&2,M.Edge>,+result:Clip.ClipResult,+p:G.Point,member:ClipL.Member(result,p),h:{M.inside(p,edges) == True{} : Bool}) -> {Clip.present(M.run(edges,result)) == True{} : Bool}:
  match edges result:
    case [] Clip.Gone{}: B.absurd({Clip.present(Clip.Gone{}) == True{} : Bool},member)
    case [] Clip.Span{q,r}: {==}
    case edge <> rest Clip.Gone{}: B.absurd({Clip.present(M.run(rest,M.step(edge,Clip.Gone{}))) == True{} : Bool},member)
    case +edge <> +rest Clip.Span{+q,+r}: span_edge(edge,rest,q,r,p,member,h,next => s => hm => hi => walk_member(rest,next,s,hm,hi))
def L.run_retained_present(edges,result,p,member,h):
  walk_member(edges,result,p,member,h)

def L.quad_edges_exact(a,b,c,d):
  {==}
def L.clip_quad_exact(quad,p,q):
  {==}
def closed_quad(+quad:N.Quad,result:Clip.ClipResult,h:{M.closed(M.quad_edges(quad),result) == True{} : Bool}) -> {Clip.in_region(quad,result) == True{} : Bool}:
  match result:
    case Clip.Gone{}: {==}
    case Clip.Span{+p,+q}:
      %L.quad_membership_exact(p,quad) : {_ && Region.contains(q,quad) == True{} : Bool}
      %L.quad_membership_exact(q,quad) : {M.inside(p,M.quad_edges(quad)) && _ == True{} : Bool}
      h
def L.quad_closed_valid(quad,p,q,hp,hq):
  (L.run_valid(M.quad_edges(quad),Clip.Span{p,q},B.and_join(G.positive_denominator(p),G.positive_denominator(q),hp,hq)),closed_quad(quad,M.clip_quad(quad,p,q),L.run_closed(M.quad_edges(quad),Clip.Span{p,q},B.and_join(G.positive_denominator(p),G.positive_denominator(q),hp,hq))))
def L.quad_retained_present(quad,p,q,r,member,h):
  L.run_retained_present(M.quad_edges(quad),Clip.Span{p,q},r,member,Equal.trans(Bool,M.inside(r,M.quad_edges(quad)),Region.contains(r,quad),True{},L.quad_membership_exact(r,quad),h))
