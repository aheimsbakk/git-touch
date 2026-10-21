# Codebase

Physical file map for the architecture in `BLUEPRINT.md`.

## Repository Structure

```
/work
├── AGENTS.md                  # master agent workflow rules
├── BLUEPRINT.md               # architecture specification
├── CHANGELOG.md               # release history (Keep a Changelog)
├── CODEBASE.md                # this file
├── CONTRIBUTING.md            # developer guide and script usage
├── README.md                  # user documentation
├── VERSION                    # single-source version number
├── .gitignore                 # environment and temporary files
├── git-touch.sh               # product: CLI entry, processor, identity, reporter
├── docs/
│   └── memory/                # session memory index and archived entries
└── scripts/
    ├── bump-version.sh        # version tooling
    ├── validate-changelog.sh  # changelog structure check
    └── verify_codebase_sync.sh# CODEBASE.md path check
```

`.opencode/` holds the AI tooling configuration (rules, agents, skills,
template updater). It is workflow tooling, not product surface, and is not
mapped to Blueprint components.

## Blueprint Component -> Physical Paths

| Component                  | Path                          | Notes                                    |
|----------------------------|-------------------------------|------------------------------------------|
| CLI Entry                  | `git-touch.sh`                | Argument loop and usage output           |
| Repository Processor       | `git-touch.sh`                | The repository run function              |
| Identity Manager           | `git-touch.sh`                | Identity resolution function             |
| Reporter                   | `git-touch.sh`                | Five leveled log helpers                 |
| Version Tooling            | `scripts/bump-version.sh`     | Rewrites markers in `git-touch.sh`       |
| Version file               | `VERSION`                     | Read by version tooling                  |
| Changelog                  | `CHANGELOG.md`                | Validated by `scripts/validate-changelog.sh` |
| Documentation Sync Tooling | `scripts/verify_codebase_sync.sh` | Checks the paths in this file      |

## Entry Points

- Product: `git-touch.sh` (executable; run as `./git-touch.sh [OPTIONS] [PATH...]`).
- Version bump: `scripts/bump-version.sh [patch|minor|major]`.
- Sync check: `scripts/verify_codebase_sync.sh` (no arguments; run from any
  directory).
- Changelog check: `scripts/validate-changelog.sh` (no arguments).

## Specifications

- Language: shell (Bash). Runtime dependency: the `git` command. No package
  manager and no third-party libraries.
- Naming: `kebab-case` for files and directories. Exception: the sync-check
  script name given in `AGENTS.md` keeps its underscore form because that
  document mandates the exact path.
- Commits follow Conventional Commits; documentation updates use the
  `docs(sync)` type.
- The `README.touched` file named in the contracts is generated in target
  repositories; it never exists in this repository.

## Language Rationale

- Bash was chosen so the product runs on any machine that has a shell and
  git, with nothing to install; the Blueprint goal of shell-and-git-only
  dependencies maps directly to a single script file.
- All four product components stay in one file (currently just over the
  200-line review threshold). Splitting a Bash program across files would
  require sourcing, which breaks the copy-a-single-file deployment the
  dependency-free goal implies. The file was reviewed against the split
  rule and kept whole for this reason.
- The version markers in `git-touch.sh` are plain comment and assignment
  lines so `scripts/bump-version.sh` can rewrite them with text patterns.
  The patterns are spacing-sensitive; `CONTRIBUTING.md` records the exact
  forms so reformatting does not silently break the sync.
