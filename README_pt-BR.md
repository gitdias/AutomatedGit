# AutoGit

## Choose your language / Escolha seu idioma

  - [English](README.en-US.md)
  - [Português (Brasil)](README.pt-BR.md)

> Automatize seu fluxo Git diário — commit, push, tag e muito mais com um único comando.

[![Version](https://img.shields.io/badge/version-0.1.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

---

## Visão Geral

**AutoGit** é um shell script (compatível com `bash` e `zsh`) que automatiza as operações Git mais comuns, reduzindo o atrito no dia a dia de um desenvolvedor.

Funcionalidades previstas para a versão estável:
- Commit, push e criação de tags automatizados
- Validação de autenticação SSH antes do push
- Wizard interativo de configuração SSH
- Configuração de identidade Git (local/global)
- Suporte a i18n: `pt_BR` (padrão) e `en_US` (fallback)
- Instalador e atualizador atômicos com suporte a backup

---

## Instalação

> Instalador ainda não disponível. Será entregue em versão futura.

Certifique-se de que `~/.local/bin/autogit` está no seu `PATH`:

```bash
export PATH="$HOME/.local/bin/autogit:$PATH"
```

---

## Uso

```bash
autogit <comando> [opções]
```

| Comando | Descrição |
|---------|-----------|
| `help` | Exibe os comandos disponíveis |
| `version` | Exibe a versão atual do AutoGit |

---

## Suporte a i18n / Locale

O AutoGit detecta o locale do sistema via `$LANG`, `$LANGUAGE` ou `$LC_ALL` (nessa ordem de prioridade).

| Locale | Arquivo | Status |
|--------|---------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Padrão |
| `en_US` | `i18n/en_US.lang` | Fallback |

Para adicionar um novo locale, crie um arquivo `<locale>.lang` em `~/.local/bin/autogit/i18n/` seguindo o formato chave=valor dos arquivos existentes.

---