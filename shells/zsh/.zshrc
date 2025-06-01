## Interactive only (3)
## Main configuration loaded for interactive shell

## Source profile configuration
typeset -U shell_files
shell_files=($GDOT_DIR/shells/*/*.zsh(N)) 2>/dev/null
for file in ${${shell_files:#*/path.zsh}:#*/completion.zsh}
do
  source "$file"
done
unset shell_files

## Source topic configuration
typeset -U topic_files
topic_files=($GDOT_DIR/topics/*/*.zsh(N)) 2>/dev/null
for file in ${${topic_files:#*/path.zsh}:#*/completion.zsh}
do
  source "$file"
done
unset topic_files

## Set language env
export LC_ALL="en_US.UTF-8"
