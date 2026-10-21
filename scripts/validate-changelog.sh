#!/bin/bash
# validate-changelog.sh - check CHANGELOG.md against the wrap-up workflow
# rules: heading first, versioned sections in the required header form,
# why/model/tags metadata in every section, newest entry equal to VERSION.
#
# Usage: scripts/validate-changelog.sh   (run from anywhere)

set -u

cd "$(dirname "$0")/.." || exit 1

CHANGELOG="CHANGELOG.md"
VERSION_FILE="VERSION"
errors=0

if [[ ! -f "$CHANGELOG" ]]; then
	echo "MISSING: $CHANGELOG"
	exit 1
fi

if [[ "$(head -n 1 "$CHANGELOG")" != "# Changelog" ]]; then
	echo "FAIL: first line of $CHANGELOG must be '# Changelog'"
	errors=$((errors + 1))
fi

# Every version header must read: ## [X.Y.Z] - YYYY-MM-DD
while IFS= read -r header; do
	if [[ ! "$header" =~ ^\#\#\ \[[0-9]+\.[0-9]+\.[0-9]+\]\ -\ [0-9]{4}-[0-9]{2}-[0-9]{2}$ ]]; then
		echo "FAIL: bad version header: $header"
		errors=$((errors + 1))
	fi
done < <(grep '^## \[' "$CHANGELOG")

# Newest entry must match the version file.
newest=$(grep -oE '^## \[[0-9]+\.[0-9]+\.[0-9]+\]' "$CHANGELOG" |
	head -n 1 | tr -d '#[] ')
if [[ -f "$VERSION_FILE" ]]; then
	version=$(tr -d '[:space:]' <"$VERSION_FILE")
	if [[ "$newest" != "$version" ]]; then
		echo "FAIL: newest changelog version '$newest' != VERSION '$version'"
		errors=$((errors + 1))
	fi
fi

# Each version section must carry the why, model, and tags metadata bullets.
sections_missing_meta=$(awk '
    /^## \[/ {
        if (section != "" && meta != 3) print section
        section = $0
        meta = 0
    }
    /\*\*(why|model|tags):\*\*/ { meta++ }
    END { if (section != "" && meta != 3) print section }
' "$CHANGELOG")
if [[ -n "$sections_missing_meta" ]]; then
	while IFS= read -r section; do
		echo "FAIL: missing why/model/tags in: $section"
		errors=$((errors + 1))
	done <<<"$sections_missing_meta"
fi

if [[ $errors -gt 0 ]]; then
	echo "Changelog validation failed with $errors error(s)."
	exit 1
fi
echo "Changelog OK (newest: $newest)."
exit 0
