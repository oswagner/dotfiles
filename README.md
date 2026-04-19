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
│   └── config.template     # Template para SSH config
│
├── vscode/
│   ├── settings.json
│   └── extensions.txt
│
├── macos/
│   └── .macos              # Preferências do macOS
│
├── backup/                 # Backups automáticos (gitignored)
│
└── scripts/
    ├── backup.sh           # Backup de arquivos existentes
    ├── symlink.sh          # Criação de symlinks
    └── validate.sh         # Validação do ambiente
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

### Configurações locais

Crie `~/.zshrc.local` para configurações específicas da máquina que não devem ser versionadas:

```bash
# ~/.zshrc.local
export API_KEY="sua-chave-aqui"
alias projeto="cd ~/caminho/projeto"
```

### SSH

O arquivo `ssh/config.template` é um template. Copie para `~/.ssh/config` e ajuste conforme necessário.

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
