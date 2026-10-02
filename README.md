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

`check.py` runs the proof gate, 200 literal arithmetic checks, five compiling
mutations that must fail their corresponding laws, two invalid artworks that
must be rejected before SVG emission, and independent SVG checks with broken
endpoint/control-point negative controls. Python orchestrates these commands
and checks the output artifact; it does not verify the Bend language.

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
over the seams. Exact two-hole topology of the composed letter, global curvature
smoothness and perceptual readability are not formal claims.

## Files

| File | Purpose |
| --- | --- |
| `artwork.bend` | Exact cross-section coordinates |
| `core.bend` | Shared geometry and SVG serialization |
| `geometry.bend` | Homogeneous quadratic and corner-weight numerators |
| `facts.bend` | Arithmetic and convex-weight supporting proofs |
| `LAWS.bend`, `PROOF.bend` | Statements and their Bend proofs |
| `validation.bend` | Finite artwork checks in Bend |
| `generate.bend` | Gated SVG generator and IO entry point |
| `b.svg`, `preview.png` | Generated artwork and preview |
| `regenerate.sh`, `check.py`, `verify.py` | Regeneration, checks and negative controls |

## License

Apache-2.0. `facts.bend` includes an attributed subset of bend-mathlib arithmetic
proofs; its original license is retained in `LICENSE.mathlib`. See [NOTICE](NOTICE).
