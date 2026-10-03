import Base
import ./coordinate-sum4.bend as S

def exact(+lx: Nat, +ly: Nat, +cx: Nat, +cy: Nat, +rx: Nat, +ry: Nat) -> Bool:
  Nat.is_gt(S.exact(cx, rx, cy, ry, lx, lx, ly, ly), S.exact(cx, lx, cy, ly, lx, rx, ly, ry)) && Nat.is_gt(S.exact(rx, rx, ry, ry, cx, lx, cy, ly), S.exact(rx, lx, ry, ly, cx, rx, cy, ry))
