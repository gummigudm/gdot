# Variables
platforms="macos"
context="code"

# Install
install() {
    brew_install
}

configure() {
    create_dir "$python_env_dir" 755

    # Poetry Zsh completion
    poetry completions zsh > "$gdot_path/shells/zsh/completions/_poetry"
    log "Poetry zsh completions ensured"
}
