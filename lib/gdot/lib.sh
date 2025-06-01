# ------------------------------------------------------------------------------
# Prerequisites
# ------------------------------------------------------------------------------

## Source empty config
function _source_base() {
    source "${gdot_path}/lib/gdot/gdot.sh"
}

## Get shell being run on.
function _get_shell() {
    current_shell=$(basename "$SHELL")

    if [ ! -d "${gdot_path}/shells/$current_shell" ]; then
        printf "Error: A profile does not exist for the current shell '$current_shell'\n" >&2
        exit 1
    fi
}

# ------------------------------------------------------------------------------
# Helper Functions
# ------------------------------------------------------------------------------

## Function to check if brew is initialized.
function _is_init_brew() {
    if [ ! -d "/opt/homebrew/bin" ]; then
        return 1
    fi
    eval "$(/opt/homebrew/bin/brew shellenv)"
    if ! which brew &> /dev/null; then
        return 1
    fi
    return 0
}

## Function to check if mas is initialized.
function _is_init_mas() {
    if ! which mas &> /dev/null; then
        return 1
    fi
    return 0
}

## Function to check if gdot is initialized.
function _is_init() {
    if [ "$current_platform" == "macos" ] ; then
        if _is_init_brew ; then
            if _is_init_mas ; then
                return 0
            fi
        fi
        return 1
    fi
    return 0
}

## Function to check if action made a change since last check
function _was_changed() {
    if [[ $was_changed_flag -eq 1 ]] ; then
        was_changed_flag=0
        return 0
    fi
    return 1
}

## Check if current platform and context is supported.
function _is_supported() {
    support_factors=0
    if [[ "$platforms" == "all" ]] ; then
        support_factors=$((support_factors + 1))
    else
        available_platforms=",${platforms},"
        needle_platform=",${current_platform},"
        if [[ "$available_platforms" == *"$needle_platform"* ]] ; then
            support_factors=$((support_factors + 1))
        fi
    fi

    if [[ "$gdot_context" == "all" ]] ; then
        support_factors=$((support_factors + 1))
    else
        available_contexts=",${gdot_context},"

        current_dir_name=$(basename "$current_dir")
        current_dir_ctx=",${current_dir_name},"
        current_ctx=",${context},"

        if [[ "$available_contexts" == *"$current_ctx"* ]] ; then
            support_factors=$((support_factors + 1))
        elif [[ "$available_contexts" == *"$current_dir_ctx"* ]] ; then
            support_factors=$((support_factors + 1))
        fi
    fi

    if [[ $support_factors -eq 2 ]] ; then
        return 0
    fi
    return 1
}

# ------------------------------------------------------------------------------
# Tool Actions
# ------------------------------------------------------------------------------

# Tool list
function _tool_list() {
    printf "\n"
    printf "%-16.16s  %-32.32s\n" "Tool" "Desc"
    printf "%-32s\n" "--------------------------------"
    desc=$(grep -m1 '^## gdotdesc:' "$gdot_path/bin/gdot" | sed 's/^## gdotdesc:[[:space:]]*//')
    printf "%-16.16s  %-32.32s\n\n" "gdot" "$desc"

    while IFS= read -r tool; do
        tool_name=$(basename "$tool")
        if [ $tool_name == "gdot" ]; then
            continue
        fi
        desc=$(grep -m1 '^## gdotdesc:' "$tool" | sed 's/^## gdotdesc:[[:space:]]*//')
        if [ -n "$desc" ]; then
            printf "%-16.16s  %-32.32s\n" "$tool_name" "$desc"
        fi
    done < <(
        find "$gdot_path/bin" -mindepth 1 -maxdepth 1 |
        while IFS= read -r path; do
            printf "%s\t%s\n" "$(basename "$path")" "$path"
        done | sort -k1,1 | cut -f2
    )
}

# ------------------------------------------------------------------------------
# Shell Actions
# ------------------------------------------------------------------------------

# Shell list
function _shell_list() {
    printf "\n"
    printf "%-16.16s  %-16.16s\n" "Shell" "Context"
    printf "%-32s\n" "--------------------------------"
    ## Loop and sort
    while IFS= read -r shell_profile; do
        source "$shell_profile/gdot.sh"
        printf "%-16.16s  %-16.16s\n" "$(basename "$shell_profile")" "$context"
    done < <(
        find "$gdot_path/shells" -mindepth 1 -maxdepth 1 -type d |
        while IFS= read -r path; do
            printf "%s\t%s\n" "$(basename "$path")" "$path"
        done | sort -k1,1 | cut -f2
    )
}

# Shell setup
function _shell_setup() {
    # Single shell setup
    if [ -n "$1" ]; then
        if [ ! -d "$gdot_path/shells/$1" ]; then
            printf "Error: Shell profile '%s' not found\n" "$1" >&2
            exit 1
        fi
        if [ ! -f "$gdot_path/shells/$1/gdot.sh" ]; then
            printf "Error: Shell profile '%s' gdot file not found\n" "$1" >&2
            exit 1
        fi
        _source_base
        source "$gdot_path/shells/$1/gdot.sh"
        current_dir="$gdot_path/shells/$1"

        printf "\n********* Configuring shell profile **********\n"
        log_header "$1"

        if _is_supported ; then
            configure
        else
            printf "* Not enabled on this platform or context.\n"
        fi
    # All shells setup
    else
        printf "\n********* Configuring shell profiles *********\n"
        while IFS= read -r shell_profile; do
            shell_name=$(basename "$shell_profile")
            if [ ! -f "$shell_profile/gdot.sh" ] ; then
                printf "Error: Shell profile '%s' gdot file not found\n" "$shell_name" >&2
                exit 1
            fi

            _source_base
            source "$shell_profile/gdot.sh"
            current_dir="$shell_profile"

            if _is_supported ; then
                log_header "$shell_name"
                bootstrap
                install
                configure
            fi
        done < <(
            find "$gdot_path/shells" -mindepth 1 -maxdepth 1 -type d |
            while IFS= read -r path; do
                printf "%s\t%s\n" "$(basename "$path")" "$path"
            done | sort -k1,1 | cut -f2
        )
    fi
}

