# === File Locations ===

export TODO_DIR="${HOME}/Sync/Notes/"
export TODO_FILE="$TODO_DIR/todo.txt"
export DONE_FILE="$TODO_DIR/done.txt"
export REPORT_FILE="$TODO_DIR/report.txt"
export TODO_ACTIONS_DIR="${HOME}/.config/todo/.todo.actions.d"

# === Color Map ===

export BLACK='\\033[0;30m'
export RED='\\033[0;31m'
export GREEN='\\033[0;32m'
export BROWN='\\033[0;33m'
export BLUE='\\033[0;34m'
export PURPLE='\\033[0;35m'
export CYAN='\\033[0;36m'
export LIGHT_GREY='\\033[0;37m'
export DARK_GREY='\\033[1;30m'
export LIGHT_RED='\\033[1;31m'
export LIGHT_GREEN='\\033[1;32m'
export YELLOW='\\033[1;33m'
export LIGHT_BLUE='\\033[1;34m'
export LIGHT_PURPLE='\\033[1;35m'
export LIGHT_CYAN='\\033[1;36m'
export WHITE='\\033[1;37m'
export DEFAULT='\\033[0m'

# === Colors ===

export PRI_A=$YELLOW        # color for A priority
export PRI_B=$GREEN         # color for B priority
export PRI_C=$LIGHT_BLUE    # color for C priority
# export PRI_D=...            # define your own
export PRI_X=$WHITE         # color unless explicitly defined

export COLOR_DONE=$LIGHT_GREY

export COLOR_PROJECT=$RED
export COLOR_CONTEXT=$RED
export COLOR_DATE=$BLUE
export COLOR_NUMBER=$LIGHT_GREY

export COLOR_META=$CYAN

# === General ===

# Run `ls` by default
export TODOTXT_DEFAULT_ACTION=ls
# Don't collapse whitespace
export TODOTXT_PRESERVE_LINE_NUMBERS=1

# === Filters ===

# Sort by due date
export TODOTXT_SORT_COMMAND='sed -e "s/.* due:\([0-9-]\+\).*/\1 &/" -e t -e "s/^/0000-00-00/" | sort -k1 | sed -e "s/^[0-9-]\+ //"'
# Hide items with starting dates in the future
export TODOTXT_FINAL_FILTER="python ${HOME}/.config/todo/.todo.actions.d/futureTasks"
# Hide "TODO: n of m tasks shown"
export TODOTXT_VERBOSE=0
