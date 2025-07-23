platforms="all"
context="bash"

# Install
install() {
    brew_install
}

# Configure
configure() {
    # Create link for .bashrc
    src="$current_dir/.bashrc"
    dest="$HOME/.bashrc"
    create_link "$src" "$dest"

    # Create link for .bash_profile
    src="$current_dir/.bash_profile"
    dest="$HOME/.bash_profile"
    create_link "$src" "$dest"
}