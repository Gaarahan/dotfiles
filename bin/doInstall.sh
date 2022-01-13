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
2) Only link the config file
"

read -r
if [ "$REPLY" == '1' ]; then
  bot "Let's start from scratch:"
  source $(getPath './startFromScratch.sh')
elif [ "$REPLY" == '2' ]; then
  bot "Let's link the config file:"
  source $(getPath './linkConfigFile.sh')
fi

