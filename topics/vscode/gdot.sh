# Variables
platforms="macos"
context="code"

# Install
install() {
    brew_install
}

# Configure
configure() {
    local vscode_conf="${gdot_config_dir}/vscode"
    local code_dir="${HOME}/Library/Application Support/Code"
    local user_dir="${code_dir}/User"

    ## Create directories.
    create_dir "$code_dir" 700
    create_dir "$user_dir" 755

    ## Create link for settings.
    src="${vscode_conf}/settings.json"
    dst="${user_dir}/settings.json"
    create_link "$src" "$dst"

    ## Create link for keybindings.
    src="${vscode_conf}/keybindings.json"
    dst="${user_dir}/keybindings.json"
    create_link "$src" "$dst"

    ## Create link for snippets.
    src="${vscode_conf}/snippets"
    dst="${user_dir}/snippets"
    create_link "$src" "$dst"
}
