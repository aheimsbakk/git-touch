---
topic: "VERSION and scripts/ must stay tracked in git"
importance: high
category: decision
tags: [gitignore, versioning, release]
created: 2026-10-21T20:02:14Z
model: kompis/qwen3.8-flash-next-iq3_s
---

The root .gitignore previously hid VERSION and scripts/, which broke the
release trail: the version file existed only untracked while
scripts/bump-version.sh stayed tracked anyway. On 2026-10-21 both entries
were removed and VERSION added to git. The wrap-up workflow requires
VERSION and config files to remain tracked; never re-add them to .gitignore.
