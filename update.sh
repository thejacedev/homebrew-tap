#!/usr/bin/env bash
# Point Casks/noteriv.rb at a Noteriv release.
#
#   ./update.sh           latest published release
#   ./update.sh 2.4.9     a specific release
#
# Does nothing (exit 0) when the cask is already current, when the requested
# release is older than the cask, or when the release has not finished
# uploading its .dmg yet.
set -euo pipefail
cd "$(dirname "$0")"

REPO="thejacedev/Noteriv"
CASK="Casks/noteriv.rb"

out() { [ -n "${GITHUB_OUTPUT:-}" ] && echo "$1" >> "$GITHUB_OUTPUT"; return 0; }
api() {
  local auth=()
  [ -n "${GH_TOKEN:-}" ] && auth=(-H "Authorization: Bearer $GH_TOKEN")
  curl -fsSL "${auth[@]}" -H "Accept: application/vnd.github+json" "https://api.github.com/repos/$REPO/$1"
}
sha256() { if command -v sha256sum >/dev/null; then sha256sum; else shasum -a 256; fi | cut -d' ' -f1; }

want="${1:-}"; want="${want#v}"
if [ -n "$want" ] && ! [[ "$want" =~ ^[0-9]+(\.[0-9]+){1,3}$ ]]; then
  echo "Not a version number: '$want'" >&2; exit 1
fi
if [ -n "$want" ]; then rel=$(api "releases/tags/v$want"); else rel=$(api "releases/latest"); fi

version=$(jq -r '.tag_name' <<<"$rel"); version="${version#v}"
current=$(sed -n -E 's/^  version "([^"]+)"$/\1/p' "$CASK")
[ -n "$current" ] || { echo "Could not read the version from $CASK" >&2; exit 1; }
out "changed=false"

if [ "$version" = "$current" ]; then
  echo "Already at $current."; exit 0
fi
if [ "$(printf '%s\n%s\n' "$version" "$current" | sort -V | tail -1)" != "$version" ]; then
  echo "Release $version is older than the cask ($current); leaving it alone."; exit 0
fi

asset="Noteriv_${version}_universal.dmg"
url=$(jq -r --arg n "$asset" '.assets[] | select(.name == $n) | .browser_download_url' <<<"$rel")
if [ -z "$url" ]; then
  echo "Release v$version has no $asset yet; try again later."; exit 0
fi

digest=$(jq -r --arg n "$asset" '.assets[] | select(.name == $n) | .digest // empty' <<<"$rel")
if [[ "$digest" == sha256:* ]]; then
  hash="${digest#sha256:}"
else
  hash=$(curl -fsSL "$url" | sha256)
fi
[[ "$hash" =~ ^[0-9a-f]{64}$ ]] || { echo "Bad sha256 for $asset: '$hash'" >&2; exit 1; }

sed -i.bak -E \
  -e "s/^  version \"[^\"]+\"$/  version \"$version\"/" \
  -e "s/^  sha256 \"[0-9a-f]{64}\"$/  sha256 \"$hash\"/" \
  "$CASK"
rm -f "$CASK.bak"

echo "Updated $CASK: $current -> $version"
out "changed=true"
out "version=$version"
