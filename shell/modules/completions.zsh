# =============================================================================
# Completions
# Configuração de autocompletions para Zsh
# =============================================================================

# Homebrew completions
# https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null; then
    FPATH=$(brew --prefix)/share/zsh-completions:$FPATH

    autoload -Uz compinit
    compinit
fi

# Ngrok completions
if command -v ngrok &>/dev/null; then
   eval "$(ngrok completion)"
fi

# Adicione outras completions aqui conforme necessário
# Ex: kubectl, docker, etc.
