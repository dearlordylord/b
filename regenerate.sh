#!/bin/sh
# Compile and execute the Bend generator; replace the candidate only on success.
set -eu
TASK_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TASK_TMP=$(mktemp -d)
trap 'find "$TASK_TMP" -type f -delete; rmdir "$TASK_TMP"' EXIT HUP INT TERM
cd "$TASK_DIR"
PYTHONDONTWRITEBYTECODE=1 python3 proof_scope.py
while IFS= read -r proof_root || [ -n "$proof_root" ]; do
  timeout 5 bend "$proof_root" --verdict
done < proof-roots.txt
# Keep C emission and compilation separately bounded. The LLVM optimizer at
# Bend's default setting can dominate this build on a shared Linux machine.
case $(uname -s) in
  Linux)
    timeout 5 bend generate.bend -o "$TASK_TMP/generate.c"
    timeout 5 clang -O1 -pthread "$TASK_TMP/generate.c" -lm -o "$TASK_TMP/generate"
    ;;
  *)
    timeout 5 bend generate.bend -o "$TASK_TMP/generate"
    ;;
esac
"$TASK_TMP/generate" > "$TASK_TMP/b.svg"
python3 verify.py "$TASK_TMP/b.svg"
PYTHONDONTWRITEBYTECODE=1 python3 topology_verify.py "$TASK_TMP/b.svg"
mv "$TASK_TMP/b.svg" "$TASK_DIR/b.svg"
