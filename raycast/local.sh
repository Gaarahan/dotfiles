#!/bin/bash

# Required parameters:
# @raycast.schemaVersion 1
# @raycast.title LOCAL
# @raycast.mode compact

# Optional parameters:
# @raycast.icon 🤖
# @raycast.argument1 { "type": "text", "placeholder": "PORT" }
# @raycast.packageName local

# Documentation:
# @raycast.description Open local by port

open "https://localhost:$1"
