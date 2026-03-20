# AutoGit

> Automatize seu fluxo Git diário — commit, push, tag e muito mais com um único comando.

[![Version](https://img.shields.io/badge/version-0.5.0-blue.svg)](CHANGELOG.md)
[![License](https://img.shields.io/badge/license-Apache--2.0-green.svg)](LICENSE)
[![Shell](https://img.shields.io/badge/shell-bash%20%7C%20zsh-lightgrey.svg)]()

[Português (Brasil)](README_pt-BR.md) | [English](README.md)

---

## Visão Geral

**AutoGit** é um shell script (compatível com `bash 4+` e `zsh 5+`) que automatiza as operações
Git mais comuns, reduzindo o atrito no dia a dia de um desenvolvedor.

Funcionalidades disponíveis nesta versão:
- Commit automatizado com criação de tag anotada
- Validação de formato de tag (`vX.Y.Z`) com verificação local e remota
- Push da branch com validação SSH (GitHub, GitLab, SourceForge, Codeberg)
- Push de tags como comando dedicado e explícito
- Wizard SSH: detecta/usa chaves existentes ou gera novas chaves ed25519
- Modo interativo (wizard) ou autônomo via CLI para todas as operações
- Suporte a i18n: `pt_BR` (padrão) e `en_US` (fallback)
- `--dry-run` para simulação segura de qualquer operação

Planejado:
- Configuração de identidade Git — v0.6.0
- Instalador e atualizador atômicos com backup — v0.7.0 / v0.8.0

---

## Instalação

> Instalador ainda não disponível. Será entregue em versão futura.

Configuração manual (apenas para desenvolvimento):

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
| `push` | Envia branch para o remote com validação SSH |
| `push-tags` | Envia todas as tags locais para o remote |
| `ssh-setup` | Wizard de configuração SSH (chave, ssh-agent, tutorial) |
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

```bash
autogit
autogit commit
```

Exemplo de fluxo:

=== AutoGit — Commit Interativo ===

Título ou versão da tag (ex: v0.5.0): v0.5.0 Mensagem da tag ou caminho do arquivo .msgtag [Enter = ./.msgtag]: Mensagem do commit ou caminho do arquivo .msgcommit [Enter = ./.msgcommit]:

Deseja fazer push agora ou acumular mais commits? [p=push / Enter=acumular]: Deseja fazer push das tags agora? [s/N]:

---

## Commit — Modo Autônomo

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit
```

Com push automático da branch após o commit:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit --push
```

Com push da branch e das tags:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --push-tags
```

Com remote e branch explícitos:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --push-tags --remote origin --branch main
```

| Flag | Descrição |
|------|-----------|
| `--tag <valor>` | Título ou versão da tag (validado contra `vX.Y.Z`) |
| `--msgtag <arquivo\|msg>` | Mensagem da tag ou caminho do arquivo `.msgtag` |
| `--msgcommit <arquivo\|msg>` | Mensagem do commit ou caminho do arquivo `.msgcommit` |
| `--push` | Faz push da branch após o commit |
| `--push-tags` | Faz push das tags após o commit (requer `--push`) |
| `--remote <nome>` | Nome do remote (padrão: `origin`) |
| `--branch <nome>` | Nome do branch (padrão: branch atual) |

---

## Push — Branch

```bash
autogit push
autogit push --remote upstream --branch develop
autogit --dry-run push
```

| Flag | Descrição |
|------|-----------|
| `--remote <nome>` | Nome do remote (padrão: `origin`) |
| `--branch <nome>` | Nome do branch (padrão: branch atual) |

### Validação SSH

Para remotes SSH (`git@host:...` ou `ssh://git@host/...`), o AutoGit:

1. Detecta se a URL do remote usa SSH ou HTTPS
2. Executa `ssh -T git@<host>` (BatchMode, timeout) para:
   - `github.com`, `gitlab.com`, `git.code.sf.net`, `codeberg.org`
3. Usa padrões de sucesso específicos de cada plataforma
4. Reporta falhas de autenticação e sugere `autogit ssh-setup`

Para remotes HTTPS, a validação SSH é ignorada e o push segue direto.

---

## Push — Tags

Tags são sempre enviadas em um comando separado e explícito:

```bash
autogit push-tags
autogit push-tags --remote upstream
autogit --dry-run push-tags
```

| Flag | Descrição |
|------|-----------|
| `--remote <nome>` | Nome do remote (padrão: `origin`) |

Fluxo:

1. Verifica se existem tags locais
2. Valida a conexão SSH (mesmo fluxo do `autogit push`)
3. Lista as tags que já existem no remote (avisa, não aborta)
4. Executa `git push <remote> --tags`

---

## Wizard de Configuração SSH

```bash
autogit ssh-setup
autogit ssh-setup --host github
autogit ssh-setup --host gitlab
autogit ssh-setup --host sourceforge
autogit ssh-setup --host codeberg
```

Fluxo:

1. Varre `~/.ssh` procurando pares de chaves:
   - `*_ed25519`, `id_ed25519`, `id_rsa`, `id_ecdsa`, `id_dsa` (com `.pub`)
2. Pergunta se você quer reutilizar uma chave existente ou criar uma nova
3. Se nova:
   - Seleciona o serviço (GitHub, GitLab, SourceForge, Codeberg)
   - Sugere o nome `~/.ssh/autogit_<serviço>_ed25519`
   - Solicita e-mail (comentário da chave)
   - Gera chave ed25519 **sem passphrase**
4. Inicia o `ssh-agent` (sessão atual) e executa `ssh-add <chave>`
5. Exibe a chave pública e um tutorial mínimo para o serviço escolhido
6. Aguarda você cadastrar a chave na plataforma
7. Retesta SSH com `ssh -T git@<host>` e informa sucesso ou falha

---

## Exemplo de Fluxo Completo de Release

```bash
# 1. Configurar SSH (uma vez, por serviço)
autogit ssh-setup --host github

# 2. Commit com tag anotada
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit

# 3. Push da branch
autogit push

# 4. Push das tags
autogit push-tags
```

Ou totalmente autônomo:

```bash
autogit commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit \
               --push --push-tags
```

---

## Modo Dry-run

```bash
autogit --dry-run commit --tag v0.5.0 --msgtag .msgtag --msgcommit .msgcommit
autogit --dry-run push
autogit --dry-run push-tags
```

---

## Suporte a i18n / Locale

| Locale | Arquivo | Status |
|--------|---------|--------|
| `pt_BR` | `i18n/pt_BR.lang` | Padrão |
| `en_US` | `i18n/en_US.lang` | Fallback |

Sobrescrever em tempo de execução:

```bash
autogit --lang pt_BR ssh-setup --host gitlab
```



---

## Estrutura do Projeto

~/.local/bin/autogit/
 ├── autogit # Executável principal — dispatcher e helpers core 
 ├── modules/ 
 │ ├── commit # Módulo de commit + tag 
 │ ├── push # Módulo de push de branch + validação SSH 
 │ ├── push_tags # Módulo de push de tags 
 │ └── ssh_setup # Wizard de configuração SSH 
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
