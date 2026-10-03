#!/usr/bin/env python3
"""Throwaway vector specimen; run with Python 3, no dependencies.

Question: do broad segmented metal ribbons work as a readable mixed-case family?
This is a visual prototype, not Bend-validated production artwork.
"""
from pathlib import Path
from math import hypot, cos, sin, pi
import html
import xml.etree.ElementTree as ET

HERE = Path(__file__).resolve().parent
INK, STEEL, SHADE = '#17272F', '#7593A7', '#476579'


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


def xy(point):
    return f'{point[0]:.3f} {point[1]:.3f}'


def polygon(points):
    return 'M'+' L'.join(map(xy, points))+' Z'


def tube(points, width=22, pitch=25, closed=False):
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
    if closed:
        outline = polygon(left)+polygon(right[::-1])
    else:
        outline = polygon(left+right[::-1])
    shade = [(l[0]*.25+r[0]*.75, l[1]*.25+r[1]*.75) for l, r in zip(left, right)]
    shade_path = polygon(shade)+polygon(right[::-1]) if closed else polygon(shade+right[::-1])
    parts = [f'<path d="{outline}" fill="{STEEL}" fill-rule="evenodd"/>',
             f'<path d="{shade_path}" fill="{SHADE}" fill-rule="evenodd"/>']
    seam_count = round(length/pitch) if length >= width else 0
    for seam in range(seam_count):
        fraction = (seam+.5)/seam_count
        i = round(fraction*(len(points)-1))
        j = min(i+2, len(points)-1)
        control = tuple((left[i][k]+right[i][k]+left[j][k]+right[j][k])/4 for k in (0, 1))
        parts.append(f'<path class="seam" d="M{xy(left[i])} Q{xy(control)} {xy(right[i])}" fill="none" stroke="{INK}" stroke-width="1.5"/>')
    parts.append(f'<path d="{outline}" fill="none" stroke="{INK}" stroke-width="2.8" stroke-linejoin="round"/>')
    return '\n'.join(parts)


def glyphs():
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
        'a': (108, [(bowl(), 20, 29, True), small(stem(86, 74))]),
        'b': (107, [(bowl(57), 20, 29, True), small(stem(25))]),
        'd': (107, [(bowl(), 20, 29, True), small(stem(86))]),
        'e': (105, [small(line((24, 102), (84, 102))), small(bezier((84, 102), ((85, 67), (32, 63), (23, 91)), ((6, 136), (60, 155), (86, 126))))]),
        'n': (108, [small(arch(25)), small(stem(25, 74))]),
        'g': (108, [small(bezier((86, 75), ((86, 106), (86, 140), (86, 156)), ((86, 180), (51, 183), (31, 165)))), (bowl(), 20, 29, True)]),
        'i': (49, [small(stem(24, 75)), (line((24, 43), (24, 58)), 18, 100, False)]),
        'r': (81, [small(bezier((25, 108), ((25, 79), (49, 69), (69, 80)))), small(stem(25, 74))]),
        'm': (163, [small(arch(80)), small(arch(25)), small(stem(25, 74))]),
        'u': (108, [small(bezier((25, 75), ((25, 111), (22, 132), (53, 132)), ((84, 132), (83, 108), (83, 75)))), small(stem(84, 75))]),
        'l': (61, [small(bezier((25, 30), ((24, 71), (24, 105), (25, 122)), ((26, 133), (32, 135), (46, 131))))]),
    }
    result = {}
    original = ET.parse(HERE.parent/'b.svg').getroot()
    for path in original.iter():
        if '-seam-' in path.get('id', ''):
            path.set('class', 'seam')
    source = ''.join(ET.tostring(child, encoding='unicode') for child in original)
    # Keep the original B itself, rather than approximating its silhouette.
    result['B'] = (123, f'<g transform="translate(-17 0) scale(.01)">{source}</g>')
    for name, (advance, arms) in forms.items():
        result[name] = advance, '\n'.join(tube(*arm) for arm in arms)
    return result


FORMS = glyphs()
DEFS = '<defs>'+''.join(f'<g id="glyph-{ord(char)}">{body}</g>' for char, (_, body) in FORMS.items())+'</defs>'


def word(text, x=0, y=0, scale=1):
    elements = []
    offset = 0
    for char in text:
        if char not in FORMS and char != ' ':
            raise ValueError(f'Glyph not in this prototype: {char!r}')
        advance = FORMS[char][0] if char in FORMS else 58
        if char in FORMS:
            elements.append(f'<use href="#glyph-{ord(char)}" transform="translate({offset} 0)"/>')
        offset += advance+5
    return f'<g transform="translate({x} {y}) scale({scale})">'+''.join(elements)+'</g>', offset*scale


def svg(content, width, height, definitions=True):
    return f'<svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" width="{width}" height="{height}" viewBox="0 0 {width} {height}">'+(DEFS if definitions else '')+content+'</svg>'


def label(text, x, y, size=16, color='#52636b'):
    return f'<text x="{x}" y="{y}" font-family="DejaVu Sans, sans-serif" font-size="{size}" fill="{color}">{html.escape(text)}</text>'


