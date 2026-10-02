import Base
import ./word-arithmetic.bend as W
import ./word-complement.bend as C
import ./word-complement-laws.bend as L
import ./word-comparison-proof.bend as Comparison
import ./word-value-proof.bend as Value
import ./facts.bend as F

def L.maximum_capacity(n):
  match n:
    case 0n: {==}
    case 1n+p:
      Equal.cong(Nat, Nat, z => Nat.double(z), 1n+C.maximum(p), W.capacity(p), L.maximum_capacity(p))

law double_pair:
  for +a: Nat
  for +b: Nat
  for +total: Nat
  for h: {Nat.add(a, b) == total : Nat}
  {Nat.add(Nat.double(a), Nat.double(b)) == Nat.double(total) : Nat}
def double_pair(a, b, total, h):
  Equal.trans(Nat, Nat.add(Nat.double(a), Nat.double(b)), Nat.double(Nat.add(a, b)), Nat.double(total), Equal.sym(Nat, Nat.double(Nat.add(a, b)), Nat.add(Nat.double(a), Nat.double(b)), Value.double_add(a, b)), Equal.cong(Nat, Nat, z => Nat.double(z), Nat.add(a, b), total, h))

def L.complement_value(n, w):
  match n:
    case 0n: {==}
    case 1n+p:
      match w:
        case WCon{False{}, t}:
          Equal.trans(Nat, Nat.add(Nat.double(Word.to_nat(p, t)), 1n+Nat.double(Word.to_nat(p, C.complement(p, t)))), 1n+Nat.add(Nat.double(Word.to_nat(p, t)), Nat.double(Word.to_nat(p, C.complement(p, t)))), 1n+Nat.double(C.maximum(p)), F.add_succ(Nat.double(Word.to_nat(p, t)), Nat.double(Word.to_nat(p, C.complement(p, t)))), Equal.cong(Nat, Nat, z => 1n+z, Nat.add(Nat.double(Word.to_nat(p, t)), Nat.double(Word.to_nat(p, C.complement(p, t)))), Nat.double(C.maximum(p)), double_pair(Word.to_nat(p, t), Word.to_nat(p, C.complement(p, t)), C.maximum(p), L.complement_value(p, t))))
        case WCon{True{}, t}:
          Equal.cong(Nat, Nat, z => 1n+z, Nat.add(Nat.double(Word.to_nat(p, t)), Nat.double(Word.to_nat(p, C.complement(p, t)))), Nat.double(C.maximum(p)), double_pair(Word.to_nat(p, t), Word.to_nat(p, C.complement(p, t)), C.maximum(p), L.complement_value(p, t)))
