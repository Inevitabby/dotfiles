#!/usr/bin/env bash
mkdir -p "${HOME}/Scripts/venv"
cd "${HOME}/Scripts/venv" || error "Couldn't access ~/Scripts/venv/"
./bin/python -m pip install --upgrade pip
