import Base
import ./natural-cover.bend as N
import ./quad-geometry.bend as Q
import ./halfplane-region.bend as Region

# At least one original corner of q lies in the closed region of r.
def inside_other(q:N.Quad,+r:N.Quad) -> Bool:
  match q:
    case N.Q{a,b,c,d}: Region.contains(Q.embed(a),r) || (Region.contains(Q.embed(b),r) || (Region.contains(Q.embed(c),r) || (Region.contains(Q.embed(d),r) || False{})))
