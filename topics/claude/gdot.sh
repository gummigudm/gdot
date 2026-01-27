# Variables
platforms="macos"
context="core"

# Install
install() {
    brew_install
}

# Configure
configure() {
    claude_dir="${HOME}/.claude"

    # Create directory for .claude config
    create_dir "$claude_dir" 755

    # Create link for CLAUDE.md file
    src="${gdot_config_dir}/claude/CLAUDE.md"
    dst="${claude_dir}/CLAUDE.md"
    create_link "$src" "$dst"

    # Create link for settings.json file
    src="${gdot_config_dir}/claude/settings.json"
    dst="${claude_dir}/settings.json"
    create_link "$src" "$dst"

    # Create link for rules folder
    src="${gdot_config_dir}/claude/rules"
    dst="${claude_dir}/rules"
    create_link "$src" "$dst"

    # Create link for skills folder
    src="${gdot_config_dir}/claude/skills"
    dst="${claude_dir}/skills"
    create_link "$src" "$dst"

    log "Claude configuration completed"
}
