# Production arithmetic coverage audit

This is an implementer audit of the current source and public laws, not an
additional proof root. Kernel evidence lives in the registered proof roots.
The complete four-stage objective remains open.

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
| `topology.cells`, append, selected cells and neighbors | `source-cells-laws.bend` envelope preservation | Natural filter equality and envelope propagation now compose; connect the guarded source entry and remaining count traversal |
| `topology.sample`, vertex witnesses and search weights | Sample arithmetic, denominator, bounds and search-hit laws | Full bounded search Boolean agreement now appears in `search-arithmetic-laws.bend`; geometric interpretation of found witnesses belongs to stage 2 |
| `topology.side`, `inside`, `common` | Side bridge and natural inside/common agreements | Half-plane/convex-polygon membership interpretation belongs to stage 2 |
| `topology.separated`, `outside`, `meets`, `strictly_convex`, `orientation` | Five composition laws in `sat-arithmetic-laws.bend` | Geometric separation and convexity theorems belong to stage 2 |
| `topology.point_equal`, `reverse_edge`, `shared_edge` | Three universal agreements in `edge-arithmetic-laws.bend` | Shared-edge geometric meaning and ribbon connectivity remain open |
| `topology.disjoint_all`, nonadjacent disjointness, overlaps and ribbons | Seven `cover-arithmetic-laws.bend` fold agreements | Connected/ribbon report fields now compose through inspection assembly; geometric sufficiency and connectivity remain stage 2 |
| `topology.sum_counts`, list length and Euler equation | Nat operations, report condition laws | Enumeration of the intended complex is stage 3, not established by arithmetic exactness |

## Boundaries of the evidence

The low-level Word/U32 laws prove conversions, arithmetic and comparisons;
they do not prove that a production caller supplies their premises. Source
and filter envelope laws supply part of that missing bridge. A full audit
must connect the actual accepted input, recursive traversal and each called
arithmetic predicate. The unscaled validator now has full arithmetic agreement via
`validator_arithmetic_exact`; the topology traversal still needs its
composed bridge. Stage 1 is therefore still incomplete.

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
