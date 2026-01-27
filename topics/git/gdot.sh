# Variables
platforms="macos,deb,rpm"
context="code"

# Install
install() {
    brew_install
    apt_install "git"
    yum_install "git"
}

# Configure
configure() {
    configure_gitconfig
    configure_gh_extensions
}

# Configure git config
configure_gitconfig() {
    # Variables
    macos_default_1pass_program="/Applications/1Password.app/Contents/MacOS/op-ssh-sign"

    # Set signer state
    local signer signerfmt
    case "$git_signer" in
        "none")
            signer=""
            signerfmt=""
            git_signing_key=""
            ;;
        "gpg")
            signer="gpg"
            signerfmt="gpg"
            [ -z "$git_signing_key" ] && signer=""
            ;;
        "ssh")
            signer="ssh"
            signerfmt="ssh"
            [ -z "$git_signing_key" ] && signer=""
            ;;
        "1pass")
            signer="1pass"
            signerfmt="ssh"
            [ -z "$git_signing_key" ] && signer=""
            ;;
        *)
            signer=""
            signerfmt=""
            ;;
    esac

    ## Create config file
    printf "## Managed by gdot\n\n" > "$HOME/.gitconfig"

    # Include base
    printf "# Include base git config\n" >> "$HOME/.gitconfig"
    printf "[include]\n" >> "$HOME/.gitconfig"
    printf "    path = %s\n\n" "$current_dir/.gitconfig" >> "$HOME/.gitconfig"

    # Personal
    printf "[user]\n" >> "$HOME/.gitconfig"
    printf "    name = %s\n" "$git_name" >> "$HOME/.gitconfig"
    printf "    email = %s\n" "$git_mail" >> "$HOME/.gitconfig"
    printf "    username = %s\n" "$git_user" >> "$HOME/.gitconfig"

    # Signing
    if [ -n "$signer" ]; then
        printf "    signingkey = %s\n" "$git_signing_key" >> "$HOME/.gitconfig"
    fi
    printf "\n" >> "$HOME/.gitconfig"
    if [ -n "$signer" ]; then
        printf "[commit]\n" >> "$HOME/.gitconfig"
        printf "    gpgsign = true\n\n" >> "$HOME/.gitconfig"
    fi
    if [ -n "$signerfmt" ]; then
        printf "[gpg]\n" >> "$HOME/.gitconfig"
        printf "    format = %s\n\n" "$signerfmt" >> "$HOME/.gitconfig"

        if [ "$signerfmt" = "ssh" ]; then
            if [ "$signer" = "1pass" ]; then
                if [ -n "$git_signer_program" ]; then
                    printf '[gpg "ssh"]\n' >> "$HOME/.gitconfig"
                    printf "    program = %s\n\n" "$git_signer_program" >> "$HOME/.gitconfig"
                else
                    if is_macos; then
                        printf '[gpg "ssh"]\n' >> "$HOME/.gitconfig"
                        printf "    program = %s\n\n" "$macos_default_1pass_program" >> "$HOME/.gitconfig"
                    fi
                fi
            fi
        fi
    fi

    # Macos helper
    if is_macos; then
        printf "[credential]\n" >> "$HOME/.gitconfig"
        printf "    helper = osxkeychain\n\n" >> "$HOME/.gitconfig"
    fi

    # Include code personal
    printf '[includeIf "gitdir:%s"]\n' "$gdot_code_dir/personal/" >> "$HOME/.gitconfig"
    printf "    path = %s\n\n" "$gdot_code_dir/personal/.gitconfig" >> "$HOME/.gitconfig"
    # Include code work
    printf '[includeIf "gitdir:%s"]\n' "$gdot_code_dir/work/" >> "$HOME/.gitconfig"
    printf "    path = %s\n\n" "$gdot_code_dir/work/.gitconfig" >> "$HOME/.gitconfig"

    log "Gitconfig configuration ensured"
}

# Configure gh extensions
configure_gh_extensions() {
    local extension_dir="$HOME/.local/share/gh/extensions"
    create_dir "$extension_dir"

    while IFS= read -r ghext; do
        ext_name=$(basename "$ghext")
        create_link "$gdot_path/lib/gh/$ext_name" "$extension_dir/$ext_name"

    done < <(
        find "$gdot_path/lib/gh" -mindepth 1 -maxdepth 1 -type d |
        while IFS= read -r path; do
            printf "%s\t%s\n" "$(basename "$path")" "$path"
        done | sort -k1,1 | cut -f2
    )

    log "GitHub CLI extensions ensured"
}