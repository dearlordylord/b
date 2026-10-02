# SPDX-License-Identifier: Apache-2.0
# Copyright 2026 HigherOrderCO
# Selected arithmetic proofs from bendlib bend-mathlib/nat.bend.
# Local subset for the SVG proof; no project dependency is introduced.
# https://github.com/bendlib/bendlib
# bend-mathlib/nat.bend: Nat arithmetic (add, mul, sub, min, max, pow) and order (le, lt, ge, gt).
import Base

# Zero is a right identity for addition: x + 0 = x.
law add_zero:
  for x: Nat
  {Nat.add(x, 0n) == x : Nat}

def add_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %add_zero(p) : {1n+Nat.add(p, 0n) == 1n+_ : Nat}
      {==}

# Zero is a left identity for addition: 0 + x = x.
law zero_add:
  for -x: Nat
  {Nat.add(0n, x) == x : Nat}

def zero_add(x):
  {==}

# Adding a successor on the right: n + (m + 1) = (n + m) + 1.
law add_succ:
  for n: Nat
  for -m: Nat
  {Nat.add(n, 1n+m) == 1n+Nat.add(n, m) : Nat}

def add_succ(n, m):
  match n:
    case 0n:
      {==}
    case 1n+p:
      %add_succ(p, m) : {1n+Nat.add(p, 1n+m) == 1n+_ : Nat}
      {==}

# Adding a successor on the left: (n + 1) + m = (n + m) + 1.
law succ_add:
  for -n: Nat
  for -m: Nat
  {Nat.add(1n+n, m) == 1n+Nat.add(n, m) : Nat}

def succ_add(n, m):
  {==}

# Addition is commutative: n + m = m + n.
law add_comm:
  for n: Nat
  for m: Nat
  {Nat.add(n, m) == Nat.add(m, n) : Nat}

def add_comm(n, m):
  match n m:
    case 0n 0n:
      {==}
    case 0n 1n+q:
      %add_zero(q) : {1n+_ == 1n+Nat.add(q, 0n) : Nat}
      {==}
    case 1n+p 0n:
      %add_zero(p) : {1n+Nat.add(p, 0n) == 1n+_ : Nat}
      {==}
    case 1n++p 1n++q:
      %Equal.sym(Nat, Nat.add(p, 1n+q), 1n+Nat.add(p, q), add_succ(p, q)) : {1n+_ == 1n+Nat.add(q, 1n+p) : Nat}
      %Equal.sym(Nat, Nat.add(q, 1n+p), 1n+Nat.add(q, p), add_succ(q, p)) : {2n+Nat.add(p, q) == 1n+_ : Nat}
      %add_comm(p, q) : {2n+Nat.add(p, q) == 2n+_ : Nat}
      {==}

# Addition is associative: (a + b) + c = a + (b + c).
law add_assoc:
  for a: Nat
  for -b: Nat
  for -c: Nat
  {Nat.add(Nat.add(a, b), c) == Nat.add(a, Nat.add(b, c)) : Nat}

def add_assoc(a, b, c):
  match a:
    case 0n:
      {==}
    case 1n+p:
      %add_assoc(p, b, c) : {1n+Nat.add(Nat.add(p, b), c) == 1n+_ : Nat}
      {==}

# Left commutativity of addition: a + (b + c) = b + (a + c).
law add_left_comm:
  for a: Nat
  for b: Nat
  for -c: Nat
  {Nat.add(a, Nat.add(b, c)) == Nat.add(b, Nat.add(a, c)) : Nat}

def add_left_comm(a, b, c):
  match a:
    case 0n:
      {==}
    case 1n+p:
      +b = b
      %Equal.sym(Nat, Nat.add(b, 1n+Nat.add(p, c)), 1n+Nat.add(b, Nat.add(p, c)), add_succ(b, Nat.add(p, c))) : {1n+Nat.add(p, Nat.add(b, c)) == _ : Nat}
      %add_left_comm(p, b, c) : {1n+Nat.add(p, Nat.add(b, c)) == 1n+_ : Nat}
      {==}

# Right commutativity of addition: (a + b) + c = (a + c) + b.
law add_right_comm:
  for a: Nat
  for b: Nat
  for c: Nat
  {Nat.add(Nat.add(a, b), c) == Nat.add(Nat.add(a, c), b) : Nat}

