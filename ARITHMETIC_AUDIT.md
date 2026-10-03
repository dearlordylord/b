# Production arithmetic coverage audit

This is an implementer audit of the current source and public laws, not an
additional proof root. Kernel evidence lives in the registered proof roots.
Stage 1 is complete for the current production bounded arithmetic under
the trusted Base/compiler boundary. The complete four-stage objective
remains open.

## Entry points and ownership

`generate.main` calls `artwork-validation.artwork_valid` before SVG emission.
That gate consumes `validation` and `topology`. `core` owns the emitted
points, centroid and SVG serialization. `validation` uses unscaled source
coordinates; `topology` uses a separate guarded quarter-scale cover.
The arithmetic proof layers model these existing owners and do not change
production behavior.

| Production path | Current kernel contract | Remaining obligation |
| --- | --- | --- |
| `core.cell_center` | Centroid model, bounded centroid and validated centroid-mean laws | Connect any downstream composite check still lacking a natural model |
| `validation.determinant_positive` | `accepted_points_determinant` in `coordinate-runtime-laws.bend` | `source-convexity-laws.bend` now composes `positive_quad`, `convex_quad`, `cell_convex`; `validator-natural-laws.bend` now propagates actual guards through the validator traversal; geometric characterization remains stage 2 |
| `validation.width_squared` | `accepted_points_width` in `coordinate-width-laws.bend` | `width-range-laws.bend` now composes `width_in_range`/`section_width` with natural bounds; `validator-natural-laws.bend` now connects accepted section traversal |
| `validation.dot`, `cell_transverse` | Accepted point dot law and `source_corners_transverse_exact` | `validator-natural-laws.bend` now composes into the full cell validator and source traversal |
| `topology.scaled` | Grid round-trip, scaled coordinate exactness and envelopes | Geometric scale correspondence belongs to stage 2 |
| `topology.cells`, append, selected cells and neighbors | `source-cells-laws.bend` envelope preservation | Natural filter equality and envelope propagation now compose; `source-inspection-laws.bend` now connects the guarded source entry; `natural-cover-laws.bend` now proves decoded source scaling/orientation and complete list construction |
| `topology.sample`, vertex witnesses and search weights | Sample arithmetic, denominator, bounds and search-hit laws | Full bounded search Boolean agreement now appears in `search-arithmetic-laws.bend`; geometric interpretation of found witnesses belongs to stage 2 |
| `topology.side`, `inside`, `common` | Side bridge and natural inside/common agreements | Half-plane/convex-polygon membership interpretation belongs to stage 2 |
| `topology.separated`, `outside`, `meets`, `strictly_convex`, `orientation` | Five composition laws in `sat-arithmetic-laws.bend` | Geometric separation and convexity theorems belong to stage 2 |
| `topology.point_equal`, `reverse_edge`, `shared_edge` | Three universal agreements in `edge-arithmetic-laws.bend` | Shared-edge geometric meaning and ribbon connectivity remain open |
| `topology.disjoint_all`, nonadjacent disjointness, overlaps and ribbons | Seven `cover-arithmetic-laws.bend` fold agreements | Connected/ribbon report fields now compose through inspection assembly; geometric sufficiency and connectivity remain stage 2 |
| `topology.sum_counts`, list length and Euler equation | Nat operations, report condition laws and full bounded `count-arithmetic-laws.bend` traversal/report agreement | Enumeration of the intended complex is stage 3, not established by arithmetic exactness |

## Boundaries of the evidence

The low-level Word/U32 laws prove conversions, arithmetic and comparisons;
they do not prove that a production caller supplies their premises. Source
and filter envelope laws supply part of that missing bridge. A full audit
must connect the actual accepted input, recursive traversal and each called
arithmetic predicate. The unscaled validator now has full arithmetic agreement via
`validator_arithmetic_exact`; the bounded topology cell inspection now has full arithmetic agreement,
and `source-inspection-laws.bend` connects the guarded source entry.
That reference reuses `T.cells`; `natural-cover-laws.bend` now independently
identifies the decoded source scaling, orientation and full cell sequence
with a Nat cover construction. The caller inventory below records the final stage-1 coverage audit.
Its validation is recorded with the natural-cover milestone in README.md.

