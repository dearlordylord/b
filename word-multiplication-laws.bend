import Base
import ./word-arithmetic.bend as W
import ./word-multiplication.bend as M

# A bound on the complete mathematical result suffices for the actual loop.
# It does not require unused trailing shifts to remain within capacity.
law loop_exact:
  for +m: Nat
  for +n: Nat
  for +a: Word(m)
  for +b: Word(n)
  for +acc: Word(n)
  for h: {Nat.is_lt(M.total(m, n, a, b, acc), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, M.loop(m, n, a, b, acc)) == M.total(m, n, a, b, acc) : Nat}

law bounded_multiplication:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for h: {Nat.is_lt(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), W.capacity(n)) == True{} : Bool}
  {Word.to_nat(n, M.multiply(n, a, b)) == Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)) : Nat}

# Quantify over the complete Word(32) payload of the U32 constructor. This
# avoids eager expansion of an unpacked U32 inside the checker; every U32
# consists of exactly such a payload.
law bounded_u32_multiplication:
  for +x: Word(32n)
  for +y: Word(32n)
  for h: {Nat.is_lt(Nat.mul(Word.to_nat(32n, x), Word.to_nat(32n, y)), W.capacity(32n)) == True{} : Bool}
  {U32.to_nat(U32.mul(U32{x}, U32{y})) == Nat.mul(Word.to_nat(32n, x), Word.to_nat(32n, y)) : Nat}

law bounded_u32_addition:
  for +x: Word(32n)
  for +y: Word(32n)
  for h: {Nat.is_lt(Nat.add(Word.to_nat(32n, x), Word.to_nat(32n, y)), W.capacity(32n)) == True{} : Bool}
  {U32.to_nat(U32.add(U32{x}, U32{y})) == Nat.add(Word.to_nat(32n, x), Word.to_nat(32n, y)) : Nat}
