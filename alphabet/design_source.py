"""Approved ribbon paths used only by the authoring adapter."""
from math import hypot, cos, sin, pi

def bezier(start, *segments):
    points = [start]
    for a, b, end in segments:
        origin = points[-1]
        for i in range(1, 33):
            t = i / 32
            s = 1 - t
            points.append(tuple(s**3*origin[k]+3*s*s*t*a[k]+3*s*t*t*b[k]+t**3*end[k] for k in (0, 1)))
    return points

def line(a, b):
    return [a, b]

def oval(cx, cy, rx, ry):
    return [(cx+rx*cos(-pi/2+i*2*pi/144), cy+ry*sin(-pi/2+i*2*pi/144)) for i in range(145)]

def resample(points, spacing=2):
    lengths = [0]
    for a, b in zip(points, points[1:]):
        lengths.append(lengths[-1]+hypot(b[0]-a[0], b[1]-a[1]))
    count = max(2, round(lengths[-1]/spacing))
    result = []
    j = 0
    for i in range(count+1):
        distance = lengths[-1]*i/count
        while j < len(points)-2 and lengths[j+1] < distance:
            j += 1
        t = (distance-lengths[j])/(lengths[j+1]-lengths[j])
        result.append(tuple(points[j][k]*(1-t)+points[j+1][k]*t for k in (0, 1)))
    return result, lengths[-1]

def ribbon_edges(points, width, closed=False):
    points, length = resample(points)
    left, right = [], []
    for i, point in enumerate(points):
        if closed and i in (0, len(points)-1):
            a, b = points[-2], points[1]
        else:
            a, b = points[max(0, i-1)], points[min(len(points)-1, i+1)]
        dx, dy = b[0]-a[0], b[1]-a[1]
        size = hypot(dx, dy)
        nx, ny = -dy/size*width/2, dx/size*width/2
        left.append((point[0]+nx, point[1]+ny))
        right.append((point[0]-nx, point[1]-ny))
    return left, right, length

def glyph_specs():
    # Each arm is (centerline, thickness, seam spacing, closed).
    cap = lambda p: (p, 22, 25, False)
    small = lambda p: (p, 20, 29, False)
    stem = lambda x, top=30, bottom=132: line((x, bottom), (x, top))
    bowl = lambda x=54: oval(x, 103, 30, 29)
    arch = lambda x: bezier((x, 131), ((x, 91), (x, 74), (x+29, 74)), ((x+58, 74), (x+58, 96), (x+58, 132)))
    upper_bowl = bezier((25, 31), ((122, 9), (125, 85), (25, 86)))
    forms = {
        'H': (124, [cap(line((24, 82), (100, 82))), cap(stem(24)), cap(stem(100))]),
        'N': (128, [cap(line((25, 31), (102, 132))), cap(stem(25)), cap(stem(102))]),
        'O': (128, [(oval(64, 81, 44, 52), 22, 25, True)]),
        'R': (126, [cap(bezier((66, 82), ((82, 95), (95, 111), (108, 133)))), cap(upper_bowl), cap(stem(24))]),
        'S': (121, [cap(bezier((100, 39), ((83, 20), (26, 18), (23, 55)), ((20, 86), (100, 76), (101, 109)), ((104, 143), (43, 145), (22, 124))))]),
        'D': (127, [cap(bezier((25, 31), ((135, 13), (137, 151), (25, 132)))), cap(stem(24))]),
        'E': (113, [cap(line((25, 31), (98, 31))), cap(line((25, 81), (85, 81))), cap(line((25, 132), (98, 132))), cap(stem(24))]),
        'a': (113, [
            (bezier((31, 78), ((47, 65), (85, 68), (85, 90)), ((85, 106), (85, 121), (85, 127)), ((85, 133), (91, 134), (97, 132))), 18, 29, False),
            (bezier((85, 102), ((58, 96), (25, 101), (25, 118)), ((25, 138), (64, 140), (85, 121))), 18, 29, False),
        ]),
        'b': (107, [(bowl(57), 20, 29, True), small(stem(25))]),
        'd': (107, [(bowl(), 20, 29, True), small(stem(86))]),
        'e': (105, [
            # A continuous ribbon: the crossbar turns into the arch without caps.
            (bezier((24, 102), ((40, 102), (61, 102), (70, 102)),
                    ((80, 102), (84, 98), (84, 89)),
                    ((84, 66), (37, 62), (24, 85)),
                    ((4, 119), (36, 146), (66, 134)),
                    ((73, 131), (80, 127), (85, 123))), 18, 29, False),
        ]),
        'n': (108, [small(arch(25)), small(stem(25, 74))]),
        'g': (108, [small(bezier((86, 75), ((86, 106), (86, 140), (86, 156)), ((86, 180), (51, 183), (31, 165)))), (bowl(), 20, 29, True)]),
        'i': (49, [small(stem(24, 75)), (line((24, 43), (24, 58)), 18, 100, False)]),
        'r': (81, [small(bezier((25, 108), ((25, 79), (49, 69), (69, 80)))), small(stem(25, 74))]),
        'm': (163, [small(arch(80)), small(arch(25)), small(stem(25, 74))]),
        'u': (108, [small(bezier((25, 75), ((25, 111), (22, 132), (53, 132)), ((84, 132), (83, 108), (83, 75)))), small(stem(84, 75))]),
        'l': (61, [small(bezier((25, 30), ((24, 71), (24, 105), (25, 122)), ((26, 133), (32, 135), (46, 131))))]),
    }
    return forms
