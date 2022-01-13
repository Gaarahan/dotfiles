set -e

# get absolute path from relative path {{
CORE_UTIL_PATH="/usr/local/opt/coreutils/libexec/gnubin"

getPath() {
  if [[ $PATH =~ "$CORE_UTIL_PATH" ]]; then
    export PATH="$CORE_UTIL_PATH:$PATH"
  fi
  local curr_path=$(pwd)
  local SHELL_POSITION=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd)

  cd $curr_path

  realpath "$SHELL_POSITION/$1"
}
# }}

UTILS_PATH=$(getPath "./utils.sh")
# shellcheck disable=SC1090
source "$UTILS_PATH"

ZSHRC="$HOME/.zshrc"

if [ "$(isSupported)" != true ]; then
  error 'Sorry, the current script only works on linux and macos'
  exit 1
fi
