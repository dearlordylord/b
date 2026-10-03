import Base
import ./topology.bend as T
import ./sample-arithmetic.bend as M
import ./sample-arithmetic-laws.bend as L
import ./sample-production-proof.bend as P
import ./word-arithmetic.bend as W

def start_endpoint() -> {M.values(T.sample(T.P{1, 2}, T.P{3, 4}, 0)) == (64n, (128n, 64n)) : Nat & (Nat & Nat)}:
  L.accepted_sample_exact(12n, {==}, T.P{1, 2}, T.P{3, 4}, 0, {==}, {==}, {==})
def midpoint() -> {M.values(T.sample(T.P{1, 2}, T.P{3, 4}, 32)) == (128n, (192n, 64n)) : Nat & (Nat & Nat)}:
  L.accepted_sample_exact(12n, {==}, T.P{1, 2}, T.P{3, 4}, 32, {==}, {==}, {==})
def finish_endpoint() -> {M.values(T.sample(T.P{1, 2}, T.P{3, 4}, 64)) == (192n, (256n, 64n)) : Nat & (Nat & Nat)}:
  L.accepted_sample_exact(12n, {==}, T.P{1, 2}, T.P{3, 4}, 64, {==}, {==}, {==})
def last_interior() -> {M.values(T.sample(T.P{1, 2}, T.P{3, 4}, 63)) == (190n, (254n, 64n)) : Nat & (Nat & Nat)}:
  L.accepted_sample_exact(12n, {==}, T.P{1, 2}, T.P{3, 4}, 63, {==}, {==}, {==})
def output_envelope() -> {M.envelope(12n, T.sample(T.P{1, 2}, T.P{3, 4}, 64)) == True{} : Bool}:
  L.accepted_sample_envelope(12n, {==}, T.P{1, 2}, T.P{3, 4}, 64, {==}, {==}, {==})
def envelope_boundary() -> {Nat.is_le(M.numerator(1n, 1n, 64n), W.capacity(6n)) == True{} : Bool}:
  L.sample_numerator_bound(0n, 1n, 1n, 64n, {==}, {==}, {==})
def vertex_exact() -> {M.values(T.witness(T.P{3, 4})) == (3n, (4n, 1n)) : Nat & (Nat & Nat)}:
  L.vertex_witness_exact(T.P{3, 4})
def vertex_envelope() -> {M.envelope(12n, T.witness(T.P{3, 4})) == True{} : Bool}:
  L.vertex_witness_envelope(12n, T.P{3, 4}, {==})
def maximum_search_weight() -> {U32.is_le(U32.from_nat(64n), 64) == True{} : Bool}:
  L.search_weight_guard(63n, 63n, {==}, {==})
def minimum_search_weight() -> {U32.is_le(U32.from_nat(1n), 64) == True{} : Bool}:
  L.search_weight_guard(0n, 0n, {==}, {==})
