#!/usr/bin/env bash
# Bump the app version stored in version.txt.
#
# Usage:
#   ./bump.sh           # bump patch (default)
#   ./bump.sh patch     # 1.0.0 -> 1.0.1
#   ./bump.sh minor     # 1.0.5 -> 1.1.0
#   ./bump.sh major     # 1.4.7 -> 2.0.0
#
# Run before `git commit` so the new version ships with the change.

set -euo pipefail
cd "$(dirname "$0")"

PART="${1:-patch}"
FILE="version.txt"

if [[ ! -f "$FILE" ]]; then
  echo "Error: $FILE not found" >&2
  exit 1
fi

current=$(tr -d '[:space:]' < "$FILE")
if ! [[ "$current" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
  echo "Error: $FILE must contain MAJOR.MINOR.PATCH (got '$current')" >&2
  exit 1
fi

IFS='.' read -r major minor patch <<< "$current"

case "$PART" in
  major) major=$((major + 1)); minor=0; patch=0 ;;
  minor) minor=$((minor + 1)); patch=0 ;;
  patch) patch=$((patch + 1)) ;;
  *) echo "Usage: $0 [major|minor|patch]" >&2; exit 1 ;;
esac

new="${major}.${minor}.${patch}"
printf '%s\n' "$new" > "$FILE"
echo "Bumped: v${current} -> v${new}"
