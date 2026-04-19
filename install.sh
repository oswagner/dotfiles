#!/bin/bash

# =============================================================================
# Dotfiles Installation Script
# Script principal de instalação dos dotfiles
# =============================================================================

set -e

DOTFILES_DIR="$HOME/dotfiles"

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

# =============================================================================
print_header "Dotfiles Installation"
# =============================================================================

echo "Este script irá:"
echo "  1. Verificar pré-requisitos"
echo "  2. Instalar dependências via Homebrew"
echo "  3. Criar symlinks dos arquivos de configuração"
echo "  4. Validar a instalação"
echo ""

read -p "Deseja continuar? (y/n) " -n 1 -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_info "Instalação cancelada."
    exit 0
fi

# =============================================================================
print_header "Verificando Pré-requisitos"
# =============================================================================

# Verificar Homebrew
if ! command -v brew &> /dev/null; then
    print_warning "Homebrew não encontrado. Instalando..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
    print_success "Homebrew instalado"
fi

# Verificar Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_warning "Oh My Zsh não encontrado. Instalando..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    print_success "Oh My Zsh instalado"
fi

# =============================================================================
print_header "Instalando Dependências (Homebrew)"
# =============================================================================

if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    print_info "Instalando pacotes do Brewfile..."
    brew bundle --file="$DOTFILES_DIR/Brewfile"
    print_success "Dependências instaladas"
else
    print_warning "Brewfile não encontrado, pulando instalação de pacotes"
fi

# =============================================================================
print_header "Criando Symlinks"
# =============================================================================

if [ -f "$DOTFILES_DIR/scripts/symlink.sh" ]; then
    bash "$DOTFILES_DIR/scripts/symlink.sh"
else
    print_error "Script de symlinks não encontrado"
    exit 1
fi

# =============================================================================
print_header "Validando Instalação"
# =============================================================================

if [ -f "$DOTFILES_DIR/scripts/validate.sh" ]; then
    bash "$DOTFILES_DIR/scripts/validate.sh" || true
else
    print_warning "Script de validação não encontrado"
fi

# =============================================================================
print_header "Instalação Concluída"
# =============================================================================

echo -e "${GREEN}Dotfiles instalados com sucesso!${NC}"
echo ""
echo "Próximos passos:"
echo "  1. Reinicie o terminal ou execute: source ~/.zshrc"
echo "  2. Configure suas chaves SSH se necessário"
echo "  3. Personalize ~/.zshrc.local para configurações locais"
echo ""
