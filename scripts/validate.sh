#!/bin/bash

# =============================================================================
# Dotfiles Environment Validation Script
# Valida que todas as ferramentas e configurações estão funcionando
# =============================================================================

set -e

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Contadores
PASSED=0
FAILED=0
WARNINGS=0

print_header() {
    echo ""
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  $1${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

print_subheader() {
    echo ""
    echo -e "${CYAN}─── $1 ───${NC}"
    echo ""
}

check_pass() {
    echo -e "${GREEN}✓${NC} $1"
    ((PASSED++))
}

check_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILED++))
}

check_warn() {
    echo -e "${YELLOW}⚠${NC} $1"
    ((WARNINGS++))
}

check_info() {
    echo -e "${BLUE}→${NC} $1"
}

# Função para verificar comando e versão
check_command() {
    local cmd=$1
    local name=$2
    local version_flag=${3:---version}

    if command -v "$cmd" &> /dev/null; then
        local version
        version=$($cmd $version_flag 2>&1 | head -n1)
        check_pass "$name: $version"
        return 0
    else
        check_fail "$name: não encontrado"
        return 1
    fi
}

# Função para verificar se PATH contém diretório
check_path() {
    local dir=$1
    local name=$2

    if [[ ":$PATH:" == *":$dir:"* ]]; then
        check_pass "PATH contém: $name"
        return 0
    else
        if [ -d "$dir" ]; then
            check_warn "PATH não contém: $name (diretório existe)"
        else
            check_fail "PATH não contém: $name (diretório não existe)"
        fi
        return 1
    fi
}

# Função para verificar arquivo
check_file() {
    local file=$1
    local name=$2

    if [ -f "$file" ]; then
        check_pass "Arquivo existe: $name"
        return 0
    else
        check_fail "Arquivo não existe: $name"
        return 1
    fi
}

# =============================================================================
print_header "Validação do Ambiente - Dotfiles"
# =============================================================================

echo "Data: $(date)"
echo "Host: $(hostname)"
echo "User: $(whoami)"

# =============================================================================
print_subheader "Sistema"
# =============================================================================

check_info "macOS: $(sw_vers -productVersion)"
check_info "Arquitetura: $(uname -m)"
check_info "Shell: $SHELL"

# =============================================================================
print_subheader "Homebrew"
# =============================================================================

if check_command brew "Homebrew"; then
    brew_prefix=$(brew --prefix)
    check_info "Prefix: $brew_prefix"

    # Verificar se brew está saudável (sem executar brew doctor que é lento)
    if [ -x "$brew_prefix/bin/brew" ]; then
        check_pass "Homebrew executável OK"
    fi
fi

# =============================================================================
print_subheader "Linguagens de Programação"
# =============================================================================

# Python via pyenv
if check_command python "Python" "--version"; then
    if command -v pyenv &> /dev/null; then
        pyenv_version=$(pyenv version-name 2>/dev/null)
        check_info "Pyenv versão ativa: $pyenv_version"
    fi
fi

# Node via nvm
if check_command node "Node.js" "--version"; then
    if [ -n "$NVM_DIR" ]; then
        check_info "NVM_DIR: $NVM_DIR"
    fi
fi

check_command npm "NPM" "--version"

# Ruby via rbenv
if check_command ruby "Ruby" "--version"; then
    if command -v rbenv &> /dev/null; then
        rbenv_version=$(rbenv version-name 2>/dev/null)
        check_info "Rbenv versão ativa: $rbenv_version"
    fi
fi

check_command go "Go" "version"
check_command rustc "Rust" "--version"

# =============================================================================
print_subheader "Ferramentas de Desenvolvimento"
# =============================================================================

check_command git "Git" "--version"
check_command docker "Docker" "--version"
check_command terraform "Terraform" "--version"
check_command aws "AWS CLI" "--version"

