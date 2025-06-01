# Variables
platforms="macos"
context="base"

# Install
install() {
    brew_install
    if was_changed; then
        open_application "iTerm2" "/Applications/iTerm.app" 4
        close_application "iTerm2"
    fi
}

# Configure
configure() {
    iterm_conf="$gdot_config_dir/iterm2"

    ## Link config folder
    if [[ -d "$iterm_conf" ]] ; then
        defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$iterm_conf"
        log "iTerm2 custom preferences set"
    else
        printf "* Preferences folder not found '%s', using default\n" "$iterm_conf"
        exit 1
    fi
}
