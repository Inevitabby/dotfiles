#!/usr/bin/env bash
# This script updates/installs/reinstalls OpenAsar (https://github.com/GooseMod/OpenAsar), a light and open alternative to Discord's app.asar
# - NOTE: Often needed after a Discord update nukes the previous app.asar
# Require to be ran with sudo
[ "$UID" -eq 0 ] || { echo "This script must be run as root."; exit 1;}
ASAR="/opt/discord/resources/app.asar"
echo "Installing OpenAsar..."
# Kill Discord
killall --quiet Discord
# Backup existing asar
[ -f "${ASAR}" ] && mv --force "${ASAR}" "${ASAR}.backup"
# Install asar (download latest nightly release)
sudo curl --silent --location "https://github.com/GooseMod/OpenAsar/releases/download/nightly/app.asar" --output "${ASAR}"
