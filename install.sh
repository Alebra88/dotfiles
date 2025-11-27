#!/bin/bash

# Mac-dotfiles installation script
# This script will set up your Mac with all dotfiles and applications

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}╔═══════════════════════════════════════╗${NC}"
echo -e "${BLUE}║   Mac Dotfiles Installation Script   ║${NC}"
echo -e "${BLUE}╚═══════════════════════════════════════╝${NC}\n"

# Get the directory where this script is located
DOTFILES_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd "$DOTFILES_DIR"

echo -e "${GREEN}Installation directory: ${DOTFILES_DIR}${NC}\n"

# ========================================
# 1. Install Homebrew
# ========================================
echo -e "${BLUE}[1/7] Checking Homebrew...${NC}"
if ! command -v brew &> /dev/null; then
    echo "  → Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    echo -e "  ${GREEN}✓ Homebrew installed${NC}"
else
    echo -e "  ${GREEN}✓ Homebrew already installed${NC}"
fi

# ========================================
# 2. Install packages from Brewfile
# ========================================
echo -e "\n${BLUE}[2/7] Installing packages from Brewfile...${NC}"
if [ -f "$DOTFILES_DIR/Brewfile" ]; then
    brew bundle install --file="$DOTFILES_DIR/Brewfile"
    echo -e "  ${GREEN}✓ Packages installed${NC}"
else
    echo -e "  ${YELLOW}⚠ Brewfile not found, skipping...${NC}"
fi

# ========================================
# 3. Backup existing dotfiles
# ========================================
echo -e "\n${BLUE}[3/7] Backing up existing dotfiles...${NC}"
BACKUP_DIR="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"

files_to_backup=(".zshrc" ".gitconfig" ".aerospace.toml" ".zprofile")
for file in "${files_to_backup[@]}"; do
    if [ -f "$HOME/$file" ] && [ ! -L "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_DIR/"
        echo "  → Backed up $file"
    fi
done

# Backup .config directories
config_dirs=("yazi" "sketchybar" "karabiner" "raycast")
for dir in "${config_dirs[@]}"; do
    if [ -d "$HOME/.config/$dir" ] && [ ! -L "$HOME/.config/$dir" ]; then
        cp -r "$HOME/.config/$dir" "$BACKUP_DIR/"
        echo "  → Backed up .config/$dir"
    fi
done

echo -e "  ${GREEN}✓ Backups saved to ${BACKUP_DIR}${NC}"

# ========================================
# 4. Create symlinks for dotfiles
# ========================================
echo -e "\n${BLUE}[4/7] Creating symlinks for dotfiles...${NC}"

# Remove existing files/symlinks
for file in "${files_to_backup[@]}"; do
    if [ -e "$HOME/$file" ]; then
        rm -f "$HOME/$file"
    fi
done

# Create new symlinks
ln -sf "$DOTFILES_DIR/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES_DIR/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES_DIR/.aerospace.toml" "$HOME/.aerospace.toml"
ln -sf "$DOTFILES_DIR/.zprofile" "$HOME/.zprofile"

echo -e "  ${GREEN}✓ Dotfile symlinks created${NC}"

# ========================================
# 5. Create symlinks for .config directories
# ========================================
echo -e "\n${BLUE}[5/7] Setting up .config directories...${NC}"

mkdir -p "$HOME/.config"

for dir in "${config_dirs[@]}"; do
    # Remove existing directory/symlink
    if [ -e "$HOME/.config/$dir" ]; then
        rm -rf "$HOME/.config/$dir"
    fi

    # Create symlink if source exists
    if [ -d "$DOTFILES_DIR/.config/$dir" ]; then
        ln -sf "$DOTFILES_DIR/.config/$dir" "$HOME/.config/$dir"
        echo "  → Linked .config/$dir"
    fi
done

echo -e "  ${GREEN}✓ Config directories linked${NC}"

# ========================================
# 6. Set up Leader Key config
# ========================================
echo -e "\n${BLUE}[6/7] Setting up Leader Key configuration...${NC}"

LEADERKEY_CONFIG_SRC="$DOTFILES_DIR/Library/Application Support/Leader Key/config.json"
LEADERKEY_CONFIG_DEST="$HOME/Library/Application Support/Leader Key"

if [ -f "$LEADERKEY_CONFIG_SRC" ]; then
    # Backup existing config if it exists
    if [ -f "$LEADERKEY_CONFIG_DEST/config.json" ]; then
        cp "$LEADERKEY_CONFIG_DEST/config.json" "$BACKUP_DIR/leaderkey_config.json"
        echo "  → Backed up existing Leader Key config"
    fi

    # Create directory and copy config
    mkdir -p "$LEADERKEY_CONFIG_DEST"
    cp "$LEADERKEY_CONFIG_SRC" "$LEADERKEY_CONFIG_DEST/config.json"
    echo -e "  ${GREEN}✓ Leader Key config installed${NC}"
else
    echo -e "  ${YELLOW}⚠ Leader Key config not found, skipping...${NC}"
fi

# ========================================
# 7. Install oh-my-zsh and plugins
# ========================================
echo -e "\n${BLUE}[7/7] Setting up oh-my-zsh...${NC}"

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "  → Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo -e "  ${GREEN}✓ oh-my-zsh installed${NC}"
else
    echo -e "  ${GREEN}✓ oh-my-zsh already installed${NC}"
fi

# Install zsh-autosuggestions
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    echo "  → Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
    echo -e "  ${GREEN}✓ zsh-autosuggestions installed${NC}"
else
    echo -e "  ${GREEN}✓ zsh-autosuggestions already installed${NC}"
fi

# Install zsh-syntax-highlighting
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    echo "  → Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
    echo -e "  ${GREEN}✓ zsh-syntax-highlighting installed${NC}"
else
    echo -e "  ${GREEN}✓ zsh-syntax-highlighting already installed${NC}"
fi

# Install zsh-autocomplete
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete" ]; then
    echo "  → Installing zsh-autocomplete..."
    git clone --depth 1 https://github.com/marlonrichert/zsh-autocomplete.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autocomplete"
    echo -e "  ${GREEN}✓ zsh-autocomplete installed${NC}"
else
    echo -e "  ${GREEN}✓ zsh-autocomplete already installed${NC}"
fi

# ========================================
# Done
# ========================================
echo -e "\n${GREEN}╔═══════════════════════════════════════╗${NC}"
echo -e "${GREEN}║     Installation Complete! 🎉        ║${NC}"
echo -e "${GREEN}╚═══════════════════════════════════════╝${NC}\n"

echo -e "${YELLOW}Next steps:${NC}"
echo -e "  1. Restart your terminal or run: ${BLUE}source ~/.zshrc${NC}"
echo -e "  2. Configure any application-specific settings"
echo -e "  3. Start AeroSpace: ${BLUE}aerospace${NC}"
echo -e "  4. Start SketchyBar: ${BLUE}brew services start sketchybar${NC}"
echo -e "  5. Open Raycast and Leader Key to complete their setup\n"

echo -e "${GREEN}Your old dotfiles have been backed up to:${NC}"
echo -e "${BLUE}${BACKUP_DIR}${NC}\n"

echo -e "${YELLOW}To update your dotfiles in the future, use:${NC}"
echo -e "${BLUE}cd ~/Mac-dotfiles && ./dump \"Your commit message\"${NC}\n"
