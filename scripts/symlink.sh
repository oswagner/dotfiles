#!/bin/bash

# =============================================================================
# Dotfiles Symlink Script
# Cria symlinks dos arquivos de configuração para $HOME
# =============================================================================

set -e

DOTFILES_DIR="$HOME/dotfiles"
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

# Função para criar symlink com backup
create_symlink() {
    local source=$1
    local target=$2
    local name=$3

    if [ -L "$target" ]; then
        # Já é um symlink, remover e recriar
        rm "$target"
        ln -s "$source" "$target"
        print_success "Atualizado symlink: $name"
    elif [ -f "$target" ]; then
        # Arquivo existe, fazer backup e criar symlink
        local backup="${target}.dotfiles-backup"
        mv "$target" "$backup"
        ln -s "$source" "$target"
        print_warning "Backup criado: ${name}.dotfiles-backup"
        print_success "Criado symlink: $name"
    else
        # Arquivo não existe, criar symlink
        ln -s "$source" "$target"
        print_success "Criado symlink: $name"
    fi
}

print_header "Dotfiles Symlink Script"

# Verificar se o diretório dotfiles existe
if [ ! -d "$DOTFILES_DIR" ]; then
    print_error "Diretório dotfiles não encontrado: $DOTFILES_DIR"
    exit 1
fi

# -----------------------------------------------------------------------------
# Shell files
# -----------------------------------------------------------------------------
print_header "Shell Configuration"

create_symlink "$DOTFILES_DIR/shell/.zshrc" "$HOME_DIR/.zshrc" ".zshrc"
create_symlink "$DOTFILES_DIR/shell/.zprofile" "$HOME_DIR/.zprofile" ".zprofile"
create_symlink "$DOTFILES_DIR/shell/.zshenv" "$HOME_DIR/.zshenv" ".zshenv"

# -----------------------------------------------------------------------------
# Git
# -----------------------------------------------------------------------------
print_header "Git Configuration"

create_symlink "$DOTFILES_DIR/git/.gitconfig" "$HOME_DIR/.gitconfig" ".gitconfig"

# Criar .gitignore_global se não existir
if [ -f "$DOTFILES_DIR/git/.gitignore_global" ]; then
    create_symlink "$DOTFILES_DIR/git/.gitignore_global" "$HOME_DIR/.gitignore_global" ".gitignore_global"
fi

# -----------------------------------------------------------------------------
# Brewfile
# -----------------------------------------------------------------------------
print_header "Brewfile"

create_symlink "$DOTFILES_DIR/Brewfile" "$HOME_DIR/Brewfile" "Brewfile"

# -----------------------------------------------------------------------------
# SSH Config (opcional - apenas se quiser versionar o template)
# -----------------------------------------------------------------------------
# NOTA: O SSH config não é linkado automaticamente por segurança
# Para usar o template: cp ~/dotfiles/ssh/config.template ~/.ssh/config

print_header "SSH Configuration"
print_info "SSH config template disponível em: $DOTFILES_DIR/ssh/config.template"
print_info "Para usar: cp ~/dotfiles/ssh/config.template ~/.ssh/config"

# -----------------------------------------------------------------------------
# Resumo
# -----------------------------------------------------------------------------
print_header "Symlinks Criados"

echo "Verificando symlinks:"
echo ""

for file in .zshrc .zprofile .zshenv .gitconfig Brewfile; do
    if [ -L "$HOME_DIR/$file" ]; then
        target=$(readlink "$HOME_DIR/$file")
        echo -e "${GREEN}✓${NC} $file -> $target"
    elif [ -f "$HOME_DIR/$file" ]; then
        echo -e "${YELLOW}⚠${NC} $file (arquivo regular, não symlink)"
    else
        echo -e "${RED}✗${NC} $file (não existe)"
    fi
done

echo ""
print_info "Para aplicar as mudanças, execute: source ~/.zshrc"
