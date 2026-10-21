---
topic: "bump-version.sh sed patterns are spacing-sensitive"
importance: medium
category: warning
tags: [versioning, sed, scripts, footgun]
created: 2026-10-21T20:02:14Z
model: kompis/qwen3.8-flash-next-iq3_s
---

scripts/bump-version.sh rewrites git-touch.sh with sed patterns that
require exact text: "# Version:" plus five spaces, and a VERSION variable
assignment line. Reformatting those lines in git-touch.sh makes the sync
fail silently, because sed exits 0 on no match. Grep both markers after
every bump, or update the patterns together with the formatting.
