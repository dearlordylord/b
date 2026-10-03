import Base
import ./model.bend as M
import ./render.bend as R

def emit(valid: Bool, glyph: M.Glyph) -> IO(Unit):
  match valid:
    case False{}: IO.die(Unit, 1, "Alphabet validation failed; no SVG emitted.")
    case True{}: IO.print(R.standalone(glyph))

def generate(+glyph: M.Glyph) -> IO(Unit):
  emit(M.glyph_valid(glyph), glyph)
