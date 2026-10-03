"""One-time design import. Bend files, not this adapter, are runtime inputs.

Run: python3 alphabet/export_design.py
Paired boundaries are snapped to a four-unit grid (0.04 px). Descender g
uses a local origin so every source coordinate satisfies the existing 16000
arithmetic guard. No polygon union or SVG outline is imported from Shapely.
"""
from pathlib import Path
from math import hypot
import runpy
import json
import sys
import xml.etree.ElementTree as ET
import re
from fractions import Fraction

HERE = Path(__file__).resolve().parent
ROOT = HERE.parent
sys.path.insert(0, str(ROOT))
from verify import cross, convex, inside
from topology_verify import clip


def oriented(sections):
    cells = []
    for (l, r), (ll, rr) in zip(sections, sections[1:]):
        cell = [l, ll, rr, r]
        assert convex(cell), ('nonconvex', cell)
        cells.append(cell if cross(*cell[:3]) > 0 else cell[::-1])
    return cells


def snap(point):
    return tuple(round(value*100/4)*4 for value in point)


def join_point(first, second):
    for a in first:
        for b in second:
            if any(max(p[k] for p in a)<min(p[k] for p in b) or max(p[k] for p in b)<min(p[k] for p in a) for k in (0, 1)):
                continue
            overlap = clip(a, b)
            if not overlap:
                continue
            candidates = overlap+[tuple(sum(p[k] for p in overlap)/len(overlap) for k in (0, 1))]
            for p in candidates:
                snapped = tuple(round(value/4)*4 for value in p)
                if inside(a, snapped) and inside(b, snapped):
                    return snapped
    return None


def point(p):
    return f'C.Pt{{{p[0]}n, {p[1]}n}}'


