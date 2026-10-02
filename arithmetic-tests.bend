import Base
import ./exact-arithmetic.bend as A
def sample_0() -> {A.orientation(0n, 0n, 1n, 0n, 0n, 1n, 1n) == GT{} : Cmp}:
  {==}
def sample_1() -> {A.orientation(1n, 0n, 0n, 0n, 0n, 1n, 1n) == LT{} : Cmp}:
  {==}
def sample_2() -> {A.orientation(0n, 0n, 2n, 0n, 1n, 0n, 1n) == EQ{} : Cmp}:
  {==}
def sample_3() -> {A.orientation(1n, 2n, 3n, 4n, 5n, 6n, 2n) == LT{} : Cmp}:
  {==}