def add_right_comm(a, b, c):
  match a:
    case 0n:
      add_comm(b, c)
    case 1n+p:
      %add_right_comm(p, b, c) : {1n+Nat.add(Nat.add(p, b), c) == 1n+_ : Nat}
      {==}

# Four-way regrouping of a sum: (a + b) + (c + d) = (a + c) + (b + d).
law add_add_add_comm:
  for a: Nat
  for b: Nat
  for c: Nat
  for -d: Nat
  {Nat.add(Nat.add(a, b), Nat.add(c, d)) == Nat.add(Nat.add(a, c), Nat.add(b, d)) : Nat}

def add_add_add_comm(a, b, c, d):
  match a:
    case 0n:
      add_left_comm(b, c, d)
    case 1n+p:
      %add_add_add_comm(p, b, c, d) : {1n+Nat.add(Nat.add(p, b), Nat.add(c, d)) == 1n+_ : Nat}
      {==}

# Zero absorbs multiplication on the right: x * 0 = 0.
law mul_zero:
  for x: Nat
  {Nat.mul(x, 0n) == 0n : Nat}

def mul_zero(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      mul_zero(p)

# Zero absorbs multiplication on the left: 0 * x = 0.
law zero_mul:
  for -x: Nat
  {Nat.mul(0n, x) == 0n : Nat}

def zero_mul(x):
  {==}

# One is a right identity for multiplication: x * 1 = x.
law mul_one:
  for x: Nat
  {Nat.mul(x, 1n) == x : Nat}

def mul_one(x):
  match x:
    case 0n:
      {==}
    case 1n+p:
      %mul_one(p) : {1n+Nat.mul(p, 1n) == 1n+_ : Nat}
      {==}

# One is a left identity for multiplication: 1 * x = x.
law one_mul:
  for x: Nat
  {Nat.mul(1n, x) == x : Nat}

def one_mul(x):
  add_zero(x)

# Multiplying by a successor on the right: n * (m + 1) = n * m + n.
law mul_succ:
  for n: Nat
  for m: Nat
  {Nat.mul(n, 1n+m) == Nat.add(Nat.mul(n, m), n) : Nat}

def mul_succ(n, m):
  match n:
    case 0n:
      {==}
    case 1n++p:
      +m = m
      %Equal.sym(Nat, Nat.add(Nat.add(m, Nat.mul(p, m)), 1n+p), 1n+Nat.add(Nat.add(m, Nat.mul(p, m)), p), add_succ(Nat.add(m, Nat.mul(p, m)), p)) : {1n+Nat.add(m, Nat.mul(p, 1n+m)) == _ : Nat}
      %Equal.sym(Nat, Nat.add(Nat.add(m, Nat.mul(p, m)), p), Nat.add(m, Nat.add(Nat.mul(p, m), p)), add_assoc(m, Nat.mul(p, m), p)) : {1n+Nat.add(m, Nat.mul(p, 1n+m)) == 1n+_ : Nat}
      %mul_succ(p, m) : {1n+Nat.add(m, Nat.mul(p, 1n+m)) == 1n+Nat.add(m, _) : Nat}
      {==}

# Multiplying by a successor on the left: (n + 1) * m = n * m + m.
law succ_mul:
  for n: Nat
  for m: Nat
  {Nat.mul(1n+n, m) == Nat.add(Nat.mul(n, m), m) : Nat}

def succ_mul(n, m):
  +m = m
  add_comm(m, Nat.mul(n, m))

# Multiplication is commutative: n * m = m * n.
law mul_comm:
  for n: Nat
  for m: Nat
  {Nat.mul(n, m) == Nat.mul(m, n) : Nat}

def mul_comm(n, m):
  match n:
    case 0n:
      %mul_zero(m) : {_ == Nat.mul(m, 0n) : Nat}
      {==}
    case 1n++p:
      +m = m
      %Equal.sym(Nat, Nat.mul(m, 1n+p), Nat.add(Nat.mul(m, p), m), mul_succ(m, p)) : {Nat.add(m, Nat.mul(p, m)) == _ : Nat}
      %mul_comm(p, m) : {Nat.add(m, Nat.mul(p, m)) == Nat.add(_, m) : Nat}
      add_comm(m, Nat.mul(p, m))

# Multiplication distributes over addition on the right: (a + b) * c = a * c + b * c.
law add_mul:
  for a: Nat
  for -b: Nat
  for c: Nat
  {Nat.mul(Nat.add(a, b), c) == Nat.add(Nat.mul(a, c), Nat.mul(b, c)) : Nat}

def add_mul(a, b, c):
  match a:
    case 0n:
      {==}
    case 1n+p:
      +c = c
      %Equal.sym(Nat, Nat.add(Nat.add(c, Nat.mul(p, c)), Nat.mul(b, c)), Nat.add(c, Nat.add(Nat.mul(p, c), Nat.mul(b, c))), add_assoc(c, Nat.mul(p, c), Nat.mul(b, c))) : {Nat.add(c, Nat.mul(Nat.add(p, b), c)) == _ : Nat}
      %add_mul(p, b, c) : {Nat.add(c, Nat.mul(Nat.add(p, b), c)) == Nat.add(c, _) : Nat}
      {==}

# Multiplication distributes over addition on the left: a * (b + c) = a * b + a * c.
law mul_add:
  for a: Nat
  for b: Nat
  for c: Nat
  {Nat.mul(a, Nat.add(b, c)) == Nat.add(Nat.mul(a, b), Nat.mul(a, c)) : Nat}

def mul_add(a, b, c):
  match a:
    case 0n:
      {==}
    case 1n++p:
      +b = b
      +c = c
      %Equal.sym(Nat, Nat.mul(p, Nat.add(b, c)), Nat.add(Nat.mul(p, b), Nat.mul(p, c)), mul_add(p, b, c)) : {Nat.add(Nat.add(b, c), _) == Nat.add(Nat.add(b, Nat.mul(p, b)), Nat.add(c, Nat.mul(p, c))) : Nat}
      add_add_add_comm(b, c, Nat.mul(p, b), Nat.mul(p, c))

# Multiplication is associative: (a * b) * c = a * (b * c).
law mul_assoc:
  for a: Nat
  for b: Nat
  for c: Nat
  {Nat.mul(Nat.mul(a, b), c) == Nat.mul(a, Nat.mul(b, c)) : Nat}

def mul_assoc(a, b, c):
  match a:
    case 0n:
      {==}
    case 1n+p:
      +b = b
      +c = c
      %mul_assoc(p, b, c) : {Nat.mul(Nat.add(b, Nat.mul(p, b)), c) == Nat.add(Nat.mul(b, c), _) : Nat}
      add_mul(b, Nat.mul(p, b), c)


# Regroup the four corner weights into pure and mixed Bernstein terms.
law corner_regroup:
  for +a: Nat
  for +b: Nat
  for +c: Nat
  {Nat.add(Nat.add(Nat.add(a,b),b),Nat.add(Nat.add(c,b),b)) == Nat.add(Nat.add(a,c),Nat.add(Nat.add(b,b),Nat.add(b,b))) : Nat}

def corner_regroup(a,b,c):
  %Equal.sym(Nat,Nat.add(Nat.add(a,b),b),Nat.add(a,Nat.add(b,b)),add_assoc(a,b,b)) : {Nat.add(_,Nat.add(Nat.add(c,b),b)) == Nat.add(Nat.add(a,c),Nat.add(Nat.add(b,b),Nat.add(b,b))) : Nat}
  %Equal.sym(Nat,Nat.add(Nat.add(c,b),b),Nat.add(c,Nat.add(b,b)),add_assoc(c,b,b)) : {Nat.add(Nat.add(a,Nat.add(b,b)),_) == Nat.add(Nat.add(a,c),Nat.add(Nat.add(b,b),Nat.add(b,b))) : Nat}
  add_add_add_comm(a,Nat.add(b,b),c,Nat.add(b,b))

# Square expansion, ordered as the four convex-cell corner weights.
law square_expand:
  for +u: Nat
  for +v: Nat
  {Nat.mul(Nat.add(u,v),Nat.add(u,v)) == Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))) : Nat}

