# Soft industrial alphabet — visual prototype

Question: can the existing segmented steel B become a readable mixed-case
family with soft turns, broad ribbons and restrained mechanical detail?

The study contains 19 glyphs: `B D E H N O R S` and `a b d e g i l m n r u`.
The original B is reused from `../b.svg`. New shapes are sampled ribbon
outlines with two-tone shading and seams spaced by centerline length.
Lowercase forms have fewer seams; `g` is single-storey and `a` is two-storey.

Run `uv run --with shapely python alphabet-prototype/generate.py` from the
repository root. Shapely joins the ribbon polygons for `a/e`, preserving one
outer contour and omitting seams that touch their junctions.
Open `index.html` directly, or inspect `specimen.svg` and `specimen.png`.
The page includes `BENDER`, `Bender`, `minimum`, size adjustment, seam toggle
and light/dark backgrounds. Each glyph also has a standalone SVG in `glyphs/`.
The revised `a/e` also appear in `made a name` and `revision-02/comparison.svg`.

Optional PNG regeneration (CairoSVG installed outside the project by uv):

```sh
uv run --with cairosvg python -c "import cairosvg; cairosvg.svg2png(url='alphabet-prototype/specimen.svg', write_to='alphabet-prototype/specimen.png')"
```

Initial assessment: the construction supports both cases and has the intended
robotic character. The next design review should focus on the crossbar of `e`,
joins of `R/N`, lowercase proportions and spacing in words. This is a visual
study, not a complete font or a validated design decision. There is no font
export, full alphabet, kerning system or Bend proof for the new geometry.
The existing production generator and proof gates are unchanged.

Revision 02 follows user feedback and a design review by Astra. The original
`a` read as a bowl with an appended stick, so it is now two-storey, with a
continuous upper arch/right stem and a joined lower bowl. The original `e`
crossbar appeared behind the arch; the two ribbons now share one contour,
the bar is painted last and the arch is higher for a larger eye. Neither
letter has separate end-cap outlines or seams through its junction. Original
glyphs are preserved in `revision-02/before-a.svg` and `before-e.svg`.

Preserved on `design/soft-industrial-alphabet`, outside `main`.
