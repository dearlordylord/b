# b

A steel-blue **B** made of three segmented arms, generated in [Bend](https://bend-lang.com/).

<p align="center">
  <img src="b.svg" alt="Steel-blue letter B made of segmented metal arms" width="320" height="320">
</p>

[SVG output](b.svg) · [PNG preview](preview.png) · [Generator](generate.bend) · [Laws](LAWS.bend) · [Proofs](PROOF.bend)

The outlines and seam endpoints share the same coordinates. Each curved seam
stays inside a convex section of its arm. BendTT checks the general algebraic
proofs; Bend checks the concrete artwork before emitting SVG. An independent
Python checker also inspects the resulting SVG.

## Generate and check

Requirements: Bend **2.0.34**, a C compiler supported by Bend, Python 3, and GNU
`timeout`. The proof gate additionally requires Bend's BendTT kernel for
`--verdict`; this repository does not install toolchains automatically.

```sh
git clone https://github.com/dearlordylord/b.git
cd b
./regenerate.sh
python3 check.py
```

`regenerate.sh` checks the proofs with BendTT, compiles and executes
`generate.bend`, checks the emitted SVG, and replaces `b.svg` only on success.
The generator itself refuses to emit an SVG if its Bend artwork validation fails.

`check.py` runs the 82-law proof gate, 200 literal arithmetic checks,
seven executed validator boundary checks, three executed transverse cases,
compiling mutations that must fail
proofs, invalid artworks that must be rejected before SVG emission, and Bend
and independent Python topology fixtures. Python checks the output artifact;
it does not verify the Bend language.

## How the geometry works

`artwork.bend` contains three arms with 33 paired left/right cross sections each.
`core.bend` derives their outlines, shadows and quadratic Bezier seams from
these shared records. Coordinates are exact natural numbers in hundredths of
a pixel. SVG uses the same integer viewBox, with no floating-point conversion
or decimal rounding. The outline is a densely sampled polygon; the seams are
continuous quadratic curves.

For each seam, the containing tile has corners `L0, L1, R1, R0`. The seam starts
at `L0`, ends at `R0`, and has control point:

```text
C = (L0 + L1 + R0 + R1) / 4
```

The artwork coordinates make this division exact. All 96 tiles are strictly
convex; 24 selected sections carry visible seams.

## What is proved and checked

`LAWS.bend` states five claims, proved in `PROOF.bend`:

1. Every seam starts on its arm's left boundary.
2. Every seam ends on the right boundary of the same cross section.
3. SVG serialization uses those exact boundary coordinates.
4. Each coordinate of the quadratic seam equals a nonnegative weighted
   combination of the four tile corners, under the exact-centroid premise.
5. The corner weights sum to the correct denominator.

For `t = u / (u + v)`, the weights are `4v² + 2uv`, `2uv`, `4u² + 2uv`, `2uv`,
with total `4(u + v)²`. Auxiliary proofs establish a positive denominator when
either parameter is positive. This places every rational-parameter point of
the seam in the tile's convex hull.

For the full continuous SVG curve, containment follows from continuity and
the closed convex hull. That real-analysis step is mathematical reasoning,
not a theorem over a real-number type inside Bend.

The proof is conditional on exact centroids and convex tiles. Before generation,
`validation.bend` checks the actual coordinate bounds, section counts, all
96 tiles for convexity, centroids and seam endpoints, widths of 18–26 px,
and forward transverse seam derivatives. These are finite executed checks,
distinct from universal formal proofs.

`verify.py` independently parses the actual SVG using exact integer arithmetic.
It checks the same geometric conditions, shadow interpolation, and absence of
boundary self-intersections within each arm. It can catch serialization and
manual-editing mistakes.

Containment concerns the seam's mathematical centerline. Rendering uses butt
caps, a 1.5 px seam stroke, and a 2.8 px closed outline with round joins drawn
over the seams. The topology checks below concern the closed **fill**, rather
than the expanded strokes. Global curvature smoothness and perceptual
readability are not formal claims.

### Validator proofs

`validation-laws.bend` and `validation-proof.bend` add six universal claims:
validation is sound and complete relative to the explicit recursive conditions;
the bounds gate rejects when closed; unbounded sections are rejected; and the
artwork gate is sound and complete, including the exact 33-section count.
These prove traversal and combination of predicates. They do not yet prove
that the U32 geometric predicates implement their natural-number formulas
without overflow. Bounds and overflow limits are documented in the code and
checked on the concrete artifact.

### Fill topology

`topology.bend` builds the intersection graph of the 96 closed convex tiles.
Each arm must be an embedded ribbon: consecutive tiles share a full edge
with opposite interiors, and nonadjacent tiles do not intersect. The three
ribbons must be connected through their intersections.

Every triangle clique requires an exact common-intersection witness. Pairwise
overlap alone is insufficient. Witness search uses vertices and rational
points with denominator 64 along vertex-pair segments; unsuccessful search
rejects conservatively. Coordinates must be divisible by four and at most
16000 before scaling. Five-cliques are rejected, so the accepted nerve has
no simplices beyond tetrahedra.

The current nerve has **96 vertices, 146 edges, 64 triangles and 15
tetrahedra**, giving Euler characteristic `96 - 146 + 64 - 15 = -1`.
With one connected component this means **two holes**. Counts are computed
from geometry, not supplied as acceptance constants.

The mathematical bridge uses planar Helly's theorem (common intersection of
every triple establishes the intersection of a larger convex family), the
[finite closed convex nerve theorem](https://pmc.ncbi.nlm.nih.gov/articles/PMC6768430/),
and the planar relation `holes = components - Euler characteristic`.
Those general topology theorems and correctness of the intersection algorithm
are **not formalized in Bend** here.

`topology-laws.bend` and `topology-proof.bend` add four universal proofs:
the report filter is sound and complete relative to its declared conditions,
the input guard closes on failure, and connectivity of three ribbons matches
the explicit eight-case specification. Together with the original five and
six validator claims, these geometry and report modules contain 15 public laws.

`topology_verify.py` independently clips polygons with exact rational arithmetic
and counts actual intersections in every dimension. It confirms one component
and two holes directly from the serialized SVG. Its fixtures include an empty
triple despite pairwise overlap, a filled five-clique, point contact and a gap.
The generator rejects an artwork unless both geometry and topology gates pass.

## Files

| File | Purpose |
| --- | --- |
| `artwork.bend` | Exact cross-section coordinates |
| `core.bend` | Shared geometry and SVG serialization |
| `geometry.bend` | Homogeneous quadratic and corner-weight numerators |
| `facts.bend` | Arithmetic and convex-weight supporting proofs |
| `LAWS.bend`, `PROOF.bend` | Statements and their Bend proofs |
| `validation.bend`, `artwork-validation.bend` | Generic checks and concrete generation gate |
| `validation-laws.bend`, `validation-proof.bend` | Validator structural soundness and completeness |
| `topology.bend` | Exact convex-cover topology checks |
| `topology-laws.bend`, `topology-proof.bend` | Report and guard proofs |
| `topology-report.bend` | Print the computed artwork certificate |
| `topology-tests.bend`, `validation-tests.bend` | Topology and boundary fixtures |
| `generate.bend` | Gated SVG generator and IO entry point |
| `b.svg`, `preview.png` | Generated artwork and preview |
| `regenerate.sh`, `check.py`, `verify.py`, `topology_verify.py` | Regeneration, checks and negative controls |

## License

Apache-2.0. `facts.bend` includes an attributed subset of bend-mathlib arithmetic
proofs; its original license is retained in `LICENSE.mathlib`. See [NOTICE](NOTICE).

## Arithmetic programme (in progress)

[ROADMAP.md](ROADMAP.md) records the autonomous four-stage programme. The
current BendTT gate checks **82 unique public laws**, plus supporting lemmas.
Arithmetic results quantify over all inputs at arbitrary word widths; the U32
operation laws cover every 32-bit constructor payload.

The proved arithmetic foundations are:

- Exact Nat orientation model: edge reversal exchanges its determinant sums.
- Full-adder and whole-word value conservation, including the high carry.
- A strict sum bound below `2^n` implies zero carry and exact Base addition.
- Exact bounded Nat conversion, including Base `U32.from_nat` and its round trip.
- Every word lies below capacity; retained shifts preserve full value and a
  bounded double agrees with Base `Word.shl`.
- The actual Base shift-and-add loop and bounded multiplication are exact;
  unused overflowing trailing shifts need no extra premise.
- Direct bounded `U32.add` and `U32.mul` agree with the natural-number formulas.
- Word and U32 comparisons agree with Nat comparison, including the U32
  equality, greater-than and less-or-equal predicates used by geometry.
- Bitwise complement sums with its input to the representable maximum;
  maximum plus one equals capacity.
- Subtraction carry characterizes borrowing, and actual Word/U32 subtraction
  equals Nat subtraction whenever the minuend is at least the subtrahend.
- The actual Base division loop for divisor four agrees with the bit quotient
  and remainder. Its exact numerical partition is proved, and actual
  `U32.div(x, 4)` agrees with `Nat.div(value(x), 4)` for every U32 value.
- The three-product sum used by the validation determinant is exact whenever
  its full mathematical sum is below capacity; all intermediate bounds follow
  from that single premise. The production determinant now uses this helper.
- Six natural coordinates bounded by 16000 imply that their three-product
  sum is strictly below `2^32`, without an additional overflow premise.
  The proof uses the 14-bit coordinate envelope and symbolic capacity algebra.
- With those source guards, the actual six `U32.from_nat` conversions and
  production three-product helper equal the exact Nat formula. The actual
  `validation.determinant_positive` predicate agrees with comparison of the
  exact determinant sums, including positive, negative and zero orientations.
  A further law derives its premises directly from acceptance by the actual
  `point_bounded` filter for the three source points.
- The actual production two-product `dot` expression agrees with the exact
  Nat dot product for every guarded pair of points. Its guard can likewise
  be supplied as acceptance by the production point filter.
  The production sum of two dots is also exact under the coordinate guards.
  Both production transversality comparisons and their conjunction agree
  with the exact Nat formula for all guarded points. Acceptance by the
  production point filter suffices to establish those coordinate guards.
- Eight coordinates bounded by 16000 imply a strict U32 bound for the paired
  sum of four products. The actual paired Word products and additions equal
  that exact formula whenever its complete sum fits; all intermediate bounds
  follow. Source conversions connect this result to the production sum of two
  dots under the coordinate guards, without an extra overflow premise.

- Production `absolute_difference` agrees with exact natural-coordinate
  distance for every pair of U32 values; max/min selection supplies the order
  required by subtraction. The natural model is symmetric and bounded by
  any common input bound. Guarded source conversions preserve that distance.
  The actual `width_squared` expression also equals the sum of squared
  natural distances for every pair of points accepted by the coordinate
  filter. The source bounds suffice for both squares and their sum; no
  intermediate overflow premise is needed.
- At every word width, a bounded sum of two squares equals its exact Nat
  formula. Natural components bounded by 16000 imply that strict U32 bound.

The squared-width proof group also connects the actual point-bound filter
to the numeric result. Replacing a square with addition, or mixing the
horizontal and vertical factors in production, is rejected by its laws.

The `word-*.bend` modules define these models, laws, proofs and fixtures;
`arithmetic-*-proof.bend` contains supporting order and product algebra.
The coordinate sum, runtime, dot and dot-pair modules prove the source
guards and their connection to the production determinant, dot expression
and sum of two dots. The transverse modules connect both production
comparisons to their exact model.
Arithmetic fixtures invoke the theorems, cover all three-bit comparisons and complements,
and include a bounded product whose unused shift overflows. Compiling mutations
must fail the corresponding proof gate. The subtraction comparison-selector
mutant fails in the shared `carry_step` lemma; the division remainder mutant
fails in `bit_division_step`; the product-operation mutant fails in `sum3_finish`.
Changing the production determinant comparator from greater-than to
less-or-equal is rejected in `guarded_determinant`; bypassing the actual
point-range filter is rejected in `accepted_points_determinant`. Changing
either production transverse comparator to less-or-equal, or
changing the exact model comparator, is rejected by the transverse proof
root. Substituting a wrong coordinate in the production dot expression fails `guarded_dot_exact`.
Reversing max/min in the production absolute difference is rejected in
`u32_absolute_exact`; swapping the natural model branches is rejected in
the supporting `choice_value` lemma.
The coordinate-sum mutant multiplies the sum by eight, making its bound
false at the maximum coordinates; it fails in `sum_width_bound`. The analogous
four-product mutant is rejected in `width_bound`. Changing a multiplication
to addition in the paired Word sum is rejected in the shared `finish` lemma.
The named carry, bit-division and sum helpers are supporting-lemma
rejections. The comparator and filter controls reject the corresponding public
laws. The U32 sum-wrapper mutant is checked
against a literal instance of its law, with the premise independently accepted;
Bend overflows its diagnostic printer on the full generic mutant mismatch.
That printer crash is not counted as a passing mutation check. Each kernel
invocation has a five-second limit. The seven concrete validator examples run as compiled native tests;
they are finite executed checks, distinct from the universal BendTT laws.
The three transverse examples also run natively: forward control, backward
start tangent and backward end tangent. Both the actual predicate and exact
model must give the independently specified Boolean result, with all point
guards satisfied.

`proof-roots.txt` lists the structural, arithmetic, transverse and absolute
difference, squared-width, centroid and division proof roots.
Both `check.py` and `regenerate.sh` audit that every public law module is
reachable, then check every root, with five seconds per kernel invocation.
The roots share supporting proofs; the 82-law total counts
each public law once. Dependency-only imports of unrelated proof groups have
been removed; a dedicated division root explicitly retains division and its
subtraction/complement prerequisites. No previously checked law is omitted. The absolute-difference root proves
subtraction and coordinate conversion without importing the width or
transverse compositions. Shared Boolean reflection lives in
`boolean-reflection.bend`; arithmetic proofs import these helpers directly,
without checking unrelated structural validation laws. The validation proof
keeps forwarding functions for its existing consumers.

The centroid root proves that the production center equals the independent
four-corner mean, that averaging preserves any common coordinate bound, and
that the production exact-centroid predicate entails four times the center
equals the corner sum. Six fixtures include a rounded, non-exact center that
the predicate must reject. Three compiling mutations change the divisor,
change the model divisor, or bypass centroid acceptance; all must fail proofs.

Validation of this milestone: `regenerate.sh` passed all seven proof roots
and preserved the SVG byte for byte. The remaining `check.py` gates passed
in a separate driver that omitted only those already-checked roots, including
all six centroid fixtures and all 42 compiling mutations. Ordinary complete
`check.py` invocations also encountered five-second wall-time failures in
existing arithmetic, transverse and width roots. Those runs are failures,
not passing checks; the time limit has not been increased. Consolidated-run
timing remains a reproducibility issue.

**Stage 1 remains incomplete:** homogeneous topology witnesses
still require their exact-model agreement and applicable bounds. Intersection
correctness, enumeration correctness and the formal topological bridge in stages 2–4 are also outstanding. Finite artwork
checks and the externally justified topology certificate remain as described
above; they are not substitutes for these universal proofs.
