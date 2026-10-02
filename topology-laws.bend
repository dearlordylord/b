import Base
import ./topology.bend as T
import ./core.bend as C

def PositiveVertices(v: Nat) -> Type:
  match v:
    case 0n: Empty
    case 1n+p: Unit

# A report accepted by the generator must carry every geometric certificate
# flag, a nonempty cover, and the exact Euler equation V+T+1 = E+Q.
# The geometric meaning of these computed flags is checked in topology.bend;
# Helly and the convex nerve theorem remain the documented mathematical bridge.
def Conditions(report: T.Counts) -> Type:
  match report:
    case T.Counts{+v, e, t, q, connected, witnessed, no_five, ribbons}:
      {connected == True{} : Bool} &
      ({witnessed == True{} : Bool} &
      ({no_five == True{} : Bool} &
      ({ribbons == True{} : Bool} &
      (PositiveVertices(v) &
       {Nat.add(Nat.add(v, t), 1n) == Nat.add(e, q) : Nat}))))

law topology_report_sound:
  for +report: T.Counts
  for accepted: {T.counts_valid(report) == True{} : Bool}
  Conditions(report)

law topology_report_complete:
  for +report: T.Counts
  for conditions: Conditions(report)
  {T.counts_valid(report) == True{} : Bool}

# Guard failure cannot produce a topology certificate for arbitrary artwork.
law topology_guard_closed:
  for a: List<&2, C.Section>
  for b: List<&2, C.Section>
  for c: List<&2, C.Section>
  {T.inspect_guard(False{}, a, b, c) ==
   T.Counts{0n, 0n, 0n, 0n, False{}, False{}, False{}, False{}} : T.Counts}

# Independent case specification for a graph on the three nonempty ribbons.
def connected_spec(ab: Bool, ac: Bool, bc: Bool) -> Bool:
  match ab ac:
    case False{} False{}: False{}
    case False{} True{}: bc
    case True{} False{}: bc
    case True{} True{}: True{}

law three_ribbons_connected:
  for +ab: Bool
  for +ac: Bool
  for +bc: Bool
  {T.connected_edges(ab, ac, bc) == connected_spec(ab, ac, bc) : Bool}
