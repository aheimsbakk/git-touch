# Contributing

Developer guide for the `git-touch` project: setup, checks, scripts, and the
commit workflow. User documentation lives in `README.md`.

## Setup

The product and the helper scripts are plain Bash. You need:

- Bash (POSIX/GNU) and `git` on your PATH.
- Nothing else. There is no package manager, build step, or dependency
  install.

## Checks

There is no test framework in this repository. Run these checks after
changes:

1. Syntax check every script:

   ```
   bash -n git-touch.sh scripts/bump-version.sh scripts/verify_codebase_sync.sh scripts/validate-changelog.sh
   ```

2. Smoke-test the product without touching any repository:

   ```
   ./git-touch.sh --help
   ./git-touch.sh -V
   ./git-touch.sh -n .
   ```

   `-n` is the dry-run mode; it prints planned actions and changes nothing.

3. Validate documentation sync (see the scripts below).

## Scripts

### scripts/bump-version.sh

Increments the version in `VERSION` and rewrites the two version markers in
`git-touch.sh` so all three stay identical.

```
./scripts/bump-version.sh patch   # 0.3.0 -> 0.3.1
./scripts/bump-version.sh minor   # 0.3.0 -> 0.4.0
./scripts/bump-version.sh major   # 0.3.0 -> 1.0.0
```

Warning: the script rewrites the markers with spacing-sensitive text
patterns. It only matches `# Version:` followed by five spaces, and a line
that starts with a version variable assignment in double quotes. If you
reformat those lines in `git-touch.sh`, update the patterns in this script
and check both markers after every bump.

### scripts/verify_codebase_sync.sh

Checks that every file path referenced in `CODEBASE.md` exists. Paths that
are generated in other repositories (such as the touch file named in the
contracts) are listed in the script's exclude variable. Exits non-zero and
prints each missing path.

```
scripts/verify_codebase_sync.sh
```

Run it after any change that adds, renames, or deletes files, and update
`CODEBASE.md` in the same change.

### scripts/validate-changelog.sh

Checks `CHANGELOG.md` structure: the first line is the changelog heading,
every version header uses the form `## [major.minor.patch] - YYYY-MM-DD`,
the newest entry matches `VERSION`, and every version section carries the
why, model, and tags metadata bullets.

```
scripts/validate-changelog.sh
```

## Release workflow

1. Decide the bump: fix or refactor is a patch, an addition is a minor, a
   breaking change is a major. Bump once per task.
2. Run `scripts/bump-version.sh <level>`.
3. Add a version section to `CHANGELOG.md` at the top, newest first, with
   why/model/tags bullets and change bullets grouped under Added, Changed,
   Fixed, Removed, or Security.
4. Run `scripts/validate-changelog.sh` and
   `scripts/verify_codebase_sync.sh`.
5. Update `BLUEPRINT.md` and `CODEBASE.md` before the final feature or fix
   commit; remove orphaned paths.
6. Commit with Conventional Commits
   (`<type>(<scope>): <summary>`, 50 characters or fewer, imperative mood).
   Documentation sync uses `docs(sync)`.

## Documentation rules

- `README.md` is user-facing only. This file holds developer setup, script
  usage, and workflow.
- Keep `VERSION`, `git-touch.sh` version markers, and the newest
  `CHANGELOG.md` section identical.
- `docs/memory/` stores session decisions and warnings; keep the index rows
  in sync with the archive files.
