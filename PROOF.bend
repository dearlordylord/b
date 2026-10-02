import Base
import ./core.bend as C
import ./LAWS.bend as Laws
import ./facts.bend as F
import ./topology-proof.bend as TopologyProof
import ./arithmetic-proof.bend as ArithmeticProof
import ./word-subtraction-proof.bend as WordProof
import ./arithmetic-order-proof.bend as ArithmeticOrder
import ./arithmetic-product-proof.bend as ArithmeticProduct

def Laws.seam_attaches_left(cell):
  {==}

def Laws.seam_attaches_right(cell):
  {==}

def Laws.svg_uses_boundaries(cell):
  {==}

def Laws.seam_inside_cell_coordinate(l0, l1, r0, r1, control, u, v, h):
  F.centroid_quadratic(Nat.mul(v, v), Nat.mul(2n, Nat.mul(u, v)),
    Nat.mul(u, u), l0, l1, r0, r1, control, h)

def Laws.corner_weights_normalize(u, v):
  F.weight_sum(u, v)
