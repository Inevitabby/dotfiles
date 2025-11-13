# =========
# Powerline
# =========
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi
USE_POWERLINE="true" # Use Powerline

# ====================================
# Portage Completation + Gentoo Prompt 
# ====================================

autoload -U compinit promptinit
compinit
promptinit
prompt gentoo

# =====================
# Aliases and Functions
# =====================

# Coreutils
alias ls="eza"
alias cat="bat"
alias grep="grep --color=auto"
alias diff="diff --color --side-by-side --minimal"
alias cp="cp -i" # Confirm before overwriting something

# Portage (requires "permit nopass <user> cmd emerge" in /etc/doas.conf)
alias emerge="doas emerge"
alias e="doas emerge"
alias es="emerge --search" # (shorter + doesn't require lockfile like doas emerge --search)
alias eq="equery"

# Update (Update, Rebuild, and Depclean)
update() {
	echo "Running update [1/4]"
	e --update --deep --newuse --verbose @world --keep-going --ask --backtrack=1000
	echo "Running preserved-rebuild [2/4]"
	e @preserved-rebuild
	echo "Running module-rebuild [3/4]"
	e @module-rebuild
	echo "Running depclean [4/4]"
	e --depclean
}

# nnn
alias nas="nnn ${HOME}/Sync/NAS" # ... in my NAS directory
alias notes="nnn ${HOME}/Sync/Notes/Personal" # ... in my [personal] notes directory
alias school="nnn '${HOME}/Sync/Notes/School/Fall 2025'" # ... in my school directory
alias gitlab="cd '${HOME}/Scripts/Gitlab/notes/'; git pull; nnn .; git status" # ... in my Gitlab notes directory
alias gl="gitlab"
alias scripts="nnn '${HOME}/Scripts'" # ... in my scripts directory

# Quick Notes
alias n="vi ${HOME}/Sync/Notes/Personal/Quicknote.md" # For notes that require more shelf-life than a scratch buffer
zettel() {
	vi "${HOME}/Sync/Notes/Personal/Zettelkasten/$1.md"
}
compdef "_files -W ${HOME}/Sync/Notes/Personal/Zettelkasten -g '*.md(:r)'" zettel
alias z='zettel' # For quicknotes that I want to store without categorizing

# Todo.txt
alias todo="vi -c ':set filetype=todotxt' ${HOME}/Sync/Notes/todo.txt" # Edit Todo.txt in Neovim
alias topydo="${HOME}/Scripts/venv/bin/topydo" # Launch topydo
alias t="todo.sh -d ${HOME}/.config/todo/config.sh"

# Auto Editor
alias auto-editor="${HOME}/Scripts/venv/bin/auto-editor --ffmpeg-location '/usr/bin/ffmpeg' --no-open"

# Whoogle Search
alias whoogle-search="${HOME}/Scripts/venv/bin/whoogle-search"

# Subliminal
alias subliminal="${HOME}/Scripts/venv/bin/subliminal"

# Personal Translation Script
alias translate="${HOME}/Scripts/venv/bin/python ${HOME}/Scripts/venv/bin/translate"

# Git
alias gitroot='cd $(git rev-parse --show-toplevel)'
alias g="git"

# Zola
alias zola="flatpak run org.getzola.zola"

# Accept package
alias accept_keyword='function _accept_keyword(){ 
    local package="$1"
    local package_name="${package##*/}"
    local file="/etc/portage/package.accept_keywords/$package_name"
    echo "$package" | sudo tee "$file" > /dev/null
}; _accept_keyword'
_accept_keyword_completions() {
    compadd $(eix)
}

compdef _accept_keyword_completions accept_keyword

# =======
# Exports
# =======

# Add PNPM support
export PNPM_HOME=~/.local/share/pnpm
export PATH="$PNPM_HOME:$PATH"

# Neovim as default editor
export EDITOR=/usr/bin/nvim
export VISUAL=/usr/bin/nvim
export NVIM_LSP_LOG_FILE=/tmp/nvim-lsp.log

# Prefer Dolphin Filepicker over GNOME (maybe this should be a global environment variable? or maybe that would create problems...)
export GTK_USE_PORTAL=1

# Spicetify
export PATH="$PATH:${HOME}/.spicetify"

# Cargo and Go
export PATH="$PATH:${HOME}/.cargo/bin"
export PATH="$PATH:${HOME}/go/bin"

# ===============
# fzf Integration
# ===============

# Default keybinds
source <(fzf --zsh)

# Use Bat for Fzf previewer
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

# =============
# Shell Options
# =============

