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

# >>> dir-context-switcher begin <<<
# Auto-seleção de contexto de desenvolvimento por diretório
#
#   GIT_SSH_COMMAND             → chave SSH (sobrepõe ~/.ssh/config)
#   NPM_CONFIG_USERCONFIG       → npmrc     (sobrepõe ~/.npmrc)
#   CLOUDSDK_ACTIVE_CONFIG_NAME → gcloud    (sobrepõe configuração ativa global)
#
# Diretórios (case-sensitive):
#   ~/Latam    → ifec-latam context
#   ~/Personal → personal context
#
# Gerenciado por setup-ssh-by-dir.sh — não edite manualmente

_dir_context_switch() {
  case "$PWD" in

    # ── Latam / Work ──────────────────────────────────────────────────────────
    "$HOME"/Latam | "$HOME"/Latam/*)
      export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_latam -o IdentitiesOnly=yes"
      export NPM_CONFIG_USERCONFIG="$HOME/.npmrcs/LATAMXP"
      export CLOUDSDK_ACTIVE_CONFIG_NAME="ifec-latam"
      ;;

    # ── Personal ──────────────────────────────────────────────────────────────
    "$HOME"/Personal | "$HOME"/Personal/*)
      export GIT_SSH_COMMAND="ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes"
      export NPM_CONFIG_USERCONFIG="$HOME/.npmrcs/personal"
      export CLOUDSDK_ACTIVE_CONFIG_NAME="personal"
      ;;

    # ── Default (fora dos contextos mapeados) ─────────────────────────────────
    *)
      unset GIT_SSH_COMMAND
      unset CLOUDSDK_ACTIVE_CONFIG_NAME
      export NPM_CONFIG_USERCONFIG="$HOME/.npmrcs/default"
      ;;

  esac
}

autoload -U add-zsh-hook
add-zsh-hook chpwd _dir_context_switch

# Aplica imediatamente ao abrir o terminal
_dir_context_switch
# >>> dir-context-switcher end <<<


