## Login shell (4)
## Loaded after .zshrc

# initialize autocomplete
autoload -U compinit && compinit

# Source profile completion file
source "$GDOT_DIR/shells/zsh/completion.zsh"

# Source all topic completion files
typeset -U completion_files
completion_files=($GDOT_DIR/topics/*/completion.zsh(N)) 2>/dev/null
for file in ${completion_files} ; do
    source "$file"
done
unset completion_files