setopt correct # Auto correct mistakes
setopt extendedglob # Extended globbing. Allows using regular expressions with *
setopt nocaseglob # Case insensitive globbing
setopt rcexpandparam # Array expension with parameters
setopt nocheckjobs # Don't warn about running processes when exiting
setopt numericglobsort # Sort filenames numerically when it makes sense
setopt nobeep # No beep
setopt appendhistory # Immediately append history instead of overwriting
setopt histignorealldups # If a new command is a duplicate, remove the older one
setopt autocd # if only directory path is entered, cd there.
setopt inc_append_history # save commands are added to the history immediately, otherwise only when shell exits.
setopt histignorespace # Don't save commands that start with space

# ===========
# Namespacing
# ===========

# Completions
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}' # Case insensitive tab completion
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}" # Colored completion (different colors for dirs/files/etc)
zstyle ':completion:*' rehash true # Automatically find new executables in path 
zstyle ':completion:*' insert-tab pending # Don't perform completion when pasting with tabs
zstyle -e ':completion:*:approximate:*' \
	max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3))numeric)' # Fuzzy completion

# Performant Completions
zstyle ':completion:*' accept-exact '*(N)' 
zstyle ':completion:*' use-cache on # Proxy list of results
zstyle ':completion:*' cache-path ~/.zsh/cache # proxy list of results

# Ignore CVS Files & Directories
zstyle ':completion:*:(all-|)files' ignored-patterns '(|*/)CVS'
zstyle ':completion:*:cd:*' ignored-patterns '(*/)#CVS'

# =======
# History
# =======

HISTFILE=~/.zhistory
HISTSIZE=10000
SAVEHIST=10000
WORDCHARS=${WORDCHARS//\/[&.;]} # Don't consider certain characters part of the word

# ===========
# Keybindings
# ===========

bindkey -e

# Make keyboard keys function as expected
bindkey '^[[2~' overwrite-mode # Insert key
bindkey '^[[3~' delete-char # Delete key
bindkey '^[[C'  forward-char # Right key
bindkey '^[[D'  backward-char # Left key
bindkey '^[[5~' history-beginning-search-backward # Page up key
bindkey '^[[6~' history-beginning-search-forward # Page down key
bindkey '^[[7~' beginning-of-line # Home key
bindkey '^[[H' beginning-of-line # Home key
if [[ "${terminfo[khome]}" != "" ]]; then
	bindkey "${terminfo[khome]}" beginning-of-line # Home key
fi
bindkey '^[[8~' end-of-line # End key
bindkey '^[[F' end-of-line # End key
if [[ "${terminfo[kend]}" != "" ]]; then
	bindkey "${terminfo[kend]}" end-of-line # End key
fi

# Navigate words with Ctrl + Arrow Keys
bindkey '^[Oc' forward-word
bindkey '^[Od' backward-word
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word
bindkey '^H' backward-kill-word # Ctrl + Backspace to delete previous word
bindkey '^[[Z' undo # Shift + Tab to undo last action

# =======
# Theming
# =======

# Theme
autoload -U compinit colors zcalc
colors

# Color man pages
export LESS_TERMCAP_mb=$'\E[01;32m'
export LESS_TERMCAP_md=$'\E[01;32m'
export LESS_TERMCAP_me=$'\E[0m'
export LESS_TERMCAP_se=$'\E[0m'
export LESS_TERMCAP_so=$'\E[01;47;34m'
export LESS_TERMCAP_ue=$'\E[0m'
export LESS_TERMCAP_us=$'\E[01;36m'
export LESS=-R

# =======
# Plugins
# =======

# Fish-like syntax highlighting (AUR Package: `zsh-syntax-highlighting`)
source ~/.zsh/catppuccin_mocha-zsh-syntax-highlighting.zsh
source ~/.zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# Fish history search (AUR Package: `zsh-history-substring-search`)
source ~/.zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
# Bind UP and DOWN arrow keys to zsh-history-substring-search
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# ======
# Prompt
# ======

emulate -L zsh
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh # Fish-like autosuggestions (AUR Package: `zsh-autosuggestions`)

# Determine terminal capabilities.
{ if ! zmodload zsh/langinfo zsh/terminfo ||
	[[ $langinfo[CODESET] != (utf|UTF)(-|)8 || $TERM == (dumb|linux) ]] ||
	(( terminfo[colors] < 256 )); then
	# Don't use the powerline config. It won't work on this terminal.
	local USE_POWERLINE=false
	# Define alias `x` if our parent process is `login`.
	local parent
	if { parent=$(</proc/$PPID/comm) } && [[ ${parent:t} == login ]]; then
		alias x='startx ~/.xinitrc'
	fi
fi } 2>/dev/null

# ================
# Powerlevel Again
# ================

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=244' # Use 256 colors and UNICODE

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

