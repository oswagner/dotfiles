#!/usr/bin/env bash
# =============================================================================
# setup-ssh-by-dir.sh
# Configura seleção automática de contexto de desenvolvimento por diretório
#
# Mecanismos:
#   GIT_SSH_COMMAND             → chave SSH correta por diretório
#   NPM_CONFIG_USERCONFIG       → npmrc correto por diretório
#   CLOUDSDK_ACTIVE_CONFIG_NAME → configuração gcloud correta por diretório
#
# Estrutura de dotfiles respeitada:
#   ~/.zshrc      → ~/dotfiles/shell/.zshrc   (symlink existente)
#   ~/.ssh/config → ~/dotfiles/ssh/config     (symlink criado pelo script)
#   ~/.npmrc      → ~/.npmrcs/LATAMXP         (symlink existente — não alterado)
#
# Mapeamento de contextos:
#   ~/Latam    → SSH: id_ed25519_latam    | npm: LATAMXP  | gcloud: ifec-latam
#   ~/Personal → SSH: id_ed25519_personal | npm: personal | gcloud: personal
#   fora       → SSH: unset               | npm: default   | gcloud: unset
#
# Usage:
#   bash setup-ssh-by-dir.sh           # aplica tudo
#   bash setup-ssh-by-dir.sh --dry-run # mostra o que seria feito, sem alterar
# =============================================================================

set -euo pipefail

# --- Paths -------------------------------------------------------------------

DOTFILES_DIR="$HOME/dotfiles"
DOTFILES_SSH_DIR="$DOTFILES_DIR/ssh"
DOTFILES_ZSHRC="$DOTFILES_DIR/shell/.zshrc"

SSH_DIR="$HOME/.ssh"
SSH_CONFIG_LINK="$SSH_DIR/config"
SSH_CONFIG_REAL="$DOTFILES_SSH_DIR/config"

NPMRCS_DIR="$HOME/.npmrcs"
NPMRC_LATAM="$NPMRCS_DIR/LATAMXP"
NPMRC_PERSONAL="$NPMRCS_DIR/personal"

BACKUP_DIR="$SSH_DIR/backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")

DRY_RUN=false

# --- Args --------------------------------------------------------------------

for arg in "$@"; do
  case $arg in
    --dry-run) DRY_RUN=true ;;
    *) echo "Argumento desconhecido: $arg"; exit 1 ;;
  esac
done

# --- Helpers -----------------------------------------------------------------

log()  { echo "[INFO]  $*"; }
warn() { echo "[WARN]  $*"; }
err()  { echo "[ERROR] $*" >&2; exit 1; }

run() {
  if $DRY_RUN; then
    echo "[DRY-RUN] $*"
  else
    eval "$*"
  fi
}

sep() { echo "----------------------------------------------------------------------"; }

# --- Preflight ---------------------------------------------------------------

preflight() {
  sep
  log "Verificações iniciais..."

  [[ "$SHELL" == */zsh ]] \
    || warn "Shell não é zsh. O hook chpwd não funcionará — adapte para PROMPT_COMMAND se usar Bash."

  [[ -d "$DOTFILES_DIR" ]]     || err "Diretório $DOTFILES_DIR não encontrado."
  [[ -d "$DOTFILES_SSH_DIR" ]] || err "Diretório $DOTFILES_SSH_DIR não encontrado."
  [[ -f "$DOTFILES_ZSHRC" ]]   || err "Arquivo $DOTFILES_ZSHRC não encontrado."
  [[ -d "$NPMRCS_DIR" ]]       || err "Diretório $NPMRCS_DIR não encontrado."
  [[ -f "$NPMRC_LATAM" ]]      || err "Arquivo $NPMRC_LATAM não encontrado."

  # Valida diretórios com casing correto
  [[ -d "$HOME/Latam" ]]    || warn "Diretório $HOME/Latam não encontrado."
  [[ -d "$HOME/Personal" ]] || warn "Diretório $HOME/Personal não encontrado."

  # gcloud
  if ! command -v gcloud &>/dev/null; then
    warn "gcloud não encontrado no PATH — CLOUDSDK_ACTIVE_CONFIG_NAME será injetado mas não testado."
  else
    local configs
    configs=$(gcloud config configurations list --format="value(name)" 2>/dev/null)
    echo "$configs" | grep -q "^ifec-latam$" || warn "gcloud config 'ifec-latam' não encontrada."
    echo "$configs" | grep -q "^personal$"   || warn "gcloud config 'personal' não encontrada."
  fi

  # Symlink do .zshrc
  local zshrc_real
  zshrc_real=$(readlink -f "$HOME/.zshrc" 2>/dev/null || echo "")
  if [[ "$zshrc_real" != "$DOTFILES_ZSHRC" ]]; then
    warn "~/.zshrc não aponta para $DOTFILES_ZSHRC (atual: $zshrc_real)"
    warn "O hook será escrito em $DOTFILES_ZSHRC mesmo assim."
  fi

  # Chaves SSH
  for key in id_ed25519_latam id_ed25519_personal; do
    [[ -f "$SSH_DIR/$key" ]] || warn "Chave $SSH_DIR/$key não encontrada."
  done

  if [[ -L "$SSH_CONFIG_LINK" ]]; then
    warn "~/.ssh/config já é symlink → $(readlink "$SSH_CONFIG_LINK") — será substituído."
  fi

  log "OK."
}

