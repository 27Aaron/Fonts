#!/usr/bin/env bash
set -euo pipefail

# Refresh the `hash` of every fetchurl-based font package from its `url`.
# This is intentionally limited to hashes: version/URL bumps stay manual
# because the release assets are named by hand.

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$root"

command -v jq >/dev/null || {
  echo "error: jq is required" >&2
  exit 1
}

changed=0

for file in nix/*.nix; do
  url=$(sed -n 's/^[[:space:]]*url = "\([^"]*\)";.*/\1/p' "$file" | head -n 1)

  if [[ -z ${url} ]]; then
    echo "skip ${file}: no fetchurl URL"
    continue
  fi

  old_hash=$(sed -n 's/^[[:space:]]*hash = "\([^"]*\)";.*/\1/p' "$file" | head -n 1)

  if [[ -z ${old_hash} ]]; then
    echo "skip ${file}: no hash"
    continue
  fi

  echo "checking ${file}"
  echo "  url: ${url}"

  new_hash=$(
    nix store prefetch-file --json --hash-type sha256 "$url" |
      jq -er '.hash'
  )

  if [[ ${new_hash} == "${old_hash}" ]]; then
    echo "  hash unchanged: ${new_hash}"
    continue
  fi

  echo "  updating hash: ${old_hash} -> ${new_hash}"
  OLD_HASH=${old_hash} NEW_HASH=${new_hash} \
    perl -0pi -e 's/\Q$ENV{OLD_HASH}\E/$ENV{NEW_HASH}/g' "$file"
  changed=1
done

if ((changed == 0)); then
  echo "all font hashes are up to date"
else
  echo "updated at least one font hash"
fi
