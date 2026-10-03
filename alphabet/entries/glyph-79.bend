import Base
import ../artwork.bend as A
import ../generate.bend as G

def main() -> IO(Unit):
  G.generate(A.glyph_79())
