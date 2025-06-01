# ------------------------------------------------------------------------------
# Available action functions
# ------------------------------------------------------------------------------

## Function to log a line of text
function log() {
    printf "* %s\n" "$1"
}

## Function to log a header line
function log_header() {
    printf "\n** %s **\n" "$1"
}

## Function to supply sudo pass before installation
function supply_sudo() {
    if [ "$current_platform" != "macos" ]; then
        if ! which sudo &> /dev/null; then
            printf "Error: gDot requires sudo to install packages\n" >&2
            return 1
        fi
    fi
    if [[ "$sudo_password" == "" ]] ; then
        until sudo -n true 2> /dev/null; do
            read -s -p "-> Sudo Password:" sudo_password
            echo
            sudo -S -v <<< "${sudo_password}" 2> /dev/null
        done
    else
        sudo -S -v <<< "${sudo_password}" 2> /dev/null
    fi
    return 0
}

## Function to check if action made a change since last check
function was_changed() {
    if [[ $was_changed_flag -eq 1 ]] ; then
        was_changed_flag=0
        return 0
    fi
    return 1
}

## Function to check if on macos
function is_macos() {
    [[ "$current_platform" == "macos" ]]
}

## Function to check if on rpm based system
function is_rpm() {
    [[ "$current_platform" == "rpm" ]]
}

## Function to check if on deb based system
function is_deb() {
    [[ "$current_platform" == "deb" ]]
}


## Function to open Application
# arg 1: application_name
# arg 2: application_path
# arg 3: sleep time seconds before continuing
function open_application() {
    if [ "$current_platform" != "macos" ] ; then
        return
    fi
    local name="$1" ; local path="$2"
    local sleeptime="$3"
    open "$path"
    if [ $? -eq 0 ]; then
        printf "* Opening application '%s'\n" "$name"
    else
        printf "Error: Could not open application '%s'\n" "$name" >&2
        exit 1
    fi
    sleep $sleeptime
}

## Function to open App Store Application
# arg 1: application_name
function close_application() {
    if [ "$current_platform" != "macos" ] ; then
        return
    fi
    local name="$1"
    printf "* Closing application '%s'\n" "$name"
    sleep 1
    osascript -e 'quit app "'"$name"'"'
}

## Function to reload Finder if changes were made
function reload_finder() {
    if [ "$current_platform" != "macos" ] ; then
        return
    fi
    sleep 3
    if killall Finder ; then
        printf "* Finder reloaded\n"
    else
        printf "Error: Finder could not be reloaded\n" >&2
        exit 1
    fi
}

## Create directory
# arg 1: dir_path
# arg 2: mode (optional)
function create_dir() {
    if [ ! -d "$1" ] ; then
        mkdir -p "$1" && chmod ${2:-"755"} "$1"
        if [ $? -eq 0 ]; then
            printf "* Directory '${1}' created\n"
            was_changed_flag=1
        else
            printf "* Directory '${1}' could not be created\n"
            return 1
        fi
    else
        printf "* Directory '${1}' already exits\n"
    fi
}

## Function to create symlink.
# arg 1: source content
# arg 2: destination link
function create_link() {
    if ! [ -f "$1" -o -d "$1" ] ; then
        printf "* Link Content '${1}' not found\n"
        return 1
    fi
    if [ -L "$2" ] ; then
        printf "* Link '${2}' already exists\n"
        return 0
    elif [ -f "$2" -o -d "$2" -o -L "$2" ] ; then
        rm -rf "$2"
        printf "* Content '${2}' removed\n"
    fi
    ln -s "$1" "$2"
    printf "* Content '${2}' linked to '${1}'\n"
}

## Function to install package with Brew
# arg 1: brewfile path, can be left empty to use default brewfile
function brew_install() {
    if ! is_macos ; then
        return 0
    fi
    if [ -n "$1" ] ; then
        use_file="$1/brewfile"
    else
        use_file="${current_dir}/brewfile"
    fi
    if [ ! -f "$use_file" ] ; then
        printf "Brewfile '%s' not found\n" "$use_file" >&2
        return 1
    fi

    printf "* Ensuring '%s' with brew\n" "$(basename "$current_dir")"
    if [ $verbose -eq 1 ]; then
        printf "(brew output start):\n"
        brew bundle upgrade --file="$use_file" --verbose
        printf "(brew output end)\n"
    else
        brew bundle upgrade --file="$use_file" --quiet &> /dev/null
    fi
}

## Function to install package with apt
# arg 1: package name
# arg n: additional apt arguments (optional)
function apt_install() {
    if ! is_deb ; then
        return 0
    fi
    if [ -n "$1" ] ; then
        pkg_name="$1"
        shift
    else
        printf "Error: Apt Package name missing\n" >&2
        return 1
    fi

    printf "* Ensuring '%s' with apt\n" "$(basename "$current_dir")"
    if ! supply_sudo ; then
        return 1
    fi
    if [ $verbose -eq 1 ]; then
        printf "(apt output start):\n"
        sudo apt update &> /dev/null
        if [ $? -ne 0 ]; then
            printf "Error: apt update failed\n" >&2
            return 1
        fi
        sudo apt install -y "$pkg_name" "$@"
        if [ $? -ne 0 ]; then
            printf "Error: apt install failed for '%s'\n" "$pkg_name" >&2
            return 1
        fi
        printf "(apt output end)\n"
    else
        sudo apt install -y "$pkg_name" "$@" &> /dev/null
        if [ $? -ne 0 ]; then
            printf "Error: apt install failed for '%s'\n" "$pkg_name" >&2
            return 1
        fi
    fi
}

## Function to install package with yum
# arg 1: package name
# arg n: additional yum arguments (optional)
function yum_install() {
    if ! is_rpm ; then
        return 0
    fi
    if [ -n "$1" ] ; then
        pkg_name="$1"
        shift
    else
        printf "Error: Yum Package name missing\n" >&2
        return 1
    fi

    printf "* Ensuring '%s' with yum\n" "$(basename "$current_dir")"
    if ! supply_sudo ; then
        return 1
    fi
    if [ $verbose -eq 1 ]; then
        printf "(yum output start):\n"
        sudo yum install -y "$pkg_name" "$@"
        if [ $? -ne 0 ]; then
            printf "Error: yum install failed for '%s'\n" "$pkg_name" >&2
            return 1
        fi
        printf "(yum output end)\n"
    else
        sudo yum install -y "$pkg_name" "$@" &> /dev/null
        if [ $? -ne 0 ]; then
            printf "Error: yum install failed for '%s'\n" "$pkg_name" >&2
            return 1
        fi
    fi
}