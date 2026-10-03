import Base
import ./word-arithmetic.bend as W
import ./homogeneous.bend as H

type Bounds<-width: Nat, -ax: Nat, -ay: Nat, -bx: Nat, -by: Nat, -x: Nat, -y: Nat, -d: Nat> is Data:
  Bound{hax: {Nat.is_le(ax, W.capacity(width)) == True{} : Bool}, hay: {Nat.is_le(ay, W.capacity(width)) == True{} : Bool}, hbx: {Nat.is_le(bx, W.capacity(width)) == True{} : Bool}, hby: {Nat.is_le(by, W.capacity(width)) == True{} : Bool}, hx: {Nat.is_le(x, W.capacity(Nat.add(width, 6n))) == True{} : Bool}, hy: {Nat.is_le(y, W.capacity(Nat.add(width, 6n))) == True{} : Bool}, hd: {Nat.is_le(d, W.capacity(6n)) == True{} : Bool}}
def exact_side(+ax: Nat, +ay: Nat, +bx: Nat, +by: Nat, +x: Nat, +y: Nat, +d: Nat) -> Cmp:
  Nat.cmp(H.exact(ax, by, d, bx, y, x, ay), H.exact(ay, bx, d, by, x, y, ax))
