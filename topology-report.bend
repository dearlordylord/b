import Base
import ./topology.bend as T
import ./artwork.bend as A

def show(report: T.Counts) -> String:
  match report:
    case T.Counts{v, e, t, q, connected, witnessed, no_five, ribbons}:
      "vertices=" ++ Nat.show(v) ++ " edges=" ++ Nat.show(e) ++
      " triangles=" ++ Nat.show(t) ++ " tetrahedra=" ++ Nat.show(q) ++
      " connected=" ++ Bool.show(connected) ++ " witnessed=" ++ Bool.show(witnessed) ++
      " no-five=" ++ Bool.show(no_five) ++ " ribbons=" ++ Bool.show(ribbons)

def main() -> IO(Unit):
  IO.print(show(T.inspect(A.upper(), A.lower(), A.stem())))
