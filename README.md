<!-- markdownlint-disable MD013 MD033-->

# DOTFILES

Personal macOS environment configuration for development and daily productivity.

Main components:

- Neovim (Lua config, plugin manager: `lazy.nvim`)
- zsh
- tmux
- lazygit
- CLI utilities and command-line tooling setup
- macOS preference automation scripts
- App-related local config files (for supported tools)

- Terminal Preview ( nvim tmux zsh lazygit) :
  [Click here](https://drive.google.com/file/d/1M6_sfxfztqIchVFZFh9LQTVj-Qond7QA/view?usp=sharing) to view how this
  work.

### Neovim

Neovim is configured in Lua under `nvim/`.

![vim & tmux & lazygit](https://user-images.githubusercontent.com/34125917/212490415-26eb779a-9026-4431-8cd1-0509662d260b.png)

### Usage

Clone this repo, and run:

```sh
cd dotfiles
chmod a+x ./bin/doInstall.sh
./bin/doInstall.sh
```

The installer is interactive and provides options to:

1. Start from scratch
2. Link config files and install dependencies
3. Apply macOS preference tweaks

### What this repo manages

This repository is not limited to terminal editor setup.
It also includes practical macOS tooling setup and selected app configuration, such as:

- shell and terminal workflows (`zsh`, `tmux`, `lazygit`)
- editor and language tooling (`nvim`, LSP, formatter-related config)
- utility scripts under `bin/` for machine bootstrap and preference setup
- selected app config directories tracked in this repository

### Plugin installation

Neovim plugins are managed by `lazy.nvim`.
After linking config files, open `nvim` once and plugins will be installed automatically on first launch.

### Platform notes

- Installer flow is currently macOS-oriented (Homebrew and macOS preferences are included).
