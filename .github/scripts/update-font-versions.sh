#!/usr/bin/env bash
set -euo pipefail

# Auto-bump font packages that track a GitHub release.
#
# Package metadata is obtained by *evaluating* the flake instead of scraping
# the source with sed. That way a package may write its URL either as a
# literal tag or as `"...v${version}/..."` interpolation; both resolve to the
# same download URL here.
#
# A package is eligible when its evaluated URL points at
#   https://github.com/<owner>/<repo>/releases/download/<tag>/<asset>
# and its `version` is tied to that tag, i.e. the tag is either
# `v<version>` or `<version>`.
#
# Sources hosted in this repository are skipped on purpose: those release
# assets are versioned by hand, and the repository's latest release tag is
# not the font's version.
#
# Only `version`, and `url` when the source carries a literal one, are
# rewritten. The hash is refreshed afterwards by update-font-hashes.sh.

root=$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
cd "$root"

command -v nix >/dev/null || {
  echo "error: nix is required" >&2
  exit 1
}

command -v gh >/dev/null || {
  echo "error: gh is required" >&2
  exit 1
}

command -v jq >/dev/null || {
  echo "error: jq is required" >&2
  exit 1
}

system=${FONT_SYSTEM:-x86_64-linux}

# The repository this workflow runs in, used to skip self-hosted sources.
repo_slug=${GITHUB_REPOSITORY:-}
if [[ -z ${repo_slug} ]]; then
  origin=$(git remote get-url origin 2>/dev/null || true)
  repo_slug=${origin#*github.com}
  repo_slug=${repo_slug#[:/]}
  repo_slug=${repo_slug%.git}
fi
echo "repository: ${repo_slug:-unknown}"

# Read every discovered package's version and *evaluated* src URL in one go.
metadata=$(nix eval --json "path:${root}#packages.${system}" --apply '
  ps: builtins.mapAttrs (n: v: {
    version = v.version or null;
    url = v.src.url or null;
  }) (removeAttrs ps [ "default" ])
')

is_newer() {
  local current=$1 candidate=$2
  [[ ${candidate} != "${current}" ]] || return 1
  [[ $(printf '%s\n%s\n' "${current}" "${candidate}" | sort -V | tail -n 1) == "${candidate}" ]]
}

select_asset_url() {
  local release_json=$1 current_asset=$2 old_version=$3 new_version=$4
  local url candidate ext
  local -a matches

  url=$(jq -r --arg name "${current_asset}" \
    '.assets[]? | select(.name == $name) | .browser_download_url' \
    <<<"${release_json}" | head -n 1)
  if [[ -n ${url} ]]; then
    printf '%s\n' "${url}"
    return 0
  fi

  candidate=${current_asset//${old_version}/${new_version}}
  if [[ ${candidate} != "${current_asset}" ]]; then
    url=$(jq -r --arg name "${candidate}" \
      '.assets[]? | select(.name == $name) | .browser_download_url' \
      <<<"${release_json}" | head -n 1)
    if [[ -n ${url} ]]; then
      printf '%s\n' "${url}"
      return 0
    fi
  fi

  ext=${current_asset##*.}
  mapfile -t matches < <(
    jq -r --arg ext ".${ext}" \
      '.assets[]? | select(.name | endswith($ext)) | .browser_download_url' \
      <<<"${release_json}"
  )
  if (( ${#matches[@]} == 1 )); then
    printf '%s\n' "${matches[0]}"
    return 0
  fi

  return 1
}

updated=0
skipped=0

for file in nix/*.nix; do
  label=$(basename "${file}" .nix)
  version=$(jq -r --arg n "${label}" '.[$n].version // empty' <<<"${metadata}")
  url=$(jq -r --arg n "${label}" '.[$n].url // empty' <<<"${metadata}")

  if [[ -z ${version} || -z ${url} ]]; then
    echo "[${label}] skip: no version/url"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ ! ${url} =~ ^https?://github\.com/([^/]+)/([^/]+)/releases/download/([^/]+)/(.+)$ ]]; then
    echo "[${label}] skip: not a GitHub release URL"
    skipped=$((skipped + 1))
    continue
  fi

  owner=${BASH_REMATCH[1]}
  repo=${BASH_REMATCH[2]}
  tag=${BASH_REMATCH[3]}
  asset=${BASH_REMATCH[4]}

  if [[ -n ${repo_slug} && ${owner,,}/${repo,,} == "${repo_slug,,}" ]]; then
    echo "[${label}] skip: source is hosted in this repository"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ ${tag} == "v${version}" ]]; then
    strip_v=true
  elif [[ ${tag} == "${version}" ]]; then
    strip_v=false
  else
    echo "[${label}] skip: tag '${tag}' is not tied to version '${version}'"
    skipped=$((skipped + 1))
    continue
  fi

  echo "[${label}] checking ${owner}/${repo}"

  if ! release_json=$(gh api "repos/${owner}/${repo}/releases/latest" 2>/dev/null); then
    echo "::warning file=${file}::could not fetch the latest release for ${owner}/${repo}"
    skipped=$((skipped + 1))
    continue
  fi

  latest_tag=$(jq -r '.tag_name // empty' <<<"${release_json}")
  if [[ -z ${latest_tag} ]]; then
    echo "[${label}] skip: no published release found"
    skipped=$((skipped + 1))
    continue
  fi

  if [[ ${strip_v} == true ]]; then
    latest_version=${latest_tag#v}
  else
    latest_version=${latest_tag}
  fi

  if [[ ${latest_version} == "${version}" ]]; then
    echo "[${label}] up to date: ${version} (latest tag ${latest_tag})"
    continue
  fi

  if ! is_newer "${version}" "${latest_version}"; then
    echo "[${label}] skip: current version ${version} is newer than latest release ${latest_version}"
    skipped=$((skipped + 1))
    continue
  fi

  if ! new_url=$(select_asset_url "${release_json}" "${asset}" "${version}" "${latest_version}"); then
    echo "::warning file=${file}::release ${latest_tag} has no matching asset for '${asset}'"
    skipped=$((skipped + 1))
    continue
  fi

  echo "[${label}] updating ${version} -> ${latest_version}"
  echo "  url: ${new_url}"

  # The url substitution below only matches sources that store a literal
  # URL. Interpolated sources pick the new tag up from the version bump.
  OLD_VERSION=${version} NEW_VERSION=${latest_version} \
    OLD_URL=${url} NEW_URL=${new_url} \
    perl -0pi -e '
      s/^([ \t]*version = ")\Q$ENV{OLD_VERSION}\E(";)/$1$ENV{NEW_VERSION}$2/m;
      s/^([ \t]*url = ")\Q$ENV{OLD_URL}\E(";)/$1$ENV{NEW_URL}$2/m;
    ' "${file}"

  # Confirm against Nix itself rather than trusting the text substitution.
  actual_version=$(nix eval --raw "path:${root}#${label}.version")
  actual_url=$(nix eval --raw "path:${root}#${label}.src.url")
  if [[ ${actual_version} != "${latest_version}" || ${actual_url} != "${new_url}" ]]; then
    echo "error: failed to update ${file}" >&2
    echo "  version: ${actual_version} (expected ${latest_version})" >&2
    echo "  url: ${actual_url} (expected ${new_url})" >&2
    exit 1
  fi

  updated=$((updated + 1))
done

echo "version updates: ${updated}; skipped: ${skipped}"
