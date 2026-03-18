# AutoGit

> Automate your daily Git workflow — commit, push, tag and more, from a single command.

[![Version](https://img.shields.io/badge/version-0.3.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

[English](README.md) | [Português (Brasil)](README_pt-BR.md)

---

## Overview

**AutoGit** is a shell script (compatible with `bash 4+` and `zsh 5+`) that automates the most
common Git operations, reducing friction in a developer's daily workflow.

Features available in this release:
- Automated commit with annotated tag creation
- Push with SSH validation (GitHub and GitLab)
- Interactive wizard or autonomous CLI mode
- i18n support: `pt_BR` (default) and `en_US` (fallback)
- `--dry-run` for safe simulation of any operation

Features planned for stable release:
- Push of tags (`--tags`) — v0.4.0
- Full SSH setup wizard — v0.5.0
- Git identity configuration — v0.6.0
- Atomic installer and updater with backup support — v0.7.0 / v0.8.0

---

## Installation

> Installer not yet available. Coming in a future release.

Manual setup (development only):

```bash
mkdir -p ~/.local/bin/autogit/{i18n,modules}
cp autogit              ~/.local/bin/autogit/autogit
cp modules/commit.sh    ~/.local/bin/autogit/modules/commit.sh
cp modules/push.sh      ~/.local/bin/autogit/modules/push.sh
cp i18n/pt_BR.lang      ~/.local/bin/autogit/i18n/
cp i18n/en_US.lang      ~/.local/bin/autogit/i18n/
chmod +x ~/.local/bin/autogit/autogit
```

Make sure `~/.local/bin/autogit` is in your `PATH`:

```bash
export PATH="$HOME/.local/bin/autogit:$PATH"
```

---

## Usage

```bash
autogit [command] [options]
```

### Commands

| Command | Description |
|---------|-------------|
| `commit` | Create a commit and annotated tag (interactive or autonomous) |
| `push` | Push to remote with SSH validation |
| `help` | Show available commands and options |
| `version` | Show current AutoGit version |

### Global Options

| Option | Description |
|--------|-------------|
| `-h, --help` | Show help |
| `-l, --lang <locale>` | Override session language (e.g.: `en_US`, `pt_BR`) |
| `--dry-run` | Simulate operation without applying any changes |

---

## Commit — Interactive Mode

Run `autogit` or `autogit commit` with no arguments to launch the wizard:

=== AutoGit — Interactive Commit ===

Tag title or version (e.g.: v0.3.0): v0.3.0 Tag message or path to .msgtag file [Enter = ./.msgtag]: Commit message or path to .msgcommit file [Enter = ./.msgcommit]:

Push now or accumulate more commits? [p=push / Enter=accumulate]:

---

## Commit — Autonomous Mode

```bash
autogit commit --tag v0.3.0 --msgtag .msgtag --msgcommit .msgcommit
```

With automatic push after commit:

```bash
autogit commit --tag v0.3.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --remote origin --branch main
```

| Flag | Description |
|------|-------------|
| `--tag <value>` | Tag title or version |
| `--msgtag <file\|msg>` | Tag message or path to `.msgtag` file |
| `--msgcommit <file\|msg>` | Commit message or path to `.msgcommit` file |
| `--push` | Push after commit (autonomous mode) |
| `--remote <name>` | Remote name (default: `origin`) |
| `--branch <name>` | Branch name (default: current branch) |

---

## Push — Standalone

```bash
autogit push
autogit push --remote upstream --branch develop
autogit --dry-run push --remote origin --branch main
```

| Flag | Description |
|------|-------------|
| `--remote <name>` | Remote name (default: `origin`) |
| `--branch <name>` | Branch name (default: current branch) |

### SSH Validation

Before pushing, AutoGit:
1. Detects whether the remote URL uses SSH (`git@host`) or HTTPS
2. For SSH remotes, runs `ssh -T git@<host>` and validates the response
3. Reports authentication failures clearly via i18n messages
4. For HTTPS remotes, skips SSH validation and pushes directly

> Full SSH setup wizard (key generation, ssh-agent, platform tutorials) coming in v0.5.0.

---

## Dry-run Mode

```bash
autogit --dry-run push
autogit --dry-run commit --tag v0.3.0 --msgtag .msgtag --msgcommit .msgcommit --push
```


---

## i18n / Locale Support

AutoGit detects your system locale via `$LANG`, `$LANGUAGE` or `$LC_ALL` (in that order).
Override at runtime with `--lang`:

```bash
autogit --lang en_US push
```

| Locale | File | Status |
|--------|------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Default |
| `en_US` | `i18n/en_US.lang` | Fallback |

---

## Project Structure

~/.local/bin/autogit/ ├── autogit # Main executable — dispatcher and core helpers ├── modules/ │ ├── commit.sh # Commit + tag module │ └── push.sh # Push + SSH validation module ├── i18n/ │ ├── pt_BR.lang # Brazilian Portuguese locale (default) │ └── en_US.lang # English locale (fallback) └── .version # Internal version tracking (coming soon)

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for full release history.

---

## License

[Apache-2.0](LICENSE) © Sandro Dias