def export():
    design = runpy.run_path(str(HERE/'design_source.py'))
    specs = design['glyph_specs']()
    manifest = []
    original = ET.parse(ROOT/'b.svg').getroot()
    ns = '{http://www.w3.org/2000/svg}'
    b_arms = []
    for group in original.findall(ns+'g'):
        path = next(p for p in group.findall(ns+'path') if p.get('id').endswith('-outline'))
        numbers = list(map(int, re.findall(r'\d+', path.get('d'))))
        boundary = list(zip(numbers[::2], numbers[1::2]))
        half = len(boundary)//2
        sections = [[(l[0]-1700, l[1]), (r[0]-1700, r[1])] for l, r in zip(boundary[:half], boundary[half:][::-1])]
        b_arms.append({'sections': sections, 'selected': list(range(2, len(sections)-1, 4))})
    raw = [('B', 123, 0, b_arms)]
    for name, (advance, arms) in specs.items():
        shift = 3000 if name == 'g' else 0
        imported = []
        for arm_index, (points, width, pitch, closed) in enumerate(arms):
            # Leave sufficient grid-rounding margin at the 18px lower bound.
            left, right, length = design['ribbon_edges'](points, max(width, 18.08), closed)
            if name == 'a' and arm_index == 0:
                # The approved outer foot stays intact. Its hidden inner edge
                # folds back at a radius smaller than half the ribbon width;
                # replace only that edge by a monotone connector under the bowl.
                start = next(i for i, p in enumerate(right) if p[1] >= 120)
                anchor = right[start]
                end = (left[-1][0]-2.5, left[-1][1]-18.1)
                for i in range(start, len(right)):
                    t = (i-start)/(len(right)-1-start)
                    right[i] = tuple(anchor[k]*(1-t)+end[k]*t for k in (0, 1))
            sections = [[(snap(l)[0], snap(l)[1]-shift), (snap(r)[0], snap(r)[1]-shift)] for l, r in zip(left, right)]
            if closed:
                sections[-1] = sections[0]
            # At a tight inner turn, two nearby samples can quantize to the
            # same boundary point. Remove redundant sections, not the corner.
            original_count = len(sections)
            while True:
                bad = next((i for i, ((l, r), (ll, rr)) in enumerate(zip(sections, sections[1:])) if not convex([l, ll, rr, r])), None)
                if bad is None:
                    break
                assert len(sections) > original_count*.9, (name, 'too much simplification')
                del sections[bad+1 if bad+1<len(sections)-1 else bad]
            try:
                cells = oriented(sections)
            except AssertionError as error:
                raise AssertionError((name, arm_index, error.args)) from error
            count = round(length/pitch) if length >= width else 0
            assert all(1800**2 <= (l[0]-r[0])**2+(l[1]-r[1])**2 <= 2600**2 for l, r in sections), (name, 'width')
            selected = sorted({min(len(cells)-1, round((i+.5)/count*len(cells))) for i in range(count)})
            imported.append({'sections': sections, 'selected': selected})
        raw.append((name, advance, shift, imported))
    for name, advance, shift, arms in raw:
        all_cells = [oriented(arm['sections']) for arm in arms]
        connections = {(i, j): join_point(all_cells[i], all_cells[j]) for i in range(len(arms)) for j in range(i)}
        order = []
        remaining = list(range(len(arms)))
        while remaining:
            nxt = next((i for i in remaining if any(connections.get((max(i,j), min(i,j))) is not None for j in order)), remaining[0])
            order.append(nxt)
            remaining.remove(nxt)
        arms = [arms[i] for i in order]
        all_cells = [all_cells[i] for i in order]
        components = 0
        for i, arm in enumerate(arms):
            attachment = None
            for j in range(i):
                p = connections.get((max(order[i], order[j]), min(order[i], order[j])))
                if p is not None:
                    attachment = (j, p)
                    break
            if attachment:
                parent, p = attachment
                arm.update(root=False, component=arms[parent]['component'], parent=parent, join=p)
            else:
                components += 1
                arm.update(root=True, component=i, parent=0, join=(0, 0))
            # Omit seams whose endpoints are interior to any other cover cell.
            cells = [cell for group in all_cells for cell in group]
            selected = []
            for k in arm['selected']:
                l, r = arm['sections'][k]
                if not any(all(cross(a, b, p) > 0 for a, b in zip(cell, cell[1:]+cell[:1])) for cell in cells for p in (l, r)):
                    selected.append(k)
            arm['selected'] = selected
        expected_components = 2 if name == 'i' else 1
        assert components == expected_components, (name, components)
        holes = {'B': 2, 'O': 1, 'D': 1, 'R': 1, 'a': 1, 'b': 1, 'd': 1, 'e': 1, 'g': 1}.get(name, 0)
        manifest.append({'key': name, 'advance': advance*100, 'offset': shift, 'components': components, 'holes': holes, 'arms': arms, 'painting':[order.index(i) for i in range(len(order))]})
    output = ['# Imported design data. All coordinates are exact Nat, on the 4-unit grid.', 'import Base', 'import ../core.bend as C', 'import ./model.bend as M', '']
    for glyph in manifest:
        name = glyph['key']
        for i, arm in enumerate(glyph['arms']):
            output += [f'def sections_{ord(name)}_{i}() -> List<&2, C.Section>:', '  [']
            output += ['    C.Section{'+point(l)+', '+point(r)+'}'+(',' if j<len(arm['sections'])-1 else '') for j, (l, r) in enumerate(arm['sections'])]
            output += ['  ]', '']
        output += [f'def glyph_{ord(name)}() -> M.Glyph:', f'  M.Glyph{{{ord(name)}n, {glyph["advance"]}n, {glyph["offset"]}n, {glyph["components"]}n, {glyph["holes"]}n, [']
        for i, arm in enumerate(glyph['arms']):
            flags = ', '.join('True{}' if j in arm['selected'] else 'False{}' for j in range(len(arm['sections'])-1))
            output += [f'    M.Arm{{sections_{ord(name)}_{i}(), [{flags}], {arm["component"]}n, {arm["parent"]}n, {point(arm["join"])}, '+('True{}' if arm['root'] else 'False{}')+'}'+(',' if i<len(glyph['arms'])-1 else '')]
        output += ['  ], ['+', '.join(f'{i}n' for i in glyph['painting'])+']}', '']
    output += ['def glyphs() -> List<&2, M.Glyph>:', '  ['+', '.join(f'glyph_{ord(g["key"])}()' for g in manifest)+']', '']
    (HERE/'artwork.bend').write_text('\n'.join(output))
    (HERE/'design.json').write_text(json.dumps(manifest, indent=2)+'\n')
    (HERE/'entries').mkdir(exist_ok=True)
    for g in manifest:
        key = ord(g['key'])
        (HERE/'entries'/f'glyph-{key}.bend').write_text(f'import Base\nimport ../artwork.bend as A\nimport ../generate.bend as G\n\ndef main() -> IO(Unit):\n  G.generate(A.glyph_{key}())\n')
    print(f'Imported {len(manifest)} glyphs / {sum(len(g["arms"]) for g in manifest)} arms / {sum(len(a["sections"])-1 for g in manifest for a in g["arms"])} cells')


if __name__ == '__main__':
    export()
