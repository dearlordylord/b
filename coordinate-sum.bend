import Base

def exact(a: Nat, b: Nat, c: Nat, d: Nat, e: Nat, f: Nat) -> Nat:
  Nat.add(Nat.add(Nat.mul(a, b), Nat.mul(c, d)), Nat.mul(e, f))

type Bounds<-a: Nat, -b: Nat, -c: Nat, -d: Nat, -e: Nat, -f: Nat> is Data:
  Bound{ha: {Nat.is_le(a, 16000n) == True{} : Bool}, hb: {Nat.is_le(b, 16000n) == True{} : Bool}, hc: {Nat.is_le(c, 16000n) == True{} : Bool}, hd: {Nat.is_le(d, 16000n) == True{} : Bool}, he: {Nat.is_le(e, 16000n) == True{} : Bool}, hf: {Nat.is_le(f, 16000n) == True{} : Bool}}
