import Base
import ./absolute-difference.bend as D
import ./natural-squares.bend as S

def exact(x: Nat, y: Nat, z: Nat, w: Nat) -> Nat:
  S.exact(D.exact(x, z), D.exact(y, w))
