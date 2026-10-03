# Soft industrial alphabet in Bend

The approved 19-glyph pilot (`B D E H N O R S / a b d e g i l m n r u`)
is now explicit Bend geometry, generated and validated by native Bend.
This is the pilot, not yet a complete 52-glyph font.

[Generated specimen](output/specimen.svg) · [PNG](output/specimen.png) ·
[Validation evidence](output/validation.json) · [Model](model.bend) ·
[Artwork](artwork.bend)

## Run

From the repository root:

```sh
python3 alphabet/regenerate.py
```

Requirements are the existing Bend **2.0.34**, Clang, and Python 3. Each proof,
C emission, native compilation, and generator invocation has an individual
five-second limit. Entries are compiled one glyph at a time, so the growing
catalog does not require a longer compiler gate. Clang uses `-O0`: optimizing
large literal geometry once exceeded that same limit at `-O1`; native
validation/rendering does not need LLVM optimization. No Shapely, CairoSVG or
prototype generator is used in this command.

The command checks the shared proof roots and `alphabet/PROOF.bend`, rejects
three well-typed seam mutations through the public laws, executes 19 native
boundary/rejection cases, and confirms that the real generator emits nothing
for invalid artwork. It then generates every glyph, independently checks its
actual SVG and exact intersection topology, and rejects six broken SVGs per
glyph before publishing the staged SVGs and `validation.json`.

The host assembles the already checked native SVGs into `specimen.svg`; it
does not create the glyph geometry. The standalone files are in `output/glyphs/`.

Optional PNG rendering:

```sh
uv run --with cairosvg python -c "import cairosvg; cairosvg.svg2png(url='alphabet/output/specimen.svg', write_to='alphabet/output/specimen.png')"
```

## Model and concrete checks

Each arm contains paired boundary sections, an explicit seam-selection list,
and a component/attachment certificate. Every native generator checks:

- At least two sections, coordinate bounds **0–16000**, and the four-unit grid.
- Every cell's strict convexity and consistent arm orientation, exact centroid, exact seam attachment,
  strictly forward seam derivative, and **18–26 px** section width.
- Exactly one seam-selection flag per cell; selected endpoints are outside
  the interiors of other cells, avoiding hidden junction seams.
- Every attached arm has an earlier parent in its component and an exact
  common-point witness in both covers. Component roots are distinct, and
  different components' covers do not intersect. The `i` dot is component two.
- The paint order is a permutation of the actual arms; layout width/offset
  also satisfy their explicit bounds.

Coordinates are natural numbers in hundredths of a pixel, with no float
conversion in Bend. `g` uses a local origin and an exact **3000-unit** SVG
translation, keeping its source arithmetic under the existing 16000 guard
while retaining the approved descender. The independent checker validates
this translation and the final 19000-unit glyph viewport.

## Rendering the joined a/e

Every cell is emitted as a consistently oriented convex SVG subpath. SVG's
nonzero fill therefore paints the union, including ribbon overlaps and holes.
For `a/e`, Bend paints the dark stroked cover first and the complete steel
cover over it, erasing internal cell edges. Quarter-interpolated shadow cells
and the checked quadratic seams follow. This preserves `e`'s continuous turn
and `a`'s joined bowl without imported polygon-union contours or clip masks.

Other glyphs preserve the approved arm layering, shadows and centered outlines.
Closed rings have separate outer/inner contours, avoiding a false cap across
the counter. Source records and every visible fill, shade, outline and seam
are independently cross-checked from the emitted SVG.

## Proof scope

`LAWS.bend` and `PROOF.bend` reuse the existing approved universal seam laws:
left/right attachment, exact SVG endpoint serialization, the quadratic's
nonnegative cell-corner representation under the exact-centroid premise, and
normalization of its weights. The native model checks those premises for all
**2434 cells**; **151 selected seams** are emitted. The existing bounded
arithmetic proof roots remain part of the generation gate.

These universal laws and the finite native checks are different evidence.
The new catalog validator, paint-order traversal, source-cover renderer and
component certificates do **not** have new universal Bend proofs. No new
axioms or weakened shared laws were introduced.

Expected holes are independently checked from the actual integer convex-cell
cover using exact `Fraction` intersections and the complete intersection nerve
at every required order. `B` has two holes; `D/O/R/a/b/d/e/g` have one; other
pilot glyphs have none. This is an independent executed topology calculation;
its continuous interpretation uses the convex nerve theorem and planar Euler
relation. Those geometric/topological bridges remain unproved in Bend, as in
the original repository. Hole metadata alone is never treated as evidence.

## Design import

`artwork.bend` is the committed source of truth. `design.json` records its
imported coordinates for review; regeneration does not read either the Python
prototype or this JSON. `export_design.py` is a one-time authoring adapter:

```sh
python3 alphabet/export_design.py
```

It imports the approved ribbon paths from `design_source.py`.
Sections snap to **0.04 px**; the 18px strokes receive a 0.08px rounding margin
so the native minimum-width check remains strict. Redundant tight-turn samples
are removed when grid rounding would collapse a cell. The outside of `a`'s
foot is retained; its folded inner edge is replaced by a monotone connector
so all source cells are strictly convex. Native and independent checks validate
the resulting integer model rather than trusting this adapter.

The original production `b.svg`, generator and shared laws are unchanged.
