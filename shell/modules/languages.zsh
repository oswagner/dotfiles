# =============================================================================
# Language Version Managers
# Configuração de pyenv, rbenv, nvm e outros gerenciadores de versão
# =============================================================================

# -----------------------------------------------------------------------------
# Python (pyenv + virtualenv)
# -----------------------------------------------------------------------------
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
eval "$(pyenv virtualenv-init -)"

# -----------------------------------------------------------------------------
# Ruby (rbenv)
# -----------------------------------------------------------------------------
eval "$(rbenv init - zsh)"

# -----------------------------------------------------------------------------
# Node.js (nvm)
# -----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# -----------------------------------------------------------------------------
