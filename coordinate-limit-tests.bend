import Base
import ./coordinate-limit.bend as Limit

def source_limit() -> {Limit.maximum() == 16000n : Nat}:
  {==}
