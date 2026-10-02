import Base
import ./artwork.bend as Artwork
import ./validation.bend as Validation
import ./topology.bend as Topology

# Concrete artwork is deliberately outside the generic proof dependency graph.
def artwork_valid() -> Bool:
  Validation.expected_artwork(Artwork.upper()) &&
    Validation.expected_artwork(Artwork.lower()) &&
    Validation.expected_artwork(Artwork.stem()) &&
    Topology.valid(Artwork.upper(), Artwork.lower(), Artwork.stem())
