# AutoGit

> Automate your daily Git workflow — commit, push, tag and more, from a single command.

[![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

[English](README.md) | [Português (Brasil)](README_pt-BR.md)

---

## Overview

**AutoGit** is a shell script (compatible with `bash 4+` and `zsh 5+`) that automates the most
common Git operations, reducing friction in a developer's daily workflow.

Features planned for stable release:
- Automated commit, push and tag operations
- SSH authentication validation before push
- Interactive SSH setup wizard
- Git identity configuration (local/global)
- i18n support: `pt_BR` (default) and `en_US` (fallback)
- Atomic installer and updater with backup support

---

## Installation

> Installer not yet available. Coming in a future release.

Manual setup (development only):

```bash
mkdir -p ~/.local/bin/autogit/{i18n,modules}
cp autogit            ~/.local/bin/autogit/autogit
cp modules/commit.sh  ~/.local/bin/autogit/modules/commit.sh
cp i18n/pt_BR.lang    ~/.local/bin/autogit/i18n/
cp i18n/en_US.lang    ~/.local/bin/autogit/i18n/
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

Tag title or version (e.g.: v0.2.0): v0.2.0 Tag message or path to .msgtag file [Enter = ./.msgtag]: .msgtag Commit message or path to .msgcommit file [Enter = ./.msgcommit]: .msgcommit

The wizard accepts either a **direct message string** or a **file path**.
Pressing `Enter` on message prompts defaults to `./.msgtag` and `./.msgcommit` in the current directory.

---

## Commit — Autonomous Mode


```bash
autogit commit --tag v0.2.0 --msgtag .msgtag --msgcommit .msgcommit
```

| Flag | Description |
|------|-------------|
| `--tag <value>` | Tag title or version |
| `--msgtag <file\|msg>` | Tag message or path to `.msgtag` file |
| `--msgcommit <file\|msg>` | Commit message or path to `.msgcommit` file |

---

## Dry-run Mode

Simulate any operation without touching the repository:

```bash
autogit --dry-run commit --tag v0.2.0 --msgtag .msgtag --msgcommit .msgcommit
```

---

## i18n / Locale Support

AutoGit detects your system locale via `$LANG`, `$LANGUAGE` or `$LC_ALL` (in that order).
You can override it at runtime with `--lang`:

```bash
autogit --lang en_US commit
```

| Locale | File | Status |
|--------|------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Default |
| `en_US` | `i18n/en_US.lang` | Fallback |

To add a new locale, create a `<locale>.lang` file in `~/.local/bin/autogit/i18n/`
following the existing `key=value` format.

---

## Project Structure

~/.local/bin/autogit/
  ├── autogit # Main executable — dispatcher and core helpers
  ├── modules/ 
  │ └── commit.sh # Commit + tag module 
  ├── i18n/ │ 
  ├── pt_BR.lang # Brazilian Portuguese locale (default) 
  │ └── en_US.lang # English locale (fallback) 
  └── .version # Internal version tracking (coming soon)

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for full release history.

---

## License

[Apache-2.0](LICENSE) © Sandro Dias

