# =============================================================================
# Language Version Managers
# Configuração de pyenv, rbenv, nvm e outros gerenciadores de versão
# =============================================================================

# -----------------------------------------------------------------------------
# Python (pyenv + virtualenv)
# -----------------------------------------------------------------------------
# Os `eval` abaixo são guardados: em shells NÃO-login o .zprofile não roda, o
# Homebrew ainda não está no PATH e um init sem guarda imprime
# "command not found" a cada abertura de shell.
export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv >/dev/null; then
    eval "$(pyenv init -)"
    # virtualenv-init só existe com o plugin pyenv-virtualenv instalado
    pyenv commands | grep -qx virtualenv-init && eval "$(pyenv virtualenv-init -)"
fi

# -----------------------------------------------------------------------------
# Ruby (rbenv)
# -----------------------------------------------------------------------------
if command -v rbenv >/dev/null; then
    eval "$(rbenv init - zsh)"
fi

# -----------------------------------------------------------------------------
# Node.js (nvm)
# -----------------------------------------------------------------------------
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# -----------------------------------------------------------------------------
