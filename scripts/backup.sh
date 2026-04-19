#!/bin/bash

# =============================================================================
# Dotfiles Backup Script
# Cria backup de todos os arquivos de configuração antes da migração
# =============================================================================

set -e

BACKUP_DIR="$HOME/dotfiles/backup/$(date +%Y%m%d_%H%M%S)"
HOME_DIR="$HOME"

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_info() {
    echo -e "${BLUE}→${NC} $1"
}

# Lista de arquivos para backup
DOTFILES=(
    ".zshrc"
    ".zshrc.backup"
    ".zprofile"
    ".zshenv"
    ".bashrc"
    ".profile"
    ".gitconfig"
    ".yarnrc"
    ".npmrc"
    ".serverlessrc"
)

# Lista de diretórios para backup (estrutura apenas, não conteúdo completo)
DOTDIRS=(
    ".ssh/config"
)

print_header "Dotfiles Backup Script"

# Criar diretório de backup
print_info "Criando diretório de backup: $BACKUP_DIR"
mkdir -p "$BACKUP_DIR"

# Backup dos arquivos
print_header "Fazendo backup dos arquivos de configuração"

for file in "${DOTFILES[@]}"; do
    if [ -f "$HOME_DIR/$file" ]; then
        cp "$HOME_DIR/$file" "$BACKUP_DIR/$file"
        print_success "Backup: $file"
    else
        print_warning "Não encontrado: $file (ignorado)"
    fi
done

# Backup do SSH config
print_header "Fazendo backup das configurações SSH"

if [ -f "$HOME_DIR/.ssh/config" ]; then
    mkdir -p "$BACKUP_DIR/.ssh"
    cp "$HOME_DIR/.ssh/config" "$BACKUP_DIR/.ssh/config"
    print_success "Backup: .ssh/config"
else
    print_warning "Não encontrado: .ssh/config"
fi

# Backup do Brewfile
print_header "Fazendo backup do Brewfile"

if [ -f "$HOME_DIR/Brewfile" ]; then
    cp "$HOME_DIR/Brewfile" "$BACKUP_DIR/Brewfile"
    print_success "Backup: Brewfile"
else
    print_warning "Não encontrado: Brewfile"
fi

# Backup das configurações do VSCode
print_header "Fazendo backup das configurações do VSCode"

VSCODE_DIR="$HOME_DIR/Library/Application Support/Code/User"
if [ -d "$VSCODE_DIR" ]; then
    mkdir -p "$BACKUP_DIR/vscode"

    if [ -f "$VSCODE_DIR/settings.json" ]; then
        cp "$VSCODE_DIR/settings.json" "$BACKUP_DIR/vscode/settings.json"
        print_success "Backup: VSCode settings.json"
    fi

    if [ -f "$VSCODE_DIR/keybindings.json" ]; then
        cp "$VSCODE_DIR/keybindings.json" "$BACKUP_DIR/vscode/keybindings.json"
        print_success "Backup: VSCode keybindings.json"
    fi

    # Lista de extensões instaladas
    if command -v code &> /dev/null; then
        code --list-extensions > "$BACKUP_DIR/vscode/extensions.txt" 2>/dev/null
        print_success "Backup: Lista de extensões do VSCode"
    fi
else
    print_warning "VSCode não encontrado ou não configurado"
fi

# Criar arquivo de metadados
print_header "Criando metadados do backup"

cat > "$BACKUP_DIR/backup_info.txt" << EOF
Dotfiles Backup
===============
Data: $(date)
Host: $(hostname)
User: $(whoami)
macOS: $(sw_vers -productVersion)
Arch: $(uname -m)

Arquivos incluídos:
EOF

ls -la "$BACKUP_DIR" >> "$BACKUP_DIR/backup_info.txt"

print_success "Metadados criados"

# Resumo
print_header "Backup Concluído"

echo -e "Diretório de backup: ${GREEN}$BACKUP_DIR${NC}"
echo ""
echo "Arquivos salvos:"
ls -la "$BACKUP_DIR"
echo ""
echo -e "${GREEN}Para restaurar, copie os arquivos de volta para \$HOME${NC}"
