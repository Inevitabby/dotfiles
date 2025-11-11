#!/usr/bin/env bash
# (LanguageTool server has relative paths)
cd "${HOME}/.config/LanguageTool" || exit

# Increase entity size limit
export _JAVA_OPTIONS="-Djdk.xml.totalEntitySizeLimit=2500000 -Djdk.xml.entityExpansionLimit=2500000"

# Launch server
languagetool-server --config ~/.config/LanguageTool/server.properties -p 8081 --public --allow-origin "*"