def square_expand(u,v):
  %Equal.sym(Nat,Nat.mul(Nat.add(u,v),Nat.add(u,v)),Nat.add(Nat.mul(u,Nat.add(u,v)),Nat.mul(v,Nat.add(u,v))),add_mul(u,v,Nat.add(u,v))) : {_ == Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))) : Nat}
  %Equal.sym(Nat,Nat.mul(u,Nat.add(u,v)),Nat.add(Nat.mul(u,u),Nat.mul(u,v)),mul_add(u,u,v)) : {Nat.add(_,Nat.mul(v,Nat.add(u,v))) == Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))) : Nat}
  %Equal.sym(Nat,Nat.mul(v,Nat.add(u,v)),Nat.add(Nat.mul(v,u),Nat.mul(v,v)),mul_add(v,u,v)) : {Nat.add(Nat.add(Nat.mul(u,u),Nat.mul(u,v)),_) == Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))) : Nat}
  %mul_comm(u,v) : {Nat.add(Nat.add(Nat.mul(u,u),Nat.mul(u,v)),Nat.add(_,Nat.mul(v,v))) == Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))) : Nat}
  %add_comm(Nat.mul(v,v),Nat.mul(u,v)) : {Nat.add(Nat.add(Nat.mul(u,u),Nat.mul(u,v)),_) == Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))) : Nat}
  %add_comm(Nat.mul(u,u),Nat.mul(v,v)) : {Nat.add(Nat.add(Nat.mul(u,u),Nat.mul(u,v)),Nat.add(Nat.mul(v,v),Nat.mul(u,v))) == Nat.add(_,Nat.add(Nat.mul(u,v),Nat.mul(u,v))) : Nat}
  add_add_add_comm(Nat.mul(u,u),Nat.mul(u,v),Nat.mul(v,v),Nat.mul(u,v))

