# Changelog

All notable changes to AutoGit will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [0.5.0] — 2026-03-19

### Added
- `modules/ssh_setup` — new SSH setup wizard module
- `module_ssh_setup()` — public entry point: `autogit ssh-setup [--host github|gitlab|sourceforge|codeberg]`
- `_ssh_scan_keys()` — scans `~/.ssh` for existing key pairs:
  - Detects `*_ed25519`, `id_ed25519`, `id_rsa`, `id_ecdsa`, `id_dsa` with matching `.pub`
- `_ssh_prompt_use_existing()` — lists existing keys and allows selecting one or creating a new key
- `_ssh_detect_service_from_keyname()` — infers service (github/gitlab/sourceforge/codeberg) from key file name
- `_ssh_prompt_service()` — interactive selection of version control service
- `_ssh_prompt_keyname()` — suggests key name `~/.ssh/autogit_<service>_ed25519` and lets user override
- `_ssh_generate_key()` — generates ed25519 key without passphrase (`ssh-keygen -N ""`)
- `_ssh_start_agent()` — starts `ssh-agent` (session-only) and runs `ssh-add <key>`
- `_ssh_show_pubkey()` — displays public key in a highlighted block
- `_ssh_show_tutorial()` — shows minimal copy-paste tutorials for:
  - GitHub, GitLab, SourceForge, Codeberg
- `_ssh_retest()` — re-tests SSH auth via `ssh -T git@<host>` with retry loop
- `_ssh_service_host()` / `_ssh_service_success_pattern()` — per-service host mapping and success patterns
- `ssh-setup` command registered in dispatcher and `cmd_help()`
- i18n keys for SSH wizard added to `pt_BR.lang` and `en_US.lang`

### Changed
- Module loader `_autogit_load_module()` now loads files without `.sh` extension
- All modules renamed (no extension):
  - `modules/commit.sh` → `modules/commit`
  - `modules/push.sh` → `modules/push`
  - `modules/push_tags.sh` → `modules/push_tags`
- `MSG_PUSH_SSH_HINT2` updated to reference `autogit ssh-setup` as the recommended way to configure SSH
- `autogit` main script bumped to v0.5.0
- `cmd_help()` updated to list `ssh-setup` command

### Notes
- SSH wizard supports four services: GitHub, GitLab, SourceForge and Codeberg
- Keys are generated **without passphrase**, optimized for automation
- `ssh-agent` is configured only for the current shell session; no changes to shell rc files
- Push behavior remains split:
  - `autogit push` → branch only
  - `autogit push-tags` → tags only

---

## [0.4.0] — 2026-03-19

### Added
- `modules/push_tags.sh` — new push-tags module with local/remote tag validation
- `module_push_tags()` — public entry point: supports `--remote` and `--dry-run`
- `_push_tags_check_local()` — verifies local tags exist before any network operation
- `_push_tags_check_remote()` — lists remote tags via `git ls-remote --tags`
- `_push_tags_report_skipped()` — warns about tags already present on the remote
- `_push_tags_execute()` — performs `git push <remote> --tags` with dry-run support
- `autogit push-tags` registered in main dispatcher and `cmd_help()`
- `--push-tags` flag added to `autogit commit` (autonomous mode)
- `_commit_ask_push_tags()` — isolated function for interactive post-push tag prompt
- `_commit_validate_tag()` — validates tag format (`vX.Y.Z`) and existence
  - Checks local tag existence via `git tag --list`
  - Checks remote tag existence via `git ls-remote --tags`
  - Interactive mode: warns on bad format and asks for confirmation
  - Autonomous mode: aborts immediately on bad format or existing tag
- i18n keys added for tag validation and push-tags in `pt_BR.lang` and `en_US.lang`

### Changed
- `modules/commit.sh` updated: added `--push-tags` flag parsing in `_commit_autonomous()`
- `modules/commit.sh` updated: `_commit_interactive()` now calls `_commit_validate_tag()`
- `modules/commit.sh` updated: `_commit_ask_push()` now calls `_commit_ask_push_tags()` after branch push
- `modules/commit.sh` updated: `module_commit()` handles `--push-tags` in autonomous flow
- `autogit` dispatcher updated: `push-tags` loads both `push.sh` and `push_tags.sh`
- `autogit` main script bumped to v0.4.0
- `cmd_help()` updated to list `push-tags` command

### Notes
- `push-tags` reuses SSH validation helpers from `push.sh` — no duplication
- `--push-tags` without `--push` in autonomous mode is silently ignored
- Branch push remains `git push <remote> <branch>`; tag push is `git push <remote> --tags`

---

## [0.3.1] — 2026-03-18

### Fixed
- `_push_resolve_remote()`: redirect all `msg_fmt` and `msg_info` calls to stderr
- `_push_resolve_branch()`: redirect `msg_fmt` call to stderr
- Prevent log output from polluting stdout when functions are captured via `$()`
- Root cause: corrupted URL string was reaching `_push_extract_host()`, triggering
  "unrecognized protocol" error on every push attempt
- Replace `echo` with `printf` in `_push_test_ssh()` for consistency

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
- `modules/commit.sh` updated: `module_commit()` calls `_commit_ask_push()` after success
- `autogit` main script bumped to v0.3.0
- `cmd_help()` updated to list `push` command with flags

### Notes
- Push of tags (`git push --tags`) intentionally excluded — delivered in v0.4.0
- Full SSH wizard (key generation, ssh-agent, multi-platform tutorials) delivered in v0.5.0
- For HTTPS remotes, SSH validation is skipped and push proceeds directly

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