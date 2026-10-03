import Base
import ./model.bend as M
import ./generate.bend as G

# The real IO generator must fail without emitting even a partial SVG.
def main() -> IO(Unit):
  G.generate(M.Glyph{97n, 10000n, 0n, 0n, 0n, [], []})
