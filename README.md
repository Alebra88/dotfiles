# Dotfiles

My personal dotfiles managed with GNU Stow.

## Setup

1. Install GNU Stow:
```bash
brew install stow
```

2. Clone this repository:
```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
```

3. Use GNU Stow to symlink configs:
```bash
stow sketchybar
stow aerospace
```

## Contents

- **sketchybar**: SketchyBar configuration with Aerospace integration
  - Custom workspace indicators
  - App icons per workspace
  - Only shows non-empty workspaces
  - White highlighting for active workspace

- **aerospace**: AeroSpace window manager configuration
  - Tiling window management
  - Workspace switching keybindings
  - SketchyBar integration hooks
