# =============================================================================
# Completions
# Configuração de autocompletions para Zsh
#
# IMPORTANTE: este módulo roda DEPOIS do compinit (executado pelo oh-my-zsh.sh).
# Não chame `compinit` aqui nem depois deste ponto: cada chamada reinicializa a
# tabela `_comps` e descarta todos os `compdef` registrados antes dela.
# O FPATH (brew, zsh-completions) é configurado no .zshrc, antes do oh-my-zsh.
# =============================================================================

# Ngrok completions
if command -v ngrok &>/dev/null; then
   eval "$(ngrok completion)"
fi

# kubectl completions
# O brew já instala _kubectl em share/zsh/site-functions, carregado via FPATH.
# O fallback cobre instalações fora do brew (asdf, curl, gcloud components).
if command -v kubectl &>/dev/null; then
    (( $+_comps[kubectl] )) || source <(kubectl completion zsh)
fi

# kubecolor e o alias `k` (ver aliases.zsh) reaproveitam a completion do kubectl
if (( $+_comps[kubectl] )); then
    compdef kubecolor=kubectl
    compdef k=kubectl
fi

# Adicione outras completions aqui conforme necessário
