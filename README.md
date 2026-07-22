# Dotfiles

Configuração pessoal de máquina para macOS.

## Estrutura

```
dotfiles/
├── README.md
├── install.sh              # Script principal de instalação
├── Brewfile                # Dependências do Homebrew
│
├── git/
│   ├── .gitconfig
│   └── .gitignore_global
│
├── shell/
│   ├── .zshrc              # Configuração principal do Zsh
│   ├── .zprofile           # Carregado no login
│   ├── .zshenv             # Variáveis de ambiente
│   └── modules/
│       ├── path.zsh        # Configuração de PATH
│       ├── aliases.zsh     # Aliases
│       ├── prompt.zsh      # Configuração do Spaceship
│       ├── languages.zsh   # pyenv, rbenv, nvm
│       └── completions.zsh # Autocompletions
│
├── ssh/
│   ├── config.template     # Template para SSH config
│   └── config              # SSH config real (gitignored)
│
├── macos/
│   ├── .macos              # Preferências do macOS
│   └── themes/
│       └── alfred/         # Temas Catppuccin para o Alfred
│
├── backup/                 # Backups automáticos (gitignored)
│
└── scripts/
    ├── backup.sh              # Backup de arquivos existentes
    ├── symlink.sh             # Criação de symlinks
    ├── validate.sh            # Validação do ambiente
    └── setup-ssh-by-dir.sh    # Troca de contexto (SSH/npm/gcloud) por diretório
```

## Instalação

### Nova máquina

```bash
# Clonar o repositório
git clone https://github.com/SEU_USUARIO/dotfiles.git ~/dotfiles

# Executar instalação
cd ~/dotfiles
./install.sh
```

### Atualizar dotfiles

```bash
cd ~/dotfiles
git pull
./scripts/symlink.sh
source ~/.zshrc
```

## Ferramentas Incluídas

### Linguagens

- **Python** via pyenv + virtualenv
- **Node.js** via nvm
- **Ruby** via rbenv
- **Go**
- **Rust**

### Desenvolvimento

- Docker via Colima
- Terraform
- AWS CLI
- Git

### Terminal

- Oh My Zsh
- Tema Spaceship
- eza (substituto moderno do ls)

## Personalização

### Ajustes manuais (paths absolutos)

Alguns arquivos versionados contêm caminhos absolutos com o usuário `wosantos`.
Ao instalar em **outra máquina ou usuário**, ajuste manualmente para o seu `$HOME`
antes (ou logo após) rodar o `install.sh`:

| Arquivo                       | O que ajustar                                                                                 |
| ----------------------------- | --------------------------------------------------------------------------------------------- |
| `git/.gitconfig`              | `includeIf "gitdir:…/Latam/**"`, `path = …/Latam/.gitconfig-local` e `excludesfile = …/.gitignore_global` |
| `ssh/config.template`         | `Include /Users/wosantos/.colima/ssh_config` (path do Colima)                                 |
| `scripts/setup-ssh-by-dir.sh` | `Include …/.colima/ssh_config` gerado no `ssh/config`, e os contextos `~/Latam` / `~/Personal` |
| `shell/.zshrc`                | Linha `export PATH=".../.local/bin/codeen:$PATH"` (adicionada por instalador; específica da máquina) |

Dica para localizar todas as ocorrências:

```bash
grep -rn '/Users/wosantos' ~/dotfiles --exclude-dir=.git --exclude-dir=backup
```

> Muitos desses caminhos poderiam usar `~` ou `$HOME` em vez do caminho absoluto —
> o ajuste manual acima é a solução enquanto não forem tornados portáveis.

### Configurações locais

Crie `~/.zshrc.local` para configurações específicas da máquina que não devem ser versionadas:

```bash
# ~/.zshrc.local
export API_KEY="sua-chave-aqui"
alias projeto="cd ~/caminho/projeto"
```

### SSH

O arquivo `ssh/config.template` é um template. Copie para `~/.ssh/config` e ajuste conforme necessário.

O `ssh/config` real é gitignored — pode conter hosts e chaves específicos da máquina.

### Contexto por diretório (SSH / npm / gcloud)

O script `scripts/setup-ssh-by-dir.sh` configura a troca automática de contexto de
desenvolvimento conforme o diretório atual, via hook `chpwd` no `.zshrc`:

| Diretório      | SSH                   | npm        | gcloud       |
| -------------- | --------------------- | ---------- | ------------ |
| `~/Latam`      | `id_ed25519_latam`    | `LATAMXP`  | `ifec-latam` |
| `~/Personal`   | `id_ed25519_personal` | `personal` | `personal`   |
| fora (default) | unset                 | `default`  | unset        |

Ele exporta `GIT_SSH_COMMAND`, `NPM_CONFIG_USERCONFIG` e `CLOUDSDK_ACTIVE_CONFIG_NAME`
ao entrar em cada diretório. O bloco gerado no `.zshrc` fica entre os marcadores
`# >>> dir-context-switcher begin/end <<<` — **não edite manualmente**, reexecute o script.

```bash
bash scripts/setup-ssh-by-dir.sh --dry-run   # mostra o que seria feito
bash scripts/setup-ssh-by-dir.sh             # aplica
```

### Preferências do macOS

`macos/.macos` ajusta preferências do sistema (teclado, Finder, Dock, screenshots, etc.).
O `install.sh` pergunta se você quer aplicá-lo (**default: não**), pois ele exige `sudo`
e reinicia apps como Dock e Finder. Para aplicar manualmente a qualquer momento:

```bash
bash ~/dotfiles/macos/.macos
```

Algumas mudanças só têm efeito após logout/restart.

### Temas do Alfred

`macos/themes/alfred/` contém temas [Catppuccin](https://github.com/catppuccin/catppuccin)
(`.alfredappearance`). Dê duplo-clique no arquivo desejado para importá-lo no Alfred.

## Backup

Para criar um backup das configurações atuais:

```bash
./scripts/backup.sh
```

Os backups são salvos em `backup/` com timestamp.

## Validação

Para verificar se todas as ferramentas estão funcionando:

```bash
./scripts/validate.sh
```

## Atualizar Brewfile

Para capturar todas as dependências instaladas:

```bash
brew bundle dump --force --file=~/dotfiles/Brewfile
```