# Nonnegative corner coefficients of the quadratic with centroid control.
def qa(+u: Nat,+v: Nat) -> Nat:
  Nat.add(Nat.mul(4n,Nat.mul(v,v)),Nat.mul(2n,Nat.mul(u,v)))
def qb(u: Nat,v: Nat) -> Nat:
  Nat.mul(2n,Nat.mul(u,v))
def qc(+u: Nat,+v: Nat) -> Nat:
  Nat.add(Nat.mul(4n,Nat.mul(u,u)),Nat.mul(2n,Nat.mul(u,v)))
def weight_total(+u: Nat,+v: Nat) -> Nat:
  Nat.add(Nat.add(qa(u,v),qb(u,v)),Nat.add(qc(u,v),qb(u,v)))

law weight_sum:
  for +u: Nat
  for +v: Nat
  {weight_total(u,v) == Nat.mul(4n,Nat.mul(Nat.add(u,v),Nat.add(u,v))) : Nat}

def weight_sum(u,v):
  %Equal.sym(Nat,weight_total(u,v),Nat.add(Nat.add(Nat.mul(4n,Nat.mul(v,v)),Nat.mul(4n,Nat.mul(u,u))),Nat.add(Nat.add(qb(u,v),qb(u,v)),Nat.add(qb(u,v),qb(u,v)))),corner_regroup(Nat.mul(4n,Nat.mul(v,v)),qb(u,v),Nat.mul(4n,Nat.mul(u,u)))) : {_ == Nat.mul(4n,Nat.mul(Nat.add(u,v),Nat.add(u,v))) : Nat}
  %add_mul(2n,2n,Nat.mul(u,v)) : {Nat.add(Nat.add(Nat.mul(4n,Nat.mul(v,v)),Nat.mul(4n,Nat.mul(u,u))),Nat.add(_,Nat.add(qb(u,v),qb(u,v)))) == Nat.mul(4n,Nat.mul(Nat.add(u,v),Nat.add(u,v))) : Nat}
  %add_mul(2n,2n,Nat.mul(u,v)) : {Nat.add(Nat.add(Nat.mul(4n,Nat.mul(v,v)),Nat.mul(4n,Nat.mul(u,u))),Nat.add(Nat.mul(4n,Nat.mul(u,v)),_)) == Nat.mul(4n,Nat.mul(Nat.add(u,v),Nat.add(u,v))) : Nat}
  %mul_add(4n,Nat.mul(v,v),Nat.mul(u,u)) : {Nat.add(_,Nat.add(Nat.mul(4n,Nat.mul(u,v)),Nat.mul(4n,Nat.mul(u,v)))) == Nat.mul(4n,Nat.mul(Nat.add(u,v),Nat.add(u,v))) : Nat}
  %mul_add(4n,Nat.mul(u,v),Nat.mul(u,v)) : {Nat.add(Nat.mul(4n,Nat.add(Nat.mul(v,v),Nat.mul(u,u))),_) == Nat.mul(4n,Nat.mul(Nat.add(u,v),Nat.add(u,v))) : Nat}
  %Equal.sym(Nat,Nat.mul(Nat.add(u,v),Nat.add(u,v)),Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))),square_expand(u,v)) : {Nat.add(Nat.mul(4n,Nat.add(Nat.mul(v,v),Nat.mul(u,u))),Nat.mul(4n,Nat.add(Nat.mul(u,v),Nat.mul(u,v)))) == Nat.mul(4n,_) : Nat}
  Equal.sym(Nat,Nat.mul(4n,Nat.add(Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v)))),Nat.add(Nat.mul(4n,Nat.add(Nat.mul(v,v),Nat.mul(u,u))),Nat.mul(4n,Nat.add(Nat.mul(u,v),Nat.mul(u,v)))),mul_add(4n,Nat.add(Nat.mul(v,v),Nat.mul(u,u)),Nat.add(Nat.mul(u,v),Nat.mul(u,v))))

