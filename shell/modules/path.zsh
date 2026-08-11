# =============================================================================
# PATH Configuration
# Configuração centralizada de todos os caminhos de executáveis
# =============================================================================

# Homebrew (já configurado em .zprofile, mas garantindo)
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Mantém $PATH sem duplicatas. Como este módulo só faz prepend, cada
# `source ~/.zshrc` (alias `reload`) duplicaria todas as entradas sem isto.
typeset -U path PATH

# Local bin directories
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Java (OpenJDK 21)
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

# Go
# GOROOT depende do brew, que só entra no PATH via .zprofile (shells de login).
export GOPATH="${HOME}/.go"
if command -v brew >/dev/null; then
    export GOROOT="$(brew --prefix golang)/libexec"
    export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
else
    export PATH="$PATH:${GOPATH}/bin"
fi

# Criar diretórios Go se não existirem
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

# Ruby gems
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# Added by codeen install
export PATH="$HOME/.local/bin/codeen:$PATH"

# Kubecolor config
export KUBECOLOR_CONFIG="$HOME/.config/kubecolor.yaml"