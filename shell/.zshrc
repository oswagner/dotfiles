# =============================================================================
# .zshrc - Zsh Configuration
# Managed by dotfiles: https://github.com/wosantos/dotfiles
# =============================================================================

# Diretório dos módulos
DOTFILES_MODULES="$HOME/dotfiles/shell/modules"

# -----------------------------------------------------------------------------
# Oh My Zsh
# -----------------------------------------------------------------------------
export ZSH="$HOME/.oh-my-zsh"

# Carregar configuração do prompt ANTES do Oh My Zsh
source "$DOTFILES_MODULES/prompt.zsh"

# Plugins do Oh My Zsh
plugins=(
  git
  sudo
  web-search
  heroku
  copypath
  zsh-nvm
)

source $ZSH/oh-my-zsh.sh

# -----------------------------------------------------------------------------
# Carregar módulos
# -----------------------------------------------------------------------------

# PATH - Configuração de caminhos de executáveis
source "$DOTFILES_MODULES/path.zsh"

# Languages - Gerenciadores de versão (pyenv, rbenv, nvm)
source "$DOTFILES_MODULES/languages.zsh"

# Completions - Autocompletions
source "$DOTFILES_MODULES/completions.zsh"

# Aliases - Atalhos de comandos
source "$DOTFILES_MODULES/aliases.zsh"

# -----------------------------------------------------------------------------
# Configurações locais (não versionadas)
# -----------------------------------------------------------------------------
# Carrega configurações específicas da máquina se existirem
[ -f "$HOME/.zshrc.local" ] && source "$HOME/.zshrc.local"
