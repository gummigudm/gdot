## History
HISTFILE=${ZDOTDIR:-$HOME}/.zsh_history
SAVEHIST=5000
HISTSIZE=2000
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE


## Shell behaviour
setopt NO_CASE_GLOB
unsetopt CORRECT
unsetopt CORRECT_ALL

## Editor
export EDITOR="code"
export VISUAL="code"