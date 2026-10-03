import Base
import ./homogeneous-bound-proof.bend as Bounds
import ./homogeneous.bend as H
import ./homogeneous-laws.bend as L
import ./word-arithmetic.bend as W
import ./word-sum3.bend as S
import ./word-sum3-laws.bend as Sum
import ./word-sum3-proof.bend as SumProof
import ./word-multiplication-laws.bend as Mul
import ./word-multiplication-proof.bend as Arithmetic

def first_value(+n: Nat, +a: Word(n), +b: Word(n), +d: Word(n), +c: Word(n), +y: Word(n), +x: Word(n), +e: Word(n), hp: {Nat.is_lt(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), W.capacity(n)) == True{} : Bool}) -> {S.exact(n, Word.mul(n, a, b), d, c, y, x, e) == H.word_exact(n, a, b, d, c, y, x, e) : Nat}:
  Equal.cong(Nat, Nat, v => Nat.add(Nat.add(Nat.mul(v, Word.to_nat(n, d)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, y))), Nat.mul(Word.to_nat(n, x), Word.to_nat(n, e))), Word.to_nat(n, Word.mul(n, a, b)), Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Mul.bounded_multiplication(n, a, b, hp))

def L.word_homogeneous_exact(n, a, b, d, c, y, x, e, hp, h):
  Equal.trans(Nat, Word.to_nat(n, H.word_sum(n, a, b, d, c, y, x, e)), S.exact(n, Word.mul(n, a, b), d, c, y, x, e), H.word_exact(n, a, b, d, c, y, x, e), Sum.sum3_exact(n, Word.mul(n, a, b), d, c, y, x, e, Arithmetic.bound(S.exact(n, Word.mul(n, a, b), d, c, y, x, e), H.word_exact(n, a, b, d, c, y, x, e), W.capacity(n), first_value(n, a, b, d, c, y, x, e, hp), h)), first_value(n, a, b, d, c, y, x, e, hp))
