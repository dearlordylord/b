import Base
import ./word-arithmetic.bend as W
import ./word-subtraction.bend as S
import ./word-subtraction-laws.bend as L
import ./word-complement-proof.bend as Complement
import ./word-comparison-laws.bend as Comparison
import ./word-comparison.bend as Comparator
import ./word-proof.bend as WordProof
import ./word-value-proof.bend as Value
import ./word-bounds-proof.bend as Bounds
import ./word-bounds-laws.bend as BoundL
import ./word-laws.bend as Addition
import ./word-complement.bend as Not
import ./word-complement-laws.bend as NotLaws
import ./subtraction-algebra-proof.bend as A
import ./boolean-reflection.bend as V
import ./facts.bend as F

law adc_complement:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  for +c: Bool
  {Word.adc(n, a, Word.not(n, b), False{}, c) == Word.adc(n, a, b, True{}, c) : Word(n)}
def adc_complement(n, a, b, c):
  match n:
    case 0n: {==}
    case 1n+p:
      match a b c:
        case WCon{False{}, at} WCon{False{}, bt} False{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{True{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, False{}), Word.adc(p, at, bt, True{}, False{}), adc_complement(p, at, bt, False{}))
        case WCon{False{}, at} WCon{False{}, bt} True{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{False{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, True{}), Word.adc(p, at, bt, True{}, True{}), adc_complement(p, at, bt, True{}))
        case WCon{False{}, at} WCon{True{}, bt} False{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{False{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, False{}), Word.adc(p, at, bt, True{}, False{}), adc_complement(p, at, bt, False{}))
        case WCon{False{}, at} WCon{True{}, bt} True{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{True{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, False{}), Word.adc(p, at, bt, True{}, False{}), adc_complement(p, at, bt, False{}))
        case WCon{True{}, at} WCon{False{}, bt} False{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{False{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, True{}), Word.adc(p, at, bt, True{}, True{}), adc_complement(p, at, bt, True{}))
        case WCon{True{}, at} WCon{False{}, bt} True{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{True{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, True{}), Word.adc(p, at, bt, True{}, True{}), adc_complement(p, at, bt, True{}))
        case WCon{True{}, at} WCon{True{}, bt} False{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{True{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, False{}), Word.adc(p, at, bt, True{}, False{}), adc_complement(p, at, bt, False{}))
        case WCon{True{}, at} WCon{True{}, bt} True{}:
          Equal.cong(Word(p), Word(1n+p), w => WCon{False{}, w}, Word.adc(p, at, Word.not(p, bt), False{}, True{}), Word.adc(p, at, bt, True{}, True{}), adc_complement(p, at, bt, True{}))

def L.subtraction_low_agrees(n, a, b, c):
  Equal.trans(Word(n), W.low(n, S.carry(n, a, b, c)), Word.adc(n, a, Word.not(n, b), False{}, c), Word.adc(n, a, b, True{}, c), Addition.low_word_agrees(n, a, Word.not(n, b), c), adc_complement(n, a, b, c))

law overflow_prepend:
  for +p: Nat
  for +s: Bool
  for +r: W.Carry<p>
  {W.overflow(1n+p, W.prepend(p, s, r)) == W.overflow(p, r) : Bool}
def overflow_prepend(p, s, r):
  match r:
    case W.Carry{c, w}: {==}

law carry_step:
  for +t: Cmp
  for +a: Bool
  for +b: Bool
  for +c: Bool
  {S.carry_from_comparison(t, Bool.or(Bool.and(a, Bool.not(b)), Bool.and(Bool.or(a, Bool.not(b)), c))) == S.carry_from_comparison(Word.cmp.fin(a, b, t), c) : Bool}
def carry_step(t, a, b, c):
  match t:
    case LT{}: {==}
    case GT{}: {==}
    case EQ{}:
      match a b c:
        case False{} False{} False{}: {==}
        case False{} False{} True{}: {==}
        case False{} True{} False{}: {==}
        case False{} True{} True{}: {==}
        case True{} False{} False{}: {==}
        case True{} False{} True{}: {==}
        case True{} True{} False{}: {==}
        case True{} True{} True{}: {==}

def L.subtraction_carry_characterization(n, a, b, c):
  match n:
    case 0n: {==}
    case 1n+p:
      match a b c:
        case WCon{False{}, at} WCon{False{}, bt} False{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, True{}, S.carry(p, at, bt, False{}))), W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp.fin(False{}, False{}, Word.cmp(p, at, bt)), False{}), overflow_prepend(p, True{}, S.carry(p, at, bt, False{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp(p, at, bt), False{}), S.carry_from_comparison(Word.cmp.fin(False{}, False{}, Word.cmp(p, at, bt)), False{}), L.subtraction_carry_characterization(p, at, bt, False{}), carry_step(Word.cmp(p, at, bt), False{}, False{}, False{})))
        case WCon{False{}, at} WCon{False{}, bt} True{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, False{}, S.carry(p, at, bt, True{}))), W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp.fin(False{}, False{}, Word.cmp(p, at, bt)), True{}), overflow_prepend(p, False{}, S.carry(p, at, bt, True{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp(p, at, bt), True{}), S.carry_from_comparison(Word.cmp.fin(False{}, False{}, Word.cmp(p, at, bt)), True{}), L.subtraction_carry_characterization(p, at, bt, True{}), carry_step(Word.cmp(p, at, bt), False{}, False{}, True{})))
        case WCon{False{}, at} WCon{True{}, bt} False{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, False{}, S.carry(p, at, bt, False{}))), W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp.fin(False{}, True{}, Word.cmp(p, at, bt)), False{}), overflow_prepend(p, False{}, S.carry(p, at, bt, False{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp(p, at, bt), False{}), S.carry_from_comparison(Word.cmp.fin(False{}, True{}, Word.cmp(p, at, bt)), False{}), L.subtraction_carry_characterization(p, at, bt, False{}), carry_step(Word.cmp(p, at, bt), False{}, True{}, False{})))
        case WCon{False{}, at} WCon{True{}, bt} True{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, True{}, S.carry(p, at, bt, False{}))), W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp.fin(False{}, True{}, Word.cmp(p, at, bt)), True{}), overflow_prepend(p, True{}, S.carry(p, at, bt, False{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp(p, at, bt), False{}), S.carry_from_comparison(Word.cmp.fin(False{}, True{}, Word.cmp(p, at, bt)), True{}), L.subtraction_carry_characterization(p, at, bt, False{}), carry_step(Word.cmp(p, at, bt), False{}, True{}, True{})))
        case WCon{True{}, at} WCon{False{}, bt} False{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, False{}, S.carry(p, at, bt, True{}))), W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp.fin(True{}, False{}, Word.cmp(p, at, bt)), False{}), overflow_prepend(p, False{}, S.carry(p, at, bt, True{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp(p, at, bt), True{}), S.carry_from_comparison(Word.cmp.fin(True{}, False{}, Word.cmp(p, at, bt)), False{}), L.subtraction_carry_characterization(p, at, bt, True{}), carry_step(Word.cmp(p, at, bt), True{}, False{}, False{})))
        case WCon{True{}, at} WCon{False{}, bt} True{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, True{}, S.carry(p, at, bt, True{}))), W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp.fin(True{}, False{}, Word.cmp(p, at, bt)), True{}), overflow_prepend(p, True{}, S.carry(p, at, bt, True{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp(p, at, bt), True{}), S.carry_from_comparison(Word.cmp.fin(True{}, False{}, Word.cmp(p, at, bt)), True{}), L.subtraction_carry_characterization(p, at, bt, True{}), carry_step(Word.cmp(p, at, bt), True{}, False{}, True{})))
        case WCon{True{}, at} WCon{True{}, bt} False{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, True{}, S.carry(p, at, bt, False{}))), W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp.fin(True{}, True{}, Word.cmp(p, at, bt)), False{}), overflow_prepend(p, True{}, S.carry(p, at, bt, False{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, False{})), S.carry_from_comparison(Word.cmp(p, at, bt), False{}), S.carry_from_comparison(Word.cmp.fin(True{}, True{}, Word.cmp(p, at, bt)), False{}), L.subtraction_carry_characterization(p, at, bt, False{}), carry_step(Word.cmp(p, at, bt), True{}, True{}, False{})))
        case WCon{True{}, at} WCon{True{}, bt} True{}:
          Equal.trans(Bool, W.overflow(1n+p, W.prepend(p, False{}, S.carry(p, at, bt, True{}))), W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp.fin(True{}, True{}, Word.cmp(p, at, bt)), True{}), overflow_prepend(p, False{}, S.carry(p, at, bt, True{})), Equal.trans(Bool, W.overflow(p, S.carry(p, at, bt, True{})), S.carry_from_comparison(Word.cmp(p, at, bt), True{}), S.carry_from_comparison(Word.cmp.fin(True{}, True{}, Word.cmp(p, at, bt)), True{}), L.subtraction_carry_characterization(p, at, bt, True{}), carry_step(Word.cmp(p, at, bt), True{}, True{}, True{})))

