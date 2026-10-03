"""Audit that every public law module belongs to the declared proof roots."""
import re
from pathlib import Path

HERE = Path(__file__).resolve().parent


def proof_scope(directory, roots_file=None):
    roots = (roots_file or HERE / "proof-roots.txt").read_text().splitlines()
    assert roots and len(roots) == len(set(roots)), roots
    sources = {p.name: p.read_text() for p in directory.glob("*.bend")}
    seen, pending = set(), list(roots)
    while pending:
        name = pending.pop()
        if name in seen:
            continue
        assert name in sources, f"Missing proof dependency: {name}"
        seen.add(name)
        pending.extend(re.findall(r"^import \./([^ ]+) as ", sources[name], re.M))
    law_files = {name for name in sources if name == "LAWS.bend" or name.endswith("-laws.bend")}
    assert law_files <= seen, f"Public law modules omitted from proof roots: {sorted(law_files - seen)}"
    count = sum(len(re.findall(r"^law [^:]+:", sources[name], re.M)) for name in law_files)
    return roots, count


if __name__ == "__main__":
    roots, count = proof_scope(HERE)
    print(f"Proof scope: {count} unique public laws across {len(roots)} roots")
