#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title JARVIS
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 👾
# @raycast.argument1 { "type": "text", "placeholder": "PORT or PACKAGE or TRACE" }
# @raycast.packageName local

# Documentation:
# @raycast.description Open local by port

if [[ $1 =~ ^[0-9]+$ ]]; then
  # if all number: open localhost
  open "https://localhost:$1"
elif [[ $1 =~ ^[A-Z0-9]{34} ]]; then
  # looks like a logid
  open "https://cloud.bytedance.net/argos/streamlog/info_overview/log_id_search?logId=$1"
else
  # else search in bnpm
  open "https://bnpm.bytedance.net/search?query=$1&pageNumber=1&pageSize=20&private=false"
fi
