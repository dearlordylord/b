import Base
import ./quad-diagonal.bend as M
import ./quad-diagonal-laws.bend as L
import ./quad-diagonal-proof.bend as Proof
import ./natural-cover.bend as N
import ./homogeneous-geometry.bend as G
import ./halfplane-region.bend as Region

def square() -> N.Quad:
  N.Q{N.P{1n, 1n}, N.P{5n, 1n}, N.P{5n, 5n}, N.P{1n, 5n}}
def below_branch() -> {M.diagonal_acd(square(), G.P{4n, 2n, 1n}) == False{} : Bool}:
  {==}
def above_branch() -> {M.diagonal_acd(square(), G.P{2n, 4n, 1n}) == True{} : Bool}:
  {==}
def diagonal_branch() -> {M.diagonal_acd(square(), G.P{3n, 3n, 1n}) == True{} : Bool}:
  {==}
def below_triangle() -> {M.triangle_abc(square(), G.P{4n, 2n, 1n}) == True{} : Bool}:
  {==}
def above_triangle() -> {M.triangle_acd(square(), G.P{2n, 4n, 1n}) == True{} : Bool}:
  {==}
def diagonal_in_abc() -> {M.triangle_abc(square(), G.P{3n, 3n, 1n}) == True{} : Bool}:
  {==}
def diagonal_in_acd() -> {M.triangle_acd(square(), G.P{3n, 3n, 1n}) == True{} : Bool}:
  {==}
def both_triangles_strict() -> {M.triangles_strict(square()) == True{} : Bool}:
  {==}
def below_split() -> M.Split<square(), G.P{4n, 2n, 1n}>:
  L.region_diagonal_split(square(), G.P{4n, 2n, 1n}, {==})
def above_split() -> M.Split<square(), G.P{2n, 4n, 1n}>:
  L.region_diagonal_split(square(), G.P{2n, 4n, 1n}, {==})
def diagonal_split() -> M.Split<square(), G.P{3n, 3n, 1n}>:
  L.region_diagonal_split(square(), G.P{3n, 3n, 1n}, {==})
def fraction_split() -> M.Split<square(), G.P{4n, 8n, 2n}>:
  L.region_diagonal_split(square(), G.P{4n, 8n, 2n}, {==})
def opposite_diagonal() -> {Region.edge(N.P{5n, 5n}, N.P{1n, 1n}, G.P{4n, 2n, 1n}) == True{} : Bool}:
  {==}
