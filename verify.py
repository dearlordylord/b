"""Check the generated SVG using exact integer geometry, without a renderer."""
import re
import sys
import xml.etree.ElementTree as ET
from pathlib import Path


def require(condition, message):
    if not condition:
        raise ValueError(message)


def points(path, commands):
    data = path.attrib["d"]
    require(not re.sub(r"[MLQZ0-9\s]", "", data), "unexpected path syntax")
    require("".join(re.findall(r"[A-Z]", data)) == commands,
            "unexpected path commands")
    numbers = list(map(int, re.findall(r"\d+", data)))
    require(len(numbers) % 2 == 0, "odd coordinate count")
    return list(zip(numbers[::2], numbers[1::2]))


def cross(a, b, c):
    return (b[0] - a[0]) * (c[1] - a[1]) - (b[1] - a[1]) * (c[0] - a[0])


def on_segment(a, b, p):
    return (cross(a, b, p) == 0 and
            min(a[0], b[0]) <= p[0] <= max(a[0], b[0]) and
            min(a[1], b[1]) <= p[1] <= max(a[1], b[1]))


def intersects(a, b, c, d):
    x, y, z, w = cross(a, b, c), cross(a, b, d), cross(c, d, a), cross(c, d, b)
    return (x * y < 0 and z * w < 0 or
            x == 0 and on_segment(a, b, c) or y == 0 and on_segment(a, b, d) or
            z == 0 and on_segment(c, d, a) or w == 0 and on_segment(c, d, b))


def convex(quad):
    turns = [cross(quad[i], quad[(i + 1) % 4], quad[(i + 2) % 4]) for i in range(4)]
    return all(t > 0 for t in turns) or all(t < 0 for t in turns)


def inside(quad, p):
    turns = [cross(quad[i], quad[(i + 1) % 4], p) for i in range(4)]
    return all(t >= 0 for t in turns) or all(t <= 0 for t in turns)


def verify(root):
    ns = "{http://www.w3.org/2000/svg}"
    require(root.attrib.get("viewBox") == "0 0 16000 16000", "wrong coordinate space")
    require(not any("transform" in e.attrib for e in root.iter()), "unverified transform")
    groups = root.findall(ns + "g")
    require([g.attrib.get("id") for g in groups] == ["upper", "lower", "stem"],
            "unexpected tube composition")
    seam_count = cell_count = 0
    widths = []
    for group in groups:
        name = group.attrib["id"]
        paths = {e.attrib["id"]: e for e in group.findall(ns + "path")}
        outline = paths[name + "-outline"]
        count = len(re.findall(r"\d+", outline.attrib["d"])) // 2
        require(count >= 4 and count % 2 == 0, name + ": invalid boundary")
        boundary = points(outline, "M" + "L" * (count - 1) + "Z")
        require(paths[name + "-fill"].attrib["d"] == outline.attrib["d"],
                name + ": fill and outline differ")
        half = count // 2
        left, right = boundary[:half], list(reversed(boundary[half:]))
        require(all(0 <= x <= 16000 and 0 <= y <= 16000 for x, y in boundary),
                name + ": outside viewBox")
        for i in range(count):
            for j in range(i + 1, count):
                if j == i + 1 or i == 0 and j == count - 1:
                    continue
                require(not intersects(boundary[i], boundary[(i + 1) % count],
                                       boundary[j], boundary[(j + 1) % count]),
                        f"{name}: boundary self-intersection at {i}/{j}")
        cells = [[left[i], left[i + 1], right[i + 1], right[i]]
                 for i in range(half - 1)]
        for i, cell in enumerate(cells):
            require(convex(cell), f"{name}: non-convex cell {i}")
        cell_count += len(cells)
        for l, r in zip(left, right):
            width2 = (r[0] - l[0]) ** 2 + (r[1] - l[1]) ** 2
            require(1800 ** 2 <= width2 <= 2600 ** 2, name + ": width outside 18–26 px")
            widths.append(width2)
        shade = points(paths[name + "-shade"], "M" + "L" * (count - 1) + "Z")
        require(shade[half:] == boundary[half:], name + ": shade outside right edge")
        for i, (l, r, s) in enumerate(zip(left, right, shade[:half])):
            require((4 * s[0], 4 * s[1]) == (l[0] + 3 * r[0], l[1] + 3 * r[1]),
                    f"{name}: shade is not exact quarter interpolation at {i}")
        seams = [p for key, p in paths.items() if "-seam-" in key]
        require(seams, name + ": no seams")
        for path in seams:
            i = int(path.attrib["data-cell"])
            require(0 <= i < len(cells), name + ": invalid seam cell")
            start, control, end = points(path, "MQ")
            require(start == left[i] and end == right[i],
                    path.attrib["id"] + ": seam endpoints do not attach")
            quad = cells[i]
            require((4 * control[0], 4 * control[1]) ==
                    (sum(p[0] for p in quad), sum(p[1] for p in quad)),
                    path.attrib["id"] + ": control is not exact centroid")
            require(inside(quad, start) and inside(quad, control) and inside(quad, end),
                    path.attrib["id"] + ": Bezier control hull escapes tile")
            # Q'(t) is the linear interpolation of these two vectors. Positive
            # projections at both ends imply positive projection for every t.
            direction = (end[0] - start[0], end[1] - start[1])
            for a, b in ((start, control), (control, end)):
                require((b[0] - a[0]) * direction[0] +
                        (b[1] - a[1]) * direction[1] > 0,
                        path.attrib["id"] + ": seam doubles back")
            require(path.attrib.get("stroke-linecap") == "butt", "unverified seam cap")
            seam_count += 1
    return {"tubes": len(groups), "convex_cells": cell_count, "seams": seam_count,
            "min_width_squared": min(widths), "max_width_squared": max(widths)}


if __name__ == "__main__":
    path = Path(sys.argv[1]) if len(sys.argv) > 1 else Path(__file__).with_name("b.svg")
    print(verify(ET.parse(path).getroot()))
