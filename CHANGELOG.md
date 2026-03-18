# Changelog

All notable changes to AutoGit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.3.0] — 2026-03-18

### Added
- `modules/push.sh` — new push module with remote/branch resolution and SSH validation
- `module_push()` — public entry point: supports `--remote`, `--branch` and `--dry-run`
- `_push_resolve_remote()` — resolves and validates remote existence via `git remote get-url`
- `_push_resolve_branch()` — resolves current branch via `git rev-parse --abbrev-ref HEAD`
- `_push_extract_host()` — extracts hostname from SSH (`git@host:...`) and HTTPS remote URLs
- `_push_test_ssh()` — tests SSH authentication via `ssh -T git@<host>` with i18n error handling
- `_push_execute()` — performs `git push <remote> <branch>` respecting `--dry-run`
- SSH validation flow: detects SSH vs HTTPS remote, tests connection, reports failures via i18n
- Support for GitHub (`github.com`) and GitLab (`gitlab.com`) SSH fingerprint messages
- `autogit push` registered in the main dispatcher and `cmd_help()`
- `--push` flag added to `autogit commit` (autonomous mode)
- `--remote` and `--branch` flags added to `autogit commit` (passed through to push)
- Interactive post-commit prompt: asks whether to push now or accumulate more commits
- `_commit_ask_push()` — isolated function handling the post-commit push decision
- i18n keys added for all push and SSH messages in `pt_BR.lang` and `en_US.lang`

### Changed
- `modules/commit.sh` updated: added `--push`, `--remote`, `--branch` flag parsing
- `modules/commit.sh` updated: `_commit_execute()` now calls `_commit_ask_push()` after success
- `autogit` main script bumped to v0.3.0
- `cmd_help()` updated to list `push` command with flags

### Notes
- Push of tags (`git push --tags`) is intentionally excluded — planned for v0.4.0
- Full SSH wizard (key generation, ssh-agent, multi-platform tutorials) planned for v0.5.0
- For HTTPS remotes, SSH validation is skipped and push proceeds directly
- If SSH validation fails, AutoGit reports the failure clearly and exits — key setup wizard comes in v0.5.0

---

## [0.2.0] — 2026-03-18

### Added
- Modular architecture: commands now live in `modules/` and are loaded on demand
- `modules/commit.sh` — commit module with interactive and autonomous modes
- Interactive wizard: prompts for tag title, tag message and commit message
- Autonomous mode: `autogit commit --tag <v> --msgtag <file> --msgcommit <file>`
- `--dry-run` global flag: simulates operations without applying any changes
- `--lang / -l` global flag: overrides system locale at runtime
- `-h / --help` support at both global and command level
- `_autogit_load_module()` — safe module loader with existence check
- `_autogit_parse_globals()` — pre-parser for global flags before dispatch
- `_commit_read_message()` — resolves message from inline string or file path
- `_commit_has_changes()` — detects staged or unstaged changes before commit
- `_commit_interactive()` — interactive wizard flow
- `_commit_autonomous()` — CLI argument parser for autonomous mode
- `_commit_execute()` — performs `git add --all`, `git commit` and `git tag -a`
- i18n keys added: all commit-related messages in `pt_BR.lang` and `en_US.lang`
- i18n keys added: global options help strings in both locale files

### Changed
- `autogit` main script bumped to v0.2.0
- `_autogit_load_locale()` now supports runtime override via `AUTOGIT_LANG_OVERRIDE`
- `cmd_help()` updated to list `commit` command and global options
- Project structure updated: `modules/` directory added

### Notes
- Calling `autogit` with no arguments launches the interactive commit wizard
- Tag is created as an annotated tag (`git tag -a`) with the resolved tag message
- Push is not yet implemented — planned for v0.3.0

---

## [0.1.0] — 2026-03-17

### Added
- Main entry point script (`autogit`) with strict mode (`set -euo pipefail`)
- i18n subsystem with locale auto-detection via `$LANG`, `$LANGUAGE`, `$LC_ALL`
- `pt_BR.lang` — Brazilian Portuguese locale (default)
- `en_US.lang` — English locale (fallback)
- Graceful fallback chain: detected locale → `en_US` → hardcoded error
- Output helper functions: `msg_info`, `msg_warn`, `msg_die`, `msg_fmt`
- Dependency check: validates `git` presence before any operation
- Git repository guard: `_autogit_require_repo()` for future commands
- Command dispatcher: `_autogit_dispatch()` routing via `case` statement
- Built-in commands: `help` and `version`
- Compatible with `bash 4+` and `zsh 5+`
- Project structure: `~/.local/bin/autogit/` with `i18n/` subdirectory

### Notes
- Foundation release. No user-facing automation commands yet.
- Installer and updater planned for a future release.