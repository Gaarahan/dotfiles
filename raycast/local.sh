#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title JARVIS
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "PORT or PACKAGE" }
# @raycast.packageName local

# Documentation:
# @raycast.description Open local by port

if [[ $string =~ ^[0-9]+$ ]]; then
  # if all number: open localhost
  open "https://localhost:$1"
else 
  # else search in yuyan
  open "https://yuyan.antfin-inc.com/search?q=$1"
fi
