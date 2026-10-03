import Base
import ./word-arithmetic.bend as W
import ./word-sum3.bend as S
import ./word-sum3-laws.bend as L
import ./word-multiplication-laws.bend as Mul
import ./word-multiplication-proof.bend as Arithmetic
import ./word-conversion-proof.bend as Copy
import ./arithmetic-order-proof.bend as O
import ./facts.bend as F

# Bounds are proofs of inequalities, rather than independently supplied flags.
def left_bound(+p: Nat, +q: Nat, +limit: Nat, h: {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}) -> {Nat.is_lt(p, limit) == True{} : Bool}:
  O.summand_bound(p, q, limit, h)
def right_bound(+p: Nat, +q: Nat, +limit: Nat, h: {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}) -> {Nat.is_lt(q, limit) == True{} : Bool}:
  O.summand_bound(q, p, limit, Arithmetic.bound(Nat.add(q, p), Nat.add(p, q), limit, F.add_comm(q, p), h))
def product_bounds(+p: Nat, +q: Nat, +limit: Nat, hs: {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool} & {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}) -> {Nat.is_lt(p, limit) == True{} : Bool} & {Nat.is_lt(q, limit) == True{} : Bool}:
  (h1, h2) = hs
  (left_bound(p, q, limit, h1), right_bound(p, q, limit, h2))
def split_sum_bounds(+p: Nat, +q: Nat, +r: Nat, +limit: Nat, hs: {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool} & {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}, hr: {Nat.is_lt(r, limit) == True{} : Bool}) -> ({Nat.is_lt(p, limit) == True{} : Bool} & {Nat.is_lt(q, limit) == True{} : Bool}) & ({Nat.is_lt(r, limit) == True{} : Bool} & {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}):
  (h1, h2) = hs
  (product_bounds(p, q, limit, Copy.duplicate_bool(Nat.is_lt(Nat.add(p, q), limit), h1)), (hr, h2))
def sum_bounds(+p: Nat, +q: Nat, +r: Nat, +limit: Nat, hs: {Nat.is_lt(Nat.add(Nat.add(p, q), r), limit) == True{} : Bool} & {Nat.is_lt(Nat.add(Nat.add(p, q), r), limit) == True{} : Bool}) -> ({Nat.is_lt(p, limit) == True{} : Bool} & {Nat.is_lt(q, limit) == True{} : Bool}) & ({Nat.is_lt(r, limit) == True{} : Bool} & {Nat.is_lt(Nat.add(p, q), limit) == True{} : Bool}):
  (h1, h2) = hs
  split_sum_bounds(p, q, r, limit, Copy.duplicate_bool(Nat.is_lt(Nat.add(p, q), limit), left_bound(Nat.add(p, q), r, limit, h1)), right_bound(Nat.add(p, q), r, limit, h2))

def add_from_sum(+n: Nat, +a: Word(n), +b: Word(n), +p: Nat, +q: Nat, es: {Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)) == Nat.add(p, q) : Nat} & {Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)) == Nat.add(p, q) : Nat}, h: {Nat.is_lt(Nat.add(p, q), W.capacity(n)) == True{} : Bool}) -> {Word.to_nat(n, Word.add(n, a, b)) == Nat.add(p, q) : Nat}:
  (e1, e2) = es
  Equal.trans(Nat, Word.to_nat(n, Word.add(n, a, b)), Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.add(p, q), Arithmetic.add_exact(n, a, b, Arithmetic.bound(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.add(p, q), W.capacity(n), e1, h)), e2)
def exact_add(+n: Nat, +a: Word(n), +b: Word(n), +p: Nat, +q: Nat, ea: {Word.to_nat(n, a) == p : Nat}, eb: {Word.to_nat(n, b) == q : Nat}, h: {Nat.is_lt(Nat.add(p, q), W.capacity(n)) == True{} : Bool}) -> {Word.to_nat(n, Word.add(n, a, b)) == Nat.add(p, q) : Nat}:
  add_from_sum(n, a, b, p, q, Copy.duplicate_nat(Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.add(p, q), Equal.trans(Nat, Nat.add(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.add(p, Word.to_nat(n, b)), Nat.add(p, q), Equal.cong(Nat, Nat, z => Nat.add(z, Word.to_nat(n, b)), Word.to_nat(n, a), p, ea), Equal.cong(Nat, Nat, z => Nat.add(p, z), Word.to_nat(n, b), q, eb))), h)

def sum3_finish(+n: Nat, +a: Word(n), +b: Word(n), +c: Word(n), +d: Word(n), +e: Word(n), +f: Word(n), bs: ({Nat.is_lt(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), W.capacity(n)) == True{} : Bool} & {Nat.is_lt(Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d)), W.capacity(n)) == True{} : Bool}) & ({Nat.is_lt(Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), W.capacity(n)) == True{} : Bool} & {Nat.is_lt(Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), W.capacity(n)) == True{} : Bool}), h: {Nat.is_lt(Nat.add(Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f))), W.capacity(n)) == True{} : Bool}) -> {Word.to_nat(n, S.sum3(n, a, b, c, d, e, f)) == S.exact(n, a, b, c, d, e, f) : Nat}:
  ((hp, hq), (hr, hpq)) = bs
  exact_add(n, Word.add(n, Word.mul(n, a, b), Word.mul(n, c, d)), Word.mul(n, e, f), Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), exact_add(n, Word.mul(n, a, b), Word.mul(n, c, d), Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d)), Mul.bounded_multiplication(n, a, b, hp), Mul.bounded_multiplication(n, c, d, hq), hpq), Mul.bounded_multiplication(n, e, f, hr), h)

def sum3_split(+n: Nat, +a: Word(n), +b: Word(n), +c: Word(n), +d: Word(n), +e: Word(n), +f: Word(n), hs: {Nat.is_lt(Nat.add(Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f))), W.capacity(n)) == True{} : Bool} & {Nat.is_lt(Nat.add(Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f))), W.capacity(n)) == True{} : Bool}) -> {Word.to_nat(n, S.sum3(n, a, b, c, d, e, f)) == S.exact(n, a, b, c, d, e, f) : Nat}:
  (h1, h2) = hs
  sum3_finish(n, a, b, c, d, e, f, sum_bounds(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d)), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f)), W.capacity(n), Copy.duplicate_bool(Nat.is_lt(Nat.add(Nat.add(Nat.mul(Word.to_nat(n, a), Word.to_nat(n, b)), Nat.mul(Word.to_nat(n, c), Word.to_nat(n, d))), Nat.mul(Word.to_nat(n, e), Word.to_nat(n, f))), W.capacity(n)), h1)), h2)

def L.sum3_exact(n, a, b, c, d, e, f, h):
  sum3_split(n, a, b, c, d, e, f, Copy.duplicate_bool(Nat.is_lt(S.exact(n, a, b, c, d, e, f), W.capacity(n)), h))

def L.u32_sum3_exact(a, b, c, d, e, f, h):
  L.sum3_exact(32n, a, b, c, d, e, f, h)
