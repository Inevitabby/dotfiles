#!/usr/bin/env bash
# === Environment Variables ===
# Allow Environment Variable Configuration
export WHOOGLE_DOTENV=1
# Catppuccin Mocha (Source: https://github.com/catppuccin/whoogle)
export WHOOGLE_CONFIG_STYLE=":root { /* DARK THEME COLORS */ --whoogle-dark-logo: #cdd6f4; --whoogle-dark-page-bg: #1e1e2e; --whoogle-dark-element-bg: #45475a; --whoogle-dark-text: #cdd6f4; --whoogle-dark-contrast-text: #bac2de; --whoogle-dark-secondary-text: #a6adc8; --whoogle-dark-result-bg: #313244; --whoogle-dark-result-title: #b4befe; --whoogle-dark-result-url: #f5e0dc; --whoogle-dark-result-visited: #eba0ac; } #whoogle-w { fill: #89b4fa; } #whoogle-h { fill: #f38ba8; } #whoogle-o-1 { fill: #f9e2af; } #whoogle-o-2 { fill: #89b4fa; } #whoogle-g { fill: #a6e3a1; } #whoogle-l { fill: #f38ba8; } #whoogle-e { fill: #f9e2af; } div.logo-container, div.logo-div, footer { display:none } body { max-width: 100%!important } "
export WHOOGLE_CONFIG_THEME="dark"
# Remove Useless Config UI
export WHOOGLE_CONFIG_DISABLE=1
# Disable Autocomplete
export WHOOGLE_AUTOCOMPLETE=0
# Use GET Requests (Firefox Container Fix)
export WHOOGLE_CONFIG_GET_ONLY=1
# === Start Whoogle ===
~/Scripts/venv/bin/whoogle-search --port 5001