law scalar_regroup:
  for +x: Nat
  for +y: Nat
  for +z: Nat
  for +w: Nat
  for +p: Nat
  for +q: Nat
  {Nat.add(Nat.add(x,Nat.add(Nat.add(y,z),Nat.add(w,p))),q) == Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(Nat.add(q,w),p)) : Nat}

def scalar_regroup(x,y,z,w,p,q):
  %add_assoc(x,Nat.add(y,z),Nat.add(w,p)) : {Nat.add(_,q) == Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(Nat.add(q,w),p)) : Nat}
  %add_assoc(x,y,z) : {Nat.add(Nat.add(_,Nat.add(w,p)),q) == Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(Nat.add(q,w),p)) : Nat}
  %Equal.sym(Nat,Nat.add(Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(w,p)),q),Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(Nat.add(w,p),q)),add_assoc(Nat.add(Nat.add(x,y),z),Nat.add(w,p),q)) : {_ == Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(Nat.add(q,w),p)) : Nat}
  %add_comm(q,Nat.add(w,p)) : {Nat.add(Nat.add(Nat.add(x,y),z),_) == Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(Nat.add(q,w),p)) : Nat}
  %add_assoc(q,w,p) : {Nat.add(Nat.add(Nat.add(x,y),z),_) == Nat.add(Nat.add(Nat.add(x,y),z),Nat.add(Nat.add(q,w),p)) : Nat}
  {==}

# Move the scalar factor 4 through a weighted centroid coordinate.
law centroid_scale:
  for +b: Nat
  for +c: Nat
  {Nat.mul(4n,Nat.mul(b,c)) == Nat.mul(b,Nat.mul(4n,c)) : Nat}

def centroid_scale(b,c):
  %mul_assoc(4n,b,c) : {_ == Nat.mul(b,Nat.mul(4n,c)) : Nat}
  %mul_comm(b,4n) : {Nat.mul(_,c) == Nat.mul(b,Nat.mul(4n,c)) : Nat}
  mul_assoc(b,4n,c)

law centroid_distribute:
  for +b: Nat
  for +l0: Nat
  for +l1: Nat
  for +r0: Nat
  for +r1: Nat
  for +c: Nat
  for h: {Nat.mul(4n,c) == Nat.add(Nat.add(l0,l1),Nat.add(r0,r1)) : Nat}
  {Nat.mul(4n,Nat.mul(b,c)) == Nat.add(Nat.add(Nat.mul(b,l0),Nat.mul(b,l1)),Nat.add(Nat.mul(b,r0),Nat.mul(b,r1))) : Nat}

