import Base
import ./sample-arithmetic.bend as M
import ./sample-arithmetic-laws.bend as L
import ./sample-bound-proof.bend as Bounds
import ./word-arithmetic.bend as W
import ./word-sum3-proof.bend as A
import ./word-multiplication-laws.bend as Mul
import ./word-multiplication-proof.bend as Arithmetic
import ./word-subtraction-laws.bend as Sub
import ./word-subtraction-proof.bend as Subtraction
import ./capacity-facts.bend as Capacity
import ./order-facts.bend as O
import ./boolean-reflection.bend as B

law final_width:
  for +width: Nat
  for hw: {width == 12n : Nat}
  {Nat.add(Nat.add(width, 6n), 14n) == 32n : Nat}
def final_width(width, hw):
  Equal.cong(Nat, Nat, w => Nat.add(Nat.add(w, 6n), 14n), width, 12n, hw)

def numerator_fits(+bits: Nat, hb: {bits == 32n : Nat}, +width: Nat, hw: {width == 12n : Nat}, +a: Nat, +b: Nat, +n: Nat, ha: {Nat.is_le(a, W.capacity(width)) == True{} : Bool}, hc: {Nat.is_le(b, W.capacity(width)) == True{} : Bool}, hn: {Nat.is_le(n, 64n) == True{} : Bool}) -> {Nat.is_lt(M.numerator(a, b, n), W.capacity(bits)) == True{} : Bool}:
  %Equal.sym(Nat, bits, 32n, hb) : {Nat.is_lt(M.numerator(a, b, n), W.capacity(_)) == True{} : Bool}
  %final_width(width, hw) : {Nat.is_lt(M.numerator(a, b, n), W.capacity(_)) == True{} : Bool}
  O.lt_of_le_of_lt(M.numerator(a, b, n), W.capacity(Nat.add(width, 6n)), W.capacity(Nat.add(Nat.add(width, 6n), 14n)), L.sample_numerator_bound(width, a, b, n, ha, hc, hn), Capacity.capacity_grows(Nat.add(width, 6n), 13n))

law le_reverse_ge:
  for +a: Nat
  for +b: Nat
  for h: {Nat.is_le(a, b) == True{} : Bool}
  {Nat.is_ge(b, a) == True{} : Bool}
def le_reverse_ge(a, b, h):
  match a b:
    case 0n 0n: {==}
    case 0n 1n+p: {==}
    case 1n+p 0n: B.absurd({Nat.is_ge(0n, 1n+p) == True{} : Bool}, B.false_impossible(h))
    case 1n+p 1n+q: le_reverse_ge(p, q, h)

def sub_order(+bits: Nat, +sixty_four: Word(bits), +n: Word(bits), h64: {Word.to_nat(bits, sixty_four) == 64n : Nat}, hn: {Nat.is_le(Word.to_nat(bits, n), 64n) == True{} : Bool}) -> {Nat.is_ge(Word.to_nat(bits, sixty_four), Word.to_nat(bits, n)) == True{} : Bool}:
  %Equal.sym(Nat, Word.to_nat(bits, sixty_four), 64n, h64) : {Nat.is_ge(_, Word.to_nat(bits, n)) == True{} : Bool}
  le_reverse_ge(Word.to_nat(bits, n), 64n, hn)

def remainder_value(+bits: Nat, +sixty_four: Word(bits), +n: Word(bits), +h64: {Word.to_nat(bits, sixty_four) == 64n : Nat}, hn: {Nat.is_le(Word.to_nat(bits, n), 64n) == True{} : Bool}) -> {Word.to_nat(bits, Word.sub(bits, sixty_four, n)) == Nat.sub(64n, Word.to_nat(bits, n)) : Nat}:
  Equal.trans(Nat, Word.to_nat(bits, Word.sub(bits, sixty_four, n)), Nat.sub(Word.to_nat(bits, sixty_four), Word.to_nat(bits, n)), Nat.sub(64n, Word.to_nat(bits, n)), Sub.ordered_subtraction(bits, sixty_four, n, sub_order(bits, sixty_four, n, h64, hn)), Equal.cong(Nat, Nat, z => Nat.sub(z, Word.to_nat(bits, n)), Word.to_nat(bits, sixty_four), 64n, h64))

def product_value(+bits: Nat, +a: Word(bits), +m: Word(bits), +q: Nat, +hm: {Word.to_nat(bits, m) == q : Nat}, hp: {Nat.is_lt(Nat.mul(Word.to_nat(bits, a), q), W.capacity(bits)) == True{} : Bool}) -> {Word.to_nat(bits, Word.mul(bits, a, m)) == Nat.mul(Word.to_nat(bits, a), q) : Nat}:
  Equal.trans(Nat, Word.to_nat(bits, Word.mul(bits, a, m)), Nat.mul(Word.to_nat(bits, a), Word.to_nat(bits, m)), Nat.mul(Word.to_nat(bits, a), q), Mul.bounded_multiplication(bits, a, m, Arithmetic.bound(Nat.mul(Word.to_nat(bits, a), Word.to_nat(bits, m)), Nat.mul(Word.to_nat(bits, a), q), W.capacity(bits), Equal.cong(Nat, Nat, z => Nat.mul(Word.to_nat(bits, a), z), Word.to_nat(bits, m), q, hm), hp)), Equal.cong(Nat, Nat, z => Nat.mul(Word.to_nat(bits, a), z), Word.to_nat(bits, m), q, hm))

def sample_finish(+bits: Nat, +a: Word(bits), +b: Word(bits), +n: Word(bits), +sixty_four: Word(bits), hm: {Word.to_nat(bits, Word.sub(bits, sixty_four, n)) == Nat.sub(64n, Word.to_nat(bits, n)) : Nat}, +total: {Nat.is_lt(M.numerator(Word.to_nat(bits, a), Word.to_nat(bits, b), Word.to_nat(bits, n)), W.capacity(bits)) == True{} : Bool}) -> {Word.to_nat(bits, M.word_sample(bits, a, b, n, sixty_four)) == M.numerator(Word.to_nat(bits, a), Word.to_nat(bits, b), Word.to_nat(bits, n)) : Nat}:
  A.exact_add(bits, Word.mul(bits, a, Word.sub(bits, sixty_four, n)), Word.mul(bits, b, n), Nat.mul(Word.to_nat(bits, a), Nat.sub(64n, Word.to_nat(bits, n))), Nat.mul(Word.to_nat(bits, b), Word.to_nat(bits, n)), product_value(bits, a, Word.sub(bits, sixty_four, n), Nat.sub(64n, Word.to_nat(bits, n)), hm, A.left_bound(Nat.mul(Word.to_nat(bits, a), Nat.sub(64n, Word.to_nat(bits, n))), Nat.mul(Word.to_nat(bits, b), Word.to_nat(bits, n)), W.capacity(bits), total)), Mul.bounded_multiplication(bits, b, n, A.right_bound(Nat.mul(Word.to_nat(bits, a), Nat.sub(64n, Word.to_nat(bits, n))), Nat.mul(Word.to_nat(bits, b), Word.to_nat(bits, n)), W.capacity(bits), total)), total)

def L.word_sample_exact(bits, hb, width, hw, a, b, n, sixty_four, h64, ha, hc, hn):
  sample_finish(bits, a, b, n, sixty_four, remainder_value(bits, sixty_four, n, h64, hn), numerator_fits(bits, hb, width, hw, Word.to_nat(bits, a), Word.to_nat(bits, b), Word.to_nat(bits, n), ha, hc, hn))
