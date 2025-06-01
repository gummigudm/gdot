# -=------------------=-------------------------------------------------------------------------=- #
#  Prompt             Options to determine behaviour                                               #
#  Settings                                                                                        #
# -=------------------=-------------------------------------------------------------------------=- #

## Allow substitution
setopt PROMPT_SUBST
setopt TRANSIENT_RPROMPT

# -=------------------=-------------------------------------------------------------------------=- #
#  Prompt             Variables to determine behaviour                                             #
#  Variables                                                                                       #
# -=------------------=-------------------------------------------------------------------------=- #

## Main
PR_CHAR='→'                                 # Character for prompt
PR_SHOW_EXIT_CODE=0                         # Show exit code on error
PR_NEWLINE=1                                # Print newline before prompt

## Info
PR_USER_AND_HOST=0                          # Show full user@host:dir (Overwrites other settings)
PR_USER_SHOW_ALL=0                          # Show all users
PR_USER_SHOW_ROOT=1                         # Show root, if not all
PR_USER_SHOW_OTHER=1                        # Show other than in main list, if not all
PR_HOST_SHOW_ALL=1                          # Show all hostnames on right prompt
PR_HOST_SHOW_OTHER=1                        # Show other than in main list, if not all
PR_HOST_FQDN=1                              # Show host fqdn name
PR_USER_MAIN=(${GDOT_USER:-gummi})          # List of main users
PR_HOST_MAIN=(${GDOT_HOST:-hermes})         # List of main hosts
PR_DIR_RELATIVE=1                           # Show dir relative to home
PR_DIR_DEPTH=2                              # Show dir depth (0 for full)

## Git
PR_GIT_SHOW=1                               # Show Git branch
PR_GIT_SHOW_UPSTREAM_INFO=1                 # Show Git branch info
PR_GIT_SHOW_DIRECTORY_INFO=1                # Show Git directory info

## Pyenv
PR_PYENV_SHOW=1                             # Show Pyenv active
PR_PYENV_SHOW_NAME=1                        # Show Pyenv name

# -=------------------=-------------------------------------------------------------------------=- #
#  Info               Shows user, host and directory information                                   #
#  Prompt                                                                                          #
# -=------------------=-------------------------------------------------------------------------=- #

## Variables
PR_USER_COLOR_ROOT="%F{red}"
PR_USER_COLOR_OTHER="%F{yellow}"
PR_USER_COLOR_MAIN="%F{green}"
PR_HOST_COLOR="%F{blue}"
PR_DIR_COLOR="%F{cyan}"

## Render user prompt
function prompt_user() {
    local prompt hn
    if [ $PR_USER_AND_HOST -eq 1 ] ; then
        [ $PR_HOST_FQDN -eq 1 ] && hn="%M" || hn="%m"
        if [ $EUID -eq 0 ] ; then
            prompt="${PR_USER_COLOR_ROOT}%n%f@${PR_HOST_COLOR}${hn}%f:"
        elif [[ " ${PR_USER_MAIN[@]} " =~ " ${USERNAME} " ]] ; then
            prompt="${PR_USER_COLOR_MAIN}%n%f@${PR_HOST_COLOR}${hn}%f:"
        else
            prompt="${PR_USER_COLOR_OTHER}%n%f@${PR_HOST_COLOR}${hn}%f:"
        fi
    else
        if [ $EUID -eq 0 ] ; then
            if [ $PR_USER_SHOW_ALL -eq 1 ] || [ $PR_USER_SHOW_ROOT -eq 1 ] ; then
                prompt="${PR_USER_COLOR_ROOT}%n%f in "
            fi
        elif [[ " ${PR_USER_MAIN[@]} " =~ " ${USERNAME} " ]] ; then
            if [ $PR_USER_SHOW_ALL -eq 1 ] ; then
                prompt="${PR_USER_COLOR_MAIN}%n%f in "
            fi
        else
            if [ $PR_USER_SHOW_ALL -eq 1 ] || [ $PR_USER_SHOW_OTHER -eq 1 ] ; then
                prompt="${PR_USER_COLOR_OTHER}%n%f in "
            fi
        fi
    fi
    prompt+="%f"
    echo "$prompt"
}

## Render hostname in right prompt
function prompt_host() {
    local prompt hn hn_test
    if [ $PR_USER_AND_HOST -eq 0 ] ; then
        [ $PR_HOST_FQDN -eq 1 ] && hn="%M" || hn="%m"
        hn_test=$(hostname)
        if [[ " ${PR_HOST_MAIN[@]} " =~ " ${hn_test} " ]] ; then
            if [ $PR_HOST_SHOW_ALL -eq 1 ] ; then
                prompt="${PR_HOST_COLOR}${hn}"
            fi
        else
            if [ $PR_HOST_SHOW_ALL -eq 1 ] || [ $PR_HOST_SHOW_OTHER -eq 1 ] ; then
                prompt="${PR_HOST_COLOR}${hn}"
            fi
        fi
        echo "$prompt"
    fi
}

## Render dir prompt
function prompt_dir() {
    local prompt=${PR_DIR_COLOR}
    if [ $PR_USER_AND_HOST -eq 0 ] ; then
        if [ $PR_DIR_RELATIVE -eq 1 ] ; then
            prompt+="%${PR_DIR_DEPTH}~%f"
        else
            prompt+="%${PR_DIR_DEPTH}/%f"
        fi
    else
        prompt+="%~%f"
    fi
    echo "$prompt"
}

# -=------------------=-------------------------------------------------------------------------=- #
#  Git                Shows Git information                                                        #
#  Prompt                                                                                          #
# -=------------------=-------------------------------------------------------------------------=- #

