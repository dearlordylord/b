import ./boolean-reflection.bend as B
import Base
import ./homogeneous-geometry.bend as G
import ./homogeneous-geometry-proof.bend as GP
import ./homogeneous-combination.bend as M
import ./homogeneous-combination-proof.bend as CP
import ./facts.bend as F

# Raw source endpoints are the unit-weight combinations, without rescaling.
def unit_left_scalar(+a:Nat,+b:Nat) -> {Nat.add(Nat.mul(a,1n),Nat.mul(b,0n)) == a : Nat}:
  %Equal.sym(Nat,Nat.mul(a,1n),a,F.mul_one(a)) : {Nat.add(_,Nat.mul(b,0n)) == a : Nat}
  %Equal.sym(Nat,Nat.mul(b,0n),0n,F.mul_zero(b)) : {Nat.add(a,_) == a : Nat}
  F.add_zero(a)
def join_left_unit(+p:G.Point,+q:G.Point) -> {M.join(p,q,1n,0n) == p : G.Point}:
  match p q:
    case G.P{+x,+y,+d} G.P{u,v,e}: GP.point_equal(Nat.add(Nat.mul(x,1n),Nat.mul(u,0n)),Nat.add(Nat.mul(y,1n),Nat.mul(v,0n)),Nat.add(Nat.mul(d,1n),Nat.mul(e,0n)),x,y,d,unit_left_scalar(x,u),unit_left_scalar(y,v),unit_left_scalar(d,e))
def join_right_unit(+p:G.Point,+q:G.Point) -> {M.join(p,q,0n,1n) == q : G.Point}:
  Equal.trans(G.Point,M.join(p,q,0n,1n),M.join(q,p,1n,0n),q,Equal.sym(G.Point,M.join(q,p,1n,0n),M.join(p,q,0n,1n),CP.join_reversed(p,q,0n,1n)),join_left_unit(q,p))

def zero_pair(+a:Nat,+b:Nat) -> {Nat.add(Nat.mul(a,0n),Nat.mul(b,0n)) == 0n : Nat}:
  %Equal.sym(Nat,Nat.mul(a,0n),0n,F.mul_zero(a)) : {Nat.add(_,Nat.mul(b,0n)) == 0n : Nat}
  %Equal.sym(Nat,Nat.mul(b,0n),0n,F.mul_zero(b)) : {Nat.add(0n,_) == 0n : Nat}
  {==}
def zero_join_invalid(p:G.Point,q:G.Point) -> {G.positive_denominator(M.join(p,q,0n,0n)) == False{} : Bool}:
  match p q:
    case G.P{x,y,+d} G.P{u,v,+e}: Equal.cong(Nat,Bool,n => Nat.is_gt(n,0n),Nat.add(Nat.mul(d,0n),Nat.mul(e,0n)),0n,zero_pair(d,e))

def positive_coefficients(+p:G.Point,+q:G.Point,+k:Nat,+l:Nat,h:{G.positive_denominator(M.join(p,q,k,l)) == True{} : Bool}) -> {Nat.is_gt(Nat.add(k,l),0n) == True{} : Bool}:
  match k l:
    case 0n 0n: B.absurd({Nat.is_gt(Nat.add(0n,0n),0n) == True{} : Bool},B.false_impossible(Equal.trans(Bool,False{},G.positive_denominator(M.join(p,q,0n,0n)),True{},Equal.sym(Bool,G.positive_denominator(M.join(p,q,0n,0n)),False{},zero_join_invalid(p,q)),h)))
    case 0n 1n+rest: {==}
    case 1n+rest n: {==}
