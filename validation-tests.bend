import Base
import ./core.bend as C
import ./validation.bend as V

def empty_rejected() -> {V.validate(Nil{}) == False{} : Bool}:
  {==}
def singleton_accepted() -> {V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{1800n, 0n}}]) == True{} : Bool}:
  {==}
def thin_rejected() -> {V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{1799n, 0n}}]) == False{} : Bool}:
  {==}
def wide_rejected() -> {V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{2601n, 0n}}]) == False{} : Bool}:
  {==}
def out_of_bounds_rejected() -> {V.validate([C.Section{C.Pt{16001n, 0n}, C.Pt{14201n, 0n}}]) == False{} : Bool}:
  {==}
def pair_accepted() -> {V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 1800n}}, C.Section{C.Pt{100n, 0n}, C.Pt{100n, 1800n}}]) == True{} : Bool}:
  {==}
def degenerate_rejected() -> {V.validate([C.Section{C.Pt{0n, 0n}, C.Pt{0n, 1800n}}, C.Section{C.Pt{0n, 0n}, C.Pt{0n, 1800n}}]) == False{} : Bool}:
  {==}
