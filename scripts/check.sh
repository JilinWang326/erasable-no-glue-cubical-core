#!/usr/bin/env sh
set -eu

root="$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)"
cd "$root"

agda_bin="${AGDA:-agda}"

patterns='\{!|\bpostulate\b|primTrustMe|TERMINATING|NON_TERMINATING|NO_TERMINATION_CHECK|allow-unsolved-metas|allow-incomplete-match|type-in-type|\bTODO\b|\bFIXME\b|placeholder|dummy|scaffold|vibe|anti-cheat|ChatGPT|Codex|\badmit\b'

if find src tests -name '*.agda' -type f -print0 | xargs -0 grep -nE "$patterns"; then
  echo "Banned Agda source pattern scan failed." >&2
  exit 1
fi

"$agda_bin" -i src -i tests src/NoGlueCubicalCore/MainTheorem.agda
"$agda_bin" -i src -i tests src/NoGlueCubicalCore/Index.agda
"$agda_bin" -i src -i tests tests/Smoke/LoadEverything.agda

echo "Check passed."
