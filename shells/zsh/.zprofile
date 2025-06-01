## Login shell (2)
## Loaded before .zshrc

# Source all topic path files
typeset -U path_files
path_files=($GDOT_DIR/topics/*/path.zsh(N)) 2>/dev/null
for file in ${path_files} ; do
    source "$file"
done
unset path_files

# Source shell path file
source "$GDOT_DIR/shells/zsh/path.zsh"