# --- Backup ------------------------------------------------------------------

backup() {
  sep
  log "Criando backups em $BACKUP_DIR..."

  run "mkdir -p '$BACKUP_DIR'"

  if [[ -f "$SSH_CONFIG_LINK" ]] || [[ -L "$SSH_CONFIG_LINK" ]]; then
    local real_config
    real_config=$(readlink -f "$SSH_CONFIG_LINK" 2>/dev/null || echo "$SSH_CONFIG_LINK")
    run "cp '$real_config' '$BACKUP_DIR/config.$TIMESTAMP'"
    log "  $BACKUP_DIR/config.$TIMESTAMP  (de: $real_config)"
  fi

  if [[ -f "$DOTFILES_SSH_DIR/config.template" ]]; then
    run "cp '$DOTFILES_SSH_DIR/config.template' '$BACKUP_DIR/config.template.$TIMESTAMP'"
    log "  $BACKUP_DIR/config.template.$TIMESTAMP"
  fi

  run "cp '$DOTFILES_ZSHRC' '$BACKUP_DIR/zshrc.$TIMESTAMP'"
  log "  $BACKUP_DIR/zshrc.$TIMESTAMP  (de: $DOTFILES_ZSHRC)"
}

# --- ~/dotfiles/ssh/config ---------------------------------------------------

write_ssh_config() {
  sep
  log "Escrevendo $SSH_CONFIG_REAL..."

  local content
  content=$(cat <<'EOF'
Include /Users/wosantos/.colima/ssh_config

# ─── Personal GitHub ──────────────────────────────────────────────────────────
# GIT_SSH_COMMAND sobrepõe IdentityFile quando dentro de ~/Personal
Host github.com
  HostName github.com
  User git
  IdentityFile ~/.ssh/id_ed25519_personal
  IdentitiesOnly yes

# ─── Work GitLab / Latam ──────────────────────────────────────────────────────
# GIT_SSH_COMMAND sobrepõe IdentityFile quando dentro de ~/Latam
Host gitlab.com
  HostName gitlab.com
  User git
  IdentityFile ~/.ssh/id_ed25519_latam
  IdentitiesOnly yes
EOF
)

  if $DRY_RUN; then
    echo "[DRY-RUN] Conteúdo que seria escrito em $SSH_CONFIG_REAL:"
    echo "$content"
  else
    echo "$content" > "$SSH_CONFIG_REAL"
    chmod 600 "$SSH_CONFIG_REAL"
    log "Escrito com permissão 600."
  fi
}

# --- Symlink ~/.ssh/config → dotfiles/ssh/config ----------------------------

create_ssh_symlink() {
  sep
  log "Criando symlink: $SSH_CONFIG_LINK → $SSH_CONFIG_REAL"

  if [[ -e "$SSH_CONFIG_LINK" ]] || [[ -L "$SSH_CONFIG_LINK" ]]; then
    run "rm '$SSH_CONFIG_LINK'"
  fi

  run "ln -s '$SSH_CONFIG_REAL' '$SSH_CONFIG_LINK'"

  if ! $DRY_RUN; then
    log "Symlink criado: $(ls -la "$SSH_CONFIG_LINK")"
  fi
}

# --- ~/.npmrcs/personal ------------------------------------------------------

create_personal_npmrc() {
  sep
  log "Verificando $NPMRC_PERSONAL..."

  if [[ -f "$NPMRC_PERSONAL" ]]; then
    warn "$NPMRC_PERSONAL já existe — não será sobrescrito."
    cat "$NPMRC_PERSONAL" | sed 's/^/    /'
    return
  fi

  local content
  content=$(cat <<'EOF'
# npmrc — personal
# Selecionado automaticamente via NPM_CONFIG_USERCONFIG quando em ~/Personal
registry=https://registry.npmjs.org/
EOF
)

  if $DRY_RUN; then
    echo "[DRY-RUN] Conteúdo que seria escrito em $NPMRC_PERSONAL:"
    echo "$content"
  else
    echo "$content" > "$NPMRC_PERSONAL"
    chmod 600 "$NPMRC_PERSONAL"
    log "Criado com permissão 600."
  fi
}

