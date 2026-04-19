# =============================================================================
# PATH Configuration
# Configuração centralizada de todos os caminhos de executáveis
# =============================================================================

# Homebrew (já configurado em .zprofile, mas garantindo)
# eval "$(/opt/homebrew/bin/brew shellenv)"

# Local bin directories
export PATH="/usr/local/sbin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# Java (OpenJDK 21)
export PATH="/opt/homebrew/opt/openjdk@21/bin:$PATH"

# Android NDK
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"

# Flutter
export PATH="$PATH:$HOME/flutter/flutter/bin"
export PATH="$PATH:$HOME/.pub-cache/bin"

# Go
export GOPATH="${HOME}/.go"
export GOROOT="$(brew --prefix golang)/libexec"
export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"

# Criar diretórios Go se não existirem
test -d "${GOPATH}" || mkdir "${GOPATH}"
test -d "${GOPATH}/src/github.com" || mkdir -p "${GOPATH}/src/github.com"

# Ruby gems
export GEM_HOME=$HOME/.gem
export PATH=$GEM_HOME/bin:$PATH

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# LM Studio CLI
export PATH="$PATH:$HOME/.cache/lm-studio/bin"

# Antigravity
export PATH="$HOME/.antigravity/antigravity/bin:$PATH"
