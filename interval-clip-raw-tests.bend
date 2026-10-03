import Base
import ./interval-clip.bend as M
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./segment-cut.bend as Cut

def a() -> N.Point: N.P{0n,1n}
def b() -> N.Point: N.P{1n,1n}
def p() -> G.Point: G.P{0n,3n,1n}
def q() -> G.Point: G.P{1n,0n,1n}
def retained_both() -> {M.clip(a(),b(),p(),G.P{1n,2n,1n}) == M.Span{p(),G.P{1n,2n,1n}} : M.ClipResult}:
  {==}
def cut_second() -> {M.clip(a(),b(),p(),q()) == M.Span{p(),G.P{2n,3n,3n}} : M.ClipResult}:
  {==}
def cut_first() -> {M.clip(a(),b(),q(),p()) == M.Span{p(),G.P{2n,3n,3n}} : M.ClipResult}:
  {==}
def rejected_both() -> {M.clip(a(),b(),G.P{0n,0n,1n},q()) == M.Gone{} : M.ClipResult}:
  {==}
def boundary_point_retained() -> {M.clip(a(),b(),G.P{0n,1n,1n},q()) == M.Span{G.P{0n,1n,1n},G.P{0n,1n,1n}} : M.ClipResult}:
  {==}
def invalid_denominator_rejected() -> {M.closed_valid(a(),b(),M.Span{G.P{0n,1n,0n},p()}) == False{} : Bool}:
  {==}
