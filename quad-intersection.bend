import Base
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./quad-hull.bend as H
import ./strict-halfplane.bend as S

# Geometric side tests; all edges of both quads participate.
def outside(q: N.Quad, +r: N.Quad) -> Bool:
  match q:
    case N.Q{+a, +b, +c, +d}:
      S.separated(a, b, r) || S.separated(b, c, r) || S.separated(c, d, r) || S.separated(d, a, r)
def meets(+q: N.Quad, +r: N.Quad) -> Bool:
  Bool.not(outside(q, r) || outside(r, q))
# An actual common rational point with independent nonnegative hull weights.
def CommonPoint(-q: N.Quad, -r: N.Quad) -> Type:
  &p:G.Point -> H.InHull(q, p) & H.InHull(r, p)
