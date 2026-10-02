#!/bin/sh
# Compile and execute the Bend generator; replace the candidate only on success.
set -eu
TASK_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
TASK_TMP=$(mktemp -d)
trap 'find "$TASK_TMP" -type f -delete; rmdir "$TASK_TMP"' EXIT HUP INT TERM
cd "$TASK_DIR"
timeout 5 bend PROOF.bend --verdict
timeout 5 bend generate.bend -o "$TASK_TMP/generate"
"$TASK_TMP/generate" > "$TASK_TMP/b.svg"
python3 verify.py "$TASK_TMP/b.svg"
mv "$TASK_TMP/b.svg" "$TASK_DIR/b.svg"
