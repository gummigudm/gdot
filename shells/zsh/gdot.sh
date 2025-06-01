platforms="all"
context="zsh"

configure() {
    # Create link for .hushlogin
    src="$current_dir/.hushlogin"
    dest="$HOME/.hushlogin"
    create_link "$src" "$dest"
    
    # Generate .zshenv
    printf "## Managed by gdot\n" > "$HOME/.zshenv"
    printf "## Initial env (1)\n## Sets dotdir locations\n\n" >> "$HOME/.zshenv"
    printf "## Dotfile directories\n" >> "$HOME/.zshenv"
    printf "export GDOT_DIR=%s\n" "$gdot_path" >> "$HOME/.zshenv"
    printf "export GDOT_DIR_CONF=%s\n" "$gdot_config_dir" >> "$HOME/.zshenv"
    printf "export GDOT_USER=%s\n" "$gdot_user" >> "$HOME/.zshenv"
    printf "export GDOT_HOST=%s\n" "$gdot_host" >> "$HOME/.zshenv"
    printf "export ZDOTDIR=%s\n" "$gdot_path/shells/zsh" >> "$HOME/.zshenv"

    log "Zsh profile ensured\n"
}
