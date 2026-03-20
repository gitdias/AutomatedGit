# AutoGit

> Automate your daily Git workflow — commit, push, tag and more, from a single command.

[![Version](https://img.shields.io/badge/version-0.5.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

[English](README.md) | [Português (Brasil)](README_pt-BR.md)

---

## Overview

**AutoGit** is a shell script (compatible with `bash 4+` and `zsh 5+`) that automates the most
common Git operations, reducing friction in a developer's daily workflow.

Features available in this release:
- Automated commit with annotated tag creation
- Tag format validation (`vX.Y.Z`) with local and remote existence checks
- Push branch with SSH validation (GitHub, GitLab, SourceForge, Codeberg)
- Push tags as a dedicated, explicit command
- SSH setup wizard: detect/use existing keys or generate new ed25519 keys
- Interactive wizard or autonomous CLI mode for all operations
- i18n support: `pt_BR` (default) and `en_US` (fallback)
- `--dry-run` for safe simulation of any operation

Planned:
- Git identity configuration — v0.6.0
- Atomic installer and updater with backup support — v0.7.0 / v0.8.0

---

## Installation

> Installer not yet available. Coming in a future release.

Manual setup (development only):

```bash
mkdir -p ~/.local/bin/autogit/{i18n,modules}
cp autogit                  ~/.local/bin/autogit/autogit
cp modules/commit           ~/.local/bin/autogit/modules/commit
cp modules/push             ~/.local/bin/autogit/modules/push
cp modules/push_tags        ~/.local/bin/autogit/modules/push_tags
cp modules/ssh_setup        ~/.local/bin/autogit/modules/ssh_setup
cp i18n/pt_BR.lang          ~/.local/bin/autogit/i18n/
cp i18n/en_US.lang          ~/.local/bin/autogit/i18n/
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
| `push` | Push current branch to remote with SSH validation |
| `push-tags` | Push all local tags to remote |
| `ssh-setup` | SSH setup wizard (key, ssh-agent, platform tutorial) |
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

```bash
autogit
autogit commit
```

Example flow:

=== AutoGit — Interactive Commit ===

Tag title or version (e.g.: v0.5.0): v0.5.0 Tag message or path to .msgtag file [Enter = ./.msgtag]: Commit message or path to .msgcommit file [Enter = ./.msgcommit]:

Push now or accumulate more commits? [p=push / Enter=accumulate]: Push tags now? [y/N]:

---

## Commit — Autonomous Mode

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit
``` 

With automatic branch push after commit:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit --push
```

With branch push and tag push:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --push-tags
```

With explicit remote and branch:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --push-tags --remote origin --branch main
```

| Flag | Description |
|------|-------------|
| `--tag <value>` | Tag title or version (validated against `vX.Y.Z`) |
| `--msgtag <file\|msg>` | Tag message or path to `.msgtag` file |
| `--msgcommit <file\|msg>` | Commit message or path to `.msgcommit` file |
| `--push` | Push branch after commit |
| `--push-tags` | Push tags after commit (requires `--push`) |
| `--remote <name>` | Remote name (default: `origin`) |
| `--branch <name>` | Branch name (default: current branch) |

---

## Push — Branch

```bash
autogit push
autogit push --remote upstream --branch develop
autogit --dry-run push
```


| Flag | Description |
|------|-------------|
| `--remote <name>` | Remote name (default: `origin`) |
| `--branch <name>` | Branch name (default: current branch) |

### SSH Validation

For SSH remotes (`git@host:...` or `ssh://git@host/...`), AutoGit:

1. Detects SSH vs HTTPS from the remote URL
2. Runs `ssh -T git@<host>` (BatchMode, timeout) for:
   - `github.com`, `gitlab.com`, `git.code.sf.net`, `codeberg.org`
3. Matches platform-specific success patterns
4. Reports failures clearly and suggests running `autogit ssh-setup`

For HTTPS remotes, SSH validation is skipped and push proceeds directly.

---

## Push — Tags

Tags are always pushed in a separate, explicit command:


```bash
autogit push-tags
autogit push-tags --remote upstream
autogit --dry-run push-tags
```


| Flag | Description |
|------|-------------|
| `--remote <name>` | Remote name (default: `origin`) |

Flow:

1. Verify local tags exist
2. Validate SSH connection (same as `autogit push`)
3. List tags already on remote (warn, do not abort)
4. Run `git push <remote> --tags`

---

## SSH Setup Wizard

```bash
autogit ssh-setup
autogit ssh-setup --host github
autogit ssh-setup --host gitlab
autogit ssh-setup --host sourceforge
autogit ssh-setup --host codeberg
```

Flow:

1. Scan `~/.ssh` for key pairs:
   - `*_ed25519`, `id_ed25519`, `id_rsa`, `id_ecdsa`, `id_dsa` (with `.pub`)
2. Ask whether to reuse an existing key or create a new one
3. If new:
   - Select service (GitHub, GitLab, SourceForge, Codeberg)
   - Suggest key name `~/.ssh/autogit_<service>_ed25519`
   - Ask for email (comment)
   - Generate ed25519 key **without passphrase**
4. Start `ssh-agent` for the current session and `ssh-add` the key
5. Display public key and service-specific tutorial (minimal steps)
6. Wait for you to register the key on the platform
7. Re-test SSH with `ssh -T git@<host>` and report success/failure

---

## Example Full Release Workflow

```bash
# 1. Configure SSH once (if needed)
autogit ssh-setup --host github

# 2. Commit with annotated tag
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit

# 3. Push branch
autogit push

# 4. Push tags
autogit push-tags
```

Or fully autonomous:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --push-tags
```

---

## Dry-run Mode

```bash
autogit --dry-run commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit
autogit --dry-run push
autogit --dry-run push-tags
```

---

## i18n / Locale Support

| Locale | File | Status |
|--------|------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Default |
| `en_US` | `i18n/en_US.lang` | Fallback |

Override at runtime:

```bash
autogit --lang en_US ssh-setup --host gitlab
```
---

## Project Structure

~/.local/bin/autogit/
 ├── autogit # Main executable — dispatcher and core helpers 
 ├── modules/ 
 │ ├── commit # Commit + tag module 
 │ ├── push # Push branch + SSH validation module 
 │ ├── push_tags # Push tags module 
 │ └── ssh_setup # SSH setup wizard module 
 ├── i18n/ 
 │ ├── pt_BR.lang # Brazilian Portuguese locale (default) 
 │ └── en_US.lang # English locale (fallback) 
 └── .version # Internal version tracking (coming soon)

---

## Changelog

See [CHANGELOG.md](CHANGELOG.md) for full release history.

---

## License

[Apache-2.0](LICENSE) © Sandro Dias
