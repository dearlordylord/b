# Soft industrial alphabet — visual prototype

Question: can the existing segmented steel B become a readable mixed-case
family with soft turns, broad ribbons and restrained mechanical detail?

The study contains 19 glyphs: `B D E H N O R S` and `a b d e g i l m n r u`.
The original B is reused from `../b.svg`. New shapes are sampled ribbon
outlines with two-tone shading and seams spaced by centerline length.
Lowercase forms have fewer seams; `a` and `g` are single-storey.

Run `python3 alphabet-prototype/generate.py` from the repository root.
Open `index.html` directly, or inspect `specimen.svg` and `specimen.png`.
The page includes `BENDER`, `Bender`, `minimum`, size adjustment, seam toggle
and light/dark backgrounds. Each glyph also has a standalone SVG in `glyphs/`.

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

Preserved on `design/soft-industrial-alphabet`, outside `main`.