def centroid_distribute(b,l0,l1,r0,r1,c,h):
  %Equal.sym(Nat,Nat.mul(4n,Nat.mul(b,c)),Nat.mul(b,Nat.mul(4n,c)),centroid_scale(b,c)) : {_ == Nat.add(Nat.add(Nat.mul(b,l0),Nat.mul(b,l1)),Nat.add(Nat.mul(b,r0),Nat.mul(b,r1))) : Nat}
  %Equal.sym(Nat,Nat.mul(4n,c),Nat.add(Nat.add(l0,l1),Nat.add(r0,r1)),h) : {Nat.mul(b,_) == Nat.add(Nat.add(Nat.mul(b,l0),Nat.mul(b,l1)),Nat.add(Nat.mul(b,r0),Nat.mul(b,r1))) : Nat}
  %mul_add(b,l0,l1) : {Nat.mul(b,Nat.add(Nat.add(l0,l1),Nat.add(r0,r1))) == Nat.add(_,Nat.add(Nat.mul(b,r0),Nat.mul(b,r1))) : Nat}
  %mul_add(b,r0,r1) : {Nat.mul(b,Nat.add(Nat.add(l0,l1),Nat.add(r0,r1))) == Nat.add(Nat.mul(b,Nat.add(l0,l1)),_) : Nat}
  mul_add(b,Nat.add(l0,l1),Nat.add(r0,r1))

# Generic Bernstein-to-corner expansion. Set a=v*v, b=2*u*v, d=u*u.
law centroid_quadratic:
  for +a: Nat
  for +b: Nat
  for +d: Nat
  for +l0: Nat
  for +l1: Nat
  for +r0: Nat
  for +r1: Nat
  for +c: Nat
  for h: {Nat.mul(4n,c) == Nat.add(Nat.add(l0,l1),Nat.add(r0,r1)) : Nat}
  {Nat.mul(4n,Nat.add(Nat.add(Nat.mul(a,l0),Nat.mul(b,c)),Nat.mul(d,r0))) == Nat.add(Nat.add(Nat.mul(Nat.add(Nat.mul(4n,a),b),l0),Nat.mul(b,l1)),Nat.add(Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.mul(b,r1))) : Nat}

