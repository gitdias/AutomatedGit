# Changelog

All notable changes to AutoGit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

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
- This is a foundation release. No user-facing automation commands yet.
- Installer and updater are planned for a future release.