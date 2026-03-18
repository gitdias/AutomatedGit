# Changelog

All notable changes to AutoGit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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