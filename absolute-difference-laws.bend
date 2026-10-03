import Base
import ./validation.bend as V
import ./absolute-difference.bend as D

# All U32 values are covered; selecting max/min prevents a borrow.
law u32_absolute_exact:
  for +a: Word(32n)
  for +b: Word(32n)
  {U32.to_nat(V.absolute_difference(U32{a}, U32{b})) == D.exact(Word.to_nat(32n, a), Word.to_nat(32n, b)) : Nat}

law natural_absolute_symmetric:
  for +a: Nat
  for +b: Nat
  {D.exact(a, b) == D.exact(b, a) : Nat}

law natural_absolute_bounded:
  for +a: Nat
  for +b: Nat
  for +limit: Nat
  for ha: {Nat.is_le(a, limit) == True{} : Bool}
  for hb: {Nat.is_le(b, limit) == True{} : Bool}
  {Nat.is_le(D.exact(a, b), limit) == True{} : Bool}

law guarded_coordinate_absolute:
  for +a: Nat
  for +b: Nat
  for ha: {Nat.is_le(a, 16000n) == True{} : Bool}
  for hb: {Nat.is_le(b, 16000n) == True{} : Bool}
  {U32.to_nat(V.absolute_difference(U32.from_nat(a), U32.from_nat(b))) == D.exact(a, b) : Nat}
