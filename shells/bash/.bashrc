## Interactive shell
## Loaded on interactive shells that are not login shells, new terminal etc.

## Profile setup based on gdot setup or direct
export GDOT=0
if [ -d ~/.gdot/.git ]; then
    ## GDOT setup
    export GDOT=1
    export GDOT_SHELL="bash"
    export GDOT_DIR="$HOME/.gdot"
fi

# Load if gdot is disabled
if [ $GDOT -eq 0 ]; then
    # Source prompt if it exists
    if [ -f ~/.bash_gdot_prompt ]; then
        source ~/.bash_gdot_prompt
    fi

    # Common path
    export PATH="$PATH:."

    # Common aliases
    alias ll='ls -alphb --color=auto'
fi

## Load gdot if enabled
if [ $GDOT -eq 1 ]; then
    # Set nullglob to avoid errors with empty arrays
    shopt -s nullglob

    # Source shell files
    shell_files=()
    shell_files=("$GDOT_DIR"/shells/bash/*.bash)
    for file in "${shell_files[@]}" ; do
        if [[ -f "$file" ]]; then
            source "$file"
        fi
    done
    unset shell_files

    # Source all topic path files
    path_files=()
    path_files=("$GDOT_DIR"/topics/*/path.bash)
    for file in "${path_files[@]}" ; do
        if [[ -f "$file" ]]; then
            source "$file"
        fi
    done
    unset path_files

    # Source aliases files
    alias_files=()
    alias_files=("$GDOT_DIR"/topics/*/aliases.bash)
    for file in "${alias_files[@]}" ; do
        if [[ -f "$file" ]]; then
            source "$file"
        fi
    done
    unset alias_files

    # Unset nullglob to restore default behavior
    shopt -u nullglob

    # Load prompt
    source "$GDOT_DIR/shells/bash/.bash_gdot_prompt"
fi