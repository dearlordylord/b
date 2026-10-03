import Base
import ./coordinate-transverse-laws.bend as L
import ./coordinate-transverse.bend as T
import ./coordinate-sum.bend as S
import ./coordinate-sum4.bend as Four
import ./coordinate-dot-pair-laws.bend as Pair
import ./coordinate-dot-pair-proof.bend as Existing
import ./coordinate-support.bend as Runtime
import ./boolean-reflection.bend as ValidationProof
import ./core.bend as Core
import ./validation.bend as V

def comparison0(+lx: Nat, +ly: Nat, +cx: Nat, +cy: Nat, +rx: Nat, +ry: Nat, hs: S.Bounds<lx, ly, cx, cy, rx, ry>) -> {U32.is_gt(U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry}), V.dot(Core.Pt{lx, ly}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly}), V.dot(Core.Pt{lx, ly}, Core.Pt{rx, ry}))) == Nat.is_gt(Four.exact(cx, rx, cy, ry, lx, lx, ly, ly), Four.exact(cx, lx, cy, ly, lx, rx, ly, ry)) : Bool}:
  match hs:
    case S.Bound{+hlx, +hly, +hcx, +hcy, +hrx, +hry}:
      Runtime.greater_values(U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry}), V.dot(Core.Pt{lx, ly}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly}), V.dot(Core.Pt{lx, ly}, Core.Pt{rx, ry})), Four.exact(cx, rx, cy, ry, lx, lx, ly, ly), Four.exact(cx, lx, cy, ly, lx, rx, ly, ry), Pair.guarded_dot_pair(cx, rx, cy, ry, lx, lx, ly, ly, Four.Bound{hcx, hrx, hcy, hry, hlx, hlx, hly, hly}), Pair.guarded_dot_pair(cx, lx, cy, ly, lx, rx, ly, ry, Four.Bound{hcx, hlx, hcy, hly, hlx, hrx, hly, hry}))

def comparison1(+lx: Nat, +ly: Nat, +cx: Nat, +cy: Nat, +rx: Nat, +ry: Nat, hs: S.Bounds<lx, ly, cx, cy, rx, ry>) -> {U32.is_gt(U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{rx, ry}), V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{lx, ly}), V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry}))) == Nat.is_gt(Four.exact(rx, rx, ry, ry, cx, lx, cy, ly), Four.exact(rx, lx, ry, ly, cx, rx, cy, ry)) : Bool}:
  match hs:
    case S.Bound{+hlx, +hly, +hcx, +hcy, +hrx, +hry}:
      Runtime.greater_values(U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{rx, ry}), V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{lx, ly}), V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry})), Four.exact(rx, rx, ry, ry, cx, lx, cy, ly), Four.exact(rx, lx, ry, ly, cx, rx, cy, ry), Pair.guarded_dot_pair(rx, rx, ry, ry, cx, lx, cy, ly, Four.Bound{hrx, hrx, hry, hry, hcx, hlx, hcy, hly}), Pair.guarded_dot_pair(rx, lx, ry, ly, cx, rx, cy, ry, Four.Bound{hrx, hlx, hry, hly, hcx, hrx, hcy, hry}))

def and_values(+a: Bool, +b: Bool, +c: Bool, +d: Bool, first: {a == c : Bool}, second: {b == d : Bool}) -> {Bool.and(a, b) == Bool.and(c, d) : Bool}:
  %first : {Bool.and(a, b) == Bool.and(_, d) : Bool}
  %second : {Bool.and(a, b) == Bool.and(a, _) : Bool}
  {==}

def transverse_finish(+lx: Nat, +ly: Nat, +cx: Nat, +cy: Nat, +rx: Nat, +ry: Nat, +hs: S.Bounds<lx, ly, cx, cy, rx, ry>) -> {U32.is_gt(U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry}), V.dot(Core.Pt{lx, ly}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly}), V.dot(Core.Pt{lx, ly}, Core.Pt{rx, ry}))) && U32.is_gt(U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{rx, ry}), V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{lx, ly}), V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry}))) == T.exact(lx, ly, cx, cy, rx, ry) : Bool}:
  and_values(U32.is_gt(U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry}), V.dot(Core.Pt{lx, ly}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly}), V.dot(Core.Pt{lx, ly}, Core.Pt{rx, ry}))), U32.is_gt(U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{rx, ry}), V.dot(Core.Pt{cx, cy}, Core.Pt{lx, ly})), U32.add(V.dot(Core.Pt{rx, ry}, Core.Pt{lx, ly}), V.dot(Core.Pt{cx, cy}, Core.Pt{rx, ry}))), Nat.is_gt(Four.exact(cx, rx, cy, ry, lx, lx, ly, ly), Four.exact(cx, lx, cy, ly, lx, rx, ly, ry)), Nat.is_gt(Four.exact(rx, rx, ry, ry, cx, lx, cy, ly), Four.exact(rx, lx, ry, ly, cx, rx, cy, ry)), comparison0(lx, ly, cx, cy, rx, ry, hs), comparison1(lx, ly, cx, cy, rx, ry, hs))

def L.guarded_transverse_exact(lx, ly, cx, cy, rx, ry, hs):
  transverse_finish(lx, ly, cx, cy, rx, ry, hs)

def L.accepted_points_transverse(lx, ly, cx, cy, rx, ry, hleft, hcontrol, hright):
  L.guarded_transverse_exact(lx, ly, cx, cy, rx, ry, Runtime.bounds_from_pairs(lx, ly, cx, cy, rx, ry, (ValidationProof.and_split(Nat.is_le(lx, 16000n), Nat.is_le(ly, 16000n), hleft), (ValidationProof.and_split(Nat.is_le(cx, 16000n), Nat.is_le(cy, 16000n), hcontrol), ValidationProof.and_split(Nat.is_le(rx, 16000n), Nat.is_le(ry, 16000n), hright)))))