## Variables
PR_GIT_COLOR_BRANCH="%F{magenta}"
PR_GIT_COLOR_STATE="%F{magenta}"
PR_GIT_ICON_BRANCH='⎇'
PR_GIT_ICON_BRANCH_NEW='⊕'
PR_GIT_ICON_BRANCH_MATCH='⦿'
PR_GIT_ICON_BRANCH_AHEAD='⇡'
PR_GIT_ICON_BRANCH_BEHIND='⇣'
PR_GIT_ICON_BRANCH_DIVERGED='⇅'
PR_GIT_ICON_DIR_CLEAN='✓'
PR_GIT_ICON_DIR_UNTRACKED='?'
PR_GIT_ICON_DIR_MODIFIED='!'
PR_GIT_ICON_DIR_STASHED='$'

## Render Git prompt
function prompt_git() {
    local branch upstream commits count directory branch_icon
    local prompt
    # Show git info
    if [ $PR_GIT_SHOW -eq 1 ] ; then
        branch=$(git symbolic-ref HEAD 2>/dev/null | awk -F/ {'print $NF'})
        [ -z $branch ] && return 0

        # Show upstream info
        if [ $PR_GIT_SHOW_UPSTREAM_INFO -eq 1 ] ; then
            upstream=$(git rev-parse --abbrev-ref --symbolic-full-name @{u} 2> /dev/null)
            if [ -z "$upstream" ] ; then
                branch_icon="$PR_GIT_ICON_BRANCH_NEW"
            else
                if commits="$(git rev-list --left-right "$upstream"...HEAD 2> /dev/null)" ; then
                    local behind=0 ahead=0
                    ## TODO: this is not splitting to lines
                    for commit in $commits ; do
                        case $commit in
                            "<"*) behind=$(( $behind + 1 )) ;;
                            *) ahead=$(( $ahead + 1 )) ;;
                        esac
                    done
                    count="$behind $ahead"
                else
                    count=""
                fi
                case "$count" in
                    "") branch_icon="$PR_GIT_ICON_BRANCH_NEW" ;;
                    "0 0") branch_icon="$PR_GIT_ICON_BRANCH_MATCH" ;;
                    "0 "*) branch_icon="$PR_GIT_ICON_BRANCH_AHEAD" ;;
                    *" 0") branch_icon="$PR_GIT_ICON_BRANCH_BEHIND" ;;
                    *) branch_icon="$PR_GIT_ICON_BRANCH_DIVERGED" ;;
                esac
            fi
            prompt+=" on ${PR_GIT_COLOR_BRANCH}${PR_GIT_ICON_BRANCH} ${branch}${branch_icon}"
        else
            prompt+=" on ${PR_GIT_COLOR_BRANCH}${PR_GIT_ICON_BRANCH} ${branch}"
        fi

        # Show directory info
        if [ $PR_GIT_SHOW_DIRECTORY_INFO -eq 1 ] ; then
            local untracked modified
            directory=$(git status --porcelain | cut -c 2 | sort | uniq -c)
            if [ ! -z $directory ] ; then
                prompt+=" ${PR_GIT_COLOR_STATE}["
                untracked=$(echo $directory | grep -c "?")
                modified=$(echo $directory | grep -c -v "?")
                [ $untracked -ne 0 ] && prompt+="${PR_GIT_ICON_DIR_UNTRACKED}"
                [ $modified -ne 0 ] && prompt+="${PR_GIT_ICON_DIR_MODIFIED}"
                prompt+="]"
            fi
        fi
        prompt+="%f"
        echo "$prompt"
    fi
}

# -=------------------=-------------------------------------------------------------------------=- #
#  Pyenv              Shows Python virtual environment information                                 #
#  Prompt                                                                                          #
# -=------------------=-------------------------------------------------------------------------=- #

## Variables
VIRTUAL_ENV_DISABLE_PROMPT=1
PR_PYENV_ICON='Ⓟ'
PR_PYENV_COLOR="%F{red}"

## Render Pyenv prompt
function prompt_pyenv() {
    local pyenv
    local prompt
    # Show pyenv info
    if [ $PR_PYENV_SHOW -eq 1 ] ; then
        if [[ -n "$VIRTUAL_ENV" ]]; then
            if [ $PR_PYENV_SHOW_NAME -eq 1 ] ; then
                pyenv="${VIRTUAL_ENV##*/}"
                prompt=" via ${PR_PYENV_COLOR}${PR_PYENV_ICON} ${pyenv}"
            else
                prompt=" via ${PR_PYENV_COLOR}${PR_PYENV_ICON}"
            fi
        fi
        prompt+="%f"
        echo "$prompt"
    fi
}

# -=------------------=-------------------------------------------------------------------------=- #
#  Prompt             Definition of prompt layout and assembly.                                    #
#  Assembly                                                                                        #
# -=------------------=-------------------------------------------------------------------------=- #

## Render prompt character
function prompt_char() {
    if [ $PR_SHOW_EXIT_CODE -eq 1 ] ; then
        echo "%(?.%F{green}.%F{red}(%?%))${PR_CHAR}%f "
    else
        echo "%(?.%F{green}.%F{red})${PR_CHAR}%f "
    fi
}

## Pre Command run before prompt
precmd() {
    if [ $PR_NEWLINE -eq 1 ] ; then
        echo
    fi
    print -P -- '$(prompt_user)$(prompt_dir)$(prompt_git)$(prompt_pyenv)'
}

RPROMPT='$(prompt_host)'
PROMPT='$(prompt_char)'
