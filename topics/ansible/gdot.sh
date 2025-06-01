# Variables
platforms="macos,deb,rpm"
context="code"

# Install
install() {
    log "No direct install, use pyenv"
}

# Configure
configure() {
    # Create link for .ansible.cfg
    src="$current_dir/.ansible.cfg"
    dest="$HOME/.ansible.cfg"
    create_link "$src" "$dest"
}
