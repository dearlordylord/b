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

Requirements: Bend **2.0.34**, Clang 14+ for native compilation, Python 3, and GNU
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
On Linux, C emission and Clang `-O1` compilation are separate five-second
commands; this avoids an expensive combined optimization step on shared
machines. Other platforms retain Bend's native build command. Proof checks
use the same five-second BendTT gate on every platform.

`check.py` runs the 153-law proof gate, 200 literal arithmetic checks,
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
current BendTT gate checks **104 unique public laws**, plus supporting lemmas.
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
the real BendTT gate. The remaining gates passed in a separate driver omitting
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
was checked by the real BendTT kernel in the mutated source tree.
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
repeated numeral expansions out of BendTT proof signatures. The independent mean and center model
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

**Stage 1 remains incomplete:** audit all production callers and connect
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
accepted-input traversal bridges. Stage 1 remains incomplete.

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
