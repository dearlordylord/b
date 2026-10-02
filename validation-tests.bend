import Base
import ./core.bend as C
import ./validation.bend as V

def empty_rejected() -> Bool:
  Bool.not(V.validate(Nil{}))
def singleton_accepted() -> Bool:
  V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{1800n, 0n}}])
def thin_rejected() -> Bool:
  Bool.not(V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{1799n, 0n}}]))
def wide_rejected() -> Bool:
  Bool.not(V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{2601n, 0n}}]))
def out_of_bounds_rejected() -> Bool:
  Bool.not(V.validate([C.Section{C.Pt{16001n, 0n}, C.Pt{14201n, 0n}}]))
def pair_accepted() -> Bool:
  V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 1800n}}, C.Section{C.Pt{100n, 0n}, C.Pt{100n, 1800n}}])
def degenerate_rejected() -> Bool:
  Bool.not(V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 1800n}}, C.Section{C.Pt{0n, 0n}, C.Pt{0n, 1800n}}]))

def tests() -> Bool:
  empty_rejected() && singleton_accepted() && thin_rejected() && wide_rejected() && out_of_bounds_rejected() && pair_accepted() && degenerate_rejected()
def main() -> IO(Unit):
  do IO<Unit>:
    IO.print("validator-tests: " ++ Bool.show(tests()))
