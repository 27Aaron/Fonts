#!/usr/bin/env bash
set -euo pipefail

# Keep the `- **Version**:` line of each font block in README.md in sync
# with the package it documents.
#
# A block is located by its heading line
#   <summary><strong>NAME</strong> ... </summary>
# and the first `- **Version**:` line that follows it. Packages absent from
# the README are ignored, so the README may document only a subset.
#
# Run after update-font-versions.sh, which is what actually bumps the
# versions.

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$root"

readme=README.md

if [[ ! -f ${readme} ]]; then
  echo "skip ${readme}: not found"
  exit 0
fi

command -v nix >/dev/null || {
  echo "error: nix is required" >&2
  exit 1
}

command -v jq >/dev/null || {
  echo "error: jq is required" >&2
  exit 1
}

system=${FONT_SYSTEM:-x86_64-linux}

versions=$(nix eval --json "path:${root}#packages.${system}" --apply '
  ps: builtins.mapAttrs (n: v: v.version or null) (removeAttrs ps [ "default" ])
')

# Build the old -> new pairs that actually differ, then hand them to awk so
# the README is rewritten in one pass.
pairs=$(
  while IFS=$'\t' read -r line_no name; do
    documented=$(jq -r --arg n "${name}" '.[$n] // empty' <<<"${versions}")

    if [[ -z ${documented} ]]; then
      echo "[${name}] skip: no such package" >&2
      continue
    fi

    version_line=$(awk -v start="${line_no}" '
      NR > start && /^- \*\*Version\*\*:/ { print NR; exit }
    ' "${readme}")

    if [[ -z ${version_line} ]]; then
      echo "[${name}] skip: no version line" >&2
      continue
    fi

    current=$(sed -n "${version_line}p" "${readme}" |
      sed -n 's/^- \*\*Version\*\*: \(.*\)$/\1/p')

    if [[ ${current} == "${documented}" ]]; then
      echo "[${name}] up to date: ${documented}" >&2
      continue
    fi

    echo "[${name}] updating ${current} -> ${documented}" >&2
    printf '%s\t%s\n' "${version_line}" "${documented}"
  done < <(grep -n '<summary><strong>' "${readme}" |
    sed -n 's/^\([0-9]*\):<summary><strong>\([^<]*\)<\/strong>.*$/\1\t\2/p')
)

if [[ -z ${pairs} ]]; then
  echo "all README versions are up to date"
  exit 0
fi

# Replace the version on each recorded line, leaving the rest of the file
# byte-for-byte intact.
tmp=$(mktemp)
trap 'rm -f "${tmp}"' EXIT

printf '%s\n' "${pairs}" |
  awk -F'\t' 'NR == FNR { want[$1] = $2; next }
    FNR in want { sub(/^- \*\*Version\*\*: .*$/, "- **Version**: " want[FNR]) }
    { print }' - "${readme}" >"${tmp}"

# Confirm every recorded line now carries the expected version before
# replacing the original.
while IFS=$'\t' read -r version_line expected; do
  actual=$(sed -n "${version_line}p" "${tmp}" |
    sed -n 's/^- \*\*Version\*\*: \(.*\)$/\1/p')
  if [[ ${actual} != "${expected}" ]]; then
    echo "error: failed to update ${readme} line ${version_line}" >&2
    echo "  found: ${actual} (expected ${expected})" >&2
    exit 1
  fi
done <<<"${pairs}"

cat "${tmp}" >"${readme}"
echo "updated README versions"
