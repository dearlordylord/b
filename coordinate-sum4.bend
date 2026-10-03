import Base
import ./coordinate-limit.bend as Limit

def exact(a: Nat, b: Nat, c: Nat, d: Nat, e: Nat, f: Nat, g: Nat, h: Nat) -> Nat:
  Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.add(Nat.mul(e, f), Nat.mul(g, h)))

type Bounds<-a: Nat, -b: Nat, -c: Nat, -d: Nat, -e: Nat, -f: Nat, -g: Nat, -h: Nat> is Data:
  Bound{ha: {Nat.is_le(a, Limit.maximum()) == True{} : Bool}, hb: {Nat.is_le(b, Limit.maximum()) == True{} : Bool}, hc: {Nat.is_le(c, Limit.maximum()) == True{} : Bool}, hd: {Nat.is_le(d, Limit.maximum()) == True{} : Bool}, he: {Nat.is_le(e, Limit.maximum()) == True{} : Bool}, hf: {Nat.is_le(f, Limit.maximum()) == True{} : Bool}, hg: {Nat.is_le(g, Limit.maximum()) == True{} : Bool}, hh: {Nat.is_le(h, Limit.maximum()) == True{} : Bool}}