The search is intentionally conservative. A successful search now carries a
bounded witness with positive denominator and exact natural half-plane
comparisons. This does not yet establish polygon membership. A missed
intersection may reject an input; universal search completeness must not be
claimed for the fixed 64-step sampling scheme.

The computed report's flags and Euler equation are not themselves proofs of
nerve enumeration, the convex nerve theorem or planar topology. The
independent Fraction-based checks of the concrete SVG remain finite artifact
evidence. Stages 2–4 require the corresponding universal geometric,
enumeration and topological bridge proofs.

## Final caller inventory (implementer self-review)

The production entry is `generate.main` → `artwork_valid`. A source search
for every `U32` operation in `core.bend`, `validation.bend` and
`topology.bend` identifies the following complete set of word-dependent
arithmetic paths. `core` has no word operations.

| Word-dependent production call | Mathematical agreement | Actual caller-premise bridge |
| --- | --- | --- |
| `validation.determinant_positive` conversions, products, three-term sums and greater comparison | `accepted_points_determinant`, source convexity composition | `validator_arithmetic_exact` extracts bounds from `sections_bounded` through every adjacent cell |
| `validation.absolute_difference` / `width_squared` min/max, subtraction, products and sum | Absolute-difference and accepted squared-width laws | Width-range and full validator composition propagate both endpoint guards |
| `validation.width_in_range` two inclusive comparisons | `width_in_range_arithmetic_exact` with thresholds pinned to the production words | Full validator composition supplies each actual squared width |
| `validation.dot` and `transverse_points` conversions, products, sums and comparisons | Accepted dot/dot-pair and source-corner transverse laws | Source-corner proof derives the centroid bound; full validator composition supplies all four source guards |
| `topology.scaled` conversion and division by four | `scaled_coordinate_exact`, `scaled_point_decoded`, grid restoration | Source guards provide coordinate bounds and divisibility; natural cover construction connects every raw corner |
| `topology.side` three homogeneous product terms, sums and comparison | Accepted/generated side bridge, inside/common and strict-side composition | Generated-cell envelopes, sample/vertex envelopes and recursive list/filter preservation supply all operands |
| `topology.point_equal` word equality | Universal point/edge equality agreement | No coordinate restriction is needed; adjacency and ribbon folds consume the agreement |
| `topology.sample` complement subtraction and weighted numerator arithmetic | Accepted sample laws and Nat-weight search composition | Each segment step derives weight ≤64 from fuel ≤63; point bounds come from the actual candidate list |
| `topology.segment_search` conversion of the successor weight | Bounded conversion inside `sample_common_arithmetic_exact` | Fuel decrement and successor bounds are proved in the full search fold |
| `topology.orientation` strict side test selecting reversal | `raw_orientation_exact` and `cells_decoded` | Raw-cell envelopes follow from previous/current section guards at the actual first-cell choice |

There are no additional machine-word arithmetic operations in the inspected
production owners. Nat-only coordinate guards, centroid/endpoints, count
addition, list length, section count, report validity and serialization are
retained in their existing owners. The full validator, bounded cover/search/
count folds, guarded source report/decision and independently decoded cover
construction connect the word agreements to those entry paths.

This inventory closes the caller-coverage obligation for bounded arithmetic
in the current production code. The recorded 175-law / 128-mutation kernel
and artifact gates passed; see the natural-cover milestone in README.md. It does not establish a compiler/backend correctness theorem, polygon
membership, separating-axis geometry, independent clique enumeration, the
nerve theorem or planar topology. New production word operations require
extending this inventory and their kernel contracts. Stages 2–4 remain open.
