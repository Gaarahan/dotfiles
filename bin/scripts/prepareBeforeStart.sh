set -e

# NOTE: This repo's install flow is intended for macOS only.

source "./bin/scripts/utils.sh"

# ###########################################################
# Install non-brew various tools (PRE-BREW Installs)
# ###########################################################
bot "ensuring build/install tools are available"
if ! xcode-select --print-path &> /dev/null; then

    # Prompt user to install the XCode Command Line Tools
    xcode-select --install &> /dev/null

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Wait until the XCode Command Line Tools are installed
    until xcode-select --print-path &> /dev/null; do
        sleep 5
    done

    print_result $? ' XCode Command Line Tools Installed'

    # Prompt user to agree to the terms of the Xcode license
    # https://github.com/alrra/dotfiles/issues/10

    sudo xcodebuild -license
    print_result $? 'Agree with the XCode Command Line Tools licence'

fi

# ###########################################################
# install homebrew (CLI Packages)
# ###########################################################

running "checking homebrew..."
which brew &> /dev/null | true
if [[ ${PIPESTATUS[0]} != 0 ]]; then
  action "installing homebrew"
  bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  
  action "add brew to PATH"

  # Support both Apple Silicon (/opt/homebrew) and Intel (/usr/local).
  brew_bin=""
  if [ -x "/opt/homebrew/bin/brew" ]; then
    brew_bin="/opt/homebrew/bin/brew"
  elif [ -x "/usr/local/bin/brew" ]; then
    brew_bin="/usr/local/bin/brew"
  fi

  # Persist shellenv setup to ~/.zprofile (portable, no hardcoded username).
  if ! grep -q "brew shellenv" "$HOME/.zprofile" 2>/dev/null; then
    {
      echo
      echo '# Added by dotfiles installer (macOS only)'
      echo 'if [ -x /opt/homebrew/bin/brew ]; then'
      echo '  eval "$(/opt/homebrew/bin/brew shellenv)"'
      echo 'elif [ -x /usr/local/bin/brew ]; then'
      echo '  eval "$(/usr/local/bin/brew shellenv)"'
      echo 'fi'
    } >> "$HOME/.zprofile"
  fi

  if [ -n "$brew_bin" ]; then
    eval "$("$brew_bin" shellenv)"
  elif command -v brew >/dev/null 2>&1; then
    eval "$(brew shellenv)"
  fi

  if [[ $? != 0 ]]; then
    error "unable to install homebrew, script $0 abort!"
    exit 2
  fi
else
  ok
  bot "Homebrew"
  read -r -p "run brew update && upgrade? [y|N] " response
  if [[ $response =~ (y|yes|Y) ]]; then
    action "updating homebrew..."
    brew update
    ok "homebrew updated"
    action "upgrading brew packages..."
    brew upgrade
    ok "brews upgraded"
  else
    ok "skipped brew package upgrades."
  fi
fi

# load realpath and utils
brewCheckOrInstall coreutils

# get absolute path from relative path {{
CORE_UTIL_PATH=""
if command -v brew >/dev/null 2>&1; then
  CORE_UTIL_PATH="$(brew --prefix coreutils 2>/dev/null)/libexec/gnubin"
fi

getPath() {
  if [[ -n "$CORE_UTIL_PATH" && ! $PATH =~ "$CORE_UTIL_PATH" ]]; then
    export PATH="$CORE_UTIL_PATH:$PATH"
  fi
  local curr_path=$(pwd)
  local SHELL_POSITION=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

  cd $curr_path

  realpath "$SHELL_POSITION/$1"
}
# }}
