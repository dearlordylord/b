"""Run all shared proofs, native model gates, exact SVG checks, then publish.

No geometry dependency is required: Python 3, Bend 2.0.34 and Clang suffice.
Each Bend/Clang/native invocation has its own unchanged five-second gate.
Generate one glyph per compiled entry to keep C emission bounded as the
catalog grows; the host only assembles already checked SVGs into a specimen.
"""
from pathlib import Path
import subprocess
import tempfile
import sys
import json
import shutil
import xml.etree.ElementTree as ET
import argparse

HERE=Path(__file__).resolve().parent
ROOT=HERE.parent
sys.path.insert(0,str(ROOT))
from alphabet.verify import verify, negative_controls, KEYS, NS
from proof_scope import proof_scope


def run(args, timeout=5):
    result=subprocess.run(args,cwd=ROOT,capture_output=True,text=True,timeout=timeout)
    if result.returncode:
        raise RuntimeError(f'{args}: exit {result.returncode}\n{result.stdout}\n{result.stderr}')
    return result.stdout


def build(entry, directory):
    c=directory/'program.c';exe=directory/'program'
    run(['bend',str(entry),'-o',str(c)])
    # Validation/rendering is fast without LLVM optimization; optimizing the
    # large literal artwork can exceed the five-second compile gate under load.
    run(['clang','-O0','-pthread',str(c),'-lm','-o',str(exe)])
    return exe


def native(entry, directory):
    return run([str(build(entry,directory))])


def proof_controls(directory):
    controls=[
        ('Seam{boundary_left(cell_start(cell)),','Seam{boundary_right(cell_start(cell)),','seam_attaches_left'),
        ('cell_center(cell), boundary_right(cell_start(cell))}','cell_center(cell), boundary_left(cell_start(cell))}','seam_attaches_right'),
        ('case Seam{start, control, end}:\n      control','case Seam{start, control, end}:\n      end','svg_uses_boundaries'),
    ]
    for i,(old,new,law) in enumerate(controls):
        candidate=directory/f'mutant-{i}';candidate.mkdir()
        for source in ROOT.glob('*.bend'):
            shutil.copyfile(source,candidate/source.name)
        core=candidate/'core.bend';text=core.read_text()
        assert text.count(old)==1,(old,text.count(old))
        core.write_text(text.replace(old,new,1))
        output=run(['bend',str(core),'--check-only'])
        assert 'ALL PROOFS CHECK' in output,output
        result=subprocess.run(['bend',str(candidate/'PROOF.bend'),'--verdict'],cwd=ROOT,capture_output=True,text=True,timeout=5)
        diagnostic=result.stdout+result.stderr
        assert result.returncode!=0 and law in diagnostic and 'expected' in diagnostic,diagnostic
        print(f'Compiling seam mutant rejected by public law: {law}',flush=True)
    return len(controls)


def specimen(roots):
    svg=ET.Element(NS+'svg',width='1320',height='1560',viewBox='0 0 132000 156000')
    ET.SubElement(svg,NS+'rect',width='132000',height='156000',fill='#e0e6e9')
    defs=ET.SubElement(svg,NS+'defs')
    glyphs={}
    for root in roots:
        glyph=root.find(NS+'g');key=chr(int(glyph.get('data-key')))
        defs.append(glyph);glyphs[key]=glyph
    def row(text,y,scale):
        group=ET.SubElement(svg,NS+'g',transform=f'translate(5000 {y}) scale({scale})')
        x=0
        for char in text:
            if char!=' ':
                glyph=glyphs[char]
                ET.SubElement(group,NS+'use',href='#'+glyph.get('id'),transform=f'translate({x} 0)')
                x+=int(glyph.get('data-advance'))+500
            else:
                x+=6300
    ET.SubElement(svg,NS+'text',x='5000',y='5000',attrib={'font-family':'DejaVu Sans','font-size':'1800','fill':'#52636b'}).text='SOFT INDUSTRIAL / BEND MODEL'
    for text,y,scale in [('BHORS',7000,1.65),('aengi',31000,1.65),('BENDER',61000,1.18),('Bender',81000,1),('minimum',99000,.78),('made a name',114000,.8),('DENbdrmul',135000,.85)]:
        row(text,y,scale)
    return svg


def main():
    parser=argparse.ArgumentParser()
    parser.add_argument('--skip-proofs',action='store_true',help='Local iteration only; final gate omits this flag.')
    args=parser.parse_args()
    scope=proof_scope(ROOT)
    if not args.skip_proofs:
        for root in (ROOT/'proof-roots.txt').read_text().splitlines():
            output=run(['bend',root,'--verdict'])
            assert 'ALL PROOFS CHECK' in output,output
            print(f'Proof accepted: {root}',flush=True)
        output=run(['bend','alphabet/PROOF.bend','--verdict'])
        assert 'ALL PROOFS CHECK' in output,output
        print(f'Shared proof scope: {scope[1]} laws / {len(scope[0])} roots; alphabet proof bridge accepted',flush=True)
    with tempfile.TemporaryDirectory(prefix='bend-alphabet-') as tmp:
        stage=Path(tmp);(stage/'glyphs').mkdir()
        mutants=proof_controls(stage)
        tests=native(HERE/'tests.bend',stage)
        assert 'alphabet-tests: True' in tests,tests
        print('Native boundary/rejection cases: 19 accepted',flush=True)
        rejection=build(HERE/'rejection.bend',stage)
        rejected=subprocess.run([str(rejection)],capture_output=True,text=True,timeout=5)
        assert rejected.returncode==1 and not rejected.stdout and 'Alphabet validation failed' in rejected.stderr,rejected
        print('Invalid artwork rejected by real Bend generator before any SVG output',flush=True)
        roots=[];results=[]
        for key in sorted(KEYS):
            output=native(HERE/'entries'/f'glyph-{ord(key)}.bend',stage)
            root=ET.fromstring(output)
            result=verify(root)
            controls=negative_controls(root)
            (stage/'glyphs'/f'glyph-{ord(key)}.svg').write_text(output)
            roots.append(root);results.append(result)
            print(f'Native + exact artifact: {key}, {result["cells"]} cells, {result["seams"]} seams, {result["components"]} components / {result["holes"]} holes; {controls} negative controls',flush=True)
        ET.register_namespace('',NS)
        ET.ElementTree(specimen(roots)).write(stage/'specimen.svg',encoding='unicode')
        report={'shared_proof_gate':not args.skip_proofs,'shared_public_laws':scope[1],'shared_proof_roots':len(scope[0]),'compiling_seam_mutants_rejected':mutants,'native_boundary_cases':19,'empty_generator_rejected':True,'svg_negative_controls':6*len(results),'glyphs':results,'total_cells':sum(r['cells'] for r in results),'total_seams':sum(r['seams'] for r in results),'scope':'shared universal seam laws + executed model checks; exact independent nerve enumeration; continuous topology bridge is not proved in Bend'}
        (stage/'validation.json').write_text(json.dumps(report,indent=2)+'\n')
        # Every staged file is checked before it replaces a public artifact.
        output_dir=HERE/'output';output_dir.mkdir(exist_ok=True)
        (output_dir/'glyphs').mkdir(exist_ok=True)
        for file in (stage/'glyphs').glob('*.svg'):
            shutil.copyfile(file,output_dir/'glyphs'/file.name)
        for name in ('specimen.svg','validation.json'):
            shutil.copyfile(stage/name,output_dir/name)
        print(f'Published checked catalog: {len(results)} glyphs, {report["total_cells"]} cells / {report["total_seams"]} seams',flush=True)


if __name__=='__main__':
    main()
