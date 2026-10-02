"""Independent exact topology of the SVG fill's convex-cell cover.

Intersections use Fraction polygon clipping, including closed edge/point
contacts. The nerve is enumerated from actual intersections, not merely from
cliques in a pairwise graph. The geometric interpretation uses the finite
convex nerve theorem and the planar Euler relation, as documented in README.
"""
from fractions import Fraction
from itertools import combinations
import re
import xml.etree.ElementTree as ET

from verify import convex, cross, points, require, verify


def clean(poly):
    result = []
    for p in poly:
        if not result or p != result[-1]:
            result.append(p)
    if len(result) > 1 and result[0] == result[-1]:
        result.pop()
    return result


def clip(subject, quad):
    """Intersect a possibly degenerate convex polygon with a closed quad."""
    orientation = 1 if cross(quad[0], quad[1], quad[2]) > 0 else -1
    output = [(Fraction(x), Fraction(y)) for x, y in subject]
    for a, b in zip(quad, quad[1:] + quad[:1]):
        source, output = output, []
        if not source:
            break
        previous = source[-1]
        previous_side = orientation * cross(a, b, previous)
        for current in source:
            current_side = orientation * cross(a, b, current)
            if (previous_side >= 0) != (current_side >= 0):
                t = previous_side / (previous_side - current_side)
                output.append((previous[0] + t * (current[0] - previous[0]),
                               previous[1] + t * (current[1] - previous[1])))
            if current_side >= 0:
                output.append(current)
            previous, previous_side = current, current_side
        output = clean(output)
    return output


def separated(a, b):
    orientation = 1 if cross(a[0], a[1], a[2]) > 0 else -1
    return any(all(orientation * cross(p, q, r) < 0 for r in b)
               for p, q in zip(a, a[1:] + a[:1]))


def meets(a, b):
    return not separated(a, b) and not separated(b, a)


def nerve(cells):
    require(all(convex(cell) for cell in cells), "topology requires convex cells")
    neighbours = [set() for _ in cells]
    for i, j in combinations(range(len(cells)), 2):
        if meets(cells[i], cells[j]):
            neighbours[i].add(j)
            neighbours[j].add(i)
    components = 0
    unseen = set(range(len(cells)))
    while unseen:
        components += 1
        pending = [unseen.pop()]
        while pending:
            new = neighbours[pending.pop()] & unseen
            unseen.difference_update(new)
            pending.extend(new)

    counts = [0] * len(cells)

    def visit(poly, candidates, size):
        counts[size - 1] += 1
        for offset, i in enumerate(candidates):
            intersection = clip(poly, cells[i])
            if intersection:
                rest = [j for j in candidates[offset + 1:] if j in neighbours[i]]
                visit(intersection, rest, size + 1)

    for i, cell in enumerate(cells):
        visit(cell, sorted(j for j in neighbours[i] if j > i), 1)
    while counts and counts[-1] == 0:
        counts.pop()
    euler = sum(n if i % 2 == 0 else -n for i, n in enumerate(counts))
    return {"components": components, "holes": components - euler,
            "euler": euler, "simplices": counts}


def svg_cells(root):
    ns = "{http://www.w3.org/2000/svg}"
    result = []
    for group in root.findall(ns + "g"):
        name = group.attrib["id"]
        fill = next(p for p in group.findall(ns + "path")
                    if p.attrib["id"] == name + "-fill")
        count = len(re.findall(r"\d+", fill.attrib["d"])) // 2
        require(count >= 4 and count % 2 == 0, "invalid paired fill boundary")
        boundary = points(fill, "M" + "L" * (count - 1) + "Z")
        half = count // 2
        left, right = boundary[:half], list(reversed(boundary[half:]))
        arm = [[left[i], left[i + 1], right[i + 1], right[i]]
               for i in range(half - 1)]
        # A consistently oriented strip with disjoint nonadjacent tiles and
        # opposite adjacent interiors realizes the closed polygon fill.
        signs = [cross(q[0], q[1], q[2]) > 0 for q in arm]
        require(all(s == signs[0] for s in signs), name + ": flipped strip orientation")
        for i, j in combinations(range(len(arm)), 2):
            if j > i + 1:
                require(not meets(arm[i], arm[j]), name + ": nonadjacent tiles intersect")
        result.extend(arm)
    return result


def verify_topology(root):
    # Establish the supported SVG contract, including rejection of transforms,
    # before interpreting local coordinates as the rendered fill geometry.
    verify(root)
    report = nerve(svg_cells(root))
    require(report["components"] == 1 and report["holes"] == 2,
            f"fill must have one component and two holes: {report}")
    return report


if __name__ == "__main__":
    import sys
    print(verify_topology(ET.parse(sys.argv[1] if len(sys.argv) > 1 else "b.svg").getroot()))
