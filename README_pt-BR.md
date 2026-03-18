# AutoGit

> Automatize seu fluxo Git diário — commit, push, tag e muito mais com um único comando.

[![Version](https://img.shields.io/badge/version-0.3.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

[Português (Brasil)](README_pt-BR.md) | [English](README.md)

---

## Visão Geral

**AutoGit** é um shell script (compatível com `bash 4+` e `zsh 5+`) que automatiza as operações
Git mais comuns, reduzindo o atrito no dia a dia de um desenvolvedor.

Funcionalidades disponíveis nesta versão:
- Commit automatizado com criação de tag anotada
- Push com validação SSH (GitHub e GitLab)
- Modo interativo (wizard) ou autônomo via CLI
- Suporte a i18n: `pt_BR` (padrão) e `en_US` (fallback)
- `--dry-run` para simulação segura de qualquer operação

Funcionalidades previstas para a versão estável:
- Push de tags (`--tags`) — v0.4.0
- Wizard completo de configuração SSH — v0.5.0
- Configuração de identidade Git — v0.6.0
- Instalador e atualizador atômicos com backup — v0.7.0 / v0.8.0

---

## Instalação

> Instalador ainda não disponível. Será entregue em versão futura.

Configuração manual (apenas para desenvolvimento):

```bash
mkdir -p ~/.local/bin/autogit/{i18n,modules}
cp autogit              ~/.local/bin/autogit/autogit
cp modules/commit.sh    ~/.local/bin/autogit/modules/commit.sh
cp modules/push.sh      ~/.local/bin/autogit/modules/push.sh
cp i18n/pt_BR.lang      ~/.local/bin/autogit/i18n/
cp i18n/en_US.lang      ~/.local/bin/autogit/i18n/
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
| `push` | Envia para o remote com validação SSH |
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

Título ou versão da tag (ex: v0.3.0): v0.3.0 Mensagem da tag ou caminho do arquivo .msgtag [Enter = ./.msgtag]: Mensagem do commit ou caminho do arquivo .msgcommit [Enter = ./.msgcommit]:

Deseja fazer push agora ou acumular mais commits? [p=push / Enter=acumular]:

---

## Commit — Modo Autônomo

```bash
autogit commit --tag v0.3.0 --msgtag .msgtag --msgcommit .msgcommit
```

Com push automático após o commit:

```bash
autogit commit --tag v0.3.0 --msgtag .msgtag --msgcommit .msgcommit --push
```

Com remote e branch explícitos:

```bash
autogit commit --tag v0.3.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --remote origin --branch main
```



| Flag | Descrição |
|------|-----------|
| `--tag <valor>` | Título ou versão da tag |
| `--msgtag <arquivo\|msg>` | Mensagem da tag ou caminho do arquivo `.msgtag` |
| `--msgcommit <arquivo\|msg>` | Mensagem do commit ou caminho do arquivo `.msgcommit` |
| `--push` | Faz push após o commit (modo autônomo) |
| `--remote <nome>` | Nome do remote (padrão: `origin`) |
| `--branch <nome>` | Nome do branch (padrão: branch atual) |

---

## Push — Comando Separado

```bash
autogit push
autogit push --remote upstream --branch develop
autogit --dry-run push --remote origin --branch main
```

| Flag | Descrição |
|------|-----------|
| `--remote <nome>` | Nome do remote (padrão: `origin`) |
| `--branch <nome>` | Nome do branch (padrão: branch atual) |

### Validação SSH

Antes de fazer o push, o AutoGit:
1. Detecta se a URL do remote usa SSH (`git@host`) ou HTTPS
2. Para remotes SSH, executa `ssh -T git@<host>` e valida a resposta
3. Reporta falhas de autenticação de forma clara via mensagens i18n
4. Para remotes HTTPS, ignora a validação SSH e faz o push diretamente

> Wizard completo de configuração SSH (geração de chave, ssh-agent, tutoriais por plataforma) disponível na v0.5.0.

---

## Modo Dry-run

```bash
autogit --dry-run push
autogit --dry-run commit --tag v0.3.0 --msgtag .msgtag --msgcommit .msgcommit --push
```

---

## Suporte a i18n / Locale

O AutoGit detecta o locale do sistema via `$LANG`, `$LANGUAGE` ou `$LC_ALL` (nessa ordem).
Você pode sobrescrever em tempo de execução com `--lang`:

```bash
autogit --lang pt_BR push
```


| Locale | Arquivo | Status |
|--------|---------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Padrão |
| `en_US` | `i18n/en_US.lang` | Fallback |

---

## Estrutura do Projeto

~/.local/bin/autogit/
  ├── autogit # Executável principal — dispatcher e helpers core
  ├── modules/
  │ ├── commit.sh # Módulo de commit + tag
  │ └── push.sh # Módulo de push + validação SSH 
  ├── i18n/ 
  │ ├── pt_BR.lang # Locale Português do Brasil (padrão) 
  │ └── en_US.lang # Locale Inglês (fallback) 
  └── .version # Controle de versão interno (em breve)

---

## Histórico de Versões

Consulte o [CHANGELOG.md](CHANGELOG.md) para o histórico completo de releases.

---

## Licença

[Apache-2.0](LICENSE) © Sandro Dias
