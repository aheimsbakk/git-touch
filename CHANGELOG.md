# Changelog

All notable changes to this project are documented here. The format follows
[Keep a Changelog](https://keepachangelog.com/en/1.1.0/). Version numbers
come from the `VERSION` file.

## [0.3.0] - 2026-10-21

- **why:** Fix documentation drift and add the required workflow documents
- **model:** kompis/qwen3.8-flash-next-iq3_s
- **tags:** docs, changelog, gitignore, workflow

### Added

- `BLUEPRINT.md`, `CODEBASE.md`, and `CONTRIBUTING.md`
- `CHANGELOG.md`, converted from `docs/worklogs/`
- `scripts/verify_codebase_sync.sh` and `scripts/validate-changelog.sh`
- `docs/memory/` index with decisions from this task
- Skills under `.opencode/skills/`: wrap-up, memory, todo-txt,
  clear-language, clear-language-norwegian

### Changed

- `.gitignore` no longer hides `VERSION` and `scripts/`; both are now tracked
- README version text corrected to match the script
- README formatting: inline code for commands and options, fenced blocks for
  examples (committed 2026-04-05)

### Removed

- `docs/worklogs/` (replaced by this file)
- Legacy agents `architect`, `brainstorm`, `builder`, `pm`, `qa` and
  `.opencode/WORKLOG_TEMPLATE.md`

## [0.2.2] - 2026-04-05

- **why:** Routine patch bump with the version synced into git-touch.sh
- **model:** opencode/big-pickle
- **tags:** version, bump

### Changed

- Version set to 0.2.2; `scripts/bump-version.sh` now updates both the
  `VERSION` file and the version markers inside `git-touch.sh`

## [0.1.0] - 2026-04-05

- **why:** Add project documentation and refine agent configuration
- **model:** opencode/big-pickle
- **tags:** docs, config, agent

### Added

- `README.md` documenting the `git-touch.sh` utility
- `scripts/bump-version.sh` for version management
- Instructions list in `opencode.json` pointing at the rules files

### Changed

- `.opencode/agents/vibe.md` now uses top_p instead of temperature
