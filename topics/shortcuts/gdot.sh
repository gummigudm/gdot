# Variables
platforms="macos"
context="base"

# Install
configure() {
    # Camera watcher launch agent
    src="${gdot_config_dir}/shortcuts/com.gummigudm.camera-watcher.plist"
    dest="$HOME/Library/LaunchAgents/com.gummigudm.camera-watcher.plist"
    create_link "$src" "$dest"
}
