#!/usr/bin/env nix-shell
#!nix-shell -i bash -p coreutils gnused jq

#AI SLOP, just bash boilerplate

set -euo pipefail

EXT_LIST="extensions.txt"
OUT_FILE="firefox-extension-ids.nix"
MOZID="nix run github:tupakkatapa/mozid --"

if [ ! -f "$EXT_LIST" ]; then
  echo "Missing $EXT_LIST" >&2
  exit 1
fi

tmp="$(mktemp)"

while IFS= read -r line; do
  # Strip comments + whitespace
  line="$(echo "$line" | sed 's/#.*//' | xargs)"
  [ -z "$line" ] && continue

  slug="$(basename "$line" | sed 's/[^a-zA-Z0-9_-]//g')"
  id="$($MOZID "$line" | tr -d '\n')"

  if [ -z "$id" ]; then
    echo "Failed to resolve: $line" >&2
    exit 1
  fi

  echo "  ${slug} = \"${id}\";" >> "$tmp"
done < "$EXT_LIST"

{
  echo "{"
  sort "$tmp"
  echo "}"
} > "$OUT_FILE"

rm "$tmp"

echo "Wrote $OUT_FILE"

