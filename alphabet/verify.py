"""Independent exact validation of actual Bend SVG, using integers/Fraction.

The topology calculation uses the existing full intersection nerve enumerator
(all orders, not the bounded four-clique native shortcut). Its interpretation
uses the convex nerve theorem, which remains outside Bend's current proofs.
"""
from pathlib import Path
import sys
import re
import xml.etree.ElementTree as ET
from itertools import combinations
import copy

ROOT = Path(__file__).resolve().parent.parent
sys.path.insert(0, str(ROOT))
from verify import require, points, cross, convex, inside
from topology_verify import nerve, meets

NS = '{http://www.w3.org/2000/svg}'
KEYS = set('BDEHNORSabde gilmnru'.replace(' ', ''))
HOLES = {'B': 2, 'O': 1, 'D': 1, 'R': 1, 'a': 1, 'b': 1, 'd': 1, 'e': 1, 'g': 1}


def subpaths(element):
    data = element.get('d', '')
    chunks = re.findall(r'M[^M]+', data)
    require(''.join(chunks) == data, 'invalid cell path')
    result = []
    for chunk in chunks:
        path = ET.Element('path', d=chunk)
        quad = points(path, 'MLLLZ')
        require(convex(quad) and cross(*quad[:3]) > 0, 'cell orientation/convexity')
        result.append(quad)
    return result


def positive(quad):
    return quad if cross(*quad[:3]) > 0 else [quad[0], quad[3], quad[2], quad[1]]


def strict_inside(quad, point):
    return all(cross(a, b, point)>0 for a, b in zip(quad, quad[1:]+quad[:1]))