law selector_ge:
  for +t: Cmp
  {S.carry_from_comparison(t, True{}) == Cmp.is_ge(t) : Bool}
def selector_ge(t):
  match t:
    case LT{}: {==}
    case EQ{}: {==}
    case GT{}: {==}

law carry_ge_exact:
  for +n: Nat
  for +a: Word(n)
  for +b: Word(n)
  {W.overflow(n, S.carry(n, a, b, True{})) == Nat.is_ge(Word.to_nat(n, a), Word.to_nat(n, b)) : Bool}
def carry_ge_exact(n, a, b):
  Equal.trans(Bool, W.overflow(n, S.carry(n, a, b, True{})), S.carry_from_comparison(Word.cmp(n, a, b), True{}), Nat.is_ge(Word.to_nat(n, a), Word.to_nat(n, b)), L.subtraction_carry_characterization(n, a, b, True{}), Equal.trans(Bool, S.carry_from_comparison(Word.cmp(n, a, b), True{}), Cmp.is_ge(Word.cmp(n, a, b)), Nat.is_ge(Word.to_nat(n, a), Word.to_nat(n, b)), selector_ge(Word.cmp(n, a, b)), Equal.cong(Cmp, Bool, t => Cmp.is_ge(t), Comparator.compare(n, a, b), Nat.cmp(Word.to_nat(n, a), Word.to_nat(n, b)), Comparison.word_comparison_exact(n, a, b))))