def specimen():
    parts = ['<rect width="1320" height="1200" fill="#e0e6e9"/>', label('SOFT INDUSTRIAL / 01', 48, 46, 18), label('Segmented steel · uppercase + lowercase study', 48, 77, 16)]
    for chars, y in [('BHORS', 104), ('aengi', 308)]:
        for i, char in enumerate(chars):
            x = 55+i*246
            parts.append(f'<use href="#glyph-{ord(char)}" transform="translate({x} {y}) scale(1.35)"/>')
            parts.append(label(char, x+62, y+(275 if y==308 else 232), 16))
    parts.append('<path d="M48 610 H1272" stroke="#bdc9cf"/>')
    for text, y, scale in [('BENDER', 640, 1.18), ('Bender', 838, 1.0), ('minimum', 1010, .78)]:
        element, _ = word(text, 50, y, scale)
        parts.append(element)
    parts.append(label('Visual prototype · original B preserved · new glyphs not formally verified', 48, 1180, 13))
    return svg(''.join(parts), 1320, 1200)


def main():
    (HERE/'glyphs').mkdir(exist_ok=True)
    for char, (advance, body) in FORMS.items():
        filename = ('upper-' if char.isupper() else 'lower-')+char+'.svg'
        (HERE/'glyphs'/filename).write_text(svg(body, advance, 190, False))
    (HERE/'specimen.svg').write_text(specimen())
    rows = []
    for title, text in [('Прописные', 'BHORS'), ('Строчные', 'aengi'), ('В словах', 'BENDER'), ('Смешанный регистр', 'Bender'), ('Ритм штрихов', 'minimum')]:
        element, width = word(text)
        rows.append(f'<section><h2>{title}</h2>{svg(element, width, 192, False)}</section>')
    for title, text in [('Дополнительные прописные', 'DEN'), ('Дополнительные строчные', 'bdrmul')]:
        element, width = word(text)
        rows.append(f'<section><h2>{title}</h2>{svg(element, width, 192, False)}</section>')
    page = '''<!doctype html><html lang="ru"><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1"><title>Мягкий индустриальный — пробный алфавит</title>
<style>
:root{--paper:#e0e6e9;--ink:#17272f}*{box-sizing:border-box}body{margin:0;background:var(--paper);color:var(--ink);font:16px/1.5 system-ui,sans-serif}main{max-width:1200px;margin:auto;padding:40px 28px 100px}header{max-width:740px}h1{font-size:clamp(25px,4vw,44px);line-height:1.15;margin:12px 0 20px}p{color:#52636b}h2{font-size:13px;font-weight:600;letter-spacing:.08em;text-transform:uppercase;margin:0 0 18px}section{margin-top:42px;padding-top:24px;border-top:1px solid #b9c6cc;overflow:auto}section svg{display:block;height:var(--size,192px);width:auto;max-width:none}nav{position:fixed;bottom:18px;left:50%;transform:translateX(-50%);display:flex;gap:14px;align-items:center;padding:12px 20px;background:#17272f;color:#fff;border-radius:28px;box-shadow:0 6px 25px #17272f30;white-space:nowrap;font-size:14px}button,select{font:inherit;border:0;border-radius:5px;padding:4px 9px;cursor:pointer}input{width:95px}body.clean .seam{display:none}body.dark{--paper:#273b45}body.dark main{color:#e0e6e9}body.dark p{color:#b9c6cc}body.dark h2{color:#b9c6cc}.note{font-size:13px}.badge{letter-spacing:.14em;font-size:12px;font-weight:700}@media(max-width:600px){nav{gap:8px;padding:10px 12px;flex-wrap:wrap;justify-content:center;width:94%}main{padding:24px 18px 130px}section svg{height:150px}}
</style><main><header><div class="badge">B / ALPHABET STUDY 01</div><h1>Мягкий индустриальный</h1><p>Широкие металлические ленты, мягкие повороты и редкие швы. Пробный набор для оценки форм и чтения в словах.</p><p class="note">Исходная B сохранена. Новые буквы — векторный прототип; формальные проверки Bend к ним пока не применяются.</p><p><a href="specimen.svg">Скачать лист SVG</a> · <a href="specimen.png">Открыть лист PNG</a></p></header>'''+''.join(rows)+'''</main><nav aria-label="Настройки просмотра"><label>Размер <input id="size" type="range" min="70" max="260" value="192"></label><button id="seams" aria-pressed="true">Швы: вкл.</button><button id="background">Тёмный фон</button></nav><script>
document.getElementById('size').addEventListener('input',e=>document.documentElement.style.setProperty('--size',e.target.value+'px'));
document.getElementById('seams').addEventListener('click',e=>{const off=document.body.classList.toggle('clean');e.target.textContent='Швы: '+(off?'выкл.':'вкл.');e.target.setAttribute('aria-pressed',String(!off))});
document.getElementById('background').addEventListener('click',e=>{const dark=document.body.classList.toggle('dark');e.target.textContent=dark?'Светлый фон':'Тёмный фон'});
</script></html>'''
    page = page.replace('<main>', '<svg xmlns="http://www.w3.org/2000/svg" width="0" height="0" style="position:absolute" aria-hidden="true">'+DEFS+'</svg><main>', 1)
    (HERE/'index.html').write_text(page)
    print(f'Generated {len(FORMS)} glyphs, specimen.svg and index.html in {HERE}')


if __name__ == '__main__':
    main()
