#!/usr/bin/env bash

# debug mode {{
getopts "d" isDebugMode

if [ "${isDebugMode}" == 'd' ]; then
  set -x
  set -v
fi
# }}

source ./bin/scripts/prepareBeforeStart.sh

bot "Which configuration do you want?
1) Start from scratch
2) Link the config file and install plugins
3) Config your MacOS preferences
"

read -r
if [ "$REPLY" == '1' ]; then
  bot "Let's start from scratch:"
  source $(getPath './startFromScratch.sh')
elif [ "$REPLY" == '2' ]; then
  source $(getPath './linkConfigFile.sh')
elif [ "$REPLY" == '3' ]; then
  bot "Let's config your MacOS preferences:"
  source $(getPath './changeMacPreference.sh')
fi