law high_record_value:
  for +n: Nat
  for +r: W.Carry<n>
  for h: {W.overflow(n, r) == True{} : Bool}
  {W.carry_value(n, r) == Nat.add(W.capacity(n), Word.to_nat(n, W.low(n, r))) : Nat}
def high_record_value(n, r, h):
  match r:
    case W.Carry{True{}, w}: BoundL.high_carry_value(n, w)
    case W.Carry{False{}, w}:
      V.absurd({W.extended_value(n, False{}, w) == Nat.add(W.capacity(n), Word.to_nat(n, w)) : Nat}, V.false_impossible(h))

law add_one:
  for +v: Nat
  {Nat.add(v, 1n) == 1n+v : Nat}
def add_one(v):
  Equal.trans(Nat, Nat.add(v, 1n), 1n+Nat.add(v, 0n), 1n+v, F.add_succ(v, 0n), Equal.cong(Nat, Nat, z => 1n+z, Nat.add(v, 0n), v, F.add_zero(v)))

law cancel_difference:
  for +a: Nat
  for +b: Nat
  for +k: Nat
  for +cap: Nat
  for +r: Nat
  for complement: {1n+Nat.add(b, k) == cap : Nat}
  for total: {Nat.add(cap, r) == Nat.add(Nat.add(a, k), 1n) : Nat}
  {r == Nat.sub(a, b) : Nat}
def cancel_difference(a, b, k, cap, r, complement, total):
  Equal.trans(Nat, r, Nat.sub(Nat.add(b, r), b), Nat.sub(a, b), Equal.sym(Nat, Nat.sub(Nat.add(b, r), b), r, A.subtract_left_sum(b, r)), Equal.cong(Nat, Nat, z => Nat.sub(z, b), Nat.add(b, r), a, A.cancel_right(Nat.add(b, r), k, a, Equal.trans(Nat, Nat.add(Nat.add(b, r), k), Nat.add(Nat.add(b, k), r), Nat.add(a, k), F.add_right_comm(b, r, k), A.successor_injective(Nat.add(Nat.add(b, k), r), Nat.add(a, k), Equal.trans(Nat, 1n+Nat.add(Nat.add(b, k), r), Nat.add(cap, r), 1n+Nat.add(a, k), Equal.cong(Nat, Nat, z => Nat.add(z, r), 1n+Nat.add(b, k), cap, complement), Equal.trans(Nat, Nat.add(cap, r), Nat.add(Nat.add(a, k), 1n), 1n+Nat.add(a, k), total, add_one(Nat.add(a, k)))))))))
def L.ordered_subtraction(n, a, b, h):
  %L.subtraction_low_agrees(n, a, b, True{}) : {Word.to_nat(n, _) == Nat.sub(Word.to_nat(n, a), Word.to_nat(n, b)) : Nat}
  cancel_difference(Word.to_nat(n, a), Word.to_nat(n, b), Word.to_nat(n, Word.not(n, b)), W.capacity(n), Word.to_nat(n, W.low(n, S.carry(n, a, b, True{}))), Equal.trans(Nat, 1n+Nat.add(Word.to_nat(n, b), Word.to_nat(n, Word.not(n, b))), 1n+Not.maximum(n), W.capacity(n), Equal.cong(Nat, Nat, z => 1n+z, Nat.add(Word.to_nat(n, b), Word.to_nat(n, Not.complement(n, b))), Not.maximum(n), NotLaws.complement_value(n, b)), NotLaws.maximum_capacity(n)), Equal.trans(Nat, Nat.add(W.capacity(n), Word.to_nat(n, W.low(n, S.carry(n, a, b, True{})))), W.carry_value(n, S.carry(n, a, b, True{})), Nat.add(Nat.add(Word.to_nat(n, a), Word.to_nat(n, Word.not(n, b))), 1n), Equal.sym(Nat, W.carry_value(n, S.carry(n, a, b, True{})), Nat.add(W.capacity(n), Word.to_nat(n, W.low(n, S.carry(n, a, b, True{})))), high_record_value(n, S.carry(n, a, b, True{}), Equal.trans(Bool, W.overflow(n, S.carry(n, a, b, True{})), Nat.is_ge(Word.to_nat(n, a), Word.to_nat(n, b)), True{}, carry_ge_exact(n, a, b), h))), Addition.whole_word_value(n, a, Word.not(n, b), True{})))

def L.ordered_u32_subtraction(x, y, h):
  L.ordered_subtraction(32n, x, y, h)
