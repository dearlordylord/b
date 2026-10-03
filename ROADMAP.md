# Geometry-to-topology proof programme

Status: active. Execute stages in order; no intermediate user approval is
required under the user's explicit autonomous-work instruction.

## 1. Exact arithmetic

Prove agreement of guarded coordinate arithmetic with exact natural-number
formulas, including orientation, homogeneous witnesses and width/dot products.
First investigate the kernel's U32 semantics and available library facts.
If necessary replace proof-critical arithmetic with an exact representation;
preserve output and measure generation cost. A bounds comment is not a proof.

## 2. Intersections

Prove orientation and closed half-plane membership, correctness of the convex
polygon intersection decision, and soundness of common-point witnesses.
Preserve edge and point contacts. Conservative witness search need not be
complete, but accepted witnesses must establish actual membership.

## 3. Enumeration

Prove unique enumeration of every required simplex, including all triangle
witness obligations and rejection of five-cliques. Relate the computed counts
to an independently stated finite intersection-complex specification.

## 4. Topological interpretation

Define the actual geometric union and its topology, then prove the bridge from
its finite convex cover to component/hole counts. Merely defining holes as
components minus Euler characteristic does not prove this bridge. Assumptions
of Helly, the convex nerve theorem and the planar Euler relation must either
be proved or explicitly remain outstanding; they cannot be disguised as
axioms in a claimed unconditional result.

## Gate for each stage

State readable laws, falsify literal instances, obtain kernel acceptance within
the five-second checker limit, and reject compiling semantic mutations. Run
artifact checks and preserve the generated B. Record exact scope, remaining
gaps and evidence in README. Review before publishing checked changes.

The programme is complete only when all four intended mathematical results
are established. Partial milestones do not complete the objective.

## Verified stage-1 milestones

- Exact homogeneous determinant model: edge reversal exchanges its sums.
- Full-adder bit cell conserves its natural-number value.
- Retained-carry addition agrees with Base Word.adc on its low word.
- Whole-word positional value, including high carry, equals the input sum.
- Zero carry implies exact standard-word addition, at every word width.
- A sum strictly below 2^n forces zero carry and exact standard addition.
- Bounded Nat conversion is exact, including the actual Base U32 primitive.
- Every word value is below capacity; retained shifts are exact, and a bounded
  double agrees with the standard shift.
- Base shift-and-add loop, bounded multiplication and direct U32 addition
  and multiplication agree with exact natural-number arithmetic.

- Word/U32 comparison and geometry-used predicates agree with exact Nat
  comparison; complements sum with their input to the representable maximum.

- Subtraction carry characterizes the borrow; ordered Word/U32 subtraction
  agrees with exact Nat subtraction.

- Actual division by four, its quotient/remainder and agreement with Nat.div
  are proved. Four is the only U32 divisor used by the generator.

- The validation determinant uses a proved three-product sum: one bound on
  its complete exact sum suffices to rule out all intermediate overflows.

- Coordinate guards at 16000 imply a strict 32-bit bound for a three-product
  sum; the universal proof avoids enumerating coordinate values.

- Guarded source coordinates now connect through the actual U32 converter
  and three-product helper to the exact Nat sum. The production determinant
  comparison agrees with the exact orientation for every guarded input.

- The production two-product dot expression is exact for all accepted
  source points.
- The paired four-product sum is strictly below U32 capacity under the
  coordinate guards. Its production addition bridge is now proved: actual
  source conversions and the sum of two production dots equal the exact
  four-product model.
- Both production transverse comparisons, including their conjunction,
  agree with exact Nat arithmetic for every point accepted by the coordinate
  filter. Proof groups now have explicit roots with the same five-second
  per-invocation limit; all earlier laws remain in the full gate.

- Production absolute difference is exact for all U32 inputs. Its natural
  model is symmetric, respects a common coordinate bound and agrees with
  the actual guarded source conversions.
- The production squared-width expression equals the exact sum of squared
  natural distances for all accepted points. The coordinate guards imply
  every intermediate bound. Bounded squared sums are exact at every word
  width.

- The production centroid equals the four-corner natural mean. Averaging
  preserves a common coordinate bound, and the exact-centroid acceptance
  predicate establishes the unrounded four-corner sum equation.

- Homogeneous sums have a strict bit-width bound including denominator 64.
  The actual production side comparison agrees with the exact Nat model
  under coordinate/numerator envelopes. The complete sum bound also proves
  every intermediate multiplication/addition fits, with the first coordinate
  product bounded by the same envelopes.

Still required for stage 1: prove exact scaling of guarded source points,
exact generation of sampled witnesses and their output envelopes.
Stages 2–4 remain uncompleted.
