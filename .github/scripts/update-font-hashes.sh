#!/usr/bin/env bash
set -euo pipefail

# Refresh the `hash` of every fetchurl-based font package from its URL.
#
# The URL is taken from the evaluated flake, so packages that interpolate
# `version` into the URL behave exactly like packages with a literal one.
# Version/URL bumps are handled by update-font-versions.sh before this runs;
# this script only verifies that the hash matches the current URL.

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$root"

command -v nix >/dev/null || {
  echo "error: nix is required" >&2
  exit 1
}

command -v jq >/dev/null || {
  echo "error: jq is required" >&2
  exit 1
}

system=${FONT_SYSTEM:-x86_64-linux}

metadata=$(nix eval --json "path:${root}#packages.${system}" --apply '
  ps: builtins.mapAttrs (n: v: { url = v.src.url or null; }) (removeAttrs ps [ "default" ])
')

changed=0

for file in nix/*.nix; do
  label=$(basename "${file}" .nix)
  url=$(jq -r --arg n "${label}" '.[$n].url // empty' <<<"${metadata}")

  if [[ -z ${url} ]]; then
    echo "skip ${file}: no fetchurl URL"
    continue
  fi

  old_hash=$(sed -n 's/^[[:space:]]*hash = "\([^"]*\)";.*/\1/p' "${file}" | head -n 1)

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
    perl -0pi -e 's/\Q$ENV{OLD_HASH}\E/$ENV{NEW_HASH}/g' "${file}"
  changed=1
done

if ((changed == 0)); then
  echo "all font hashes are up to date"
else
  echo "updated at least one font hash"
fi
