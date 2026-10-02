import Base
import ./word-comparison.bend as C
import ./word-comparison-laws.bend as L
import ./word-complement.bend as N
import ./word-complement-laws.bend as NL
import ./word-conversion.bend as V
import ./word-complement-proof.bend as P
def comparison_0_0() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_0_1() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_0_2() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_0_3() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_0_4() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_0_5() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_0_6() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_0_7() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_1_0() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_1_1() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_1_2() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_1_3() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_1_4() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_1_5() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_1_6() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_1_7() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_2_0() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_2_1() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_2_2() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_2_3() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_2_4() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_2_5() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_2_6() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_2_7() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_3_0() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_3_1() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_3_2() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_3_3() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_3_4() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_3_5() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_3_6() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_3_7() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_4_0() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_4_1() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_4_2() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_4_3() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_4_4() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_4_5() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_4_6() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_4_7() -> {C.compare(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_5_0() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_5_1() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_5_2() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_5_3() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_5_4() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_5_5() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_5_6() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_5_7() -> {C.compare(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_6_0() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_6_1() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_6_2() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_6_3() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_6_4() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_6_5() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_6_6() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_6_7() -> {C.compare(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == LT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_7_0() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_7_1() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def comparison_7_2() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_7_3() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def comparison_7_4() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_7_5() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def comparison_7_6() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}) == GT{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def comparison_7_7() -> {C.compare(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}) == EQ{} : Cmp}:
  L.word_comparison_exact(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def complement_0() -> {Nat.add(Word.to_nat(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{False{}, WCon{False{}, WCon{False{}, WNil{}}}})
def complement_1() -> {Nat.add(Word.to_nat(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{True{}, WCon{False{}, WCon{False{}, WNil{}}}})
def complement_2() -> {Nat.add(Word.to_nat(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{False{}, WCon{True{}, WCon{False{}, WNil{}}}})
def complement_3() -> {Nat.add(Word.to_nat(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{True{}, WCon{True{}, WCon{False{}, WNil{}}}})
def complement_4() -> {Nat.add(Word.to_nat(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{False{}, WCon{False{}, WCon{True{}, WNil{}}}})
def complement_5() -> {Nat.add(Word.to_nat(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{True{}, WCon{False{}, WCon{True{}, WNil{}}}})
def complement_6() -> {Nat.add(Word.to_nat(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{False{}, WCon{True{}, WCon{True{}, WNil{}}}})
def complement_7() -> {Nat.add(Word.to_nat(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}), Word.to_nat(3n, N.complement(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}}))) == 7n : Nat}:
  NL.complement_value(3n, WCon{True{}, WCon{True{}, WCon{True{}, WNil{}}}})
def u32_equality() -> {U32.is_eq(U32{V.from_nat(3n, 32n)}, U32{V.from_nat(7n, 32n)}) == False{} : Bool}:
  L.u32_equality_exact(V.from_nat(3n, 32n), V.from_nat(7n, 32n))
def u32_greater() -> {U32.is_gt(U32{V.from_nat(3n, 32n)}, U32{V.from_nat(7n, 32n)}) == False{} : Bool}:
  L.u32_greater_exact(V.from_nat(3n, 32n), V.from_nat(7n, 32n))
def u32_less_equal() -> {U32.is_le(U32{V.from_nat(3n, 32n)}, U32{V.from_nat(7n, 32n)}) == True{} : Bool}:
  L.u32_less_equal_exact(V.from_nat(3n, 32n), V.from_nat(7n, 32n))
