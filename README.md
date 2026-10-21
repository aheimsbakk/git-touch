`git-touch.sh` — update `README.touched` across multiple Git repositories

Synopsis
--------

```
git-touch.sh [OPTIONS] [PATH...]
```

Description
-----------

`git-touch.sh` is a small, dependency-free Bash utility that updates one or more local Git repositories by writing the current ISO date (`YYYY-MM-DD`) into a file named `README.touched`, committing the change if any, and pushing it to the repository's current branch.

Version
-------

0.3.0

Requirements
------------

- bash (POSIX / GNU)
- `git` available on PATH
- network access for `git pull`/`git push` (unless running dry-run)

Usage
-----

Run:
```
./git-touch.sh [OPTIONS] [PATH...]
```

Options
-------

- `-n`, `--dry-run`   simulate actions; do not change files or git state
- `-u`, `--name NAME` set `git user.name` for this operation (local repo config)
- `-e`, `--email EMAIL` set `git user.email` for this operation (local repo config)
- `-h`, `--help`      show help and exit
- `-V`              show script version and exit

Examples
--------

Dry run:
```
./git-touch.sh -n ./repo1 ./repo2
```

Set commit identity and run:
```
./git-touch.sh -u "CI Bot" -e "ci@example.com" ./repo1
```

How it works
------------

1. Validates each PATH is a directory and a Git working tree.
2. Rejects repositories in detached HEAD state.
3. Pulls latest changes from the configured remote branch.
4. Ensures a git identity is configured (uses CLI overrides; falls back to local config; sets `Git Touch Bot <automation@bot.local>` if none).
5. Writes the current date (`YYYY-MM-DD`) to `README.touched` in the repository root.
6. Stages the file and commits with message: `docs: touch update <YYYY-MM-DD>` if there is any change.
7. Pushes the commit to the repository's current branch.

Behavior & notes
----------------

- The script modifies local `git` config `user.name` and `user.email` only when overrides are supplied or when it applies a fallback identity.
- Commits are created only if `README.touched` differs from `HEAD`.
- In `--dry-run` mode the script prints the operations it would perform without making changes.
- Exit status: `0` on success; non-zero if one or more repositories failed to process.

Troubleshooting
---------------

- `"Not a valid git repository"`: verify the path points to a cloned repository with a `.git` directory.
- `"Detached HEAD"`: checkout a branch before running the script.
- `git pull` or `git push` failures: ensure network access and valid credentials (SSH key, credential helper, or token).

Safety & audit
--------------

- Review commits before pushing when running in production. Use `--dry-run` to preview actions.
- The script writes a small, deterministic file; use usual code-review and approval workflows if used in automation.

Author
------

Senior Sysadmin

Files
-----

- `git-touch.sh` — primary script (version 0.3.0)

License
-------

No license specified.

See also
--------

Run `./git-touch.sh --help` for the full built-in usage text.
