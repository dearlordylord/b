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

Still required for stage 1: prove Nat-to-word conversion and multiplication,
instantiate the arithmetic bounds for geometry, and connect each production
geometric expression to its exact model. Stages 2–4 remain uncompleted.
