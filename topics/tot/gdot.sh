# Variables
platforms="macos"
context="personal"

# Install
install() {
    brew_install
}

# Configure
configure() {
    defaults write com.iconfactory.Tot detachedWindow -int 1
    defaults write com.iconfactory.Tot hideDockIcon -int 1
    defaults write com.iconfactory.Tot hideToutIOS -int 1
    defaults write com.iconfactory.Tot launchAtLogin -int 1
    log "Tot settings configured"
}