# Flutter (pode não estar no PATH padrão)
if [ -f "$HOME/flutter/flutter/bin/flutter" ]; then
    flutter_version=$("$HOME/flutter/flutter/bin/flutter" --version 2>&1 | head -n1)
    check_pass "Flutter: $flutter_version"
else
    check_command flutter "Flutter" "--version"
fi

check_command code "VSCode CLI" "--version"
check_command ngrok "Ngrok" "--version"

# =============================================================================
print_subheader "Version Managers"
# =============================================================================

if command -v pyenv &> /dev/null; then
    check_pass "pyenv instalado"
    check_info "PYENV_ROOT: ${PYENV_ROOT:-não definido}"
else
    check_fail "pyenv não encontrado"
fi

if command -v rbenv &> /dev/null; then
    check_pass "rbenv instalado"
else
    check_fail "rbenv não encontrado"
fi

if [ -n "$NVM_DIR" ] && [ -s "$NVM_DIR/nvm.sh" ]; then
    check_pass "nvm instalado"
    check_info "NVM_DIR: $NVM_DIR"
else
    check_warn "nvm pode não estar configurado corretamente"
fi

# =============================================================================
print_subheader "Verificação de PATH"
# =============================================================================

check_path "/opt/homebrew/bin" "Homebrew bin"
check_path "$HOME/.pyenv/shims" "pyenv shims"
check_path "$HOME/.rbenv/shims" "rbenv shims"
check_path "$HOME/.local/bin" "local bin"
check_path "$HOME/.cargo/bin" "Cargo bin"
check_path "$HOME/flutter/flutter/bin" "Flutter bin"
check_path "$HOME/.go/bin" "Go bin"

# =============================================================================
print_subheader "Arquivos de Configuração"
# =============================================================================

check_file "$HOME/.zshrc" ".zshrc"
check_file "$HOME/.zprofile" ".zprofile"
check_file "$HOME/.gitconfig" ".gitconfig"
check_file "$HOME/.ssh/config" ".ssh/config"
check_file "$HOME/Brewfile" "Brewfile"

# =============================================================================
print_subheader "Oh My Zsh"
# =============================================================================

if [ -d "$HOME/.oh-my-zsh" ]; then
    check_pass "Oh My Zsh instalado"

    if [ -d "$HOME/.oh-my-zsh/custom/themes/spaceship-prompt" ]; then
        check_pass "Tema Spaceship instalado"
    else
        # Verificar se está instalado via Homebrew
        if brew list spaceship &> /dev/null 2>&1; then
            check_pass "Tema Spaceship (via Homebrew)"
        else
            check_warn "Tema Spaceship pode não estar instalado"
        fi
    fi
else
    check_fail "Oh My Zsh não encontrado"
fi

# =============================================================================
print_subheader "Docker / Colima"
# =============================================================================

if command -v colima &> /dev/null; then
    check_pass "Colima instalado"
    colima_status=$(colima status 2>&1 || true)
    if echo "$colima_status" | grep -q "running"; then
        check_pass "Colima está rodando"
    else
        check_info "Colima não está rodando (normal se Docker não está em uso)"
    fi
else
    check_warn "Colima não encontrado"
fi

# =============================================================================
print_header "Resumo da Validação"
# =============================================================================

echo ""
echo -e "Testes passaram:  ${GREEN}$PASSED${NC}"
echo -e "Testes falharam:  ${RED}$FAILED${NC}"
echo -e "Avisos:           ${YELLOW}$WARNINGS${NC}"
echo ""

if [ $FAILED -eq 0 ]; then
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${GREEN}  Ambiente validado com sucesso! Pronto para migração.         ${NC}"
    echo -e "${GREEN}═══════════════════════════════════════════════════════════════${NC}"
    exit 0
else
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    echo -e "${YELLOW}  Algumas verificações falharam. Revise antes de prosseguir.   ${NC}"
    echo -e "${YELLOW}═══════════════════════════════════════════════════════════════${NC}"
    exit 1
fi