# ------------------------------------------------------------------------------
# Topic Actions
# ------------------------------------------------------------------------------

# Topic list
function _topic_list() {
    printf "\n"
    printf "%-16.16s  %-16.16s\n" "Topic" "Context"
    printf "%-32s\n" "--------------------------------"
    while IFS= read -r topic; do
        source "$topic/gdot.sh"
        printf "%-16.16s  %-16.16s\n" "$(basename "$topic")" "$context"
    done < <(
        find "$gdot_path/topics" -mindepth 1 -maxdepth 1 -type d |
        while IFS= read -r path; do
            printf "%s\t%s\n" "$(basename "$path")" "$path"
        done | sort -k1,1 | cut -f2
    )
}

# Topic setup
function _topic_setup() {
    # Single topic setup
    if [ -n "$1" ]; then
        if [ ! -d "$gdot_path/topics/$1" ]; then
            printf "Error: Topic '%s' not found\n" "$1" >&2
            exit 1
        fi
        if [ ! -f "$gdot_path/topics/$1/gdot.sh" ]; then
            printf "Error: Topic '%s' gdot file not found\n" "$1" >&2
            exit 1
        fi
        _source_base
        source "$gdot_path/topics/$1/gdot.sh"
        current_dir="$gdot_path/topics/$1"

        printf "\n********* Configuring topic ******************\n"
        log_header "$1"

        if _is_supported ; then
            bootstrap
            install
            configure
        else
            printf "* Not enabled on this platform or context.\n"
        fi
    # All topics setup
    else
        printf "\n********* Configuring topics *****************\n"
        while IFS= read -r topic; do
            topic_name=$(basename "$topic")
            if [ ! -f "$topic/gdot.sh" ] ; then
                printf "Error: Topic '%s' gdot file not found\n" "$topic_name" >&2
                exit 1
            fi

            _source_base
            source "$topic/gdot.sh"
            current_dir="$topic"

            if _is_supported ; then
                log_header "$topic_name"
                bootstrap
                install
                configure
            fi
        done < <(
            find "$gdot_path/topics" -mindepth 1 -maxdepth 1 -type d |
            while IFS= read -r path; do
                printf "%s\t%s\n" "$(basename "$path")" "$path"
            done | sort -k1,1 | cut -f2
        )
    fi
}

# ------------------------------------------------------------------------------
# CLI Actions
# ------------------------------------------------------------------------------

# Dot
function _dot() {
    _shell_setup
    _topic_setup
}

# Edit dotfiles
function _edit() {
    if [ -n "$VISUAL" ]; then
        if [ "$VISUAL" == "code" ]; then
            if ! command -v "code" &> /dev/null; then
                printf "Error: VSCode is not installed or not in PATH.\n" >&2
                exit 1
            fi
            printf "Opening dotfiles for editing with vs code...\n"
            code "$gdot_path"
        else
            printf "Opening dotfiles for editing with '%s'...\n" "$VISUAL"
            "$VISUAL" "$gdot_path"
            if [ $? -ne 0 ]; then
                printf "Error: Could not open editor '%s'. Please ensure visual editor can handle opening repo.\n" "$VISUAL" >&2
                exit 1
            fi
        fi
    else
        printf "No editor set. Please set VISUAL environment variable.\n" >&2
        exit 1
    fi
}

# Initialize gdot
function _init() {
    if _is_init ; then
        return 0
    fi

    if [ "$current_platform" == "macos" ] ; then
        printf "\n********* Initializing gdot ******************\n"

        if ! which brew > /dev/null; then
            log_header "Installing Homebrew"
            if [ $verbose -eq 1 ]; then
                /bin/bash -c "$(curl -fsSL ${brew_url})"
            else
                /bin/bash -c "$(curl -fsSL ${brew_url})" &> /dev/null
            fi
            if [ $? -eq 0 ]; then
                eval "$(/opt/homebrew/bin/brew shellenv)"
                printf "%s\n" "Homebrew installed"
            else
                printf "%s\n" "Homebrew could not be installed"
                exit 1
            fi
        else
            printf "%s\n" "Homebrew already installed"
        fi

        if which brew > /dev/null; then
            if ! which mas &> /dev/null; then
                log_header "Installing Mas CLI"
                if [ $verbose -eq 1 ]; then
                    brew install -q mas
                else
                    brew install -q mas &> /dev/null
                fi
                if [ $? -eq 0 ]; then
                    printf "%s\n" "MAS CLI installed"
                    open_application 'App Store' '/System/Applications/App Store.app' 4
                    printf "\n"
                    printf "Finish init by logging in to App store if not already logged in\n"
                    exit 0
                else
                    printf "%s\n" "MAS CLI could not be installed"
                    exit 1
                fi
            else
                printf "%s\n" "MAS CLI already installed"
            fi
        fi
    fi
}
