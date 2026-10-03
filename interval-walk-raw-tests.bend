import Base
import ./interval-walk.bend as M
import ./interval-clip.bend as Clip
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./interval-walk-fixtures.bend as F

def all_four_edges() -> {M.quad_edges(F.box()) == [M.Halfplane{N.P{1n,1n},N.P{3n,1n}},M.Halfplane{N.P{3n,1n},N.P{3n,3n}},M.Halfplane{N.P{3n,3n},N.P{1n,3n}},M.Halfplane{N.P{1n,3n},N.P{1n,1n}}] : List<&2,M.Edge>}: {==}
def two_cuts() -> {M.clip_quad(F.box(),F.p(),F.q()) == Clip.Span{G.P{24n,16n,8n},G.P{48n,96n,48n}} : Clip.ClipResult}: {==}
def reverse_two_cuts() -> {M.clip_quad(F.box(),F.q(),F.p()) == Clip.Span{G.P{24n,16n,8n},G.P{48n,96n,48n}} : Clip.ClipResult}: {==}
def rejected_at_third_edge() -> {M.clip_quad(F.box(),G.P{0n,4n,1n},G.P{4n,4n,1n}) == Clip.Gone{} : Clip.ClipResult}: {==}
def corner_contact() -> {M.clip_quad(F.box(),G.P{0n,1n,1n},G.P{1n,1n,1n}) == Clip.Span{G.P{1n,1n,1n},G.P{2n,2n,2n}} : Clip.ClipResult}: {==}
def no_edges() -> {M.run([],Clip.Span{F.p(),F.q()}) == Clip.Span{F.p(),F.q()} : Clip.ClipResult}: {==}
def duplicate_edge() -> {M.run(M.Halfplane{N.P{1n,3n},N.P{1n,1n}} <> M.quad_edges(F.box()),Clip.Span{F.p(),F.q()}) == Clip.Span{G.P{8n,16n,8n},G.P{144n,96n,48n}} : Clip.ClipResult}: {==}
