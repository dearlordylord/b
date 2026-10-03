import Base
import ./topology.bend as T
import ./side-bridge-laws.bend as L
import ./side-bridge-proof.bend as P

def accepted_negative() -> {T.side(T.P{1, 1}, T.P{2, 3}, T.W{1, 0, 1}) == LT{} : Cmp}:
  L.accepted_side_exact(12n, {==}, T.P{1, 1}, T.P{2, 3}, T.W{1, 0, 1}, {==}, {==}, {==})
def sample_above() -> {T.side(T.P{0, 0}, T.P{4, 0}, T.sample(T.P{1, 1}, T.P{3, 3}, 32)) == GT{} : Cmp}:
  L.sampled_side_exact(12n, {==}, T.P{0, 0}, T.P{4, 0}, T.P{1, 1}, T.P{3, 3}, 32, {==}, {==}, {==}, {==}, {==})
def sample_on_edge() -> {T.side(T.P{0, 0}, T.P{4, 0}, T.sample(T.P{1, 0}, T.P{3, 0}, 32)) == EQ{} : Cmp}:
  L.sampled_side_exact(12n, {==}, T.P{0, 0}, T.P{4, 0}, T.P{1, 0}, T.P{3, 0}, 32, {==}, {==}, {==}, {==}, {==})
def vertex_above() -> {T.side(T.P{0, 0}, T.P{4, 0}, T.witness(T.P{1, 1})) == GT{} : Cmp}:
  L.vertex_side_exact(12n, {==}, T.P{0, 0}, T.P{4, 0}, T.P{1, 1}, {==}, {==}, {==})
def vertex_on_edge() -> {T.side(T.P{0, 0}, T.P{4, 0}, T.witness(T.P{1, 0})) == EQ{} : Cmp}:
  L.vertex_side_exact(12n, {==}, T.P{0, 0}, T.P{4, 0}, T.P{1, 0}, {==}, {==}, {==})
