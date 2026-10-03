# b

A steel-blue **B** made of three segmented arms, generated in [Bend](https://bend-lang.com/).

<p align="center">
  <img src="b.svg" alt="Steel-blue letter B made of segmented metal arms" width="320" height="320">
</p>

[SVG output](b.svg) · [PNG preview](preview.png) · [Generator](generate.bend) · [Laws](LAWS.bend) · [Proofs](PROOF.bend)

The outlines and seam endpoints share the same coordinates. Each curved seam
stays inside a convex section of its arm. Bend checks the general algebraic
proofs; Bend checks the concrete artwork before emitting SVG. An independent
Python checker also inspects the resulting SVG.

Current formalization status: **stage 1 is complete for the current production
bounded arithmetic**, under the existing trusted Base/compiler boundary.
The [caller audit](ARITHMETIC_AUDIT.md) records the operation inventory and
kernel contracts. Stages 2–4 (geometric interpretation, independent complex
enumeration, and the topological bridge) remain open. Earlier milestones
below retain the state and evidence that applied when they were completed.

## Generate and check

Requirements: Bend **2.0.34**, Clang 14+ for native compilation, Python 3, and GNU
`timeout`. The proof gate additionally requires Bend's proof checker for
`--verdict`; this repository does not install toolchains automatically.

```sh
git clone https://github.com/dearlordylord/b.git
cd b
./regenerate.sh
python3 check.py
```

`regenerate.sh` checks the proofs with Bend, compiles and executes
`generate.bend`, checks the emitted SVG, and replaces `b.svg` only on success.
The generator itself refuses to emit an SVG if its Bend artwork validation fails.
On Linux, C emission and Clang `-O1` compilation are separate five-second
commands; this avoids an expensive combined optimization step on shared
machines. Other platforms retain Bend's native build command. Proof checks
use the same five-second Bend gate on every platform.

`check.py` runs the 175-law proof gate, 200 literal arithmetic checks,
seven executed validator boundary checks, three executed transverse cases,
four executed cell-transverse cases and rejection beyond each source-coordinate limit,
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
current Bend gate checks **104 unique public laws**, plus supporting lemmas.
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
they are finite executed checks, distinct from the universal Bend laws.
The three transverse examples also run natively: forward control, backward
start tangent and backward end tangent. Both the actual predicate and exact
model must give the independently specified Boolean result, with all point
guards satisfied.

`proof-roots.txt` lists the structural, arithmetic, transverse and absolute
difference, squared-width, centroid, division, dot, witness-arithmetic, scaled-coordinate, grid-scaling, sample-arithmetic and side-bridge proof roots.
Both `check.py` and `regenerate.sh` audit that every public law module is
reachable, then check every root, with five seconds per kernel invocation.
The roots share supporting proofs; the 104-law total counts
each public law once. Dependency-only imports of unrelated proof groups have
been removed; a dedicated division root explicitly retains division and its
subtraction/complement prerequisites. No previously checked law is omitted. The absolute-difference root proves
subtraction and coordinate conversion without importing the width or
transverse compositions. Shared Boolean reflection lives in
`boolean-reflection.bend`; arithmetic proofs import these helpers directly,
without checking unrelated structural validation laws. The validation proof
keeps forwarding functions for its existing consumers.
Coordinate bounds and comparison transport live in `coordinate-support.bend`.
Width, absolute-difference and transverse proofs consume that support directly,
without importing production determinant proofs. The latter remain checked
through the dedicated dot root; dependency auditing retains every public law.

The centroid root proves that the production center equals the independent
four-corner mean, that averaging preserves any common coordinate bound, and
that the production exact-centroid predicate entails four times the center
equals the corner sum. Six fixtures include a rounded, non-exact center that
the predicate must reject. Three compiling mutations change the divisor,
change the model divisor, or bypass centroid acceptance; all must fail proofs.

Validation of the centroid milestone: `regenerate.sh` passed all seven proof roots
and preserved the SVG byte for byte. The remaining `check.py` gates passed
in a separate driver that omitted only those already-checked roots, including
all six centroid fixtures and all 42 compiling mutations. Ordinary complete
`check.py` invocations also encountered five-second wall-time failures in
existing arithmetic, transverse and width roots. Those runs are failures,
not passing checks; the time limit has not been increased. Consolidated-run
timing was a reproducibility issue at that milestone.

The witness-arithmetic root adds three public laws. The exact homogeneous
sum `((a*b)*d + c*y) + x*e` is strictly below `2^(2*width+8)` when point
coordinates are at most `2^width`, numerators at most `64*2^width`, and the
denominator at most 64. This includes the envelope boundaries and `d=0`.
At width 12 the complete sum fits U32. A generic word theorem establishes
that the actual nested multiplication and additions agree with this model
when the first product and final sum fit; all other intermediate bounds
follow from the final sum. The production `topology.side` comparison then
agrees with the exact Nat comparison under those coordinate envelopes,
with no separately supplied overflow premise. Four theorem fixtures cover
positive, zero and negative signs, denominators 1 and 64, and simultaneous
envelope boundaries. Three compiling mutations multiply the exact sum by
eight, change the word product, or change the actual
production denominator term; each is rejected by the proof gate.

Validation of the witness milestone: all 85 laws across nine roots passed
the real Bend gate. The remaining gates passed in a separate driver omitting
only those already-checked roots, including all 45 compiling mutations.
The final four witness fixtures and three witness mutations also passed a
focused recheck; the eightfold sum mutant is falsified at width0 with all
envelope limits attained together. A complete `check.py` invocation reached
and accepted every proof root but timed out on the existing squared-width
fixture group. Thus consolidated-run timing remains unresolved; no timeout
is reported as a passing check.

The scaled-coordinate root adds three public laws. Every original coordinate
at most 16000 has its natural quotient by four bounded by `2^12`. The actual
U32 conversion followed by division by four gives that natural quotient, and
both coordinates returned by production `topology.scaled` agree with those
quotients. These results include nonmultiples of four: division rounds down.
Three fixtures cover divisible points, rounded points and the scaled envelope;
a compiling production mutation changes divisor four to three and is rejected.

Validation of the scaled-coordinate milestone: the ordinary complete
`python3 check.py` invocation passed all 88 unique public laws across ten
roots, every fixture group, all 46 compiling mutations and the independent
SVG geometry/topology checks, with the original five-second limits. This is
a complete successful run. `regenerate.sh` also passed all ten roots and
preserved the SVG byte for byte. The earlier timing failures remain historical
failed runs and are not counted as passing evidence.

The grid-scaling root adds three public laws. Zero natural remainder implies
`(x/4)*4 == x`. For every point accepted by the actual `topology.point_guard`,
restoring both coordinates returned by `topology.scaled` recovers the original
point exactly; this proves that accepted scaling has no rounding error. The
accepted production point also satisfies the 12-bit coordinate envelope used
by homogeneous side proofs. The proof uses the actual four filter conditions,
rather than assuming divisibility separately. Six fixtures cover exact
multiples, round trips, the origin, output bounds, and rejection of a
nonmultiple in either coordinate. Three compiling mutations bypass the x-grid
filter, change the restoration multiplier, or shrink the output envelope.
The filter mutant is additionally falsified by the accepted point `(3,0)`,
whose scaled/restored value loses its x-coordinate.

Validation of the grid-scaling milestone: the ordinary complete
`python3 check.py` passed all 91 unique laws across eleven roots, every fixture
group, all 49 compiling mutations and the independent SVG checks. Every
kernel invocation retained its five-second limit. The filter counterexample
was checked by the real Bend kernel in the mutated source tree.
`regenerate.sh` also passed every root and preserved the SVG byte for byte.

The sample-arithmetic root adds ten public laws. Weights `(64-n)` and `n`
sum to 64 under `n<=64`. For coordinates bounded by `2^width`, their weighted
numerator is bounded by `64*2^width`, including both endpoints. At width12,
this proves that the actual ordered subtraction, multiplications and addition
fit U32 and agree with natural arithmetic. The production `topology.sample`
returns the exact two numerators and denominator 64. Accepted point envelopes
and the actual `U32.is_le(n,64)` predicate suffice; callers supply no overflow
premises. Its output satisfies the numerator/denominator envelopes used by
homogeneous side comparison proofs. Vertex witnesses preserve their
coordinates, have denominator 1, and satisfy the same envelopes. Natural
search indices `n<=fuel<=63` convert `1+n` to a U32 weight accepted at 64.
This is an index arithmetic law, not yet a proof of the complete search.
Ten fixtures cover endpoints, midpoint, final interior sample, output bounds,
simultaneous scalar envelope limits, vertex witnesses and index extremes.
Five compiling mutations alter weights, word subtraction, actual subtraction,
the sample denominator or the vertex denominator; every mutant is rejected.
The weight-model mutant is independently falsified at the scalar envelope
boundary with `a=b=1` and `n=64`. The production weight and denominator
mutants also have kernel-checked concrete counterexamples whose point and
weight guards hold.

Validation of the sample-arithmetic milestone: the ordinary complete
`python3 check.py` passed all 101 unique laws across twelve roots, every
fixture group, all 54 compiling mutations and independent SVG geometry and
topology checks. No kernel invocation exceeded the retained five-second limit.
`regenerate.sh` also passed all twelve roots and preserved the SVG byte for byte.

The side-bridge root adds three public laws. Actual point and witness envelope
predicates imply every arithmetic precondition of production `topology.side`.
For generated samples, its comparison equals the independent natural formula
with the two weighted numerators and denominator 64; for vertices it uses the
original coordinates and denominator 1. These compositions require only
point envelopes and the actual weight predicate, with no manual overflow
premises or independently assumed witness bounds. Five fixtures cover both
witness kinds, strict signs and boundary contact. Two compiling mutations
swap witness coordinates or reverse the model edge. Their kernel-checked
counterexamples satisfy every guard: the actual comparison is LT while the
mutated model says GT.

Validation of the side-composition milestone: the ordinary complete
`python3 check.py` passed all 104 unique laws across thirteen roots, every
fixture group, all 56 compiling mutations and independent SVG geometry and
topology checks. Each kernel invocation retained the five-second limit.
`regenerate.sh` also passed all thirteen roots and preserved the SVG byte for byte.

The source-corner transverse root adds one public law. The four actual
`point_bounded` predicates on a cell's source corners imply that production
`cell_transverse` agrees with the independent natural-number model. The
control-point envelope is derived from averaging those corners, rather than
supplied by the caller. The result covers accepted and rejected sections,
including rounded controls and degenerate sections.

The source-coordinate limit now has one transparent definition in
`coordinate-limit.bend`; a kernel-checked fixture pins it to 16000. This keeps
repeated numeral expansions out of Bend proof signatures. The independent mean and center model
lives in `centroid-model-laws.bend` and `centroid-model-proof.bend`; shared
centroid bounds live in `centroid-bounds-proof.bend`. Both centroid validation
and the new transverse composition consume that proof. Its intermediate
limit stays symbolic, preventing a large closed division from being executed
while checking the composition. The public cell law retains only the four
source-corner guards.

Four native cell fixtures cover forward projection, reversal, a degenerate
section, and the inclusive coordinate boundary. Two additional native
checks reject 16001 in either source coordinate. Two compiling model
mutations replace the seam's ending section or its centroid; each must be
rejected in the public `source_corners_transverse_exact` proof section.

Validation of the source-corner composition milestone: the complete
`taskset -c 7,11 python3 -u check.py` passed all 105 unique public laws across
fourteen roots, every fixture group, all 58 compiling mutations, and the
independent SVG geometry and topology checks. `taskset -c 7,11 ./regenerate.sh`
also passed and reproduced `b.svg` byte for byte. Every successful proof
invocation retained the five-second limit. CPU affinity was used because
unaffinitized attempts timed out in different existing proof or fixture
groups on this shared machine. A trial mutation of the limit numeral crashed
Bend's diagnostic normalization and was discarded; it is not counted among
the rejected mutations. The new native build path was tested on Linux.

The search-witness root adds six public laws over the actual search functions.
An accepted segment search with `fuel<=63` constructs a witness satisfying
the sample arithmetic envelope, native `common`, and exact denominator 64.
The proof derives the index guard at every recursive step. This result is
preserved through `pair_search` and `all_pairs`. An accepted `vertex_search`
constructs the same kind of witness with denominator 1. `triangle_search`
and `triangle_witness` combine these cases into an existential witness with
a strictly positive denominator and the proved arithmetic envelope.
Their callers provide point or quad envelopes, not witness bounds.

The source-cells root adds three public laws connecting those quad envelopes
to production source data. Four actual source-point guards suffice for
`raw_cell`; orientation preserves all vertex envelopes; and the actual
`sections_guard(xs)` implies that every cell in `cells(xs)` satisfies its
envelope. These results include empty and singleton source lists and either
orientation. Source-cell predicates reuse the same point and quad envelopes
as the search proofs.

The new laws establish native witness provenance and arithmetic bounds.
They do not yet connect native `common` to Euclidean polygon membership,
prove that the finite sample search finds every intersection, or establish
the topological interpretation. Those requirements remain in stages 2–4.
Native fixtures cover empty searches, weights 1/63, vertex and pair hits,
accepted and disjoint triples, and empty/singleton/forward/reversed source
cells. Six compiling mutations introduce empty-search hits or bypass either
triangle search; each is rejected in its public law. Three further mutations
double a raw-cell coordinate, distort reversal, or corrupt the cell-envelope
recursion. The reversal and recursion mutations fail in the shared
`reversed_fields` and `walk_bound` helpers; these are not independent
law-specific sections.

Validation of the search/source-envelope milestone:
`taskset -c 7,11 python3 -u check.py` passed all 114 unique public laws across
sixteen roots, every fixture group, all 67 compiling mutations, and the
independent SVG checks. `taskset -c 7,11 ./regenerate.sh` passed all sixteen
roots and reproduced `b.svg` byte for byte. Every kernel check retained the
five-second limit. This was implementer self-review, not independent review.

The source-cells root now also proves that concatenation preserves every
cell envelope, a cell selected after any list prefix inherits its envelope,
and the actual `neighbors` filter retains bounded input cells. The query
cell needs no bound for this preservation law: it affects selection, not
which records the filter returns. This does not yet establish that the
selection predicate denotes geometric intersection.

The inside-arithmetic root adds three public laws. Production `inside` and
`common` agree with independent natural-number side formulas under the actual
quad and witness envelopes. The reference uses “not less than” for each
closed half-plane comparison. An accepted `triangle_witness` consequently
constructs a witness satisfying those natural formulas with a strictly
positive natural denominator. This is arithmetic and half-plane predicate
agreement, not yet a proof identifying a quad with its geometric polygon.

Native fixtures cover concatenation, an unbounded query over bounded
neighbors, interior/boundary/exterior classifications, denominator 64 and a
rejected third cell. Three additional compiling controls corrupt envelope
scanning or return the query instead of an input neighbor; the two scanner
controls fail in the shared `walk_bound` helper. Skipping a scanner head
admits an out-of-envelope cell, whose scanner premise was false before the
mutation; this control checks scanner soundness rather than an originally
accepted input. Four classifier controls reject boundary contact, omit an
edge or third cell, or reverse denominator positivity. Three fail in shared
`nonnegative_exact`, `inside_bounds`, and `natural_ready` helpers; the
third-cell control fails in its public `common_arithmetic_exact` section.

Validation of the filter/classifier arithmetic milestone:
`taskset -c 7,11 python3 -u check.py` passed all 120 unique public laws across
seventeen roots, every fixture group, all 74 compiling mutations and
independent artifact checks. `taskset -c 7,11 ./regenerate.sh` also passed
and preserved the SVG byte for byte. Every kernel invocation retained its
five-second limit. Implementer self-review found no weakened arithmetic
preconditions; geometric interpretation and the later stages remain open.

At the filter/classifier milestone, **stage 1 remained incomplete:** audit all production callers and connect
any remaining arithmetic paths. The composition laws below now cover
separation, outside, intersection and convexity arithmetic. Full
intersection/search soundness remains part of stage 2. Intersection
correctness, enumeration correctness and the formal topological bridge in stages 2–4 are also outstanding. Finite artwork
checks and the externally justified topology certificate remain as described
above; they are not substitutes for these universal proofs.

Strict-side arithmetic bridge: two additional public laws identify the native
negative and positive vertex-side predicates with exact natural comparisons
under the existing coordinate envelopes. Zero determinants are excluded by
both strict predicates. Two compiling controls change that boundary behavior
and are rejected in the shared `negative_cmp_exact` and `positive_cmp_exact`
helpers. This bridge does not yet prove the composed separation or convexity
checks, or their geometric interpretation.

Validation of the strict-side bridge: `taskset -c 7,11 python3 -u check.py`
passed 122 unique public laws across eighteen roots, all fixture groups,
76 compiling mutations and the independent artifact checks.
`taskset -c 7,11 ./regenerate.sh` passed and preserved `b.svg` byte for byte.
Implementer self-review covered the new natural comparison owner, its
existing vertex-side dependency, root registration and mutation routing;
no weakened preconditions or production changes were found. Composed
separation/convexity and their geometric meaning remain unproved.

The strict-side bridge now composes into five additional public arithmetic
agreement laws: `separated`, `outside`, `meets`, `strictly_convex`, and
`orientation`. Their premises are the existing point/quad coordinate
envelopes; no caller-supplied overflow assumption was added. The independent
natural formulas use exact vertex-side comparisons and Boolean composition.
This proves agreement with those formulas, not yet the separating-axis
theorem or the geometric interpretation of convexity. Native fixtures cover
edge/point contact, a gap, reversed winding and degeneracy. Five compiling
mutations omit a tested side, invert the intersection result or reverse
orientation; they are rejected in `separated_fields`, `outside_bounds`,
`meets_arithmetic_exact`, `strictly_convex_bounds`, and `orientation_fields`.

Validation of the composed arithmetic milestone:
`taskset -c 7,11 python3 -u check.py` passed 127 unique public laws across
eighteen roots, all fixture groups and 81 compiling mutations.
`taskset -c 7,11 ./regenerate.sh` passed with every kernel invocation limited
to five seconds; `b.svg` remained byte-identical. Implementer self-review
covered the five public contracts, their existing bounded vertex-side
dependency, Boolean composition helpers, native fixture integration and
mutation routing. No production behavior or arithmetic premise changed.
The caller audit and geometric proofs remain open.

Edge identity arithmetic: three additional public laws connect
`point_equal`, `reverse_edge`, and `shared_edge` to natural coordinate
equality and the corresponding Boolean formulas. They cover every U32
value and therefore need no coordinate guard. The later ribbon-connectivity
proof can consume these contracts; this milestone does not itself prove
connectivity. Native fixtures cover the maximum U32 coordinate, a single
coordinate mismatch, opposite/same winding, a shared edge, a gap and point
contact. Three compiling mutations weaken equality or omit candidate edges;
the corresponding public law sections reject them.

The [production arithmetic audit](ARITHMETIC_AUDIT.md) records current
caller coverage and the remaining unscaled-validator compositions and
accepted-input traversal bridges. That earlier audit left stage 1 incomplete.

Validation of the edge-identity milestone:
`taskset -c 7,11 python3 -u check.py` passed 130 unique public laws across
nineteen roots, all fixture groups, 84 compiling mutations and independent
artifact checks. `taskset -c 7,11 ./regenerate.sh` passed and preserved
`b.svg` byte for byte; each kernel invocation retained its five-second limit.
Implementer self-review covered equality conversion, reversed-edge ordering,
the four candidate edges, proof dependencies, root/mutation registration
and the entry-point coverage audit. No production behavior or coordinate
restriction was added. The caller audit identifies further required work.

Unscaled source convexity arithmetic: three public laws now connect
`validation.positive_quad`, `convex_quad`, and `cell_convex` with independent
natural determinant formulas. Actual point-bounded guards suffice, without
an additional overflow premise. Both winding directions are represented
and the cell's corner ordering is explicit. This is arithmetic agreement;
the geometric characterization of strict convexity remains stage 2 work.
Native fixtures exercise both windings, repeated corners, a concave corner,
cell corner ordering and coordinates at the accepted envelope boundary.
Three compiling controls omit the last turn or reverse-winding branch, or
exchange cell corners; the corresponding public law sections reject them.

Validation of unscaled convexity composition:
`taskset -c 7,11 python3 -u check.py` passed 133 unique public laws across
twenty roots, all fixture groups, 87 compiling mutations and independent
artifact checks. `taskset -c 7,11 ./regenerate.sh` passed, retaining the
five-second kernel limit and preserving `b.svg` byte for byte. Implementer
self-review covered source-point guards, determinant reuse, both winding
branches, actual cell corner order, fixtures and mutation/root registration.
No production behavior changed; geometric interpretation and the remaining
caller obligations recorded in the audit are still open.

Width interval composition: three public laws connect `width_in_range`,
bounded point widths and `section_width` with natural squared-distance and
interval formulas. Threshold words are symbolic arguments pinned by equality
to the actual constants 3240000 and 6760000. This keeps the numerical policy
fixed while avoiding the checker's deep expansion of their Nat values. An
initial closed-threshold formulation overflowed the machine stack and is
not counted as passing evidence. The natural interval decodes those literal
word thresholds; it does not perform word arithmetic or native comparisons.
The accepted point guards suffice for the squared-width bridge. Native
fixtures check both inclusive thresholds, their adjacent values, physical
widths 1799/1800/2600/2601 and zero width at the coordinate limit. Three
compiling controls invert the lower comparison, increase the upper limit,
or compare a section endpoint with itself. The range and section public
law sections reject them. Accepted traversal and geometric interpretation
remain open.

Validation of width interval composition:
`taskset -c 7,11 python3 -u check.py` passed 136 unique public laws across
twenty-one roots, all fixture groups, 90 compiling mutations and independent
artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with the five-second
limit on every kernel invocation and preserved `b.svg` byte for byte.
Implementer self-review covered the pinned threshold equalities, inclusive
comparison directions, accepted squared-width dependency, section endpoint
selection, fixtures and root/mutation registration. No production behavior
changed. The initial stack-overflow formulation is excluded from evidence;
the committed symbolic formulation passed the real kernel. Accepted source
traversal and later geometric/topological obligations remain open.

Natural validator composition: four public laws connect a bounded cell, the
recursive adjacent-cell fold, the nonempty fold and the full `validate`
entry point with `validator-natural.bend`. The reference replaces word
convexity, transverse checks and width comparisons with the separately
proved natural predicates. It reuses the existing Nat-only centroid, endpoint
and coordinate-filter checks; it is an arithmetic reference, not an
independent geometric specification. List-head and tail bounds are extracted
from the actual `sections_bounded` filter at each recursive step. The full
entry-point agreement covers arbitrary lists, including guard failure, and
needs no caller-supplied bounds premise. Threshold arguments remain pinned
to the production constants. Native fixtures compare empty, singleton,
two-section and out-of-range inputs. Four compiling model mutations omit a
transverse check, recursive tail or first width, or accept a failed guard;
rejection occurs in the three composition law sections and the shared
`gate_exact` helper. This closes the unscaled traversal arithmetic bridge,
not geometric correctness or the topology traversal bridge.

Validation of full unscaled validator arithmetic composition:
`taskset -c 7,11 python3 -u check.py` passed 140 unique public laws across
twenty-two roots, all fixture groups, 94 compiling mutations and independent
artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with the five-second
limit on every kernel invocation and preserved `b.svg` byte for byte.
Implementer self-review covered the distinction between reused Nat-only
checks and replaced word checks, recursive head/tail bound extraction, the
previous/current section relation, empty and failed-guard branches, pinned
thresholds and gate integration. No production behavior or caller-supplied
overflow premise was added. The topology traversal arithmetic bridge and
stages 2–4 remain open.

Bounded cover-fold arithmetic: seven public laws now connect `disjoint_all`,
`disjoint_nonadjacent`, `overlaps_one`, `overlaps`, `adjacent`, `ribbon_walk`
and `ribbon` with folds over natural separation/convexity and edge-identity
formulas. Actual list envelopes provide head and tail bounds recursively;
`adjacent` needs no bound because its edge equality bridge is universal.
The reference preserves the existing rule that only the immediate neighbor
is excluded from nonadjacent disjointness. It does not prove that rule's
geometric sufficiency or that a valid ribbon is connected. Native fixtures
cover empty/singleton ribbons, a three-cell chain, point contact, a gap, a
later overlap hit, the neighbor exclusion and reversed winding. Seven
compiling model controls skip a tested head or tail, include the adjacent
cell among disjointness checks, weaken shared-edge/convexity checks, or
allow an empty ribbon. Their corresponding public law sections reject
them. Inspection assembly, filtering/count traversal and geometric
interpretation remain open.

Validation of bounded cover-fold arithmetic:
`taskset -c 7,11 python3 -u check.py` passed 147 unique public laws across
twenty-three roots, every fixture group, 101 compiling mutations and
independent artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with
the five-second limit on every kernel invocation and preserved `b.svg` byte
for byte. Implementer self-review covered head/tail envelope propagation,
conservative closed-contact comparisons, the immediate-neighbor exclusion,
shared-edge identity, empty-list branches and mutation/root registration.
No production behavior or bound was changed. Filtering/inspection assembly
and the geometric, enumeration and topological bridges remain open.

Natural neighbor filtering and inspection flags: six public laws prove
exact list equality for bounded `neighbors`, carry the list envelope through
the natural filter, compose the three-cover connected/ribbon flags, and
identify those two fields of the actual `inspect_cells` report with the
natural folds. The reference reuses the structural `keep` constructor and
Boolean three-cover graph policy; their word-dependent inputs are replaced
with natural comparisons. Head/tail bounds come from actual list envelopes.
The report-field proofs work for arbitrary clique-count payloads and do not
prove the correctness of those payloads. The filter envelope law reuses the
existing separately mutated preservation contract. Five additional compiling
controls drop all filter hits, omit a cross-cover overlap, ignore one ribbon,
or read the wrong report field. The first three fail in
their public law sections; the field controls in shared `assembled_connected`
and `assembled_ribbons`. Native fixtures cover self/edge/point hits, a gap,
filter bounds, connected/disconnected reports and an empty ribbon. Search
Boolean composition, count traversal, guarded source inspection and later
geometric/topological interpretation remain open.

Validation of filtering and inspection flags:
`taskset -c 7,11 python3 -u check.py` passed 153 unique public laws across
twenty-three roots, every fixture group, 106 compiling mutations and
independent artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with
the five-second limit on each kernel invocation and preserved `b.svg` byte
for byte. Implementer self-review covered exact list equality, inherited
filter envelopes, cross-cover flag composition, field ordering and the
distinction between arbitrary count payloads and proved enumeration. No
production behavior or coordinate premise changed. Search/count arithmetic
composition, guarded inspection and stages 2–4 remain open.

Complete bounded witness-search arithmetic: eight public laws connect vertex
and sampled common-point classification, the segment/pair/all-pairs/vertex
folds, triangle search and the actual triangle-witness entry point to
`search-arithmetic.bend`. The reference uses Nat weights and numerators with
exact homogeneous side comparisons. The proof establishes exact weight
conversion and bounds before invoking the sample laws; list and quad
envelopes supply the remaining premises recursively. The Boolean agreement
covers both successful and unsuccessful searches, with segment fuel at most
63. It does not establish geometric membership or universal search
completeness. Native fixtures cover a boundary sample, a failed third-cell
classification, zero fuel, empty folds, a vertex-only hit, full segment fuel
and successful/failed triple searches. Eight compiling controls change the
denominator, omit the third cell, accept empty search cases, replace the
triangle OR with AND, or omit the third cell's candidates. The first two
fail in shared `word_sample_values` and `common_coords_values`; the
remaining six in their public fold laws. Guarded source inspection, count
arithmetic composition and stages 2–4 remain open.

Validation of full bounded witness-search arithmetic:
`taskset -c 7,11 python3 -u check.py` passed 161 unique public laws across
twenty-four roots, every fixture group, 114 compiling mutations and
independent artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with
the five-second limit on each kernel invocation and preserved `b.svg` byte
for byte. Implementer self-review covered exact natural weight conversion,
sample denominators, all three classified cells, recursive point/quad
envelopes, fuel decrement, empty searches, vertex/pair choice and the actual
concatenated candidate list. No production behavior or arithmetic premise
changed. Enumeration/count composition, guarded source inspection and the
geometric/topological bridges remain open.

Bounded count traversal arithmetic: five public laws now connect `fourth`,
`third`, `second`, `first` and the complete `inspect_cells` report with
`count-arithmetic.bend`. The reference retains the existing Nat-only count
constructors, addition and report assembly, replacing word-dependent
filters, witness search and cover flags with their natural models. Filtered
list envelopes are propagated at every nesting level. This establishes
arithmetic agreement for all count and certificate fields, not yet
independent correctness of clique enumeration or its geometric meaning.
Native fixtures exercise empty/disjoint lists and full cliques of sizes
3/4/5, including the K5 rejection flag and repeated equal cells as distinct
list positions. Five compiling controls create an empty tetrahedron, omit
the triangle witness, zero an edge contribution, drop the outer tail, or
zero the report's vertex count. Their public composition law sections
reject them. Guarded source inspection and stages 2–4 remain open.

Validation of bounded count/report arithmetic:
`taskset -c 7,11 python3 -u check.py` passed 166 unique public laws across
twenty-five roots, all fixture groups, 119 compiling mutations and independent
artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with the five-second
limit on each kernel invocation and preserved `b.svg` byte for byte.
Implementer self-review covered nested filtered-list envelopes, fixed-cell
bounds at the third/second levels, triangle-witness agreement, Nat-only
constructor/addition reuse, all report fields and positional fixture semantics.
No production behavior changed. Guarded source inspection and the geometric,
independent enumeration and topological bridges remain open.

Guarded source inspection composition: three public laws now connect the
actual `topology.inspect` and `valid` entry points with `source-inspection.bend`
and pin its failed-guard branch to the zero/false report. These agreements
cover arbitrary source lists without an externally supplied bounds premise.
The accepted branch splits all three actual source guards, obtains the
existing generated-cell envelopes and invokes the full count/report
arithmetic agreement. The reference intentionally reuses `T.cells` and
the Nat-only report validity policy; it is not an independent source-cover
construction or geometric specification. Native fixtures cover a three-strip
chain, empty input, a non-grid coordinate, an out-of-range third cover and
the final decision. Three compiling controls omit the third cover, alter
a failed-guard flag, or force the final decision false. They fail in
shared `source_accepted_fields`, `source_gate_exact`, and the public
`source_valid_arithmetic_exact` section respectively. Stage 1 still requires
a final coverage audit of source scaling/orientation construction; stages
2–4 remain open.

Validation of guarded source inspection:
`taskset -c 7,11 python3 -u check.py` passed 169 unique public laws across
twenty-six roots, every fixture group, 122 compiling mutations and independent
artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with the five-second
limit on each kernel invocation and preserved `b.svg` byte for byte. An
initial third-cover mutation duplicated a linear list and was discarded as
ill-typed; it is not counted. The committed omission control compiles and
is rejected by its proof. Implementer self-review covered all three source
guards, generated-cell envelopes, empty versus rejected input, report fields,
final validity reuse and root/mutation routing. No production behavior
changed. Source-cover construction coverage and stages 2–4 remain open.

Independent natural cover construction: six public laws now identify the
decoded point scaling, raw cell, orientation choice and full source-cell
walk/tail/entry list with `natural-cover.bend`. Its Point/Quad coordinates
are Nat; its scaler performs Nat division and its orientation uses exact
natural homogeneous comparison. It does not reuse production cell
construction. The decoder only reads the native word fields for comparison.
Actual point/section/list guards supply all bounds, while structural reversal
and orientation preserve corner order. The final list equality is positional
and covers empty/singleton lists and both winding directions. Native fixtures
exercise those cases, three sections producing two cells, explicit winding
signs, and scaling at 12/16000. Six compiling controls change the scale
divisor, swap raw corners, reverse the orientation predicate, drop the walk
tail, invent a trailing cell or invent an empty-input cell. Scale and sign
controls fail in shared `scaled_fields` and `orientation_decoded`; the
remaining four in their public construction laws. A final arithmetic coverage
audit remains necessary before closing stage 1; stages 2–4 remain open.

Validation and final arithmetic coverage audit:
`taskset -c 7,11 python3 -u check.py` passed 175 unique public laws across
twenty-seven roots, every fixture group, 128 compiling mutations and
independent artifact checks. `taskset -c 7,11 ./regenerate.sh` passed with
the five-second limit on each kernel invocation and preserved `b.svg` byte
for byte. Implementer self-review covered natural coordinate representation,
raw corner order, the first-cell sign, structural reversal, previous/current
section propagation, positional list equality, empty/singleton branches and
all production word-operation callers. No production behavior changed.

**Stage 1 is complete for the current production bounded arithmetic.** The
final inventory in `ARITHMETIC_AUDIT.md` accounts for every word operation
in the production owners and its guard/traversal premises; entry-point,
search, count/report and independently decoded cover contracts passed the
real kernel. Nat-only policies remain in their existing owners. This is not
compiler/backend verification or a proof that the geometric policies are
correct. Stage 2 must establish the polygon/half-plane and intersection/
witness meanings; stage 3 must establish independent enumeration of the
intended complex; stage 4 must prove the topological bridge. The complete
four-stage objective remains unfinished.

### Stage 2: homogeneous witness representation

[Model](homogeneous-geometry.bend), [eight laws](homogeneous-geometry-laws.bend)
and [proof root](HOMOGENEOUS_GEOMETRY_PROOF.bend) establish representation
invariance for nonnegative rational coordinates. A point stores `(x, y, d)`;
its rational interpretation requires `d > 0`. `scale(p, k)` multiplies all
three fields by **1 + k**, not by k. The signed-side comparison and closed
left-half-plane predicate are invariant under this positive scaling and under
any equivalent pair of positive-denominator representations, including pairs
that are not integer multiples of each other. Equivalence checks both cross
products. The proof passes through equal common-denominator points and proves
positive-product comparison by induction, without a division axiom.

The side and half-plane predicates here are homogeneous polynomial definitions;
no real-number plane or quotient type is introduced. This is an algebraic
representation result. It does not yet establish polygon
membership, intersection completeness, geometric witness correctness, or the
connection to the topology of the SVG. Stages 2–4 remain unfinished.

Three compiling mutation controls change denominator scaling, allow zero
denominators, or omit the y-coordinate equivalence test. Each violates at least
one representation contract. The proof gate rejects them at `scaled_side`,
`denominator_scale`, and `equivalent_scaled`, respectively; these are the first
proof incompatibilities, not necessarily the violated public theorem itself.
For example, accepting zero denominators permits inequivalent side results for
`(0,1,0)` and `(0,0,0)` despite equal cross products. Dropping the y test admits
`(0,0,1)` and `(0,1,1)`, which lie on different sides of the horizontal boundary.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 183 public
laws across 28 roots, existing fixture groups, 131 compiling mutation controls
and independent artifact checks. `taskset -c 7,11 ./regenerate.sh` passed and
`git diff --exit-code -- b.svg` confirmed byte-identical output. Implementer
self-review covered zero-denominator rejection, positive scaling, both cross
products, equal common-denominator construction, the two side-polynomial
operands, and honest proof/mutation scope. No findings; the remaining geometric
and topological bridges are explicitly outside this increment.

### Stage 2: production witnesses in half-plane regions

[Half-plane region model](halfplane-region.bend), [seven laws](halfplane-region-laws.bend)
and [proof root](HALFPLANE_REGION_PROOF.bend) connect the production validator
to the natural-coordinate cover. A region is the intersection of the four
closed left half-planes of its ordered sides. `contains` is a conjunction of
all four predicates, including the closing side; it accepts boundary points.
This model uses `natural-cover`'s point/quad owners and the previously proved
homogeneous side predicates rather than duplicating arithmetic or word guards.

Natural `inside` and `common` calculations equal membership in the decoded
regions for every input. Production `inside` equals that membership under the
actual 12-bit quad envelope and witness envelope. No positive-denominator or
convexity premise is needed for the polynomial equality itself. The two
representation-invariance laws cover positive rescaling and equivalent
positive-denominator points in an arbitrary ordered four-side region.

Most importantly, `triangle_halfplane_witness` constructs an existential point
with a positive denominator and membership in **all three** decoded regions
whenever the real production triangle-witness search accepts three bounded
quads. It obtains the witness from the previously proved search/Nat bridge;
it does not invent a point or assume successful search. Its result omits the
implementation-specific envelope while retaining geometric positivity and
all three membership judgments. This proves successful-search soundness for
the half-plane regions, not completeness of the conservative search.

The remaining interpretation gap is important: the intersection of these four
half-planes has not yet been proved equal to the filled convex quad for every
accepted source cell. Nor has the separating-axis decision been proved to
characterize intersection. These bridges, independent complex enumeration,
and the topological theorem remain required by stages 2–4.

Three compiling mutation controls swap decoded witness x/y, omit the closing
half-plane, and omit the third region. They fail at `edge_values`,
`inside_halfplanes_decoded`, and `common_halfplanes_decoded`; the first is a
shared support lemma, while the latter two are public contracts. Each changes
actual membership behavior, rather than merely renaming a proof expression.

Validation: `taskset -c 7,11 python3 -u check.py` passed 190 public laws
across 29 roots, the existing fixture groups, 134 compiling mutation controls
and independent SVG checks. Additional temporary literal proof instances
confirmed closing-side rejection and boundary inclusion for the square
`[(1,1),(3,1),(3,3),(1,3)]`, asymmetric witness decoding, and rejection by a
disjoint third region. Those finite examples supplement the universal laws.
Implementer self-review found no violations of the stated contracts: it traced
the decoded coordinate order, all four ordered sides, all three regions,
production envelope premises, actual search witness, positive denominator,
and existential result through their existing owners. Later convex-quad and
intersection proofs can consume the natural region and its existential point;
no speculative polygon or topology theorem was introduced.
`taskset -c 7,11 ./regenerate.sh` also passed; `git diff --exit-code -- b.svg`
confirmed byte-identical output. Stage 2 remains open at the geometric bridges
listed above, and stages 3–4 remain open.

### Stage 2: rational convexity of half-plane regions

[Combination model](homogeneous-combination.bend), [six laws](homogeneous-combination-laws.bend)
and [proof root](HOMOGENEOUS_COMBINATION_PROOF.bend) prove closure of the
previously connected half-plane regions under rational weighted means.
The model retains the existing homogeneous point owner; no signed-coordinate,
real-number, polygon-fill, or topology axiom is introduced.

`join(p, q, k, l)` adds the three homogeneous fields with nonnegative Nat
weights k/l. Every linear form of those fields is exactly the corresponding
weighted sum. Its two side polynomials therefore retain a nonnegative signed
comparison if both input points pass the closed half-plane predicate. Applying
that fact to each of the four sides proves `region_weighted_join` for any
ordered quad, including degenerate or empty regions. A separate theorem proves
that positive input denominators and `k + l > 0` give a positive output
denominator. The polynomial predicate alone does not exclude zero denominators.

For ordinary affine weights, `mix(p, q, k, l)` calls `join` with weights
`k * denominator(q)` and `l * denominator(p)`. Its denominator is proved equal
to `denominator(p) * denominator(q) * (k + l)`. Thus its fraction coordinates
represent `(k * p + l * q) / (k + l)`. `region_convex_mixture` proves both
positive denominator and region membership under the explicit positive-input,
nonzero-weight and two-membership premises. This is rational convexity in the
nonnegative-coordinate domain; it is not a theorem about real-number convexity
or equality with the SVG fill.

[Eleven literal fixtures](homogeneous-combination-tests.bend) cover unequal
denominators, both one-zero-weight cases, boundary inclusion, positive output,
and zero total weight. The asymmetric unequal-denominator case distinguishes
the two operations: joining `(2,4,2)` and `(9,3,3)` with weights 2/1 gives
`(13,11,7)`, whereas their ordinary affine mixture gives `(30,30,18)`.
The zero/zero case has denominator zero even though the polynomial region
predicate accepts it, demonstrating why the positivity contract is necessary.

Four compiling mutations use the wrong x weight, omit the second y term,
omit the second denominator term, and use the wrong denominator when forming
the affine weights. The first three violate linear-form exactness and fail at
the shared `weighted_fields` helper; the last violates the public
`mixture_denominator_exact` contract itself. Distribution and order arguments
reuse the existing attributed `facts.bend` / `order-facts.bend` proofs.

The remaining stage-2 bridges are still required: source quad corners must be
shown to inhabit these regions, the regions must be identified with the filled
convex quads, and the separating-axis decision must characterize geometric
intersection. Independent enumeration and the real topological bridge remain
open in stages 3–4.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 196 public
laws across 30 proof roots, the eleven new literal fixtures and existing fixture
groups, 138 compiling mutations, and independent SVG checks. Implementer
self-review found no violations of the stated contracts: it checked coefficient
and coordinate order in both side polynomials, distribution/regrouping,
nonnegative comparison reflection, all four region sides, zero-weight branches,
positive input denominators, unequal-denominator affine weights and the
existential-witness consumer boundary. This adds a Nat geometry model and proof
root; production search/generation policies and word arithmetic owners are
unchanged. No real-number convexity or polygon/topology theorem is claimed.
`taskset -c 7,11 ./regenerate.sh` passed with the five-second kernel limits;
`git diff --exit-code -- b.svg` confirmed byte-identical output. Stages 2–4
remain unfinished at the geometric and topological bridges described above.

### Stage 2: quad corners inhabit their half-plane region

[Quad model](quad-geometry.bend), [six laws](quad-geometry-laws.bend) and
[proof root](QUAD_GEOMETRY_PROOF.bend) connect ordered quad corners to the
previous rational-region model. Integer cover vertices embed with denominator
**one**. Triangle-side comparisons are cyclically invariant, and the side
comparison at either endpoint is exactly `EQ`. These statements include
coincident points and degenerate triangles; no strictness premise is needed
for the algebraic identities.

`strict_quad_corners_inside` proves that all four embedded corners belong to
the region whenever all four cyclic turns are strictly positive. It uses
endpoint equalities for the two incident sides and cyclic invariance for the
other two sides of each corner. `strict_quad_decoded` identifies this natural
four-turn predicate with the existing Nat SAT model. Under the actual 12-bit
quad-envelope premise, `production_corners_inside` derives the same corner
membership from the production validator's accepted `strictly_convex` result.
It reuses the established arithmetic bridge rather than assuming word
comparisons are exact or silently omitting their bounds.

[Nine literal fixtures](quad-geometry-tests.bend) cover a CCW square, clockwise
orientation, collinearity and a necessary-fourth-turn counterexample. For
`[(4,4),(8,4),(8,8),(2,3)]` the first three turns are positive, the fourth is
negative, and the last corner lies outside the first side's closed half-plane.
Thus a three-turn acceptance policy does not justify the corner theorem.

Three compiling mutations change the embedding denominator to two, omit the
fourth turn, and accept negative turns. They violate endpoint/cyclic semantics,
corner soundness, and the production-decoding/corner contracts, respectively.
Their first proof failures are `cyclic_fields`, the public
`strict_quad_corners_inside` law, and `edge_turn`; the first and third are shared
support lemmas. The theorem statements do not treat a clockwise quad as a
CCW region or use a strict inequality to exclude boundary corners.

This proves corners-in-region, not region-equals-hull or region-equals-SVG-fill.
The convex-mixture theorem can now combine these corners, but the reverse
inclusion, intersection characterization, independent enumeration and
real-number/topological bridges remain open. Stages 2–4 are unfinished.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 202 public
laws across 31 proof roots, nine new literal fixtures and the existing groups,
141 compiling mutation controls and independent artifact checks. Implementer
self-review found no violations of the stated contracts: it traced denominator
one, cyclic determinant product order, both endpoint equalities, the two
incident and two opposite side judgments for every corner, all four turn
premises, the natural decoder and the production envelope bridge. The shared
point/quad owners and exact arithmetic policies are reused. The future hull
inclusion proof can consume corner membership together with rational convex
mixture closure; reverse inclusion and topology are not assumed here.
`taskset -c 7,11 ./regenerate.sh` passed with the existing five-second kernel
limits, and `git diff --exit-code -- b.svg` confirmed byte-identical output.
Stages 2–4 remain open at the bridges described above.

### Stage 2: rational corner hull is inside the region

[Hull model](quad-hull.bend), [seven laws](quad-hull-laws.bend) and
[proof root](QUAD_HULL_PROOF.bend) define a rational four-corner hull and prove
its inclusion in the existing half-plane region. The model reuses natural cover
vertices, denominator-one embedding and homogeneous combination; it introduces
no new word-arithmetic, polygon-fill or topological policy.

`weighted(q, k, l, m, n)` combines all four embedded corners, using nonnegative
Nat weights. An independent polynomial reference in the law module verifies
both coordinates and the denominator, which is exactly `(k+l)+(m+n)`.
`InHull(q, p)` is an existential witness of those four weights with positive
sum, positive denominator of p, and cross-product equivalence between p and
the generated weighted point. It allows arbitrary unreduced fractional
representations; it does not admit a zero-denominator point or zero total
weight. `hull_point_positive` exposes the representation validity directly.

`weighted_quad_inside` derives region membership from corner membership via
three proved homogeneous joins. It needs no positivity for either intermediate
pair: one pair may have zero weights. Positivity of the **final** denominator
is proved from the exact total instead. `hull_point_inside` transports that
membership to the equivalent fraction p with both denominators proved positive.
The production theorem obtains corner membership from the validator's accepted
strict-convexity result under its actual 12-bit envelope. Thus every represented
rational hull point of a guarded, accepted production quad passes its decoded
half-plane region. The conclusion uses exact Nat geometry; the guarded
production bridge supplies the input quad’s corner membership.

[Ten fixture judgments/constructions](quad-hull-tests.bend) cover asymmetric
four-way weights, fourth-corner-only weights, either zero intermediate pair,
zero total, and a reconstructed equivalent fraction. For the square with
corners `(1,1),(3,1),(3,3),(1,3)`, weights `(1,2,3,4)` produce `(20,24,10)`;
the membership witness for `(10,12,5)` is explicitly constructed and consumed
by the membership and positivity theorems.

Six compiling mutation controls omit the fourth weight, omit the second pair,
swap the first pair's weights, omit n from the total, allow zero total weight,
and allow zero-denominator membership. The first three fail at shared
`quad_weighted_fields`, the fourth at shared `denominator_sum`, and the last two
at the public `hull_point_inside` and `hull_point_positive` laws. The last two
expand the membership domain: their countercases are deliberately excluded by
the original guards. Allowing all-zero weights admits arbitrary positive
fraction points because cross-product equivalence with `(0,0,0)` is vacuous;
allowing zero denominators admits `(0,0,0)` as equivalent to any weighted point.
These are domain-integrity controls, not claims that those cases were accepted
by the original `InHull` type.

Only hull-to-region inclusion is proved. Region-to-hull inclusion is still
required before the two can be identified, and there is no real-number or SVG
fill equivalence theorem here. Intersection characterization, independent
complex enumeration and the actual topological bridge remain open in stages
2–4.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 209 public
laws across 32 proof roots, ten new fixture judgments/constructions and the
existing groups, 147 compiling mutation controls and independent artifact
checks. Implementer self-review found no violations of the stated contracts:
it traced all four labelled weights, the independent coordinate reference,
exact total denominator, either zero intermediate pair, positive final sum,
positive candidate denominator, equivalence transport, existential witness
unpacking and the guarded production corner theorem. Nat coordinates, quad
identity and region policies remain in their existing owners. The future
region-to-hull proof can construct this membership witness directly; no reverse
inclusion or topology is assumed by the present proof.
`taskset -c 7,11 ./regenerate.sh` passed with the existing five-second kernel
limits; `git diff --exit-code -- b.svg` confirmed byte-identical output.
Stages 2–4 remain unfinished at the reverse-inclusion, intersection, enumeration
and topology bridges stated above.

### Stage 2: region points split into diagonal triangles

[Diagonal model](quad-diagonal.bend), [four laws](quad-diagonal-laws.bend) and
[proof root](QUAD_DIAGONAL_PROOF.bend) construct a checked triangle choice for
an arbitrary point passing all four quad half-planes. `Split<q,p>` carries an
ABC or ACD tag, a proof that the actual diagonal decision selected that tag,
and a proof of membership in that triangle's **three closed half-planes**.
The decision uses side AC; nonnegative side selects ACD, and negative side
selects ABC. A point on AC therefore selects ACD while belonging to both
closed triangle regions.

`opposite_closed_halfplane` proves that failure of a directed closed half-plane
implies membership in its reverse. It reuses the established determinant-sum
reversal identities and proves the comparison implication by Nat induction.
`region_diagonal_split` uses that result for the ABC branch and the original
AC half-plane for the ACD branch. Its four input side judgments are extracted
from the existing region predicate; no convexity assumption is needed for
this implication. It does not assert that either triangle region is contained
in the quad region for an arbitrary ordered quad.

`strict_diagonal_triangles` separately derives positive orientation of both
ABC and ACD from the quad's four strict turns, using the proved cyclic identity.
The production split theorem applies the exact bounded `inside`/region bridge
to a word witness under the actual 12-bit quad and witness envelopes. Its
conclusion is the natural-coordinate split; positivity of a rational witness
remains an additional requirement, supplied by accepted-search witness laws.
The polynomial split theorem also applies to denominator-zero inputs, and
does not interpret those inputs as points in the rational plane.

[Thirteen fixture judgments/constructions](quad-diagonal-tests.bend) cover
points strictly on either side of AC, the diagonal boundary, both closed
triangle predicates, both strict turns, an unreduced fraction and concrete
applications of the tagged split theorem. Four compiling mutations reverse a
triangle side, reverse the diagonal decision, reverse the ACD corner order and
reverse its strict turn. The first three fail at shared `diagonal_split_choice`,
the last at shared `diagonal_strict_fields`. Each violates the corresponding
public split/orientation contract; the reported failure locations remain shared
support lemmas, not individual public-law sections.

This prepares region-to-hull inclusion: the selected positively oriented
triangle still needs a proved barycentric-weight construction for an arbitrary
positive-denominator point in its three half-planes. That construction and the
reverse inclusion remain unfinished, followed by intersection characterization,
independent enumeration and the real topological bridge. Stages 2–4 stay open.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 213 public
laws across 33 proof roots, thirteen new fixture judgments/constructions and
the existing groups, 151 compiling mutation controls and independent artifact
checks. Implementer self-review found no violations of the stated contracts:
it checked opposite determinant sums, strict failure versus closed inclusion,
AC/CA direction, ABC/ACD vertex order, all three triangle predicates, the
closed-boundary tie, tagged decision evidence, both strict orientations and
production envelope premises. Existing point, region, cyclic-orientation and
exact-arithmetic owners are reused. The future barycentric construction can
consume the tagged triangle judgment and strict-turn result directly; no
barycentric weights or reverse hull inclusion are assumed in this increment.
`taskset -c 7,11 ./regenerate.sh` passed with the existing five-second kernel
limits; `git diff --exit-code -- b.svg` confirmed byte-identical output.
Stages 2–4 remain open at barycentric construction, reverse inclusion,
intersection, enumeration and the real topological bridge.

### Stage 2: oriented-area weights have an exact positive total

[Area model](triangle-area.bend), [six laws](triangle-area-laws.bend) and
[proof root](TRIANGLE_AREA_PROOF.bend) begin the barycentric construction for
the selected triangle. Each weight is the corresponding directed area:
`wA = area(B,C,p)`, `wB = area(C,A,p)`, `wC = area(A,B,p)`. The model reuses the
existing two nonnegative determinant sums and computes their Nat difference.
Here `area` uses the doubled-area convention and retains the homogeneous
witness denominator; it is not an ordinary Euclidean area measurement.
`area_reconstruct` proves that this difference is exact under the closed
half-plane premise: adding back the negative sum gives the positive sum.
Outside that premise Nat subtraction may saturate, so these weights alone do
not establish triangle membership.

The two cycle laws regroup all nine determinant terms. The positive and
negative totals have the same coordinate-dependent common part; their
remaining parts are the triangle's positive/negative determinant sums times
the witness denominator. The proof transposes three rows of three terms,
distributes products, rotates sums and uses the already proved Nat cancellation
facts. It adds no signed-number or area axiom.

For a positive triangle turn and a point passing all three closed triangle
half-planes, `triangle_weights_total` proves exactly
`wA + wB + wC = denominator(p) * area(A,B,C)`.
`triangle_area_positive` proves the triangle's directed area is positive,
and `triangle_weights_positive` combines this with a positive point denominator
to prove a nonzero total. Individual weights may be zero on edges and corners.
The total identity also covers a zero denominator algebraically, but the
positivity theorem requires its separate explicit validity premise.

[Ten fixture judgments/constructions](triangle-area-tests.bend) cover interior
weights, a vertex's zero weights, an unreduced fraction, positivity through the
public theorem, outside saturation and zero denominator. For
`A=(1,1), B=(5,1), C=(1,5)`, the whole directed area is 16; `(2,2,1)` has weights
`(8,4,4)` and `(4,4,2)` has total 32. The outside point `(6,6,1)` fails the
triangle predicate and its saturated weights total 40, demonstrating why
half-plane premises cannot be dropped.

Four compiling mutations reverse subtraction, reverse the third weight's
side, reverse the whole triangle's orientation and omit a common-coordinate
term. They fail at the public `area_reconstruct` law, shared
`area_sum_reconstruct`, public `triangle_area_positive`, and shared
`area_positive_cycle_fields`, respectively. Each changes a true stated
arithmetic/geometry contract into a false one; noncompiling mutations are
excluded from the gate.

At this milestone, the area weights had not yet been proved to reconstruct the point's x/y
coordinates. Those two identities are required to turn the weights into the
`InHull` witness and finish region-to-hull inclusion. Intersection
characterization, independent enumeration and the real topological bridge
remain open; stages 2–4 are unfinished.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 219 public
laws across 34 proof roots, ten new fixture judgments/constructions and the
existing groups, 155 compiling mutation controls and independent artifact
checks. Implementer self-review found no violations of the stated contracts:
it traced each directed weight, the subtraction guard, determinant column
regrouping, the shared coordinate part, both Nat cancellations, strict triangle
orientation, individual zero weights, positive point denominator and outside
saturation. Existing determinant, order, cyclic, distribution and cancellation
owners are reused. The future coordinate-reconstruction proof can consume the
exact total and nonzero result without assuming either x/y identity.
`taskset -c 7,11 ./regenerate.sh` passed with the existing five-second kernel
limits; `git diff --exit-code -- b.svg` confirmed byte-identical output.
At this milestone, stages 2–4 remained open at x/y reconstruction, reverse inclusion, intersection,
independent enumeration and the actual topological bridge.

### Stage 2: exact triangle coordinate reconstruction

[Coordinate model](triangle-coordinate.bend), [five laws](triangle-coordinate-laws.bend)
and [proof root](TRIANGLE_COORDINATE_PROOF.bend) complete the coordinate identities
for the previously constructed area weights. If `A,B,C` have a strict positive
turn and `p=(x,y,d)` passes their three closed half-planes, the checker proves
`Ax*wA + Bx*wB + Cx*wC = x*area(A,B,C)` and the corresponding identity for y.
Together with the proved total-weight identity, reconstruction is exactly
`(x*area, y*area, d*area)`. With `d>0`, its denominator is positive and its
cross-products equal those of the original point.

The positive and negative coordinate cycles are proved for arbitrary natural
coordinates and either axis. Explicit distribution, matrix transposition,
monomial rotations and addition regrouping give the same common part on both
sides. The guarded result then uses exact area reconstruction and the existing
Nat cancellation owner. The proof does not introduce signed arithmetic, an
unchecked polynomial normalizer or a new geometric axiom. The temporary host
script used to write repeated proof terms is outside the trusted boundary:
every emitted equality is checked by Bend.

[Ten fixtures](triangle-coordinate-tests.bend) exercise distinct x/y values,
an unreduced fraction, a vertex, a zero coordinate, public validity, and the
outside/zero-denominator guards. In the triangle `(1,1),(5,1),(1,5)`, the point
`(3,2,1)` reconstructs as `(48,32,16)` and `(6,4,2)` as `(96,64,32)`. Outside
point `(6,6,1)` is not equivalent to its saturated-weight reconstruction;
the zero-denominator reconstruction is invalid.

Five compiling controls swap the corner axis, change the third negative-cycle
coefficient, change the third area-weight coefficient, swap the reconstructed
x/y fields and zero its denominator. Their first failures are in shared
`coord_x_positive_fields`, `coord_x_negative_fields`, `coord_sum_reconstruct`
and `coord_reconstruct_fields` (the last two controls), rather than distinct
public law sections. Each corrupts a stated law on valid literal inputs; these
are handwritten compiling proof controls, not a bend-falsify report.

At the coordinate milestone, reverse region-to-hull inclusion could consume both
the exact coordinates and the positive total. It still needed four-corner `InHull` witnesses
for the selected diagonal triangle. Intersection characterization, independent
enumeration and the actual topological bridge remain open. Stages 2–4 are
unfinished.

Validation of coordinate reconstruction: `taskset -c 7,11 python3 -u check.py`
passed all 224 public laws across 35 roots, the ten new fixtures and existing
groups, 160 compiling mutation controls and the independent SVG checks.
Five additional literal mutant probes checked the strict-turn, triangle-inside
and positive-denominator premises before confirming a false coordinate-cycle,
weighted-coordinate, point-equivalence or reconstructed-denominator result.
These probes were run separately; they are not counted as fixtures in `check.py`.
Implementer self-review found no violations of the stated contracts: it traced
both axis conventions, all three weight/corner pairings, positive and negative
coefficient rotations, subtraction guards, coordinate cancellation, denominator
normalization and the distinction between algebraic equivalence and fraction
validity. Existing determinant, distribution, reflection and cancellation
owners are reused. The next consumer is reverse region-to-hull inclusion;
the current laws do not claim that this witness has already been constructed.
`taskset -c 7,11 ./regenerate.sh` also passed every proof root under the existing
five-second kernel limit, native generation and independent geometry/topology
checks. `git diff --exit-code -- b.svg` confirmed byte-identical output.

### Stage 2: constructive region/hull equivalence

[Barycentric model](quad-barycentric.bend), [eight laws](quad-barycentric-laws.bend)
and [proof root](QUAD_BARYCENTRIC_PROOF.bend) construct four-corner convex-hull
membership from the closed half-plane predicate. The actual diagonal selector
assigns weights in the original `A,B,C,D` order. On the ABC branch it uses
`(area(B,C,p), area(C,A,p), area(A,B,p), 0)`; on ACD it uses
`(area(C,D,p), 0, area(D,A,p), area(A,C,p))`. A point on the diagonal follows
the closed ACD branch. The proof preserves each branch's own triangle area;
they need not be equal.

For a strictly positive-turn quad and a point passing its closed half-planes
with positive denominator,
`selected_weights_valid` proves a positive total and exact cross-product
equivalence to the selected four-weight point. `region_point_in_hull` packages
these actual weights into the existing existential `InHull` type. It does not
define membership as a renamed half-plane Boolean. The two zero-corner
reconstruction laws hold without geometry premises; the guarded selector proof
combines them with the earlier diagonal split, strict triangle turns and exact
triangle reconstruction. Zero individual weights and boundary points remain
valid.

`region_hull_characterization` supplies both implication functions: passing the
half-planes produces an `InHull` witness, and an `InHull` witness passes the
half-planes. The reverse function reuses the original hull inclusion owner and
the proved corner-containment theorem. This is a universal pointwise equivalence
in the stated natural-coordinate/positive-denominator rational domain. It does
not quantify over a newly introduced real plane or over arbitrary SVG paths.

The native inside/strict-convexity bridge consumes the existing width-12
arithmetic envelopes and exact native judgments. Its positive-denominator
premise is explicit: an arithmetic envelope only gives upper bounds, and also
accepts a zero denominator. For triples, `CommonHull` carries one rational point
with independent `InHull` evidence for each of the three cells.
`common_region_in_hulls` converts a shared half-plane witness, and
`production_triangle_hull_witness` turns an accepted native triple search into
that genuine shared convex-hull point when all three native quads are strictly
convex. This is search soundness; completeness of the finite search is still
open.

[Nineteen fixture judgments/constructions](quad-barycentric-tests.bend) cover
both selected branches, distinct coordinates, diagonal contact, a vertex's
zero weights, an unreduced fraction, two different triangle areas in a skew
quad, explicit hull membership, both characterization functions, native
membership, shared membership in three different cells and the actual native
triple search. The skew quad `(1,1),(6,1),(5,4),(1,5)` reconstructs `(4,2,1)`
with denominator 15 and `(2,4,1)` with denominator 16. Outside, flat-quad and
zero-denominator fixtures expose the guards rather than asserting membership.

Six compiling controls add a nonzero unused fourth weight, swap the ACD
third/fourth weights, change either diagonal branch, omit the fourth weight
from the total, and omit it from the reconstructed point. Their first failures
are in shared `bary_abc_fields`, `bary_acd_fields`, `bary_selected_abc`,
`bary_selected_acd` and `bary_acd_valid`, rather than distinct public law
sections. Each control additionally checks a literal false instance of the
public selector contract with strict-quad, inside and positive-denominator
premises verified. The total control uses the fourth vertex, where only the
fourth weight is nonzero. These are handwritten proof controls, not an external
bend-falsify report.

Stages 2–4 remain unfinished. SAT intersection characterization, complete
intersection enumeration, the independent complex counts and the formal link
from that complex to the actual SVG fill and its two holes are still open.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 232 public laws
across 36 proof roots, the nineteen new fixture judgments/constructions and
existing groups, 166 compiling mutation controls, all six new literal mutant
counterexamples and independent artifact checks. Every kernel invocation kept
the five-second limit. Implementer self-review found no violations of the
stated contracts: it traced all four weight slots, each omitted corner,
coordinate/denominator regrouping, the actual selector decisions, both strict
triangle areas, positive totals, fraction validity, both implication functions,
bounded native bridges and the single point shared by all three hull witnesses.
Existing area, coordinate reconstruction, diagonal, hull inclusion, arithmetic
and search owners are reused. The new owner constructs barycentric evidence;
it does not duplicate intersection policy or redefine the existing hull type.
The next consumers are SAT intersection characterization and an independent
intersection enumerator. Independent SVG topology results remain finite
artifact evidence, not the unfinished universal topological bridge.
`taskset -c 7,11 ./regenerate.sh` passed every proof root, native compilation,
generation and independent geometry/topology checks with the existing limits.
`git diff --exit-code -- b.svg` confirmed byte-identical output.

### Stage 2: strict separators exclude hull points

[Strict-side model](strict-halfplane.bend), [eight laws](strict-halfplane-laws.bend)
and [proof root](STRICT_HALFPLANE_PROOF.bend) connect the production separator
to geometric exclusion. `negative(a,b,p)` is the exact complement of the
closed left half-plane. `separated(a,b,q)` requires all four embedded corners
strictly on the negative side; contact with the line is not separation.

`negative_weighted_join` proves strict negativity is preserved by a nonnegative
two-point homogeneous weighted sum when its total weight is nonzero.
`separated_weighted_quad` extends this to the actual four-corner hull point.
The proof handles all four choices of a first nonzero weight. Either pair of
weights may be entirely zero; no intermediate pair is assumed to have a
positive denominator. Both determinant forms distribute through the existing
join owner, and existing order facts show that one strictly smaller positive
weighted term plus the remaining weak inequalities gives a strict total.
The all-zero case contradicts the explicit positive-total premise.

`separated_hull_point` transfers the result to any actual `InHull` witness,
using its positive point denominator, nonzero weight total and exact
cross-product equivalence. `separated_region_exclusion` produces a function
from supposed hull membership of a point on the closed side to `Empty`.
This is a checked impossibility proof, not an empty search result. These
theorems require no convexity assumption on the four input vertices: their
convex hull is defined by the existing nonnegative weight witnesses.

`separated_decoded` proves the exact native-coordinate reference tests those
same four geometric sides. `production_separated_exact` reuses the proved
width-12 U32 arithmetic bridge, and `production_separated_region_exclusion`
turns a true bounded production separator into the same hull-exclusion
function. Endpoint and quad arithmetic envelopes remain explicit. The point
being excluded is a homogeneous natural-coordinate rational point; actual
hull membership supplies its fraction validity.

[Seventeen fixture judgments/constructions](strict-halfplane-tests.bend)
exercise contact versus strict separation, unequal fraction denominators,
a zero join weight, each single nonzero corner weight, all four weights,
an alternate fraction for a hull point, direct and native exclusion functions,
the decoded native separator, a blocking fourth corner, zero total and
reversed line orientation.

Six compiling controls flip the strict comparison, include boundary equality,
omit the second, third or fourth corner, or replace conjunction by disjunction.
Comparison controls fail in public `negative_closed_complement`; the four
corner-composition controls first fail in public `separated_weighted_quad`.
Each also has an independently checked literal counterexample to an
unconditional public complement or decoded-separator equation. Omission and
disjunction controls newly admit invalid separators: their examples are not
claimed to satisfy the original strict-separator premise. These are handwritten
compiling proof controls, not a bend-falsify report.

This establishes the exclusion meaning of one production separating side.
The full `meets` characterization still needs to assemble both quads' side
tests and prove the converse existence of a common point when no side separates
them. Finite triple-search completeness, independent complex enumeration and
the actual SVG-fill/topological bridge remain open. Stages 2–4 are unfinished.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 240 public laws
across 37 proof roots, the seventeen new fixture judgments/constructions and
existing groups, 172 compiling mutation controls, six new literal counterexamples
and independent artifact checks. Implementer self-review found no violations of
the stated contracts: it traced strict versus closed boundary behavior, the
positive-total condition, all four first-nonzero branches, zero intermediate
pairs, both distributed determinant forms, alternate fraction validity,
contradiction construction and the bounded native separator bridge. Existing
linear-form, order, hull and arithmetic owners are reused. The next consumer
must assemble all separating sides into a global intersection theorem; this
milestone does not claim SAT completeness or the unfinished topological link.
`taskset -c 7,11 ./regenerate.sh` passed all proof roots, native compilation,
generation and independent geometry/topology checks under the existing limits.
`git diff --exit-code -- b.svg` confirmed byte-identical output.

### Stage 2: common hull points cannot be rejected by `meets`

[Intersection model](quad-intersection.bend), [ten laws](quad-intersection-laws.bend)
and [proof root](QUAD_INTERSECTION_PROOF.bend) assemble every side of both quads.
`outside(q,r)` is the disjunction of the four strict separating-side tests;
`meets(q,r)` negates `outside(q,r) || outside(r,q)`. The independent
`CommonPoint(q,r)` type carries one valid rational point and two explicit
four-weight hull-membership witnesses, rather than defining an intersection as
that Boolean decision.

`hull_region_not_outside` proves that a point passing all four closed sides of
one quad and belonging to the other's convex hull defeats every separating
side. It does not require a convexity premise for the first quad beyond the
supplied inside-point evidence. The proof decomposes the four closed-side
judgments and uses the previous strict hull exclusion owner. Each hypothetical
separator produces `Empty`; an explicit Boolean case split therefore proves
that side test false, and the four-side disjunction is false.

For two strictly positive-turn quads, `common_hull_meets` proves
`CommonPoint(q,r) -> meets(q,r)=true`. It unpacks both hull witnesses, reuses the
existing corner-containment and hull-in-region proofs, and applies the preceding
side result in both directions. It keeps the same point throughout; independent
scalar weights and their Boolean certificates may be reused, while the
existential membership values are consumed once. `rejected_meets_excludes`
turns a false decision into a checked function from supposed common-point
membership to `Empty`.

The decoded `outside` and `meets` laws pin the exact native-coordinate
reference to this geometric composition. Under the existing width-12 arithmetic
envelopes, `production_meets_exact` connects the actual U32 decision to it.
The two production common-point/exclusion laws also consume explicit native
strict-convexity premises. Thus a bounded production rejection cannot discard
a genuine common hull point in this domain. Natural and native input-order
symmetry are separately proved; the native symmetry is Boolean composition
and does not need arithmetic envelopes.

[Eighteen fixture judgments/constructions](quad-intersection-tests.bend) cover
one-sided separation in either input order, decoded decisions, overlapping
hulls, an unreduced common-point fraction, edge and corner contact, same-quad
membership, both rejection functions, actual native contact decisions and both
symmetry laws. A box `(5,5),(15,5),(15,15),(5,15)` and the diamond
`(16,10),(17,9),(18,10),(17,11)` are separated by a box side, but no diamond
side separates the entire box. This exposes dropping one input's side tests
or changing their disjunction to conjunction. The invalid projective origin
`(0,0,0)` passes both quads' closed half-plane predicates even for that disjoint
pair, but its denominator is not positive; it is not an allowed `CommonPoint`.

Six compiling controls omit the closing or second edge, test each quad against
itself, omit the reverse-quad test, replace the global disjunction by
conjunction, or drop the final negation. They first fail in public
`outside_decoded` or `meets_decoded`. Each also has an independently checked
literal false instance of the corresponding unconditional decoder equation,
with strict convexity verified for both inputs. The last control rejects an
identical quad pair; the others incorrectly admit a disjoint pair. These are
handwritten compiling proof controls, not an external bend-falsify report.

The implication `meets=true -> CommonPoint` is still unproved: it needs a
constructive existence argument when no side separates. This milestone proves
correctness of rejection, rather than claiming the full intersection
characterization. Finite triple-search completeness, independent complex
enumeration and the actual SVG-fill/topological bridge remain open. Stages
2–4 are unfinished.

Validation: `taskset -c 7,11 python3 -u check.py` passed all 250 public laws
across 38 proof roots, the eighteen new fixture judgments/constructions and
existing groups, 178 compiling mutation controls, all six new literal mutant
counterexamples and independent artifact checks. Every kernel invocation kept
the five-second limit. Implementer self-review found no violations of the
stated contracts: it traced all four cyclic sides, both quad orders, the same
common point in both hull witnesses, positive denominators and totals, each
closed-side contradiction, Boolean rejection and symmetry, and the native
arithmetic/convexity bridges. The new owner composes existing strict-side,
hull-in-region and arithmetic owners. It introduces no existence assumption or
unchecked geometric axiom. The future existence/enumeration consumers still
need the explicitly missing true-decision-to-common-point direction.
`taskset -c 7,11 ./regenerate.sh` also passed all proof roots, native compilation,
generation and independent geometry/topology checks under the existing limits.
`git diff --exit-code -- b.svg` confirmed byte-identical output.

### Stage 2: exact segment/line cut

[Cut model](segment-cut.bend), [six laws](segment-cut-laws.bend) and
[proof root](SEGMENT_CUT_PROOF.bend) construct a rational point where an endpoint
pair crosses a line. For a point `p` on the closed left side and `q` strictly on
the negative side, let `gp = positive(p)-negative(p)` and
`gq = negative(q)-positive(q)`, using the existing homogeneous determinant sums.
The actual construction is `join(p,q,gq,gp)`: the opposite endpoint's gap is
its weight. `gp` may be zero at a boundary endpoint; `gq` is strictly positive.

`negative_gap_positive` and `crossing_total_positive` prove this positive gap
and nonzero total. `crossing_on_line` proves the constructed point's two
orientation sums exactly equal. It reuses guarded area reconstruction for p,
ordered subtraction cancellation for q and the existing linear-form owner.
The balance identity is
`positive(p)*gq + positive(q)*gp = negative(p)*gq + negative(q)*gp`.
The proof distributes products, swaps the matching `gp*gq` terms and regroups
addition; it introduces no division, floating-point rounding or geometric
existence axiom.

`crossing_denominator_positive` requires positive denominators at both
endpoints and proves the result valid. `InSegment` carries actual nonnegative
weights with nonzero total, validity of both endpoints and result, and exact
cross-product equivalence to their homogeneous join. `crossing_in_segment`
constructs that witness with the actual computed gap weights.
`crossing_region_preserved` proves the result remains in any other closed
half-plane region containing both endpoints. This last algebraic preservation
law does not need the line-crossing premises.

The homogeneous gaps already include endpoint denominators, so the cut uses
`join`, not the ordinary weighted-mean `mix` with these same weights. For line
`(0,2)->(6,2)` and endpoints `(1,4,1),(5,1,1)`, the gaps are `(12,6)` and the
constructed point is `(66,36,18)`, representing `(11/3,2)`. Replacing the
endpoint representations by `(2,8,2),(15,3,3)` produces `(396,216,108)`, the
same point, without assuming equal denominators. A boundary endpoint `(3,2,1)`
gets all the weight and reconstructs as `(18,12,6)`.

[Fourteen fixture judgments/constructions](segment-cut-tests.bend) cover the
asymmetric gaps, actual point, line equality, denominator validity, region
preservation and explicit segment witness; unequal denominators, a boundary
endpoint and reversed orientation; and the same-side/invalid-endpoint guards.
The invalid homogeneous endpoint `(0,0,0)` can give an algebraic on-line result
with zero denominator. Thus line equality alone is not fraction validity, and
the segment witness does not admit it.

Six compiling controls reverse negative-gap subtraction, use q's positive gap,
swap the two weights, drop the second weight, classify equality as strict
negativity, or replace the join by the ordinary weighted mean. Their first
failures are public `negative_gap_positive` and `crossing_total_positive`,
shared `cut_crossing_equal` and shared `cut_on_line_equation`. Each also has a
checked literal false public-law instance with the original closed/strict-side
and positive-endpoint premises still true. The positive-gap control uses a
boundary p; the weighted-mean control uses unequal endpoint denominators.
These are handwritten compiling proof controls, not a bend-falsify report.

This cut is a construction needed by the missing
`meets=true -> CommonPoint` direction. It does not yet select which edge pair
supplies a point satisfying all eight sides, or prove that such a selection
succeeds whenever `meets` is true. Triple-search completeness, independent
complex enumeration and the actual SVG-fill/topological bridge remain open.
Stages 2–4 are unfinished.

Validation: the complete retry of `taskset -c 7,11 python3 -u check.py` passed
all 256 public laws across 39 proof roots, the fourteen new fixture
judgments/constructions and existing groups, 184 compiling mutation controls,
all six new literal counterexamples and independent artifact checks. The first
complete attempt stopped when native compilation of the existing
`search-witness-tests.bend` exceeded its five-second limit; it was a failed run,
not a pass. The retry retained the same limits and passed every check.
Implementer self-review found no violations of the stated contracts: it traced
both guarded determinant differences, positive total, opposite-gap weighting,
exact determinant balance, endpoint/result denominator validity, the actual
segment weights and preservation of a containing region. Existing area,
linear-form, order, equality-reflection and convex-join owners are reused.
The future selection/clipping consumer must still prove the missing common-point
existence direction; this cut does not assume that result.
`taskset -c 7,11 ./regenerate.sh` passed all proof roots, native compilation,
generation and independent geometry/topology checks under the existing limits.
`git diff --exit-code -- b.svg` confirmed byte-identical output.

### Exact intersection candidate search (stage 2, incomplete)

`intersection-search.bend` constructs both four-corner lists and all sixteen
pairs of directed sides, including closing sides. Opposite closed-side decisions
produce exact homogeneous segment cuts; every candidate is filtered by a
positive denominator and all eight closed halfplanes. `scan` returns the first
accepted candidate in list order. It uses unbounded `Nat` coordinates and no
fixed denominator grid; it is not yet the bounded native topology search.

Thirteen new public laws pin the corner/side lists, cut orientation, each nested
loop, complete candidate layout, and both list and public search against an
independent first-accepted reference. For every input list, a returned hit
satisfies the actual domain and region predicates. For strict quads it yields
independent nonnegative four-corner hull weights and therefore `meets=true`.
The reference laws exclude an implementation that always returns `Miss`.

These are correctness and enumeration laws, **not geometric completeness**:
`meets=true -> search hit` remains unproved. A missed candidate cannot yet be
used as a disjointness certificate. Triple-search completeness, independent
complex enumeration, and the bridge to the topology of the actual SVG fill
remain open. Stages 2–4 are unfinished.

Validation: the complete final `taskset -c 7,11 python3 -u check.py` run
passed 269 public laws across 40 roots, all six new literal fixtures and existing
groups, 194 compiling mutation controls, and independent geometry/topology
checks. Ten new controls remove an accepted hit, accept an exterior point, omit
denominator validity, drop a corner or closing side, reverse cut orientation,
skip a row/column, omit the second corner list, or replace public search with
`Miss`. Their first failures occur in `choice_sound`, `find_hit_common_hull`,
`vertices_exact`, `edges_exact`, `cut_branch_exact`, `row_exact`, `pairs_exact`,
`candidates_layout` and `find_hit_sound`. These handwritten compiling controls
are not a bend-falsify report; some first failures are shared helpers.

The first full attempt failed at an existing native search-test compilation
timeout. The next run reached the mutation controls and exposed two incorrect
expected-diagnostic labels in the new harness rows. Those labels were corrected
to actual first failures without changing the core or proofs. The successful
final run retained all original five-second limits. Neither failed run counts
as passing validation.

Implementer self-review: the new pure search reuses the segment-cut,
halfplane-region, barycentric-hull and global-intersection owners. Its result
contains a rational point, while the proof supplies actual hull memberships;
neither a `Miss` nor a SAT acceptance is promoted to an existence proof.
The later native topology consumer still needs an exact arithmetic bridge and
geometric completeness. No production generator or SVG path was changed.
The independent reference covers traversal and selection but does not replace
the missing convex-polygon existence theorem.

`taskset -c 7,11 ./regenerate.sh` passed all 40 real proof roots, native
generation, and the independent geometry/topology checks with the original
limits. `git diff --exit-code -- b.svg` confirmed byte-identical output.

### List-level candidate existence (stage 2, incomplete)

`candidate-existence.bend` distinguishes successful search from the independent
Boolean fold `any_valid` over the input list. Five universal laws prove equality
of these decisions for every list, construct the actual returned point and its
acceptance proof from a true fold, lift equality to public `find`, distribute
existence over list concatenation, and show that an actual `Miss` certifies no
valid candidate in that list. These laws require no strict-convexity premise;
that premise belongs to the later hull and geometric-completeness consumers.

Real Bend accepted the new universal proof and four literal constructions:
extraction of an actual witness after invalid/exterior entries, empty-list
absence, an accepted appended candidate, and zero-denominator rejection.
Four compiling controls replace OR by AND, skip the head candidate, classify
Hit as false, or classify Miss as true. Their proof failures were checked at
`scan_found_exact` or shared `choice_found`. These are handwritten controls,
not bend-falsify. The complete final `taskset -c 7,11 python3 -u check.py` run
passed 274 public laws across 41 roots, all new and existing fixtures, 198
compiling mutation controls, and independent artifact checks.

The first full attempt failed because direct native compilation of the existing
`search-witness-tests.bend` exceeded five seconds. On Linux that fixture now
uses the same build path as `regenerate.sh`: Bend emits C under a five-second
limit, then clang compiles it with `-O1` under another five-second limit. This
keeps the executable tests and their assertions intact, reuses the existing
clang toolchain, and avoids the default optimizer that caused recurring native
build timeouts. Each subprocess retains its original limit; proof gates are
unchanged. The successful full run used this path. The earlier failed run is
not counted as passing validation.

This closes list traversal completeness, not geometric completeness. The missing
geometric theorem must establish `any_valid(candidates(q,r),q,r)=true` from
actual convex-hull intersection (or strict-quad SAT acceptance). Without that
bridge, `Miss` cannot certify geometric disjointness. Native triple-search
completeness, independent complex enumeration and actual SVG-fill topology
remain open. No generator or SVG output was changed.

Implementer self-review: `any_valid` is a fold of the existing domain and
halfplane predicate, not a renamed `found` result. The recursive equality proof
covers empty lists and both accepted/rejected heads; witness extraction retains
actual search equality and invokes the existing universal hit-soundness law.
Concatenation preserves the OR condition. The later geometric-completeness
consumer must supply existence in the generated list, which none of these laws
assumes. Existing geometry owners and the native generator remain unchanged.

`taskset -c 7,11 ./regenerate.sh` passed all 41 proof roots, native generation,
and independent geometry/topology checks. `git diff --exit-code -- b.svg`
confirmed byte-identical output. The Linux native-build harness change was
self-reviewed against the existing regeneration path and passed the actual
native fixture in the successful complete run.

### Geometric completeness for contained corners (stage 2, incomplete)

`corner-candidate.bend` states that at least one original corner of q lies in
r's closed halfplane region. Four public laws prove that, for a strict q, this
predicate exactly equals admissibility of q's four embedded corners; a true
predicate forces a witness from the actual complete candidate search. With both
quads strict, the selected witness supplies independent nonnegative hull weights.
A symmetric law proves success when a corner of the second quad lies in the
first; this law uses strictness of the second quad, not an assumed first-list
hit. The proofs reuse own-corner containment, positive embedded denominators,
list-level existence, concatenation, and actual search-hit soundness.

Five witness fixtures exercise each of the four corner positions and the
second-quad containment direction. A separate crossing fixture proves that
horizontal and vertical rectangles can intersect with no contained corner in
either direction, while the exact search still succeeds. This literal example
is not a universal proof of the crossing branch.

Five compiling controls remove each corner in turn or replace the outer OR
with AND. Each fails at shared `corner_admissions`; each also has a separately
checked literal refutation of public `corner_admission_exact` with its strict-q
premise true and an actual admissible vertex present. These are handwritten
proof controls, not a bend-falsify report. The new proof passed real Bend
under the five-second limit with CPU affinity; an initial unrestricted run of
the extended proof exceeded that limit and was not counted as passing. Crossing
fixtures are separate from witness fixtures so their literal computation does
not add to the imported universal proof-check workload.

The contained-corner branches are proved. The no-contained-corner branch still
needs a universal theorem providing an admissible side-intersection candidate.
This is not full SAT/geometric completeness. Triple-search completeness,
independent complex enumeration, and the actual SVG-fill topological bridge
remain open. Stages 2–4 are unfinished.

Implementer self-review: contained-corner acceptance is a region predicate,
while the resulting witness includes actual equality to the full search output;
it does not substitute the original corner for the selected point. Strictness
is used only to prove own-corner containment, and both hull memberships require
both strict-quad premises. The symmetric branch preserves the original search
order and proves existence in the second list. Existing geometry owners and
the native generator are unchanged. The later crossing consumer cannot infer
geometric disjointness merely from failure of these corner predicates.

Validation: the final complete `taskset -c 7,11 python3 -u check.py` run
passed 278 public laws across 42 roots, all new and existing fixtures, 203
compiling mutation controls, the five new literal public-law refutations, and
independent geometry/topology checks. Three earlier full attempts failed on
five-second timeouts in the monolithic intersection fixtures, the unchanged
`QUAD_BARYCENTRIC_PROOF.bend` root, and the combined corner-witness fixtures.
They are not counted as passing validation. A separate repeat of the unchanged
barycentric root passed in approximately 2.7 seconds with the same limit.

The old intersection fixtures now run in separation, common-point, and
native-bridge groups with shared `quad-intersection-fixtures.bend` data.
All 26 original fixture/helper definitions were verified present exactly once;
no assertion or coordinate was removed or weakened. The five new corner-witness
constructions run separately with shared `corner-candidate-fixtures.bend` data.
Each separate group passed real Bend under its unchanged five-second limit,
as did the final complete run. The self-review checked preserved test coverage,
actual result extraction, guard placement and both candidate-list directions.

The first regeneration attempt exited 124 during its proof-root loop and is
not counted as passing. The complete retry, `taskset -c 7,11 sh -x
./regenerate.sh`, passed all 42 real proof roots, native generation and
independent geometry/topology checks with unchanged limits. Shell tracing
provided command diagnostics only. `git diff --exit-code -- b.svg` confirmed
byte-identical output.

### Retained-segment coefficient rebasing (stage 2, incomplete)

`clip-weights.bend` replaces endpoints p,q by p and the homogeneous cut
`v*p + w*q`. For an original point `k*p + l*q`, the retained coefficients are
`alpha = k*w - l*v` and `l`. Five universal laws prove subtraction reconstruction
under `l*v <= k*w`, exact equality of all three homogeneous components to the
original point scaled by w, positive retained total when the old total and w
are positive, positive result denominator and equivalent coordinates, and an
actual nonnegative-weight `InSegment(p,cut,oldPoint)` witness. Existing natural
subtraction, arithmetic, raw scaling, point equality and homogeneous-join owners
supply the facts. No ordinary rational averaging or denominator rounding occurs.

Real Bend accepted the five laws and seven fixture constructions/judgments:
interior, zero-alpha boundary and zero-second-weight segment membership with
unequal endpoint denominators; exact components; false balance guard; changed
coordinates after saturated subtraction; and invalid zero-scale output.
Five compiling controls reverse subtraction, replace either product by a sum,
swap cut weights, or drop the second retained coefficient. First failures occur
in public `retained_reconstruct` or `rebase_exact`. Each also has a literal
refutation of public `rebase_valid` with all five premises checked true.
These are handwritten proof controls, not a bend-falsify report.

This is conditional algebra needed for segment clipping. Its consumer must
derive the balance condition and handle zero inside gap. The later
`clip-halfplane.bend` owner now proves those obligations for weighted points
in one-sided clipping. Full clipping iteration and geometric intersection
completeness remain open, alongside triple-search completeness, independent
complex enumeration and the actual SVG-fill/topological bridge. Stages 2–4
are unfinished.

Implementer self-review: the rebase equality covers the denominator alongside
both coordinates. Positive old total, positive w and valid endpoints are
explicit prerequisites for the geometric membership law. The boundary with zero
alpha and the endpoint with zero l are preserved. Saturated subtraction and zero
w have concrete counterexamples, so their missing premises cannot be silently
promoted to general clipping correctness. The later halfplane consumer must
prove the balance condition; this pure coefficient module cannot infer it.

Validation: the final complete `taskset -c 7,11 python3 -u check.py` run
passed all 283 public laws across 43 proof roots, seven new rebase fixtures,
existing fixture groups, 208 compiling mutation controls, all five new literal
public-validity refutations, and independent geometry/topology checks.
The first full attempt timed out in unchanged `SOURCE_INSPECTION_PROOF.bend`;
a separate exact repeat passed in about 2.7 seconds under the same limit.
The second full attempt accepted all 283 laws and the new fixtures, then timed
out in the existing combined `segment-cut-tests.bend`. Neither failed run is
counted as passing. The final complete run retained all five-second limits.

The fourteen original segment-cut fixtures now run in raw-coordinate and
witness-construction groups sharing `segment-cut-fixtures.bend`. All 19 original
fixture/helper definitions were verified present exactly once; no assertion or
coordinate was removed or weakened. Both groups passed separate real Bend
checks and the final complete run. Self-review covered guard placement, both
zero-coefficient boundaries, all three reconstructed components, retained total,
positive endpoint/result denominators and the actual segment-weight witness.

`taskset -c 7,11 sh -x ./regenerate.sh` passed all 43 real proof roots,
native generation and independent geometry/topology checks under unchanged
limits; shell tracing provided command diagnostics only.
`git diff --exit-code -- b.svg` confirmed byte-identical output.

### One-sided halfplane clipping of weighted points (stage 2, incomplete)

`clip-halfplane.bend` connects the actual inside/outside determinant gaps to the
retained-segment coefficients. Eight universal laws characterize `l*v <= k*w`
as exactly closed-halfplane membership of the original weighted point, given a
closed retained endpoint p and a strictly outside endpoint q. In particular,
a closed original weighted point `k*p+l*q` supplies the balance required by
rebasing. The proof expands both exact determinant sums, uses the
proved endpoint gap reconstructions, and cancels their common weighted terms.
No balance assumption is supplied by the caller.

For positive inside gap w, the coefficient rebase preserves membership of the
original weighted point in the segment between p and the actual cut. The public
`rebased` calculation is pinned to exact common scaling and proved valid under
its positive-gap/domain premises. For zero w, the derived balance and positive
outside gap force l=0; a separate actual weight witness retains the old point
without producing a zero-denominator result. `retained_member_all_gaps` combines
both branches and proves one-sided membership preservation for every valid
weighted point that remains in the closed halfplane. The primitive `rebased`
calculation still requires its positive-gap guard for validity: at w=0 its raw
scaled result is zero, and the boundary proof uses the separate certificate.

Real Bend accepted all eight laws and thirteen new fixture definitions covering
derived balance, balance equality, positive-gap membership, explicit boundary
membership, the combined law in both branches, actual positive rebase validity,
exact components, rejection through the exact classifier, an outside original
point with false balance, and invalid raw zero-gap rebase. Six compiling controls
return constant True, reverse the balance inequality, replace either product
by a sum, swap the geometry-bound rebase gaps, or drop the second old coefficient.
Each fails at public `closed_join_balance_exact` or `halfplane_rebase_exact`,
and each has a checked literal public-law refutation with its actual premises
verified true. The constant-True control incorrectly accepts an outside point
while both endpoint premises hold. The left-sum control uses a valid
boundary point and zero outside coefficient; the right-sum control uses equal
gap products. These are handwritten compiling controls, not bend-falsify.
Integrated validation passed: 291 unique public laws across 44 roots, all fixture groups, 214 compiling mutation controls, invalid-artwork controls and independent SVG geometry/topology checks.

This proves one-sided clipping for explicit homogeneous weighted points. It does
not yet supply a full interval-clipping iterator, establish how its final
endpoints correspond to the original side-pair candidate list, or prove the
no-contained-corner intersection branch. Triple-search completeness,
independent complex enumeration and the actual SVG-fill/topological bridge
remain open. Stages 2–4 are unfinished.

Implementer self-review: endpoint, original-point and outside decisions are
separate premises; no numerical balance premise is substituted for them.
The exact classifier handles both acceptance and rejection and prevents a
constant-acceptance implementation from satisfying the public decision contract.
Exact linear-form and gap facts come from their existing owners. Natural-order
cancellation removes identical terms, with a checked symbolic recursive proof.
The zero-gap branch derives the vanishing outside weight and supplies actual
positive endpoint/result denominators and nonnegative retained coefficients.
The positive branch reuses the existing coefficient proof, while public rebase
validity follows the exact scale and positive old denominator. Existing native
search and generation are unchanged. Future interval iteration must prove its
own selection, provenance and representative-preservation obligations.


Validation checkpoint: the first integrated attempt timed out in unchanged
`INTERSECTION_SEARCH_PROOF.bend`; its exact separate repeat passed real Bend
under the same five-second limit. That attempt is a failed run. Before the next
full run, the new balance law was strengthened to exact Boolean equivalence,
with the original preservation law derived from it. The new rejection fixture
and all six compiling/literal controls passed real Bend. The complete retry passed with unchanged proof limits: 291 laws across 44 roots and 214 compiling controls. Generator regeneration also passed all 44 real proof roots, bounded native compilation and independent artifact checks. The generated SVG is byte-for-byte unchanged.


### Exact source-segment provenance (stage 2, incomplete)

`segment-provenance.bend` carries a pair of original-source coefficients through
one combination of reparameterized endpoints. Four universal laws prove that
`compose` equals the nested homogeneous join in all three raw components, that
valid nonempty combinations retain a positive denominator, and that
`cut_on_source` equals the actual determinant-gap cut of the current endpoints.
The source-cut denominator is positive under valid original endpoints,
nonempty current coefficient pairs and the actual outside-endpoint premise.
The cut weights are computed from the current points, not from the original
source endpoints. Zero inside gap is allowed by the cut validity contract.

Ten fixture definitions cover unequal denominators, exact components, empty
outer weights, a zero inner pair, current endpoint combinations, source-cut
validity and a boundary cut with zero inside gap. Three handwritten compiling
controls drop either contribution to the source coefficients or swap the
current cut gaps. Each is tied to a literal refutation of the corresponding
exact public equality; these equality laws have no premises. The swap
counterexample uses unequal gaps and small coordinates to keep literal kernel
reduction within the unchanged five-second limit. An earlier larger literal
counterexample timed out and is not counted as passing. Integrated validation passed: 295 unique public laws across 45 roots, all fixture groups, 217 compiling mutation controls, invalid-artwork controls and independent SVG geometry/topology checks. Generator regeneration also passed all 45 real proof roots, bounded native compilation and independent artifact checks. The generated SVG is byte-for-byte unchanged.

Implementer self-review: the new pure owner depends on the existing homogeneous
combination and exact segment-cut owners. Its proofs reuse their denominator
contracts and the existing distributive/regrouping facts. The scalar helper
states arithmetic independently of the implementation so coefficient mutations
fail in public `compose_exact`; the cut-gap mutation fails in `source_cut_exact`.
No native search, generator or SVG behavior has changed. The intended later
consumer is the clipping iterator, whose endpoints must remain tied to the
original side rather than merely belong to a transient segment.

This establishes a single composition step, not an implemented iteration or a
proof that every final endpoint occurs in the original candidate list.
Proportional-weight equivalence, clipping selection and complete search still
need their proofs. Independent enumeration and the actual topological bridge
remain open; stages 2–4 are unfinished.

Validation checkpoint: the first integrated provenance run accepted all 295 laws
across 45 roots and the new fixtures, then timed out in unchanged
`candidate-existence-tests.bend`. Its separate repeat passed at the same
five-second limit; the first integrated run remains failed. The complete retry passed with unchanged limits and assertions: 295 laws across 45 roots, all fixtures and 217 compiling controls.


### Proportional source-segment representatives (stage 2, incomplete)

`segment-proportional.bend` compares the actual cross products `k*w` and `l*v`
and reports equivalence of the two actual homogeneous joins. Four public laws
pin both reports to their exact calculations, prove that a true coefficient
proportion implies identical rational coordinates, and prove exact equality of
closed-region membership for valid nonempty representatives. The region law
uses positive original endpoint denominators and positive totals for both
coefficient pairs. It preserves both acceptance and rejection, without
requiring membership as an extra caller premise.

The proof expands the two coordinate cross products into four checked Nat
terms. The proportion matches the two mixed terms; commutativity matches the
other two. It uses no division, numeric sampling, cancellation of possibly
zero factors or new axioms. Region transport reuses the existing homogeneous
combination and halfplane-region contracts. Algebraic equivalence also holds
for an all-zero coefficient pair, but such a join has a zero denominator and
cannot satisfy the region theorem's validity guards.

Ten fixture definitions cover unequal endpoint denominators, rejection of
unequal proportions, scaled coefficient pairs, a zero endpoint weight, an
all-zero pair's algebraic equivalence and invalidity, and inside/outside
region preservation. Three handwritten compiling controls always accept the
ratio, replace equality with an inequality, or swap the second pair of join
weights. Each fails in public `proportional_exact` or `same_point_exact` and
has a checked literal refutation of that exact public law. The report laws
have no premises; the swapped-weight example additionally checks a true ratio.
Integrated validation of the subsequent boundary checkpoint passed all 302 public laws across 47 roots, all fixture groups and 223 compiling mutation controls. Regeneration also passed all 47 real proof roots, bounded native compilation and independent artifact checks. The generated SVG is byte-for-byte unchanged.

Implementer self-review: the two pure reporting functions have exact contracts
for all inputs, so constant acceptance cannot pass unnoticed. The algebraic
proof is independent of domain validity; only the existing region owner
interprets valid point equivalence geometrically. The later clipping consumer
can use this transport to compare a reparameterized source-segment point with
a direct candidate, but must still derive the proportion from the actual
boundary condition. No generator, native search or SVG behavior has changed.

This does not yet prove that an on-boundary point's coefficients have the
computed cut-gap proportion, implement interval clipping, or establish
complete pair/triple search. Independent enumeration and the actual
topological bridge remain open; stages 2–4 are unfinished.

Validation checkpoint: seven integrated attempts failed on five-second timeouts
in existing `SOURCE_INSPECTION_PROOF.bend`, `QUAD_DIAGONAL_PROOF.bend`,
`INSIDE_ARITHMETIC_PROOF.bend`, `NATURAL_COVER_PROOF.bend`,
`quad-intersection-native-tests.bend`, `segment-provenance-tests.bend`, or
`CELL_TRANSVERSE_PROOF.bend`.
These runs are not passes. Separate repeats of all five timed-out roots passed under
the same limit. CPU-affinity changes alone did not eliminate whole-run failures.
The six original native assertions were preserved verbatim and partitioned
into native and contact files; the six provenance assertions were likewise
preserved verbatim and partitioned into combination and cut files. All are
required by `check.py`, exactly once, and both revised groups passed separately.
The last complete retry used normal affinity with unchanged limits and assertions and timed out in the existing transverse root. These historical failures were not passes. The proportional laws were published separately in `05a0793` with validation recorded as pending; the subsequent boundary checkpoint now passes the complete integrated gate, including both fixture partitions and all proportional laws/controls.


### Boundary-derived source coefficient proportion (stage 2, incomplete)

`segment-boundary.bend` uses the actual determinant gaps of the source
endpoints to classify a weighted point's boundary condition. Three universal
laws prove exact equivalence between that computed ratio and the actual
`Cut.on_line` decision, equivalence to the direct cut for a boundary point,
and identical closed-region membership under valid nonempty point premises.
The ratio is derived from the boundary, rather than supplied by the caller.
A closed first endpoint and strictly outside second endpoint are explicit
geometric premises. The inside gap may be zero; the boundary endpoint branch
is included. The algebraic theorem allows zero weights, while geometric
region transport requires positive endpoint denominators and a positive
old coefficient total.

The proof expands the actual positive and negative determinant sums using
the existing segment-cut owner, reconstructs the endpoint gaps using the
existing area/order owners, and cancels their identical common weighted
terms. It reuses the gap regrouping from the halfplane clipping proof and
the already checked proportional-representative transport. No numerical
proportion premise, division, sampling or extra axiom is introduced.

Nine fixture assertions cover a scaled coefficient boundary point, both
interior and exterior rejection, an all-zero pair's algebraic boundary
condition, direct-cut equivalence, region transport and zero-gap boundary
endpoint equivalence. The first combined proof-fixture file exceeded the
unchanged five-second limit; its five assertions were preserved verbatim
and partitioned into classification and witness files, both of which passed
separately. Three handwritten compiling controls always accept the ratio,
swap the computed gaps, or use the saturated inside-area gap of the outside
endpoint. Each fails at public `ratio_on_line_exact` and has a checked
literal refutation with both geometric endpoint premises true. A preliminary
wrong-endpoint mutation did not compile because it duplicated an affine
parameter; it was discarded and is not counted as a compiling control.
Integrated validation passed all 302 public laws across 47 roots, all fixture groups, 223 compiling mutation controls, invalid-artwork controls and independent exact SVG geometry/topology checks. Regeneration also passed all 47 real proof roots, bounded native compilation and independent artifact checks. The generated SVG is byte-for-byte unchanged.

Implementer self-review: the new pure classification owner consumes actual
source endpoints and shared gap/point calculations. The proof keeps boundary
classification separate from denominator validity. The region theorem
inherits the existing region owner's exact membership transport and uses
the proved positive total of the direct cut. A later clipping iterator can
now turn an on-boundary original-source representative into the direct
candidate while preserving membership in both regions. It must still
prove its selection, iteration, endpoint provenance and boundary-label
invariants. The generator, native search and SVG are unchanged.

Interval clipping, complete pair/triple search, independent enumeration
and the actual topological bridge remain open. Stages 2–4 are unfinished.

Validation checkpoint: the first integrated boundary run timed out in unchanged
`COVER_ARITHMETIC_PROOF.bend`; that run is failed. The exact separate repeat
passed under the same five-second limit. A complete retry is pending, including
the previous proportional checkpoint's local fixture partitions and all new
boundary assertions and controls.

The next full boundary run timed out in unchanged `SEARCH_ARITHMETIC_PROOF.bend`.
An exact separate attempt also timed out at five seconds (about 5.4 total child
CPU seconds), so it was not treated as a passed gate. Inspection found that
search imported the entire cover proof only for generic Boolean `or_two`.
That checked helper now lives in the existing Boolean-reflection owner;
cover retains its old entry point as a forwarding proof, and search consumes
the shared owner directly. All 302 public laws remain in the 47-root manifest.
The first post-change search attempt printed `ALL PROOFS CHECK` but still exited
124 at the limit; that attempt is explicitly failed. The separate cover root
passed, and the next exact search repeat passed under the same five-second
limit on CPUs 7/11. A full run of this revised dependency graph is pending.

The revised full run timed out in unchanged `INTERSECTION_SEARCH_PROOF.bend`.
Inspection found another generic reflection dependency: geometric proofs
imported the full artwork validator only for Nat equality reflection. The
existing Boolean-reflection owner now supplies reflexivity/completeness;
the validator retains forwarding entry points, and its public laws remain
required by the manifest. Four geometric proof owners consume the shared
reflection directly. Comparing import graphs against the published checkpoint
reduces the intersection-search root from 129 modules/909 definitions to
127 modules/866 definitions, without removing any public law from the overall
47-root/302-law scope. The exact intersection-search and new boundary roots
passed real Bend after this change, at the same five-second limit. The subsequent complete integrated run passed all 302 laws, all fixture groups and 223 compiling controls. Regeneration subsequently passed all 47 real proof roots, bounded native compilation and independent artifact checks. The generated SVG is byte-for-byte unchanged.


Reflection dependency self-review: the generic Boolean disjunction congruence
and Nat equality reflection proofs were moved unchanged into their existing
shared owner. Cover and validator retain forwarding entry points, while search
and four geometric proof consumers depend directly on reflection. No public
law, caller premise, mutant, fixture assertion or proof deadline was removed.
The complete integrated gate validates all affected consumers and the native
controls, not only the new boundary root. The trusted Base/compiler and the
arithmetic library subset are unchanged.

Regeneration checkpoint: after the successful complete integrated gate, the
first regeneration attempt timed out in `INTERSECTION_SEARCH_PROOF.bend` before
native compilation or SVG replacement. That regeneration attempt is failed;
the subsequent unchanged-limit full-script retry passed all roots, native compilation and artifact checks.

The CPUs-7/11 regeneration retry also timed out, in unchanged
`INSIDE_ARITHMETIC_PROOF.bend`, before compilation/replacement. It is another
failed regeneration run. The normal-affinity same-limit full-script retry passed all 47 roots, native compilation and independent geometry/topology checks. The already passed complete integrated gate is unchanged. Both prior regeneration attempts remain recorded as failed runs.


Verified boundary checkpoint: `python3 -u check.py` completed with exit 0:
302 unique public laws across 47 roots, all fixture groups and 223 compiling
mutation controls; invalid artwork, SVG and independent topology controls also
passed. The final `sh -x ./regenerate.sh` run completed with exit 0 at unchanged
five-second proof/compilation limits. The independent artifact checks report
3 tubes, 96 convex cells, 24 seams, one fill component and two holes (Euler -1;
simplex counts [96, 146, 64, 15]). `git diff --exit-code -- b.svg` confirms the
SVG is byte-for-byte unchanged. This is a verified implementation checkpoint,
not completion of stages 2–4 or a universal topological bridge.


### Constructive interval clipping step

`interval-clip.bend` implements one closed-halfplane clipping step. It keeps
both inside endpoints, removes an entirely outside interval, or retains the
inside endpoint and the computed boundary cut. The reversed mixed case places
the inside endpoint first; it does not preserve endpoint order. A later iterator
must carry and swap original-source coefficients and boundary labels explicitly.

Ten public laws require the actual four-way selection, exact validity, region
and presence reports, valid closed output endpoints, preservation of a second
convex region, and retention of every closed weighted input point with positive
total weight. Retention supplies an explicit `InSegment` witness for the actual
output; its membership predicate belongs to the law specification. An empty
output has no membership witness. The proof covers both mixed directions and
zero boundary gaps. Exact report laws prevent constant Boolean reports from
satisfying preservation laws vacuously. A shared homogeneous-combination proof
establishes exact reversal of endpoints and weights.

Sixteen fixture assertions exercise selection, cut coordinates, invalid
denominators, preservation, membership and zero-gap cases. Eleven compiling
mutation controls alter selection, reports, direction or endpoint validity.
Each is required to fail a public proof and admit a checked literal refutation
of the unfolded public law; selected controls additionally refute constructive
membership or preservation with checked input premises. These are handwritten
Bend controls, not a run of an external mutation tool.

Implementer self-review: clipping consumes the existing region, segment-cut
and one-sided clipping owners; generic join reversal lives with homogeneous
combination. The law-owned membership predicate constrains the real selected
result. This step adds no trusted axioms and changes neither the generator nor
the SVG. The full integrated check and regeneration passed for this checkpoint. This is one clipping step, not the four-halfplane iterator, complete
intersection search, independent enumeration or a universal topology bridge.
Stages 2–4 remain open.


Interval-clipping validation: the first integrated attempt timed out in the
unchanged `WIDTH_PROOF.bend` at five seconds and is recorded as failed. The
exact separate repeat passed at the same limit. The complete unchanged-limit
retry of `python3 -u check.py` exited 0: 312 public laws across 48 roots, all
fixture groups, 234 compiling mutation controls and the invalid-artwork,
independent artifact and topology negative controls. The artifact still has
3 tubes, 96 convex cells, 24 seams, one component and two holes. Those topology
counts are exact finite evidence, not the missing universal bridge.


The subsequent `sh -x ./regenerate.sh` completed with exit 0: all 48 roots
passed real Bend at the unchanged five-second limit, followed by bounded
native compilation, execution and independent artifact verification.
`git diff --exit-code -- b.svg` confirms byte-for-byte preservation.
Self-review found no additional violations in this clipping slice; complete
iteration, provenance selection and the stages 2–4 bridges remain outstanding.


### Iterated closed-halfplane clipping

`interval-walk.bend` executes the interval clip over an arbitrary list of
directed halfplanes. `clip_quad` uses all four directed sides, in their
declared order. Nineteen public laws constrain the exact step, empty/cons
iteration, side list, wrapper and physical acceptance/validity/closure
predicates. They prove valid final endpoints, compliance with every processed
halfplane, and preservation of any supplied list of earlier constraints.

The constructive nonemptiness theorem starts with a valid `InSegment` witness
for a point accepted by every requested halfplane. At each step the proof uses
that witness's actual nonnegative weights, transports the remaining side tests
to the equivalent homogeneous combination, and obtains a witness for the
actual selected interval. Recursion proves the actual final result is present.
This includes closed boundary contacts and arbitrary equivalent point
representations with positive denominators. It proves forward existence
preservation; it does not yet return the original point's membership in the
final interval or label the final endpoints on the original source segment.

Fifteen fixture assertions cover two successive cuts, reversal, rejection at
the third side, corner-only contact, an empty side list, an extra/repeated side,
validity, all final constraints, a prior constraint, unequal denominators,
exact quad membership and retained interior/boundary points. Thirteen compiling
mutations cover forgotten sides, early termination, endpoint loss or creation,
reversed halfplanes, constant predicates and a bypassed quad wrapper. Each
failed a public-law proof and has a real Bend-checked literal refutation of
that law. These are handwritten controls, not external `bend-falsify`.

Implementer self-review: the iterator owns traversal only; the existing clip
owner owns selection/cuts, and the region and homogeneous-combination owners
supply geometry and representation transport. The later source-provenance
consumer still needs endpoint coefficients and boundary labels, including
metadata swaps in reversed mixed cases. No source-provenance, complete search,
enumeration or topology theorem is inferred from this traversal. Full
integrated validation and regeneration passed for this checkpoint.
Stages 2–4 remain open; the trusted Base/compiler boundary is unchanged.
The production generator and intersection search do not yet consume this
iterator; source-provenance and candidate-completeness bridges are still needed.


Walk validation attempt: the first complete run timed out at the unchanged
five-second limit in existing `TRIANGLE_AREA_PROOF.bend`; that run failed.
The exact separate repeat passed real Bend at the same limit. The complete
retry is pending. The new walk root, all three new fixture groups and all
thirteen new compiling mutants/literal refutations passed locally beforehand.


The next complete walk run accepted all 331 laws across 49 roots and the new
walk fixtures, then timed out in existing `quad-intersection-common-tests.bend`.
That full run failed. The unchanged-limit separate fixture repeat passed real
Bend. Another complete same-limit retry is pending; no assertion, public law
or mutation was removed and no deadline was increased.


Verified walk integrated check: the subsequent complete `python3 -u check.py`
exited 0 with 331 unique root-level public laws across 49 roots, all fixture
groups and 247 compiling mutation controls. Invalid-artwork, SVG corruption
and independent topology controls passed. Exact finite artifact checks still
report 3 tubes, 96 convex cells, 24 seams, one component, two holes and Euler
-1 (simplex counts [96,146,64,15]). The subsequent regeneration also passed.
The two earlier failed integrated attempts remain recorded as failed attempts. These checks
cover the root-level B generator and proof core, not the separate alphabet
work added concurrently in commit `921c842`.

Publication checkpoint: the walk proof root and all three walk fixture groups
were rechecked successfully with the unchanged five-second limit. All thirteen
walk mutants compiled, failed their public-law proof, and passed the literal
refutation check. Complete integrated validation remains pending as recorded
above at publication of that checkpoint. The later completed full-suite and
regeneration evidence is recorded below.


Verified walk regeneration: `sh -x ./regenerate.sh` exited 0, with all 49
real Bend roots accepted at the unchanged five-second limit, bounded native
C emission/Clang compilation, execution and independent geometry/topology
checks. `git diff --exit-code -- b.svg` confirms byte-for-byte preservation.
The implementer self-review found no additional contract violations in this
traversal slice. This is a verified stage-2 checkpoint, not completion of
intersection completeness, independent enumeration or the topology bridge.


### Tracked source endpoints through interval clipping

`tracked-interval.bend` carries two natural coefficients and an origin tag
for each endpoint. The tags identify the original left/right endpoint or the
actual directed boundary used for a cut. New cut coefficients flatten the
current endpoint combinations through the existing segment-provenance owner.
The reversed mixed branch swaps the complete endpoint records together.

Twenty-one public laws constrain the actual point evaluation, full cut record,
branch choice, step, empty/cons traversal, initialization, quad wrapper and
physical interpretation of labels. The erasure laws prove exact raw equality
with the existing clipping step and iterator, including the homogeneous
denominator; this is stronger than equality up to rescaling. Origin honesty
is preserved through the actual traversal. Boundary tags assert the resulting
point lies on the stored line, and source tags assert geometric equality with
the named original endpoint. Exact reports prevent replacing this check with
a constant Boolean.

Constructive source-membership laws supply explicit `InSegment` witnesses for
every valid evaluated endpoint and both final quad-clipping endpoints. The
proof derives positive coefficient total from positive point denominator;
zero/zero coefficients are ruled out by a checked zero-combination theorem.
The source endpoints' positive denominators remain explicit premises. The
member predicate belongs to the specification, not an implementation report.
An empty result has no endpoints, while the earlier iterator's existence
theorem and exact erasure prevent silently losing an accepted source point.

Fifteen fixtures cover exact coefficients and tags after two cuts, reversed
source order, retained source tags, late rejection, dishonest tags, zero
denominators, raw erasure, honest final labels, unequal denominators, explicit
source membership and corner-only contact. Fourteen compiling mutations alter
coefficients, tag orientation, branch selection, traversal, initial weights,
reports, side guards or the quad wrapper. Their public-law failures have
Bend-checked refutations at literal inputs. These remain handwritten controls,
not an external `bend-falsify` run. A local source-membership proof attempt
reached the unchanged five-second limit and failed; its separate repeat passed
under that limit. The final expanded root and fixture groups passed locally.

Implementer self-review: traversal and metadata belong to the tracked interval
owner; flattening coefficients reuses segment provenance, and unit/zero
combination proofs live with homogeneous combination. The new core consumes
existing cut and walk owners rather than duplicating their geometry. The later
candidate consumer still needs the fact that a stored cut boundary separates
the original source ends, followed by the direct-cut equivalence and complete
search bridge. Honest line membership alone does not establish those facts.
The production generator/search are unchanged; stages 2–4 remain unfinished.
Full integrated validation and regeneration are pending for this checkpoint.


Tracked-source validation: the first integrated run accepted all 352 public
laws across 50 roots, then timed out at the unchanged five-second limit in
`tracked-interval-tests.bend`. An exact separate repeat also timed out. Both
attempts failed. The four original assertions are now partitioned into the
erasure/honesty group and `tracked-interval-source-tests.bend`, with each
assertion and proof preserved verbatim and required by `check.py`. No law,
fixture premise, mutation or deadline was weakened. Integrated retry is pending.


The partitioned fixture batch produced no accepted verdicts within the limits,
and a separate tracked root attempt also exited 124. Those attempts failed.
Inspection found that pure geometric proofs imported the native halfplane
decoding proof for generic Boolean congruence and representation transport.
The unchanged Boolean `four_cong` proof now lives in Boolean reflection; the
old entry point forwards to it. Pure edge/region equivalence proofs now live in
`halfplane-equivalence-proof.bend`, while the corresponding original halfplane
public laws and helper entry points forward to those proofs. Strict-halfplane, quad
geometry, quad hull and the interval iterator consume the pure owners directly.
No public law or premise was removed. Comparing the tracked root import graphs
before/after this cleanup reduces 134 modules/972 definitions to 128/937.

The revised tracked root, all partitioned source fixture groups and the
original full native `HALFPLANE_REGION_PROOF.bend` passed real Bend at the
same five-second limit. The proof manifest still requires all 352 laws across
50 roots, including native decoding laws. A full integrated retry is pending
for the revised dependency graph; the trusted Base/arithmetic library is
unchanged. This cleanup changes proof dependencies, not geometric predicates,
the generator, source membership requirements or the mutation suite.


The revised integrated run passed all roots and fixtures, then failed a mutation
diagnostic assertion: the existing fourth-side-omission mutant now first fails
in the extracted region-scale proof, before the old decoder diagnostic. That
run failed. A scale-invariance theorem alone would not refute omission of a
side, so the control now uses a literal of the original public
`inside_halfplanes_decoded` law at a point outside exactly the fourth side.
The original literal passed real Bend; the same compiling omission mutant
failed that literal and admitted a Bend-checked refutation of the public-law
instance. The suite still has 261 compiling controls and still checks the full
native halfplane proof in its positive gate. A complete integrated retry is
pending; this change strengthens the control's evidence instead of accepting
a different diagnostic as evidence of the original public-law failure.


The first full retry after the fourth-side literal-control fix timed out in
existing `WITNESS_ARITHMETIC_PROOF.bend` at five seconds and failed before
fixture/mutation checks. Its exact separate repeat passed at the same limit.
Another complete unchanged-limit retry is pending.


The next integrated retry timed out in existing `INTERSECTION_SEARCH_PROOF.bend`
and failed. Separate normal-affinity and CPU-pinned repeats also exited 124.
An archived published-HEAD comparison at the same five-second limit exited 124
after printing `ALL PROOFS CHECK`; that comparison is failed, not accepted.
The current-root comparison also exited 124.

New unit/zero-coefficient proofs have now been factored into their own
homogeneous-combination proof companion, `homogeneous-source-proof.bend`, so
old geometric consumers do not import unrelated source-basis proofs. The
original homogeneous-combination proof file is unchanged from published HEAD.
Only edge/region equivalence was extracted from the halfplane owner; scale
proofs retain their original implementation. The exact separate intersection
search repeat subsequently exited 0 with `ALL PROOFS CHECK`, at the unchanged
five-second limit. The full integrated retry is pending for this final graph.
This is proof-dependency factoring; no law, premise, control or deadline was
removed or increased.


The final-graph integrated run accepted all 352 laws across 50 roots, then
timed out in `tracked-interval-member-tests.bend` and failed. Its exact
separate repeat passed with exit 0 under the same five-second limit. A full
unchanged-code, unchanged-limit retry is pending; the fixture assertions and
proofs are unchanged.


The next integrated attempt timed out in existing `SOURCE_INSPECTION_PROOF.bend`
and failed. Its separate five-second repeat also exited 124 without an
accepted verdict. The full integrated retry remains pending. No failed attempt
is counted as a successful proof gate.


The next full integrated attempt timed out in the first existing `PROOF.bend`
and failed. A CPUs-7/11 separate repeat also exited 124. The new laws and
source fixtures have accepted local/current-graph kernel evidence above, but
there is still no completed integrated gate for this checkpoint. Regeneration
and publication remain pending; these timeouts are not reported as passing.


### Source crossing checkpoint (unpublished)

Four additional public laws in `source-crossing-laws.bend` classify both
source endpoints exactly and derive original-source crossing from an accepted
nonzero weighted combination and a strictly rejected combination. The
positive-denominator version derives the required nonzero coefficient sum;
no premise is assumed from trace metadata. `SOURCE_CROSSING_PROOF.bend`
passed the real kernel with exit 0 and `ALL PROOFS CHECK` under `timeout 5`.
A preceding verdict attempt exited 124; frontend-only acceptance was not
counted as mathematical verification. The manifest now includes 356 public
laws across 51 proof roots (scope validation passed).

The generic positive-coefficient helper moved from the tracked-interval proof
to `homogeneous-source-proof.bend`, where source crossing also consumes it.
The tracked root's current-graph repeat timed out (124); its previous accepted
21-law evidence predates this helper relocation. New source-crossing fixtures
cover all four classifications, both directions, unequal denominators,
validity-derived crossing and the zero-combination pitfall. Their verdict
attempts timed out, so these fixtures are not recorded as passing.
Four compiling-mutant controls and literal law refutations were added to the
integrated harness; their validation remains pending until recorded below.

The integrated attempts in this checkpoint failed at existing
`SAMPLE_ARITHMETIC_PROOF.bend` and `ARITHMETIC_PROOF.bend`, respectively,
because of the unchanged five-second subprocess limit. No complete integrated
result, regeneration or publication is claimed. Stage 2 still needs a proof
connecting each actual clipping boundary tag to the search's original-source
candidate; stages 3 and 4 remain open.

Implementer self-review: the new crossing contract describes physical source
classifications and preserves the essential nonzero/validity premise. It does
not infer candidate completeness from boundary labels or finite examples.
The protected arithmetic core, SVG and compiler deadlines are unchanged.

The first new source-crossing mutant passed its frontend compilation gate,
but the subsequent expected-rejection proof invocation timed out. Therefore
no new mutant/refutation pair has an accepted complete validation result yet;
the controls stay required by the integrated harness.


### Source-boundary correspondence (work in progress, unpublished)

Five public laws were added in `source-boundary-laws.bend`: exact orientation
selection, exact branches, projective equivalence of an on-line source
combination to the direct original-source cut, crossing forced by actual
valid clipping inputs, and equivalence of the actual new clipped endpoint
to the direct original-source cut. Both source orientations are handled;
closed boundary endpoints count as inside. The manifest scope check accepts
361 unique laws across 52 roots. These five new laws are not yet kernel
accepted: all current verdict attempts exited 124 under the unchanged
five-second limit. An initial frontend diagnostic exposed a reversed equality
orientation in the coefficient-swap helper; that call was corrected. Later
frontend attempts also timed out and do not establish acceptance.

Four source-boundary raw fixtures (forward/reverse orientation and boundary
contact) passed with exit 0 and `ALL PROOFS CHECK` under `timeout 5`.
Two proof fixtures exercise actual cut/source representative agreement with
unequal denominators in both source orientations; their checks timed out,
so they remain unverified and required by `check.py`.

The closed-to-negative reflection helper now belongs to the strict-halfplane
proof owner; interval clipping retains its old forwarding entry, and new
crossing/boundary proofs avoid importing the entire clipping proof for this
single implication. Exact tracked-cut coordinates and their boundary-line
proof were extracted into `tracked-cut-proof.bend`; tracked interval and
source-boundary proofs share this owner rather than duplicate the algebra.
The updated graph still needs full verification, including the older 21-law
tracked root and four-law crossing root previously accepted before these
refactorings. No protected arithmetic source, SVG, law/control or timeout
was removed or weakened. A host CPU sample showed high load and one idle
allowed CPU; repeats pinned to that CPU still timed out, so affinity alone
does not fix the pending proof gate.

Implementer self-review: the new contract bridges actual cut construction
and the exact oriented source representative, rather than trusting a label.
It remains necessary to prove this correspondence for boundary labels retained
through an entire valid clipping walk, then establish search completeness.
Stages 2–4 and publication remain open. No new verdict timeout is counted
as a passing proof or integrated result.

After extracting the shared tracked-cut proof owner, the exact current
`SOURCE_BOUNDARY_PROOF.bend --check-only` command completed with exit 0
and frontend acceptance under `timeout 5`. This resolves the frontend
uncertainty above; mathematical kernel acceptance remains a separate gate.

The subsequent exact current `timeout 5 bend SOURCE_BOUNDARY_PROOF.bend
--verdict` completed with exit 0 and `ALL PROOFS CHECK`: all five new
source-boundary laws now have kernel acceptance in this shared-owner graph.
The two source-boundary proof fixtures' next separate verdict attempt still
exited 124, so their acceptance and the complete integrated run remain pending.
The universal law acceptance is not reported as fixture/full-suite acceptance.

All three new source-boundary controls passed their complete local gates:
the original literal law instance was accepted, each mutated core compiled,
the generic proof rejected `direct_exact` or `choose_exact` as expected,
and Bend accepted the literal Empty refutation under the unchanged
five-second limit. All four source-crossing decision controls likewise
compiled, rejected `different_exact`, and had accepted literal refutations.
These are repository-owned compiling mutants with kernel-checked witnesses;
external bend-falsify was not run. `check.py` requires these seven controls
and all earlier controls. The Python harness compiles and `git diff --check`
passes. The tracked root's current shared-owner verdict repeat timed out;
a new complete integrated attempt is in progress and is not yet counted.

The full integrated attempt for this exact checkpoint failed on the existing
`SAMPLE_ARITHMETIC_PROOF.bend --verdict` subprocess timeout at five seconds.
It is not a successful full gate. Regeneration and publication remain pending;
the source-boundary kernel acceptance and seven complete local mutation
controls above remain the verified evidence for this turn.


### Candidate correspondence through the complete clipping walk

Seven new public laws in `tracked-candidates-laws.bend` pin the physical
label, endpoint and complete report interpretation, establish initial
correspondence, preserve it under every valid clipping step and arbitrary
edge-list traversal, and specialize it to actual four-side quad clipping.
Source tags mean projective equivalence to the named original endpoint.
Boundary tags require both original-source crossing and projective equivalence
to the direct original-source cut. Current validity is an explicit step/run
premise and is propagated by the existing actual clipping validity theorem;
positive original denominators establish the quad wrapper's initial validity.
The implementation does not assume metadata to infer physical crossing.

The exact current `timeout 5 bend TRACKED_CANDIDATES_PROOF.bend --verdict`
completed with exit 0 and `ALL PROOFS CHECK`. Seven raw fixtures and two proof
fixtures also passed separate real Bend verdict gates at the unchanged limit,
including retained labels through a complete walk, reversed sources, unequal
denominators, wrong-boundary rejection and a false span report. Earlier
verdict/frontend attempts timed out and are not counted as passing.
All seven new compiling mutants passed complete local gates: wrong source
tags, omitted crossing, omitted projective equivalence, swapped coefficients,
false empty-state and constant span report each compiled, rejected the expected
physical public law, and admitted a kernel-checked literal Empty refutation.
These are handwritten mutation controls; external bend-falsify was not run.
The manifest scope check now accepts 368 unique laws across 53 roots.
The integrated harness retains all old/new roots, fixtures and controls.

Self-review: the invariant applies to actual retained endpoints through the
entire walk, and the independent exact report laws reject constant-success
implementations. The geometric bridge still needs to place each boundary label
in the enumerated quad edge set and transport common-region admission to that
actual search candidate; search completeness and stages 3–4 remain open.
No SVG coordinate, proof premise, protected arithmetic definition or deadline
changed. Complete verification, regeneration and publication remain pending.

A separate terminology-only correction was published as `1c5d14e`: project
prose, a comment and the checker's status text now use Bend. It changes no
proof or algorithm. The correction was staged from the prior published versions,
so unfinished proof work was not included in that commit. Origin clarification:
the longer name appeared in the installed compiler's guide; attributing it to
user dictation was incorrect. It remains omitted from project terminology.

The complete integrated attempt for the candidate-invariant checkpoint failed
at the existing `INTERSECTION_SEARCH_PROOF.bend --verdict` five-second
subprocess timeout. No complete integrated result is claimed for this graph;
local invariant, fixture and seven mutation-control acceptance above is the
verified evidence. Regeneration and publication remain pending.


### Directed origin occurrence through the clipping walk

Seven laws in `tracked-origin-laws.bend` construct actual directed-edge list
occurrences for boundary origins, establish edge-list self-membership and
initial source origins, preserve allowed origins under cut/step/arbitrary
walk, and specialize to the exact quad edge list. Occurrence is an explicit
sum of a head equality or a recursive tail occurrence, with Empty for an empty
list; boundary labels cannot claim membership by a constant Boolean report.
Metadata membership is independent of geometric validity, while the earlier
candidate invariant separately proves physical crossing and representative
agreement under validity. These contracts compose without inferring geometry
from metadata.

The exact `timeout 5 bend TRACKED_ORIGIN_PROOF.bend --verdict` passed with
exit 0 and `ALL PROOFS CHECK`. Four constructive fixtures passed the same real
Bend gate: actual complete/reversed walks, the second directed quad side and
a cut with that actual side occurrence. Initial binder/forward-call errors
were corrected before this accepted gate. The scope manifest accepts
375 unique laws across 54 roots. The directed-boundary mutation control was
added to the integrated harness; its complete validation result is recorded
separately below. The checker Python module compiles.

The preceding complete 368-law/53-root retry failed at existing
`VALIDATOR_NATURAL_PROOF.bend` on the unchanged five-second timeout. This is
not a successful integrated gate and no intermediate acceptance substitutes
for it. Regeneration and publication of proof work remain pending. The next
mathematical obligation is to transport directed-edge occurrence into the
actual search candidate list and common-region admission. Stage 2 remains
open; stages 3–4 remain open. The SVG is unchanged.

Directed-origin control result: the reversed-label core compiled and the
public `cut_allowed` proof was rejected. The first counterexample file
incorrectly imported unfilled law declarations and failed with seven TODOs;
that invocation is not counted as an accepted refutation. Constructive
occurrence/report definitions were then moved into their pure owner
`tracked-origin.bend`, retaining forwarding type APIs in the law module.
The literal refutation imports the pure owner, with no unfilled law claim.
Its corrected complete local control passed compilation, expected public-law
rejection and the real Bend literal Empty-refutation gate.

Three anti-vacuity extractor laws were added: an occurrence in an empty list
constructs Empty, endpoint reports expose the actual origin report, and span
reports expose both actual endpoint reports. The current ten-law directed
origin root passed real `--verdict` with exit 0 and `ALL PROOFS CHECK` under
`timeout 5` after this owner extraction. The original fixture assertions are
unchanged and all remain required. Manifest scope is now 378 laws/54 roots;
no proof or control was removed or weakened. The source SVG is unchanged.

The full integrated attempt for the 378-law/54-root origin checkpoint failed
at existing `ARITHMETIC_PROOF.bend --verdict` on the unchanged five-second
timeout. That is not a passing gate; no regeneration/publication is claimed.
All ten new origin laws, four constructive fixtures and the complete directed
boundary control have accepted local evidence recorded above. The harness now
includes the additional directed-origin control in its reported total rather
than excluding its separate invocation. Stage 2 still needs search-list
membership/admission and full completeness; stages 3–4 remain open.


### Exact occurrence in the actual search candidate list

Fourteen new laws in `search-membership-laws.bend` construct exact point/edge
occurrences, pin empty/head extraction, preserve occurrences through both list
append directions, translate actual directed walk edges to search edges,
prove the exact quad-edge translation, and carry a crossed source cut through
actual `cut_branch`, `edge_cut`, `row`, `pairs` and `candidates`. The final
boundary-origin law accepts an actual occurrence in the walk's quad edge list
and produces an exact occurrence of the oriented direct cut in the production
search's candidate list, given the original source edge occurrence and crossing.
Membership retains raw homogeneous point equality; earlier boundary laws
separately supply projective equivalence from retained traced endpoints.

The exact current `timeout 5 bend SEARCH_MEMBERSHIP_PROOF.bend --verdict`
passed with exit 0 and `ALL PROOFS CHECK`. Eight constructive fixtures passed
real Bend at the same deadline: a fourth source-edge candidate, reversed
source direction, translated second directed quad side, boundary contact,
an actual constructed cut's origin occurrence, and its composed search-list
membership (with the shared occurrence fixtures). The fixture module contains
eight proof assertions plus shared data/helper definitions; all remain required.
The manifest scope check accepts 392 public laws across 55 proof roots.

Five new complete local mutation controls passed: skip a row head, drop a row
tail, skip a pairs head, drop a pairs tail and omit all pair-cut candidates.
Each original literal public-law instance and its premise witnesses passed
before mutation; each mutant compiled and rejected the expected literal
membership law; Bend accepted a literal Empty refutation under mutation.
For omitted pair cuts, the refutation explicitly eliminates the remaining
eight vertices using unequal raw coordinates. It does not infer failure only
from a diagnostic helper. These are handwritten compiling controls, with no
external bend-falsify claim. The integrated harness requires all five controls
and includes them in its reported mutation count.

Self-review: exact candidate occurrence is separated from candidate admission.
No membership theorem claims an arbitrary cut lies in either common region;
that guard and validity transport are the next bridge. These laws do not yet
prove all geometric intersections have a candidate or complete stages 2–4.
The protected arithmetic core, generator, SVG and deadlines are unchanged.
Full integrated verification, regeneration and proof publication remain pending.

The complete integrated attempt for this exact 392-law/55-root checkpoint
failed at the existing `EDGE_ARITHMETIC_PROOF.bend --verdict` subprocess on
the unchanged five-second deadline. This attempt is not a passing full gate.
The fourteen new laws, eight constructive fixtures and five complete local
mutation controls above retain their accepted evidence; regeneration and
publication remain pending.


### Admission transport and actual selected search witnesses

Six laws in `search-admission-laws.bend` connect exact candidate occurrence
and actual common-region admission to the list existence predicate and the
actual selected search hit. They prove admission invariance under valid
projective representatives, validity of an oriented direct cut from valid
crossed source endpoints, and construction of the search witness from a
boundary occurrence, original source edge occurrence and a valid equivalent
point in both regions. The existential witness retains the actual `scan`
result and its admission predicate; the returned point can be an earlier
acceptable corner rather than the candidate used to establish existence.
Membership by itself is not treated as geometric admission.

The exact `timeout 5 bend SEARCH_ADMISSION_PROOF.bend --verdict` completed
with exit 0 and `ALL PROOFS CHECK`. Four proof constructions and five raw
judgments passed real Bend under the same deadline: boundary witnesses in
both crossing directions, selected tail after an invalid prefix, projective
admission equivalence, the actual earlier selected corner, rejection of a
zero-denominator point, rejection of an exterior point, and a clockwise
region rejection. An initial reverse-direction fixture incorrectly reversed
the whole quad, making its closed region inadmissible; the compiler rejected
that false premise. The reverse-direction positive fixture now uses a proper
quad and its other directed source edge. The rejected clockwise example is
retained explicitly as a negative raw assertion, not dropped or counted as
passing a positive premise.

Three complete local compiling mutation controls passed: skip the actual scan
head, bypass a true admission and accept a false admission. Each original
literal of the public occurrence-to-witness result and its occurrence/admission
premises passed before mutation; the altered core compiled and rejected that
literal; the real Bend checker then accepted the Empty refutation of the
actual witness. The false-admission control exposes a selected zero-denominator
head and contradicts the witness's admission predicate constructively.
These are handwritten controls, with no external mutation-tool claim.
The integrated harness requires all fixtures/controls and includes the three
additional controls in its mutation total. Scope validation accepts
398 unique public laws across 56 roots. The Python harness compiles.

Self-review: both representative denominators are required for admission
transport; direct validity is derived from real crossing and source validity;
both common-region predicates remain explicit. No claim is made yet that every
geometric intersection supplies the occurrence/correspondence premises.
The next composition must derive these premises from retained actual clipping
endpoints and source-region preservation, then close geometric search
completeness. Stages 2–4 remain open. Full integrated verification,
regeneration and proof publication remain pending. The source SVG and
protected arithmetic definitions are unchanged.

The integrated attempt for this exact checkpoint accepted all 398 public laws
across all 56 roots using real Bend verdict checks under the unchanged
five-second deadline. It then failed on the `tracked-candidates-tests.bend`
fixture subprocess timeout. All preceding newly ordered fixture groups in
that run completed before the failure. This is accepted full current-graph
law evidence, not a complete integrated gate: remaining fixtures, mutation
controls, regeneration and publication remain pending. The failed attempt
is not reported as passing.

The exact unchanged-limit standalone repeat of the two candidate proof fixtures
also timed out. A one-assertion-per-file partition was tried; both isolated
instances still exited 124, so partitioning was not treated as a fix. The two
original result assertions are now checked by direct kernel normalization of
the same concrete expressions, with unchanged coordinates, rather than by
expanding the generic theorem at concrete coefficients. Both original positive
source-denominator premises are retained as explicit kernel-checked assertions.
The temporary partition was recombined without dropping either result. The
fixture no longer imports the entire theorem dependency graph; the generic
seven-law candidate proof still runs as a mandatory manifest root, alongside
all other universal laws. This changes the proof strategy for finite examples,
not their propositions or the universal theorem coverage.

The revised `timeout 5 bend tracked-candidates-tests.bend --verdict` passed
with exit 0 and `ALL PROOFS CHECK`. All four concrete assertions are required
by the ordinary harness. These finite checked instances are not presented as
universal proofs. A full unchanged-deadline retry is in progress.

The next complete retry (with the unchanged propositions and revised concrete
fixture proof strategy) failed at existing `WIDTH_RANGE_PROOF.bend --verdict`
on the same five-second subprocess timeout, before completing the proof-root
loop. This is a failed attempt, not a full successful result. The previously
accepted 398-law current proof graph and the revised concrete fixture's accepted
local check are the verified evidence; regeneration/publication remain pending.


### Actual source-edge region preservation

Seven laws in `source-edge-region-laws.bend` pin physical endpoint admission
and the complete edge-list report, extract an edge's report from an actual
list occurrence, prove all four edges of a strict quad have both endpoints
inside that quad, expose the actual source endpoints' region predicates, and
preserve that region predicate for nonnegative source combinations. They use
the existing strict-corner theorem and shared homogeneous-combination theorem;
source-region membership is derived from source edge occurrence, not assumed
from a stored endpoint label. Positive denominator remains a separate condition:
the all-zero combination can satisfy the arithmetic halfplane predicates but
is not a valid geometric point and cannot pass search admission.

The exact `timeout 5 bend SOURCE_EDGE_REGION_PROOF.bend --verdict` passed
with exit 0 and `ALL PROOFS CHECK`. Four proof constructions and three raw
judgments passed real Bend under the same deadline: all actual quad edges,
the fourth source edge, a positive source mixture, a zero-first-weight endpoint,
exterior-edge rejection, clockwise-region rejection and all-zero-mixture
invalidity. Initial tuple duplication inference and the region-join argument
order were corrected before the accepted gate; failed invocations are not
counted as passing.

Four complete local mutation controls passed: omit first endpoint containment,
omit second endpoint containment, reject the empty list and skip a list head.
The original literal public-law instance passed before each mutation; the
mutant compiled and rejected that literal; the real Bend checker accepted
the corresponding Empty refutation. The integrated harness requires all seven
fixture assertions and all four controls, and includes them in the total.
Scope validation accepts 405 public laws across 57 roots. The Python checker
compiles, `git diff --check` passes, and the SVG is unchanged.

Self-review: strict orientation and actual directed source-edge occurrence
are explicit premises. The source mixture's region predicate is not equated
to validity at zero total weight. The next composition must extract validity,
inside-clip-region membership, candidate correspondence and boundary occurrence
from actual retained endpoints, then supply this derived source-region predicate
to the witness constructor. A further completeness step must handle source-end
labels as well as boundary labels and produce such a retained boundary point
from a common polygon point. Stages 2–4 remain open. Full integrated
verification, regeneration and proof publication remain pending.

The integrated attempt for the 405-law/57-root checkpoint accepted every
public law and all newly ordered fixture groups, including source-region
proofs, admission witnesses, membership, origins and candidate examples.
It continued through the original tracked intervals, interval walk/clipping,
segment-boundary/proportionality and source-provenance fixtures, then failed
at existing `clip-halfplane-boundary-tests.bend --verdict` on the unchanged
five-second timeout. This is stronger positive integration evidence, but not
a complete successful gate. No mutation result, regeneration or publication
is inferred from the partial run.

The subsequent unchanged integrated retry stopped at
`SCALED_COORDINATE_PROOF.bend` on the five-second timeout. An exact standalone
repeat (`timeout 5 bend SCALED_COORDINATE_PROOF.bend --verdict`) then returned
exit 0 and `ALL PROOFS CHECK`; this does not turn the failed integrated retry
into a pass. Independent current-artifact checks (`python3 verify.py b.svg`
and `python3 topology_verify.py b.svg`) both returned exit 0: 3 tubes,
96 convex cells, 24 seams, and finite nerve counts [96, 146, 64, 15],
one component and two holes. These remain finite artifact evidence, not the
missing universal topology bridge. No proof deadline or protected arithmetic
implementation was changed.

Two additional universal origin laws now recover actual directed quad-edge
occurrence from an equality identifying the left or right boundary-labelled
endpoint of `Trace.clip_quad`. The proof transports `quad_allowed` along that
exact state equality and extracts the appropriate constructive occurrence;
it does not accept an occurrence premise supplied by the caller. Both laws
passed `timeout 5 bend TRACKED_ORIGIN_PROOF.bend --verdict` (exit 0,
`ALL PROOFS CHECK`). The mandatory existing `tracked-origin-tests.bend` now
contains both actual retained endpoints of the two-cut fixture, including their
exact coefficients and directed boundary tags; its real five-second gate also
returned exit 0 and `ALL PROOFS CHECK`.

Self-review: these laws extract occurrence only, without asserting validity,
inside membership or a search witness. They work for arbitrary homogeneous
source points because origin tracking itself has no denominator premise.
The existing reversed-origin mutation control remains required by the harness,
but was not rerun for this addition; no new mutation result or complete suite
pass is claimed. Subsequent composition must still derive candidate correspondence,
positive denominator and both region predicates for the retained endpoint.
Stages 2–4 and publication of this proof checkpoint remain incomplete.

Two universal candidate laws now extract both original-source crossing and
projective equivalence to the direct boundary cut from an equality identifying
the actual left or right retained boundary endpoint. They require positive
original source denominators, transport `quad_candidates` along the exact
clip-state equality, split the endpoint report, and split the boundary label's
physical interpretation. No crossing or equivalence premise is supplied by
the caller. `timeout 5 bend TRACKED_CANDIDATES_PROOF.bend --verdict` returned
exit 0 and `ALL PROOFS CHECK`. The two actual endpoints, with exact coefficients
(2,6) and (36,12), invoke the generic laws in the new mandatory
`tracked-candidates-retained-tests.bend`; its identical five-second real gate
also returned exit 0 and `ALL PROOFS CHECK`. Existing fixture groups remain
required; no deadline was changed.

Self-review: extracted projective equivalence is distinct from raw-coordinate
equality, as required for differently scaled homogeneous points. The source
denominator guards are explicit. This does not yet establish a retained point's
positive denominator or containment in both quads; those must still be derived
before composing the actual search witness. Existing candidate mutation controls
remain required but have not been rerun on this addition; publication and the
full integrated gate remain pending. Stages 2–4 remain open.

The universal `retained_closed_valid` law derives positive denominators and
clip-region containment for both actual retained endpoints from positive
source denominators and the exact clip-state equality. Its proof transports
the existing real interval-walk `quad_closed_valid` result through `quad_erases`,
then through the retained-state equality, and splits both conjunctions. An
initial rewrite had the wrong orientation and failed; the corrected symmetric
rewrite passed `timeout 5 bend TRACKED_INTERVAL_PROOF.bend --verdict` with
exit 0 and `ALL PROOFS CHECK`. The new mandatory
`tracked-interval-retained-tests.bend` invokes this law on both exact retained
endpoints and passed its real five-second gate with exit 0 and
`ALL PROOFS CHECK`. `git diff --check` passed.

Self-review: no strict-quad premise is needed for validity and containment
in the clipping halfplanes; strictness remains necessary for the separately
derived source-region theorem used by witness composition. This law asserts
no retained endpoints when clipping returns Lost: the Segment equality is an
explicit premise. No new mutation result or full integrated pass is claimed.
The source-region membership and actual search-witness composition remain next;
stages 2–4 and publication of this checkpoint remain open.

The new `retained-witness` owner composes both actual boundary endpoints
into `E.Witness(Search.candidates(q,r),q,r)`. Its two universal laws require
only directed source-edge occurrence in `r`, strict orientation of `r`, and
an exact equality identifying the retained boundary endpoint of that source
edge clipped into `q`. They derive boundary-edge occurrence, original-source
crossing, projective direct-cut correspondence, positive endpoint denominator,
clip-region containment and source-region containment through the respective
shared owners. No caller-supplied geometric/admission premises remain.
A structural occurrence-copy helper supplies two constructive uses of the
linear source-edge occurrence. The initial attempt to duplicate the Type
premise directly was rejected and replaced with this structural proof; an
initial tuple-pattern syntax error was corrected before accepted verification.
`timeout 5 bend RETAINED_WITNESS_PROOF.bend --verdict` and the mandatory
`retained-witness-tests.bend` each returned exit 0 and `ALL PROOFS CHECK`.
The tests invoke both generic laws on the exact two-cut endpoint coefficients.
The new root is included in the proof manifest and the fixture in `check.py`;
`git diff --check` passed.

Self-review: the conclusion concerns the actual search selection witness; it
does not assert that the search selects the particular retained endpoint.
Search may select an earlier admitted candidate. Completeness from arbitrary
common points and source-end labels is still missing, as is the topology
bridge; stages 2–4 remain open. Mutation controls have not been rerun on this
composition, and full integrated verification/publication remain pending.

The integrated 412-law/58-root attempt accepted every public law and every
geometric proof fixture through homogeneous combinations, including all new
retained-endpoint/witness groups. It then failed the unchanged five-second
`clang -O1` deadline for the native `search-witness-tests` executable. No full
gate is claimed. A standalone rebuild of the exact same Bend fixture emitted
C, compiled with `clang -O0`, and ran its original `search-witness-tests: True`
assertion successfully; all three commands returned exit 0 within their
individual five-second deadlines. The harness now uses -O0 for this test-only
executable. The production generator retains -O1. No Bend proof gate, time
limit, fixture input or assertion changed. Self-review: compiler optimization
is unnecessary for correctness of the native assertions; this change addresses
build work under the existing deadline, not proof acceptance.

The subsequent integrated retry with the test-only -O0 build change stopped
at `TRIANGLE_AREA_PROOF.bend` on the unchanged five-second deadline, before
any whole-root success report. No full pass is claimed. The four source-edge
region mutation controls were then rerun independently on an isolated copy
of the current Bend sources. `source_edge_region_controls` returned 4 and
the driver exited 0: each original law instance accepted, each compiling
mutant rejected that instance, and each literal Empty refutation accepted.
The integrated harness still requires these controls. This is current local
mutation evidence, not a substitute for its full remaining checks.

The current isolated source snapshot also passed all custom search controls:
`search_admission_controls` returned 3, `search_membership_controls` returned
5 and `tracked_origin_controls` returned 1; the sequential driver exited 0.
Together with the four source-region controls, this rerun supplies 13 current
mutation controls with unchanged per-command deadlines. Their original literal
instances, mutant compile/rejection gates and constructive Empty refutations
remain enforced by the existing control implementations. It does not claim
all dynamically assembled legacy controls, regeneration or publication.

The universal `search-membership.source_edge_vertices` law now extracts
actual search-vertex occurrences for both endpoints of any actual directed
quad edge. The proof enumerates all four edge positions, transports exact
edge equality through the endpoint projections, and constructs the two
vertex occurrences; an impossible tail is eliminated constructively.
`timeout 5 bend SEARCH_MEMBERSHIP_PROOF.bend --verdict` returned exit 0 and
`ALL PROOFS CHECK`. The existing mandatory `search-membership-tests.bend`
now invokes the law at all four positions, including the wrap-around edge,
and its real five-second gate likewise returned exit 0 and
`ALL PROOFS CHECK`.

Self-review: this law concerns exact list membership only; no strict geometry
or region claim is implied. Duplicate coordinates and degenerate quads do
not invalidate it, because occurrence is constructive and not uniqueness.
It supplies the missing actual-vertex enumeration fact for retained source
labels. No additional mutation result or complete suite pass is claimed.
Stages 2–4 and publication remain incomplete.

The retained-witness owner now covers every left-endpoint origin.
`retained_endpoint_witness` splits SourceLeft, SourceRight and Boundary;
source labels derive actual vertex membership from `source_edge_vertices`,
transport the retained point's admission to that valid embedded vertex, and
construct the actual full candidate-search witness. Boundary labels reuse the
proved directed-cut constructor. `clipped_source_witness` needs no supplied
endpoint or origin: nonempty actual `Walk.clip_quad` of a directed source edge
in a strict source quad implies an actual full-search witness, via trace erasure
and constructive case elimination. `source_member_witness` further derives
this nonempty result from a constructive common point on the actual source
edge and clip-region containment. These are three additional universal laws.

The current `timeout 5 bend RETAINED_WITNESS_PROOF.bend --verdict` returned
exit 0 and `ALL PROOFS CHECK`. Mandatory `retained-witness-tests.bend` covers
both explicit boundary endpoints, nonempty two-cut clipping, retained
SourceLeft, retained SourceRight, and a common source-edge midpoint; its real
five-second gate also returned exit 0 and `ALL PROOFS CHECK`. Scope audit
reports 416 public laws across 58 roots.

Self-review: strictness is required only for the source quad in these laws.
The common-point law requires actual source-edge membership, not merely an
interior common point. Nonempty clipping is no longer a conclusion inferred
from examples or a caller-supplied candidate correspondence. General polygon
intersection completeness still requires deriving a common boundary/source-edge
point from arbitrary common hull membership. The independent complex enumeration
and real-fill topology bridge remain open. No new mutation/full-suite success,
regeneration or publication is claimed for this addition.

The integrated 416-law/58-root attempt stopped at
`SEARCH_ADMISSION_PROOF.bend` on the unchanged five-second timeout. An exact
standalone `timeout 5 bend SEARCH_ADMISSION_PROOF.bend --verdict` also exited
124, without an accepted verdict. Earlier local/integrated acceptance is not
claimed as a current full gate. Read-only `bend --help` exposed no worker or
thread tuning option; the installed compiler was not modified. This repeated
local timing failure warrants investigating this proof owner's dependency
closure before further unchanged full-suite retries. No proof deadline was
raised, proof omitted, regeneration run or change published.

Dependency refactoring isolates pure scan soundness in `scan-sound-proof.bend`.
The existing public `intersection-search.scan_hit_sound` law forwards to this
same proof; `candidate-existence` consumes the pure owner directly instead of
the complete geometry-search proof. Measured transitive candidate-existence
source closure decreased from 131 files to 21, removing 110 dependencies;
no public law, search implementation or assertion changed. Its real root
gate passed. Initial local admission/search/retained gates still timed out
and are not counted as passing.

A second pure owner, `strict-complement-proof.bend`, contains the original
Boolean double-negation/closed-halfplane complement derivation and its rejected
edge-to-strict-negative implication. The public strict law and old helper API
forward to it; admission consumes this small owner instead of the full native
strict-separation proof. The subsequent real five-second gates for
SEARCH_ADMISSION_PROOF, STRICT_HALFPLANE_PROOF, RETAINED_WITNESS_PROOF,
INTERSECTION_SEARCH_PROOF and search-admission-tests all returned exit 0 and
`ALL PROOFS CHECK`. `git diff --check` passed.

Self-review: original universal soundness proofs were moved, not replaced by
literal instances or unchecked postulates. Public API wrappers and all proof
manifest roots remain required. Pure candidate-list existence no longer needs
quad hull or native SAT proofs; complement reflection no longer pulls in the
native arithmetic bridge for one Boolean implication. The shared owners remain
imported by their original public proof roots, so their statements are checked
by the full graph. A new complete integrated gate and publication are pending.

The integrated attempt after scan/complement dependency refactoring stopped
at `INTERVAL_CLIP_PROOF.bend` on the unchanged five-second deadline. The
manifest audit still reports 416 public laws across 58 roots, the SVG diff
is empty, and no full gate/publication is claimed. An isolated current-source
rerun of `search_admission_controls` returned 3 with driver exit 0, confirming
that original literal instances, compiling mutant rejection and Empty
refutations still pass after removing the full geometry-search dependency
from candidate existence. Read-only inspection shows interval clipping still
consumes the full strict-halfplane owner for weighted negativity and the
strict/closed contradiction, beyond the newly isolated complement helper.
That remaining pure/native dependency boundary is the next factoring target.

Pure strict geometry is now owned by `strict-geometry-proof.bend`: the
original weighted-negativity, hull-separation and strict/closed contradiction
derivations are explicitly typed shared proofs. The original strict public
laws forward to them, while native arithmetic/decoding stays in the full
strict proof owner. Interval clipping and original-source crossing consume
this pure owner directly instead of loading native SAT proofs. No public
law or geometric implementation changed. Initial standalone pure/interval
gates timed out and are not passes; subsequent real five-second gates for
STRICT_HALFPLANE_PROOF, SOURCE_CROSSING_PROOF, INTERVAL_CLIP_PROOF and
RETAINED_WITNESS_PROOF returned exit 0 and `ALL PROOFS CHECK`. The actual
interval-clip-member, source-crossing and retained-witness fixture gates also
returned exit 0 and `ALL PROOFS CHECK`. Scope remains 416 laws/58 roots.

Self-review: the shared file imports no native strict law module; its proof
statements preserve the original guards and conclusions. The original
public laws remain in the full graph and still check the native bridge.
Full integrated verification, regeneration and publication remain pending.

## Published handoff checkpoint

At the user's explicit request to publish the current work, leave follow-up,
push everything and finish this conversation, further implementation is
deferred to https://github.com/dearlordylord/b/issues/1. This is a partial
formalization checkpoint, not completion of all four original stages.

The latest integrated run accepted all **416 public laws across 58 roots**
with real Bend `--verdict` under the unchanged five-second per-command
deadline. It then timed out at `tracked-candidates-retained-tests.bend`; the
whole `check.py` gate did **not** pass. Individual earlier fixture and mutation
results above retain their exact scopes. Regeneration was not rerun for this
checkpoint. Current `python3 proof_scope.py`, `python3 verify.py b.svg` and
`python3 topology_verify.py b.svg` returned exit 0; the SVG is unchanged from
HEAD. Artifact results: 3 tubes, 24 seams, 96 convex cells, finite nerve counts
[96, 146, 64, 15], one component, two holes and Euler characteristic -1.
Those artifact checks do not prove the missing continuous-topology bridge.

Self-review: shared scan/complement/strict-geometry proof owners preserve
public statements and guards, and public wrappers retain their consumers.
Retained endpoint laws derive occurrence, crossing, projective correspondence,
validity and both-region membership rather than accepting those conclusions
as caller assumptions. All origins now construct an actual search witness;
a common point on an actual source edge also does so. General common-point
completeness, production triple completeness, independent complex enumeration
and the actual real/PL fill topology bridge remain open in the follow-up.
No full-suite pass, complete regeneration or completion of stages 2–4 is
claimed. Publication of this explicitly partial state is user-authorized.
