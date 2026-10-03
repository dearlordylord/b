import Base
import ./word-sum4.bend as S
import ./word-sum4-laws.bend as L
import ./word-arithmetic.bend as W
import ./word-sum3-proof.bend as A
import ./word-multiplication-laws.bend as Mul

type Bounds<-p: Nat, -q: Nat, -r: Nat, -s: Nat, -limit: Nat> is Data:
  Bound{hp: {Nat.is_lt(p, limit) == True{} : Bool}, hq: {Nat.is_lt(q, limit) == True{} : Bool}, hr: {Nat.is_lt(r, limit) == True{} : Bool}, hs: {Nat.is_lt(s, limit) == True{} : Bool}, hpq: {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}, hrs: {Nat.is_lt(Nat.add(r, s), limit) == True{} : Bool}}

def split_bounds(+p: Nat, +q: Nat, +r: Nat, +s: Nat, +limit: Nat, +left: {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}, +right: {Nat.is_lt(Nat.add(r, s), limit) == True{} : Bool}) -> Bounds<p, q, r, s, limit>:
  Bound{A.left_bound(p, q, limit, left), A.right_bound(p, q, limit, left), A.left_bound(r, s, limit, right), A.right_bound(r, s, limit, right), left, right}

def sum_bounds(+p: Nat, +q: Nat, +r: Nat, +s: Nat, +limit: Nat, +total: {Nat.is_lt(Nat.add(Nat.add(p, q), Nat.add(r, s)), limit) == True{} : Bool}) -> Bounds<p, q, r, s, limit>:
  split_bounds(p, q, r, s, limit, A.left_bound(Nat.add(p, q), Nat.add(r, s), limit, total), A.right_bound(Nat.add(p, q), Nat.add(r, s), limit, total))

def finish(+n: Nat, +a: Word(n), +b: Word(n), +c: Word(n), +d: Word(n), +e: Word(n), +f: Word(n), +g: Word(n), +h: Word(n), bs: Bounds<Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d)), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), Nat.mul(Word.to_nat(n, g), Word.to_nat(n, h)), W.capacity(n)>, total: {Nat.is_lt(S.exact(n, a, b, c, d, e, f, g, h), W.capacity(n)) == True{} : Bool}) -> {Word.to_nat(n, S.sum4(n, a, b, c, d, e, f, g, h)) == S.exact(n, a, b, c, d, e, f, g, h) : Nat}:
  match bs:
    case Bound{hp, hq, hr, hs, hpq, hrs}:
      A.exact_add(n, Word.add(n, Word.mul(n, a, b), Word.mul(n, c, d)), Word.add(n, Word.mul(n, e, f), Word.mul(n, g, h)), Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.add(Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), Nat.mul(Word.to_nat(n, g), Word.to_nat(n, h))), A.exact_add(n, Word.mul(n, a, b), Word.mul(n, c, d), Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d)), Mul.bounded_multiplication(n, a, b, hp), Mul.bounded_multiplication(n, c, d, hq), hpq), A.exact_add(n, Word.mul(n, e, f), Word.mul(n, g, h), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), Nat.mul(Word.to_nat(n, g), Word.to_nat(n, h)), Mul.bounded_multiplication(n, e, f, hr), Mul.bounded_multiplication(n, g, h, hs), hrs), total)

def L.sum4_exact(n, a, b, c, d, e, f, g, h, total):
  finish(n, a, b, c, d, e, f, g, h, sum_bounds(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d)), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), Nat.mul(Word.to_nat(n, g), Word.to_nat(n, h)), W.capacity(n), total), total)
