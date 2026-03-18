# AutoGit

## Choose your language / Escolha seu idioma

  - [English](README.en-US.md)
  - [Português (Brasil)](README.pt-BR.md)

> Automate your daily Git workflow — commit, push, tag and more, from a single command.

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

---

## Overview

**AutoGit** is a shell script (compatible with `bash` and `zsh`) that automates the most common Git operations, reducing friction in a developer's daily workflow.

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

Make sure `~/.local/bin/autogit` is in your `PATH`:

```bash
export PATH="$HOME/.local/bin/autogit:$PATH"
```

---

## Usage

```bash
autogit <command> [options]
```

| Command | Description |
|---------|-------------|
| `help` | Show available commands |
| `version` | Show current AutoGit version |

---

## i18n / Locale Support

AutoGit detects your system locale via `$LANG`, `$LANGUAGE` or `$LC_ALL` (in that order).

| Locale | File | Status |
|--------|------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Default |
| `en_US` | `i18n/en_US.lang` | Fallback |

To add a new locale, create a `<locale>.lang` file in `~/.local/bin/autogit/i18n/` following the existing key=value format.

---