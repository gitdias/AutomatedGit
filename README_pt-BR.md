# AutoGit

> Automatize seu fluxo Git diário — commit, push, tag e muito mais com um único comando.

[![Version](https://img.shields.io/badge/version-0.2.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

[Português (Brasil)](README_pt-BR.md) | [English](README.md)

---

## Visão Geral

**AutoGit** é um shell script (compatível com `bash 4+` e `zsh 5+`) que automatiza as operações
Git mais comuns, reduzindo o atrito no dia a dia de um desenvolvedor.

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

Configuração manual (apenas para desenvolvimento):

```bash
mkdir -p ~/.local/bin/autogit/{i18n,modules}
cp autogit            ~/.local/bin/autogit/autogit
cp modules/commit.sh  ~/.local/bin/autogit/modules/commit.sh
cp i18n/pt_BR.lang    ~/.local/bin/autogit/i18n/
cp i18n/en_US.lang    ~/.local/bin/autogit/i18n/
chmod +x ~/.local/bin/autogit/autogit
```

Certifique-se de que `~/.local/bin/autogit` está no seu `PATH`:

```bash
export PATH="$HOME/.local/bin/autogit:$PATH"
```

---

## Uso

```bash
autogit [comando] [opções]
```

### Comandos

| Comando | Descrição |
|---------|-----------|
| `commit` | Cria commit e tag anotada (interativo ou autônomo) |
| `help` | Exibe comandos e opções disponíveis |
| `version` | Exibe a versão atual do AutoGit |

### Opções Globais

| Opção | Descrição |
|-------|-----------|
| `-h, --help` | Exibe ajuda |
| `-l, --lang <locale>` | Troca o idioma da sessão (ex: `en_US`, `pt_BR`) |
| `--dry-run` | Simula a operação sem aplicar nenhuma alteração |

---

## Commit — Modo Interativo

Execute `autogit` ou `autogit commit` sem argumentos para abrir o wizard:

=== AutoGit — Commit Interativo ===

Título ou versão da tag (ex: v0.2.0): v0.2.0 Mensagem da tag ou caminho do arquivo .msgtag [Enter = ./.msgtag]: .msgtag Mensagem do commit ou caminho do arquivo .msgcommit [Enter = ./.msgcommit]: .msgcommit

O wizard aceita tanto uma **mensagem literal** quanto um **caminho de arquivo**.
Pressionar `Enter` nos prompts de mensagem usa como padrão `./.msgtag` e `./.msgcommit` no diretório atual.

---

## Commit — Modo Autônomo

```bash
autogit commit --tag v0.2.0 --msgtag .msgtag --msgcommit .msgcommit
```

| Flag | Descrição |
|------|-----------|
| `--tag <valor>` | Título ou versão da tag |
| `--msgtag <arquivo\|msg>` | Mensagem da tag ou caminho do arquivo `.msgtag` |
| `--msgcommit <arquivo\|msg>` | Mensagem do commit ou caminho do arquivo `.msgcommit` |

---

## Modo Dry-run

Simule qualquer operação sem tocar no repositório:

```bash
autogit --dry-run commit --tag v0.2.0 --msgtag .msgtag --msgcommit .msgcommit
```

---

## Suporte a i18n / Locale

O AutoGit detecta o locale do sistema via `$LANG`, `$LANGUAGE` ou `$LC_ALL` (nessa ordem).
Você pode sobrescrever em tempo de execução com `--lang`:

```bash
autogit --lang pt_BR commit
```
| Locale | Arquivo | Status |
|--------|---------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Padrão |
| `en_US` | `i18n/en_US.lang` | Fallback |

Para adicionar um novo locale, crie um arquivo `<locale>.lang` em `~/.local/bin/autogit/i18n/`
seguindo o formato `chave=valor` dos arquivos existentes.

---

## Estrutura do Projeto

~/.local/bin/autogit/ ├── autogit # Executável principal — dispatcher e helpers core ├── modules/ │ └── commit.sh # Módulo de commit + tag ├── i18n/ │ ├── pt_BR.lang # Locale Português do Brasil (padrão) │ └── en_US.lang # Locale Inglês (fallback) └── .version # Controle de versão interno (em breve)

---

## Histórico de Versões

Consulte o [CHANGELOG.md](CHANGELOG.md) para o histórico completo de releases.

---

## Licença

[Apache-2.0](LICENSE) © Sandro Dias