# --- Hook no dotfiles/.zshrc -------------------------------------------------

write_zshrc_hook() {
  sep
  log "Injetando hook em $DOTFILES_ZSHRC..."

  local marker_begin="# >>> dir-context-switcher begin <<<"
  local marker_end="# >>> dir-context-switcher end <<<"

  # Remove bloco anterior se existir (idempotente)
  if grep -qF "$marker_begin" "$DOTFILES_ZSHRC" 2>/dev/null; then
    warn "Bloco anterior encontrado — removendo antes de reinjetar..."
    if ! $DRY_RUN; then
      sed -i '' "/$marker_begin/,/$marker_end/d" "$DOTFILES_ZSHRC"
    fi
  fi

  local hook_block
  hook_block=$(cat <<'EOF'

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
EOF
)

  if $DRY_RUN; then
    echo "[DRY-RUN] Bloco que seria adicionado a $DOTFILES_ZSHRC:"
    echo "$hook_block"
  else
    echo "$hook_block" >> "$DOTFILES_ZSHRC"
    log "Hook adicionado."
  fi
}

# --- Validação ---------------------------------------------------------------

print_validation() {
  sep
  log "Instalação concluída. Execute a validação completa abaixo:"
  cat <<'VALIDATION'

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
  VALIDAÇÃO COMPLETA
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

1. Recarregue o shell:
     source ~/.zshrc


2. Symlinks:
     ls -la ~/.ssh/config
     # esperado: ~/.ssh/config -> /Users/wosantos/dotfiles/ssh/config

     ls -la ~/.npmrc
     # inalterado: ~/.npmrc -> /Users/wosantos/.npmrcs/LATAMXP


3. Contexto Latam:
     cd ~/Latam
     echo $GIT_SSH_COMMAND
     # → ssh -i ~/.ssh/id_ed25519_latam -o IdentitiesOnly=yes

     echo $NPM_CONFIG_USERCONFIG
     # → /Users/wosantos/.npmrcs/LATAMXP

     echo $CLOUDSDK_ACTIVE_CONFIG_NAME
     # → ifec-latam

     gcloud config configurations list
     # → ifec-latam IS_ACTIVE = true


4. Contexto Personal:
     cd ~/Personal
     echo $GIT_SSH_COMMAND
     # → ssh -i ~/.ssh/id_ed25519_personal -o IdentitiesOnly=yes

     echo $NPM_CONFIG_USERCONFIG
     # → /Users/wosantos/.npmrcs/personal

     echo $CLOUDSDK_ACTIVE_CONFIG_NAME
     # → personal

     gcloud config configurations list
     # → personal IS_ACTIVE = true


5. Fora dos contextos:
     cd ~
     echo $GIT_SSH_COMMAND              # → (vazio)
     echo $NPM_CONFIG_USERCONFIG        # → /Users/wosantos/.npmrcs/default
     echo $CLOUDSDK_ACTIVE_CONFIG_NAME  # → (vazio)


6. Autenticação SSH:
     cd ~/Latam    && ssh -T git@gitlab.com
     # → Welcome to GitLab, @<conta-latam>

     cd ~/Personal && ssh -T git@github.com
     # → Hi oswagner!


7. npm registry:
     cd ~/Latam    && npm config get registry
     # → https://artifactoryrepo1.appslatam.com/artifactory/api/npm/npm/

     cd ~/Personal && npm config get registry
     # → https://registry.npmjs.org/


8. gcloud account:
     cd ~/Latam    && gcloud config get-value account
     # → wagnersantos.thoughtworks@latam.com

     cd ~/Personal && gcloud config get-value account
     # → prog.wagner@gmail.com


9. Para reverter:
     cp ~/.ssh/backups/config.<timestamp>  ~/dotfiles/ssh/config
     cp ~/.ssh/backups/zshrc.<timestamp>   ~/dotfiles/shell/.zshrc

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
VALIDATION
}

# --- Main --------------------------------------------------------------------

main() {
  echo "======================================================================"
  echo "  setup-ssh-by-dir.sh${DRY_RUN:+ [DRY-RUN MODE]}"
  echo "  dotfiles : $DOTFILES_DIR"
  echo "  npmrcs   : $NPMRCS_DIR"
  echo "======================================================================"

  preflight
  backup
  write_ssh_config
  create_ssh_symlink
  create_personal_npmrc
  write_zshrc_hook
  print_validation
}

main