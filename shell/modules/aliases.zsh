# =============================================================================
# Aliases
# Atalhos para comandos frequentes
# =============================================================================

# Terminal config
alias configterminal="code $HOME/dotfiles"
alias reload="source ~/.zshrc"

# Navegação de projetos
alias sindico="cd $HOME/Personal/sindicodigital-pro"
alias sindico-mobile="cd $HOME/Personal/sindicodigital-pro-mobile"
alias socielo="herdr session attach socielo"

# Claude Code — Isolated profiles per working directory
# Override the configuration directory (default: ~/.claude). 
# All settings, session history, and plugins are stored under this path, as are credentials on Linux and Windows; 
# on macOS, credentials are in the system Keychain. Useful for running multiple accounts side by side: 
alias claude-pers='CLAUDE_CONFIG_DIR=~/.claude_personal claude'
alias claude-latam='CLAUDE_CONFIG_DIR=~/.claude_latam claude'
alias claude-tw='CLAUDE_CONFIG_DIR=~/.claude_thoughtworks claude'

# Substituições modernas de comandos
alias ls='eza'

# Kubecolor wrapping kubectl
alias k=kubecolor
alias kubectl=kubecolor

# Git aliases (complementam os do oh-my-zsh)
# alias gs='git status'
# alias gp='git pull'
# alias gc='git commit'

# Docker
# alias dc='docker compose'
# alias dps='docker ps'

# Outros
# alias ..='cd ..'
# alias ...='cd ../..'
