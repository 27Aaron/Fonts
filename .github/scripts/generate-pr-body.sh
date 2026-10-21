#!/usr/bin/env bash
set -euo pipefail

# Build the pull request body from the changes in the working tree.
# Run this after the version/hash updaters and before create-pull-request.
# The first argument is the output file, e.g. "$RUNNER_TEMP/pr-body.md".

if [[ $# -ne 1 ]]; then
  echo "usage: $0 <output-file>" >&2
  exit 2
fi

output=$1
root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$root"

command -v jq >/dev/null || {
  echo "error: jq is required" >&2
  exit 1
}

changes=()

# flake.lock: report the nixpkgs date, falling back to short revisions when
# the lock moved more than once on the same day.
if ! git diff --quiet -- flake.lock; then
  old_lock=$(git show HEAD:flake.lock)
  new_lock=$(cat flake.lock)

  old_rev=$(jq -r '.nodes.nixpkgs.locked.rev // empty' <<<"${old_lock}")
  new_rev=$(jq -r '.nodes.nixpkgs.locked.rev // empty' <<<"${new_lock}")
  old_date=$(jq -r '.nodes.nixpkgs.locked.lastModified // empty | if type == "number" then (todate[0:10]) else . end' <<<"${old_lock}")
  new_date=$(jq -r '.nodes.nixpkgs.locked.lastModified // empty | if type == "number" then (todate[0:10]) else . end' <<<"${new_lock}")

  if [[ -n ${old_rev} && -n ${new_rev} && ${old_rev} != "${new_rev}" ]]; then
    if [[ -n ${old_date} && -n ${new_date} && ${old_date} != "${new_date}" ]]; then
      changes+=("- \`flake.lock\`: nixpkgs \`${old_date}\` → \`${new_date}\`")
    else
      changes+=("- \`flake.lock\`: nixpkgs \`${old_rev:0:12}\` → \`${new_rev:0:12}\`")
    fi
  else
    changes+=("- \`flake.lock\`: inputs refreshed")
  fi
fi

# Font packages: version changes are the interesting ones. If only the asset
# was replaced under the same version, report the hash refresh instead.
for file in nix/*.nix; do
  [[ -e ${file} ]] || continue
  label=$(basename "${file}" .nix)

  if ! git cat-file -e "HEAD:${file}" 2>/dev/null; then
    changes+=("- \`${label}\`: new package")
    continue
  fi

  old_content=$(git show "HEAD:${file}")
  old_version=$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";.*/\1/p' <<<"${old_content}" | head -n 1)
  new_version=$(sed -n 's/^[[:space:]]*version = "\([^"]*\)";.*/\1/p' "${file}" | head -n 1)
  old_hash=$(sed -n 's/^[[:space:]]*hash = "\([^"]*\)";.*/\1/p' <<<"${old_content}" | head -n 1)
  new_hash=$(sed -n 's/^[[:space:]]*hash = "\([^"]*\)";.*/\1/p' "${file}" | head -n 1)

  if [[ -n ${old_version} && -n ${new_version} && ${old_version} != "${new_version}" ]]; then
    changes+=("- \`${label}\`: \`${old_version}\` → \`${new_version}\`")
  elif [[ -n ${old_hash} && -n ${new_hash} && ${old_hash} != "${new_hash}" ]]; then
    changes+=("- \`${label}\`: source hash refreshed")
  fi
done

mkdir -p "$(dirname "${output}")"
{
  cat <<'EOF'
This PR refreshes:

- `flake.lock` via `nix flake update`
- versions and URLs for GitHub-release-backed packages in `nix/*.nix`
- fixed-output hashes for release assets in `nix/*.nix`
- the `**Version**` lines in `README.md`

### Changes

EOF

  if (( ${#changes[@]} > 0 )); then
    printf '%s\n' "${changes[@]}"
  else
    printf '%s\n' "- See the diff for details."
  fi

  cat <<'EOF'

Fonts hosted in this repository are skipped by the version updater and remain manually versioned. The result was validated with `nix build .#default --no-link`.
EOF
} >"${output}"

echo "wrote ${output}"
