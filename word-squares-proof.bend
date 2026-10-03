import Base
import ./word-squares.bend as S
import ./word-squares-laws.bend as L
import ./word-arithmetic.bend as W
import ./word-sum3-proof.bend as A
import ./word-multiplication-laws.bend as Mul

def L.bounded_squares_exact(n, a, b, total):
  A.exact_add(n, Word.mul(n, a, a), Word.mul(n, b, b), Nat.mul(Word.to_nat(n, a), Word.to_nat(n, a)), Nat.mul(Word.to_nat(n, b), Word.to_nat(n, b)), Mul.bounded_multiplication(n, a, a, A.left_bound(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, a)), Nat.mul(Word.to_nat(n, b), Word.to_nat(n, b)), W.capacity(n), total)), Mul.bounded_multiplication(n, b, b, A.right_bound(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, a)), Nat.mul(Word.to_nat(n, b), Word.to_nat(n, b)), W.capacity(n), total)), total)
