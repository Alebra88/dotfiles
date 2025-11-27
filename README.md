# Mac-dotfiles

My personal macOS configuration files and settings.

## Quick Installation

Set up your Mac with a single command:

```bash
bash -c "$(curl -fsSL https://raw.githubusercontent.com/Alebra88/Mac-dotfiles/main/install.sh)"
```

Or clone first and then install:

```bash
git clone https://github.com/Alebra88/Mac-dotfiles.git ~/Mac-dotfiles && cd ~/Mac-dotfiles && ./install.sh
```

This will automatically:
- ✅ Install Homebrew (if not already installed)
- ✅ Install all applications and tools from the Brewfile
- ✅ Backup your existing dotfiles
- ✅ Set up all configuration files (.zshrc, .gitconfig, .aerospace.toml, etc.)
- ✅ Configure Raycast, Karabiner, SketchyBar, Yazi
- ✅ Install Leader Key configuration
- ✅ Install oh-my-zsh with plugins (autosuggestions, syntax-highlighting, autocomplete)

## Contents

### Shell Configuration
- `.zshrc` - Zsh configuration with oh-my-zsh, autosuggestions, syntax highlighting, and autocomplete
- `.zprofile` - Zsh profile settings

### Application Configurations
- `.aerospace.toml` - AeroSpace window manager configuration
- `.gitconfig` - Git configuration

### .config Directory
- `yazi/` - Yazi terminal file manager configuration (Catppuccin Mocha theme)
- `sketchybar/` - SketchyBar configuration
- `karabiner/` - Karabiner-Elements keyboard customization
- `raycast/` - Raycast launcher settings

### Application Support
- `Library/Application Support/Leader Key/` - Leader Key configuration

### Package Management
- `Brewfile` - Homebrew packages and casks (auto-generated)

### Utilities
- `install.sh` - Automated installation script for new machines
- `dump` - Script to update all dotfiles repositories

## Manual Installation

If you prefer to install manually or customize the process:

1. Clone this repository:
   ```bash
   git clone https://github.com/Alebra88/Mac-dotfiles.git ~/Mac-dotfiles
   ```

2. Run the installation script:
   ```bash
   cd ~/Mac-dotfiles
   ./install.sh
   ```

The script will:
- Automatically backup your existing dotfiles
- Create symlinks for all configuration files
- Install Homebrew and all packages
- Set up oh-my-zsh with plugins
- Configure all applications

## Updating Your Dotfiles

Use the `dump` script to easily update all your dotfiles repositories:

```bash
cd ~/Mac-dotfiles
./dump "Your commit message"
```

This script will:
1. Copy the latest dotfiles from your home directory to `Mac-dotfiles`
2. Generate an updated `Brewfile` with all installed packages
3. Update and push changes to all three repositories:
   - `Mac-dotfiles`
   - `leaderkey-dotfiles`
   - `dotfiles`

If no commit message is provided, it defaults to "Update dotfiles".

Example:
```bash
./dump "Add new aerospace keybindings"
```

## Requirements

- macOS
- [Homebrew](https://brew.sh/)
- [oh-my-zsh](https://ohmyz.sh/)
- zsh (default on modern macOS)

### Optional Applications
- [AeroSpace](https://github.com/nikitabobko/AeroSpace) - Tiling window manager
- [SketchyBar](https://github.com/FelixKratz/SketchyBar) - macOS status bar
- [Karabiner-Elements](https://karabiner-elements.pqrs.org/) - Keyboard customization
- [Raycast](https://www.raycast.com/) - Launcher and productivity tool
- [Yazi](https://github.com/sxyazi/yazi) - Terminal file manager