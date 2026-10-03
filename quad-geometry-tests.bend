import Base
import ./quad-geometry.bend as M
import ./natural-cover.bend as N
import ./halfplane-region.bend as Region

def ccw_square() -> N.Quad:
  N.Q{N.P{1n, 1n}, N.P{3n, 1n}, N.P{3n, 3n}, N.P{1n, 3n}}
def strict_square() -> {M.strict_quad(ccw_square()) == True{} : Bool}:
  {==}
def square_corners() -> {M.corners_inside(ccw_square()) == True{} : Bool}:
  {==}
def missing_fourth_quad() -> N.Quad:
  N.Q{N.P{4n, 4n}, N.P{8n, 4n}, N.P{8n, 8n}, N.P{2n, 3n}}
def first_three_turns_pass() -> {M.turn(N.P{4n, 4n}, N.P{8n, 4n}, N.P{8n, 8n}) && M.turn(N.P{8n, 4n}, N.P{8n, 8n}, N.P{2n, 3n}) && M.turn(N.P{8n, 8n}, N.P{2n, 3n}, N.P{4n, 4n}) == True{} : Bool}:
  {==}
def fourth_turn_fails() -> {M.turn(N.P{2n, 3n}, N.P{4n, 4n}, N.P{8n, 4n}) == False{} : Bool}:
  {==}
def fourth_corner_outside() -> {Region.contains(M.embed(N.P{2n, 3n}), missing_fourth_quad()) == False{} : Bool}:
  {==}
def all_four_turns_required() -> {M.strict_quad(missing_fourth_quad()) == False{} : Bool}:
  {==}
def clockwise_rejected() -> {M.strict_quad(N.Q{N.P{1n, 1n}, N.P{1n, 3n}, N.P{3n, 3n}, N.P{3n, 1n}}) == False{} : Bool}:
  {==}
def clockwise_corners_outside() -> {M.corners_inside(N.Q{N.P{1n, 1n}, N.P{1n, 3n}, N.P{3n, 3n}, N.P{3n, 1n}}) == False{} : Bool}:
  {==}
def collinear_rejected() -> {M.strict_quad(N.Q{N.P{1n, 1n}, N.P{2n, 2n}, N.P{3n, 3n}, N.P{4n, 4n}}) == False{} : Bool}:
  {==}
