# Variables
platforms="macos,deb,rpm"
context="base"

# Configure
configure() {
    ssh_dir="${HOME}/.ssh"

    # Create directory for .ssh config
    create_dir "$ssh_dir" 700

    # Create link for config file
    src="${gdot_config_dir}/ssh/config"
    dest="$HOME/.ssh/config"
    create_link "$src" "$dest"

    # Create link for personal folder
    src="${gdot_config_dir}/ssh/personal"
    dest="$HOME/.ssh/personal"
    create_link "$src" "$dest"

    # Create link for work folder
    src="${gdot_config_dir}/ssh/work"
    dest="$HOME/.ssh/work"
    create_link "$src" "$dest"

    # Ensure authorized_keys file exists
    authorized_keys_file="${ssh_dir}/authorized_keys"
    if [ ! -f "$authorized_keys_file" ]; then
        touch "$authorized_keys_file"
        chmod 600 "$authorized_keys_file"
    fi
    log "Authorized keys file ensured"

    # Ensure known_hosts file exists
    known_hosts_file="${ssh_dir}/known_hosts"
    if [ ! -f "$known_hosts_file" ]; then
        touch "$known_hosts_file"
        chmod 644 "$known_hosts_file"
    fi
    log "Known hosts file ensured"
}