def centroid_quadratic(a,b,d,l0,l1,r0,r1,c,h):
  %Equal.sym(Nat,Nat.mul(4n,Nat.add(Nat.add(Nat.mul(a,l0),Nat.mul(b,c)),Nat.mul(d,r0))),Nat.add(Nat.mul(4n,Nat.add(Nat.mul(a,l0),Nat.mul(b,c))),Nat.mul(4n,Nat.mul(d,r0))),mul_add(4n,Nat.add(Nat.mul(a,l0),Nat.mul(b,c)),Nat.mul(d,r0))) : {_ == Nat.add(Nat.add(Nat.mul(Nat.add(Nat.mul(4n,a),b),l0),Nat.mul(b,l1)),Nat.add(Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.mul(b,r1))) : Nat}
  %Equal.sym(Nat,Nat.mul(4n,Nat.add(Nat.mul(a,l0),Nat.mul(b,c))),Nat.add(Nat.mul(4n,Nat.mul(a,l0)),Nat.mul(4n,Nat.mul(b,c))),mul_add(4n,Nat.mul(a,l0),Nat.mul(b,c))) : {Nat.add(_,Nat.mul(4n,Nat.mul(d,r0))) == Nat.add(Nat.add(Nat.mul(Nat.add(Nat.mul(4n,a),b),l0),Nat.mul(b,l1)),Nat.add(Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.mul(b,r1))) : Nat}
  %mul_assoc(4n,a,l0) : {Nat.add(Nat.add(_,Nat.mul(4n,Nat.mul(b,c))),Nat.mul(4n,Nat.mul(d,r0))) == Nat.add(Nat.add(Nat.mul(Nat.add(Nat.mul(4n,a),b),l0),Nat.mul(b,l1)),Nat.add(Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.mul(b,r1))) : Nat}
  %mul_assoc(4n,d,r0) : {Nat.add(Nat.add(Nat.mul(Nat.mul(4n,a),l0),Nat.mul(4n,Nat.mul(b,c))),_) == Nat.add(Nat.add(Nat.mul(Nat.add(Nat.mul(4n,a),b),l0),Nat.mul(b,l1)),Nat.add(Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.mul(b,r1))) : Nat}
  %Equal.sym(Nat,Nat.mul(4n,Nat.mul(b,c)),Nat.add(Nat.add(Nat.mul(b,l0),Nat.mul(b,l1)),Nat.add(Nat.mul(b,r0),Nat.mul(b,r1))),centroid_distribute(b,l0,l1,r0,r1,c,h)) : {Nat.add(Nat.add(Nat.mul(Nat.mul(4n,a),l0),_),Nat.mul(Nat.mul(4n,d),r0)) == Nat.add(Nat.add(Nat.mul(Nat.add(Nat.mul(4n,a),b),l0),Nat.mul(b,l1)),Nat.add(Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.mul(b,r1))) : Nat}
  %Equal.sym(Nat,Nat.mul(Nat.add(Nat.mul(4n,a),b),l0),Nat.add(Nat.mul(Nat.mul(4n,a),l0),Nat.mul(b,l0)),add_mul(Nat.mul(4n,a),b,l0)) : {Nat.add(Nat.add(Nat.mul(Nat.mul(4n,a),l0),Nat.add(Nat.add(Nat.mul(b,l0),Nat.mul(b,l1)),Nat.add(Nat.mul(b,r0),Nat.mul(b,r1)))),Nat.mul(Nat.mul(4n,d),r0)) == Nat.add(Nat.add(_,Nat.mul(b,l1)),Nat.add(Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.mul(b,r1))) : Nat}
  %Equal.sym(Nat,Nat.mul(Nat.add(Nat.mul(4n,d),b),r0),Nat.add(Nat.mul(Nat.mul(4n,d),r0),Nat.mul(b,r0)),add_mul(Nat.mul(4n,d),b,r0)) : {Nat.add(Nat.add(Nat.mul(Nat.mul(4n,a),l0),Nat.add(Nat.add(Nat.mul(b,l0),Nat.mul(b,l1)),Nat.add(Nat.mul(b,r0),Nat.mul(b,r1)))),Nat.mul(Nat.mul(4n,d),r0)) == Nat.add(Nat.add(Nat.add(Nat.mul(Nat.mul(4n,a),l0),Nat.mul(b,l0)),Nat.mul(b,l1)),Nat.add(_,Nat.mul(b,r1))) : Nat}
  scalar_regroup(Nat.mul(Nat.mul(4n,a),l0),Nat.mul(b,l0),Nat.mul(b,l1),Nat.mul(b,r0),Nat.mul(b,r1),Nat.mul(Nat.mul(4n,d),r0))

# A nonzero parameter pair gives a genuinely positive normalization divisor.
law weight_positive_left:
  for +k: Nat
  for +v: Nat
  {Nat.is_eq(weight_total(1n+k,v),0n) == False{} : Bool}

def weight_positive_left(k,v):
  %Equal.sym(Nat,weight_total(1n+k,v),Nat.mul(4n,Nat.mul(Nat.add(1n+k,v),Nat.add(1n+k,v))),weight_sum(1n+k,v)) : {Nat.is_eq(_,0n) == False{} : Bool}
  {==}

law weight_positive_right:
  for +u: Nat
  for +k: Nat
  {Nat.is_eq(weight_total(u,1n+k),0n) == False{} : Bool}

def weight_positive_right(u,k):
  %Equal.sym(Nat,weight_total(u,1n+k),Nat.mul(4n,Nat.mul(Nat.add(u,1n+k),Nat.add(u,1n+k))),weight_sum(u,1n+k)) : {Nat.is_eq(_,0n) == False{} : Bool}
  %Equal.sym(Nat,Nat.add(u,1n+k),1n+Nat.add(u,k),add_succ(u,k)) : {Nat.is_eq(Nat.mul(4n,Nat.mul(_,Nat.add(u,1n+k))),0n) == False{} : Bool}
  %Equal.sym(Nat,Nat.add(u,1n+k),1n+Nat.add(u,k),add_succ(u,k)) : {Nat.is_eq(Nat.mul(4n,Nat.mul(1n+Nat.add(u,k),_)),0n) == False{} : Bool}
  {==}
