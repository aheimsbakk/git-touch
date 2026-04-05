#!/bin/bash
# Bump version script
# Usage: ./scripts/bump-version.sh [patch|minor|major]
# Updates version in: VERSION file, git-touch.sh

set -e

LEVEL="${1:-patch}"
VERSION_FILE="VERSION"
SCRIPT_FILE="git-touch.sh"

read_version() {
	if [[ -f "$VERSION_FILE" ]]; then
		cat "$VERSION_FILE"
	else
		echo "0.0.0"
	fi
}

bump() {
	local ver="$1"
	local level="$2"
	IFS='.' read -r major minor patch <<<"$ver"

	case "$level" in
	major) echo "$((major + 1)).0.0" ;;
	minor) echo "$major.$((minor + 1)).0" ;;
	patch) echo "$major.$minor.$((patch + 1))" ;;
	*) echo "$ver" ;;
	esac
}

update_script_version() {
	local new_ver="$1"
	local script="$SCRIPT_FILE"

	if [[ -f "$script" ]]; then
		# Update version comment: # Version:     X.Y.Z
		sed -i "s/# Version:     [0-9.]*/# Version:     $new_ver/" "$script"
		# Update VERSION variable: VERSION="X.Y.Z"
		sed -i "s/^VERSION=\"[0-9.]*\"/VERSION=\"$new_ver\"/" "$script"
	fi
}

current=$(read_version)
new=$(bump "$current" "$LEVEL")
echo "$new" >"$VERSION_FILE"
update_script_version "$new"
echo "$new"
