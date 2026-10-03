import Base
import ./search-admission-fixtures.bend as F
import ./intersection-search.bend as Search
import ./homogeneous-geometry.bend as G

def actual_selected_corner() -> {Search.find(F.q(),F.r()) == Search.Hit{G.P{3n,1n,1n}} : Search.SearchResult}: {==}
def invalid_present_point_rejected() -> {Search.scan([G.P{0n,0n,0n}],F.q(),F.r()) == Search.Miss{} : Search.SearchResult}: {==}
def outside_present_point_rejected() -> {Search.scan([G.P{9n,9n,1n}],F.q(),F.r()) == Search.Miss{} : Search.SearchResult}: {==}
def admitted_tail_selected() -> {Search.scan([G.P{0n,0n,0n},F.point()],F.q(),F.r()) == Search.Hit{F.point()} : Search.SearchResult}: {==}

def clockwise_region_rejected() -> {Search.admit(F.point(),F.q(),F.reversed_r()) == False{} : Bool}: {==}
