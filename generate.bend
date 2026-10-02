import Base
import ./core.bend as Core
import ./artwork.bend as Artwork
import ./artwork-validation.bend as Validation

def svg() -> String:
  "<svg xmlns=\"http://www.w3.org/2000/svg\" width=\"160\" height=\"160\" viewBox=\"0 0 16000 16000\">\n" ++ Core.tube_svg("upper", Artwork.upper()) ++ Core.tube_svg("lower", Artwork.lower()) ++ Core.tube_svg("stem", Artwork.stem()) ++ "</svg>"

def emit(valid: Bool) -> IO(Unit):
  match valid:
    case False{}:
      IO.die(Unit, 1, "Artwork geometry validation failed; no SVG emitted.")
    case True{}:
      IO.print(svg())

def main() -> IO(Unit):
  emit(Validation.artwork_valid())
