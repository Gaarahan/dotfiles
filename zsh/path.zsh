# Centralized PATH management for zsh.
# Goal: keep PATH clean, deduplicated, and portable across machines.

# `path` <-> `PATH` are tied in zsh. Make it unique to avoid duplicates.
typeset -U path PATH

path_prepend() {
  local p="$1"
  [[ -n "$p" && -d "$p" ]] || return 0
  path=("$p" $path)
}

path_append() {
  local p="$1"
  [[ -n "$p" && -d "$p" ]] || return 0
  path+=("$p")
}

brew_prefix() {
  command -v brew >/dev/null 2>&1 || return 1
  brew --prefix "$1" 2>/dev/null
}

# Add lower-priority toolchains first because each call prepends its path.
# --- Platform tools ---
path_prepend "$HOME/Library/Android/sdk/platform-tools"

# --- Language toolchains ---
export PYENV_ROOT="${PYENV_ROOT:-$HOME/.pyenv}"
path_prepend "$PYENV_ROOT/bin"

export GOPATH="${GOPATH:-$HOME/go}"
path_prepend "$GOPATH/bin"

# --- Package managers ---
path_prepend "$HOME/.yarn/bin"
path_prepend "$HOME/.config/yarn/global/node_modules/.bin"

# --- Personal & dotfiles tools ---
path_prepend "$HOME/.local/bin"

_path_file_dir="${${(%):-%N}:A:h}"
_dot_bin_path="${_path_file_dir:A}/../bin/tools"
path_prepend "${_dot_bin_path:A}"
unset _path_file_dir _dot_bin_path

# --- Highest priority: NVM-selected Node ---
path_prepend "$NVM_DIR/current/bin"

# --- Homebrew packages (lower priority than user/toolchain bins) ---
_icu4c_prefix="$(brew_prefix icu4c)" || _icu4c_prefix=""
[[ -n "$_icu4c_prefix" ]] && path_append "$_icu4c_prefix/bin"
[[ -n "$_icu4c_prefix" ]] && path_append "$_icu4c_prefix/sbin"

_openjdk_prefix="$(brew_prefix openjdk)" || _openjdk_prefix=""
[[ -n "$_openjdk_prefix" ]] && path_append "$_openjdk_prefix/bin"

unset _icu4c_prefix _openjdk_prefix