def verify(root, topology=True):
    groups = root.findall(NS+'g')
    require(len(groups)==1, 'exactly one glyph per emitted SVG')
    glyph = groups[0]
    key = chr(int(glyph.get('data-key')))
    require(key in KEYS and glyph.get('id')==f'glyph-{ord(key)}', 'unknown or mismatched glyph key')
    advance, offset = int(glyph.get('data-advance')), int(glyph.get('data-offset'))
    require(root.get('viewBox')==f'0 0 {advance} 19000', 'wrong glyph viewBox')
    require(root.get('width')==str(advance//100) and root.get('height')=='190', 'wrong glyph dimensions')
    require(offset==(3000 if key=='g' else 0), 'unexpected local origin')
    inner = glyph.findall(NS+'g')
    require(len(inner)==1 and inner[0].get('transform')==f'translate(0 {offset})', 'unverified translation')
    body = inner[0]
    require(not any('transform' in element.attrib for element in list(body.iter())[1:]), 'unexpected source transform')
    paths = list(body)
    require(all(p.tag==NS+'path' for p in paths), 'unexpected drawing element')
    by_id = {p.get('id'): p for p in paths}
    require(len(by_id)==len(paths), 'duplicate path IDs')
    sources = [p for p in paths if p.get('id','').endswith('-source')]
    arms = []
    expected_cover, expected_shade = [], []
    expected_seams = {}
    for i, source in enumerate(sources):
        arm_id = f'glyph-{ord(key)}-arm-{i}'
        require(source.get('id')==arm_id+'-source', 'arm order')
        require(source.get('fill')=='none' and source.get('stroke')=='none', 'source record must be invisible')
        count = len(re.findall(r'\d+', source.get('d')))//2
        boundary = points(source, 'M'+'L'*(count-1)+'Z')
        require(count>=4 and count%2==0, 'invalid section array')
        half = count//2
        left, right = boundary[:half], boundary[half:][::-1]
        for point in boundary:
            require(all(0<=n<=16000 and n%4==0 for n in point), 'source coordinate/grid guard')
            require(point[1]+offset<=19000, 'translated source leaves glyph viewBox')
        for l, r in zip(left,right):
            require(1800**2<=(l[0]-r[0])**2+(l[1]-r[1])**2<=2600**2, 'width outside 18–26 px')
        cells = [positive([left[j],left[j+1],right[j+1],right[j]]) for j in range(half-1)]
        require(all(convex(cell) for cell in cells), 'nonconvex source cell')
        expected_cover.extend(cells)
        shade = [((l[0]+3*r[0])//4,(l[1]+3*r[1])//4) for l,r in zip(left,right)]
        expected_shade.extend(positive([shade[j],shade[j+1],right[j+1],right[j]]) for j in range(half-1))
        marks = source.get('data-marks')
        require(len(marks)==len(cells) and set(marks)<=set('01'), 'seam marks length')
        for j, mark in enumerate(marks):
            if mark=='1':
                expected_seams[f'{arm_id}-seam-{j}'] = (j,left[j],right[j],cells[j])
        arm = {'cells':cells,'shade':[positive([shade[j],shade[j+1],right[j+1],right[j]]) for j in range(half-1)],'left':left,'right':right,'boundary':boundary,'component':int(source.get('data-component')),'parent':int(source.get('data-parent')),'root':source.get('data-root'),'join':tuple(map(int,source.get('data-join').split()))}
        require(arm['root'] in ('0','1'), 'root flag')
        if arm['root']=='1':
            require(arm['component']==i,'root component label')
        else:
            require(0<=arm['parent']<i,'parent must precede child')
            parent = arms[arm['parent']]
            require(arm['component']==parent['component'],'parent component')
            require(all(0<=v<=16000 and v%4==0 for v in arm['join']),'join guard')
            require(any(inside(q,arm['join']) for q in cells) and any(inside(q,arm['join']) for q in parent['cells']),'join witness is outside one arm')
        arms.append(arm)
    require(bool(arms), 'empty glyph')
    for a,b in combinations(arms,2):
        if a['component']!=b['component']:
            require(not any(meets(q,r) for q in a['cells'] for r in b['cells']), 'component roots overlap')
    expected_components = 2 if key=='i' else 1
    require(sum(a['root']=='1' for a in arms)==expected_components==int(glyph.get('data-components')),'component count')
    painting = list(map(int,glyph.get('data-painting').split()))
    require(sorted(painting)==list(range(len(arms))),'painting must be an arm permutation')
    if key in ('a','e'):
        border, fill, shade = (by_id[f'glyph-{ord(key)}-{name}'] for name in ('border','fill','shade'))
        require(subpaths(fill)==expected_cover and border.get('d')==fill.get('d'), 'fill/border does not equal source cover')
        require(subpaths(shade)==expected_shade, 'shadow is not exact quarter interpolation')
        require(paths.index(border)<paths.index(fill)<paths.index(shade), 'internal-border erasure order')
        for path,color in [(border,'#17272F'),(fill,'#7593A7'),(shade,'#476579')]:
            require(path.get('fill')==color and path.get('fill-rule')=='nonzero','unverified union fill style')
        require(border.get('stroke')=='#17272F' and border.get('stroke-width')=='560' and border.get('stroke-linejoin')=='round','unverified outline')
        require('stroke' not in fill.attrib and 'stroke' not in shade.attrib,'unexpected inner stroke')
        decorative_paths=3
    else:
        previous_end=-1
        for index in painting:
            arm=arms[index];prefix=f'glyph-{ord(key)}-arm-{index}'
            fill,shade,outline=(by_id[prefix+'-'+name] for name in ('fill','shade','outline'))
            require(subpaths(fill)==arm['cells'],'arm fill differs from cover')
            require(subpaths(shade)==arm['shade'],'arm shade interpolation')
            require(previous_end<paths.index(fill)<paths.index(shade)<paths.index(outline),'arm painting order')
            previous_end=paths.index(outline)
            for path,color in [(fill,'#7593A7'),(shade,'#476579')]:
                require(path.get('fill')==color and path.get('fill-rule')=='nonzero' and 'stroke' not in path.attrib,'arm fill style')
            require(outline.get('fill')=='none' and outline.get('stroke')=='#17272F' and outline.get('stroke-width')=='280' and outline.get('stroke-linejoin')=='round','arm outline style')
            chunks=re.findall(r'M[^M]+',outline.get('d'))
            actual=[]
            for chunk in chunks:
                count=len(re.findall(r'\d+',chunk))//2
                actual.append(points(ET.Element('path',d=chunk),'M'+'L'*(count-1)+'Z'))
            left,right=arm['left'],arm['right']
            expected=[left,[right[0]]+right[1:][::-1]] if left[0]==left[-1] and right[0]==right[-1] else [arm['boundary']]
            require(actual==expected,'outline is not the source boundary')
        decorative_paths=3*len(arms)
    actual_seams = {p.get('id'):p for p in paths if '-seam-' in p.get('id','')}
    require(set(actual_seams)==set(expected_seams),'missing/extra seam')
    require(len(paths)==len(sources)+decorative_paths+len(actual_seams),'unexpected path')
    for name,path in actual_seams.items():
        index,l,r,cell = expected_seams[name]
        start,control,end = points(path,'MQ')
        require(int(path.get('data-cell'))==index and start==l and end==r,'seam boundary attachment')
        require(tuple(4*c for c in control)==tuple(sum(p[k] for p in cell) for k in (0,1)),'seam centroid')
        require(inside(cell,control),'seam control hull containment')
        direction = (r[0]-l[0],r[1]-l[1])
        require(all((b[0]-a[0])*direction[0]+(b[1]-a[1])*direction[1]>0 for a,b in [(start,control),(control,end)]),'seam reverses')
        require(not any(strict_inside(q,p) for q in expected_cover for p in (start,end)),'seam endpoint hidden in junction')
        require(path.get('fill')=='none' and path.get('stroke')=='#17272F' and path.get('stroke-width')=='150' and path.get('stroke-linecap')=='butt','seam style')
    require(int(glyph.get('data-holes'))==HOLES.get(key,0),'hole metadata differs from glyph specification')
    result = {'key':key,'arms':len(arms),'cells':len(expected_cover),'seams':len(actual_seams),'components':expected_components,'holes':HOLES.get(key,0)}
    if topology:
        counts = nerve(expected_cover)
        require(counts['components']==expected_components and counts['holes']==HOLES.get(key,0),f'{key}: topology {counts}')
        result['nerve'] = counts
    return result


def negative_controls(root):
    """Literal SVG failures must be caught by the independent checker."""
    def mutate_source(tree):
        p=next(p for p in tree.iter(NS+'path') if p.get('id','').endswith('-source'))
        p.set('data-marks',p.get('data-marks')+'1')
    def mutate_cover(tree):
        p=next(p for p in tree.iter(NS+'path') if p.get('id','').endswith('-fill'))
        p.set('d',p.get('d').split('Z',1)[1])
    def mutate_seam(tree):
        p=next(p for p in tree.iter(NS+'path') if '-seam-' in p.get('id',''))
        p.set('d',re.sub(r'\d+',lambda m:str(int(m.group())+1),p.get('d'),count=1))
    def mutate_shadow(tree):
        p=next(p for p in tree.iter(NS+'path') if p.get('id','').endswith('-shade'))
        p.set('d',re.sub(r'\d+',lambda m:str(int(m.group())+4),p.get('d'),count=1))
    def mutate_holes(tree):
        g=tree.find(NS+'g');g.set('data-holes',str(int(g.get('data-holes'))+1))
    def mutate_transform(tree):
        p=next(tree.iter(NS+'path'));p.set('transform','translate(4 0)')
    for mutate in (mutate_source,mutate_cover,mutate_seam,mutate_shadow,mutate_holes,mutate_transform):
        broken=copy.deepcopy(root);mutate(broken)
        try:
            verify(broken,topology=False)
        except (ValueError,AssertionError):
            continue
        raise AssertionError(f'Negative control survived: {mutate.__name__}')
    return 6


if __name__=='__main__':
    directory=Path(sys.argv[1]) if len(sys.argv)>1 else Path(__file__).with_name('output')
    results=[verify(ET.parse(path).getroot()) for path in sorted(directory.glob('glyph-*.svg'))]
    require({r['key'] for r in results}==KEYS and len(results)==len(KEYS),'incomplete/duplicate glyph set')
    for result in results:
        print(result,flush=True)
