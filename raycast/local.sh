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
elif [[ $1 =~ ^[a-z0-9]{30} ]]; then
  open "https://yuntu.alipay.com/yuntu/trace/traceView?traceId=$1"
else
  # else search in yuyan
  open "https://yuyan.antfin-inc.com/search?q=$1"
fi
