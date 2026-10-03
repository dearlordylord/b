import Base
import ./absolute-difference-laws.bend as L
import ./absolute-difference.bend as D
import ./absolute-order-proof.bend as O
import ./validation.bend as V
import ./word-comparison-laws.bend as Comparison
import ./word-subtraction-laws.bend as Sub
import ./word-subtraction-proof.bend as Existing
import ./order-facts.bend as Order
import ./coordinate-runtime-proof.bend as Coordinate
import ./word-conversion.bend as C
import ./word-conversion-laws.bend as Conversion

def choice(+a: U32, +b: U32, +less: Bool) -> U32:
  U32.sub(Bool.pick(U32, less, b, a), Bool.pick(U32, less, a, b))

law comparison_less:
  for +a: Word(32n)
  for +b: Word(32n)
  {U32.is_lt(U32{a}, U32{b}) == Nat.is_lt(Word.to_nat(32n, a), Word.to_nat(32n, b)) : Bool}
def comparison_less(a, b):
  Equal.cong(Cmp, Bool, c => Cmp.is_lt(c), U32.cmp(U32{a}, U32{b}), Nat.cmp(Word.to_nat(32n, a), Word.to_nat(32n, b)), Comparison.u32_comparison_exact(a, b))

def choice_value(+a: Word(32n), +b: Word(32n), +less: Bool, h: {Nat.is_lt(Word.to_nat(32n, a), Word.to_nat(32n, b)) == less : Bool}) -> {U32.to_nat(choice(U32{a}, U32{b}, less)) == D.choice(Word.to_nat(32n, a), Word.to_nat(32n, b), less) : Nat}:
  match less:
    case False{}:
      Sub.ordered_u32_subtraction(a, b, O.not_lt_ge(Word.to_nat(32n, a), Word.to_nat(32n, b), h))
    case True{}:
      Sub.ordered_u32_subtraction(b, a, O.lt_reverse_ge(Word.to_nat(32n, a), Word.to_nat(32n, b), h))

def L.u32_absolute_exact(a, b):
  Equal.trans(Nat, U32.to_nat(V.absolute_difference(U32{a}, U32{b})), U32.to_nat(choice(U32{a}, U32{b}, Nat.is_lt(Word.to_nat(32n, a), Word.to_nat(32n, b)))), D.exact(Word.to_nat(32n, a), Word.to_nat(32n, b)), Equal.cong(Bool, Nat, flag => U32.to_nat(choice(U32{a}, U32{b}, flag)), U32.is_lt(U32{a}, U32{b}), Nat.is_lt(Word.to_nat(32n, a), Word.to_nat(32n, b)), comparison_less(a, b)), choice_value(a, b, Nat.is_lt(Word.to_nat(32n, a), Word.to_nat(32n, b)), {==}))

def L.natural_absolute_symmetric(a, b):
  match a b:
    case 0n 0n: {==}
    case 0n 1n+q: {==}
    case 1n+p 0n: {==}
    case 1n+p 1n+q: L.natural_absolute_symmetric(p, q)

def choice_bound(+a: Nat, +b: Nat, +limit: Nat, less: Bool, ha: {Nat.is_le(a, limit) == True{} : Bool}, hb: {Nat.is_le(b, limit) == True{} : Bool}) -> {Nat.is_le(D.choice(a, b, less), limit) == True{} : Bool}:
  match less:
    case False{}: Order.le_trans(Nat.sub(a, b), a, limit, O.sub_le(a, b), ha)
    case True{}: Order.le_trans(Nat.sub(b, a), b, limit, O.sub_le(b, a), hb)

def L.natural_absolute_bounded(a, b, limit, ha, hb):
  choice_bound(a, b, limit, Nat.is_lt(a, b), ha, hb)

def converted_values(+a: Nat, +b: Nat, ha: {Nat.is_le(a, 16000n) == True{} : Bool}, hb: {Nat.is_le(b, 16000n) == True{} : Bool}) -> {D.exact(Word.to_nat(32n, C.from_nat(a, 32n)), Word.to_nat(32n, C.from_nat(b, 32n))) == D.exact(a, b) : Nat}:
  %Equal.sym(Nat, Word.to_nat(32n, C.from_nat(a, 32n)), a, Conversion.bounded_conversion(a, 32n, Coordinate.coordinate32(a, ha))) : {D.exact(_, Word.to_nat(32n, C.from_nat(b, 32n))) == D.exact(a, b) : Nat}
  %Equal.sym(Nat, Word.to_nat(32n, C.from_nat(b, 32n)), b, Conversion.bounded_conversion(b, 32n, Coordinate.coordinate32(b, hb))) : {D.exact(a, _) == D.exact(a, b) : Nat}
  {==}

def converted_absolute(+a: Nat, +b: Nat, ha: {Nat.is_le(a, 16000n) == True{} : Bool}, hb: {Nat.is_le(b, 16000n) == True{} : Bool}) -> {U32.to_nat(V.absolute_difference(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)})) == D.exact(a, b) : Nat}:
  Equal.trans(Nat, U32.to_nat(V.absolute_difference(U32{C.from_nat(a, 32n)}, U32{C.from_nat(b, 32n)})), D.exact(Word.to_nat(32n, C.from_nat(a, 32n)), Word.to_nat(32n, C.from_nat(b, 32n))), D.exact(a, b), L.u32_absolute_exact(C.from_nat(a, 32n), C.from_nat(b, 32n)), converted_values(a, b, ha, hb))

def L.guarded_coordinate_absolute(a, b, ha, hb):
  %Equal.sym(U32, U32.from_nat(a), U32{C.from_nat(a, 32n)}, Conversion.u32_conversion_agrees(a)) : {U32.to_nat(V.absolute_difference(_, U32.from_nat(b))) == D.exact(a, b) : Nat}
  %Equal.sym(U32, U32.from_nat(b), U32{C.from_nat(b, 32n)}, Conversion.u32_conversion_agrees(b)) : {U32.to_nat(V.absolute_difference(U32{C.from_nat(a, 32n)}, _)) == D.exact(a, b) : Nat}
  converted_absolute(a, b, ha, hb)
