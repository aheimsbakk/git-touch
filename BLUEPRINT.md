# Blueprint

Language-agnostic architecture specification for the `git-touch` utility and
its release tooling.

## System Goals

- Update many local Git repositories in one run by writing the current date
  to a `README.touched` file in each repository root.
- Keep every action reviewable: a dry-run mode previews all changes, and the
  run never commits when nothing changed.
- Depend only on a shell and the `git` command; no third-party libraries.
- Keep the product version synchronized across the version file, the script,
  and the changelog.

## Component Hierarchy

1. **CLI Entry** — parses options and path arguments; reports usage; decides
   the process exit status.
2. **Repository Processor** — validates, syncs, touches, commits, and pushes
   one repository.
3. **Identity Manager** — resolves the Git author for a repository: command
   line override, then existing local configuration, then a fallback bot
   identity.
4. **Reporter** — emits leveled status messages (info, success, warning,
   error, dry-run). Errors go to the error stream; everything else to the
   output stream.
5. **Version Tooling** — a separate script that increments the stored version
   and rewrites the version markers inside the main script.
6. **Documentation Sync Tooling** — scripts that verify `CODEBASE.md` paths
   and `CHANGELOG.md` structure.

## Data Flow

Option flags and a path list flow from the CLI Entry to the Repository
Processor once per path, in order. Each repository run reads repository
state (branch, identity, diff), writes the touch file, and produces status
messages. A failure in one repository increments an error counter and the
loop continues with the next path. The final exit status is success only if
the counter is zero.

## State Management

- No shared in-memory state beyond option flags, the path list, and the error
  counter for the run.
- Persistent state lives outside the tool: in each target repository the file
  `README.touched` (one ISO date line) and the local Git identity
  configuration; in this project the version file, the version markers in the
  main script, and the changelog.
- Processing is strictly sequential; no concurrency exists, so no locking is
  required.

Repository run state machine (per path):

`validate -> reject-if-detached-head -> sync-with-upstream -> ensure-identity
-> write-touch-file -> commit-if-changed -> push -> done`

Any arrow that fails ends the run for that repository with a recorded error;
it never aborts other repositories.

## Contracts

**Entry point:** `git-touch.sh [OPTIONS] [PATH...]`

- `PATH...` — one or more directories, each the root of a Git working tree.
- Options: dry-run flag; name override (non-empty value); email override
  (non-empty value); help; version.
- An unknown option, a missing option value, or zero paths prints usage and
  exits with the failure status.

**Exit statuses:**

- `0` — every path processed without error.
- `1` — bad usage, or at least one path failed.

**Output schema:** one status line per action, prefixed with a level marker
(`INFO`, `OK`, `WARN`, `ERR`, `DRY`). In dry-run mode every mutating action
is announced with the dry-run marker and no file or Git state changes.

## Error Boundaries

- Per-repository isolation: one failed repository never stops the others.
- Missing directory, not a Git working tree, and detached head are rejected
  before any mutation.
- Network operations (sync, push) are the only externally failure-prone
  steps; their failure marks that repository failed and asks for manual
  intervention.
- The version tooling must fail loudly when the current version cannot be
  parsed.

## Persistence

- `README.touched` (generated in target repositories): plain text, a single
  line, format `YYYY-MM-DD`, newline terminated.
- Version file (this project): plain text, a single line in
  `major.minor.patch` form.
- The main script carries two version markers (a header comment and a
  variable) that the version tooling rewrites; they must always equal the
  version file.
- `CHANGELOG.md` (this project): newest version first; each version section
  records reason, model, tags, and categorized change bullets.

## External Dependencies

- A POSIX-compatible shell and the `git` command on the execution path.
- Network access and valid credentials (SSH key, credential helper, or token)
  for sync and push, unless dry-run mode is used.
- The date must come from the system clock; no service authentication beyond
  what Git itself requires.
