# Variables
platforms="macos"
context="base"

# Install
install() {
    brew_install
}

# Configure
configure() {
    # Settings
    defaults write com.knollsoft.Rectangle launchOnLogin -int 1
    defaults write com.knollsoft.Rectangle alternateDefaultShortcuts -int 1
    defaults write com.knollsoft.Rectangle internalTilingNotified -int 1
    defaults write com.knollsoft.Rectangle windowSnapping -int 2
    defaults write com.knollsoft.Rectangle subsequentExecutionMode -int 0
    log "Rectangle settings configured"

    # Shortcuts
    defaults write com.knollsoft.Rectangle maximize -dict keyCode 126 modifierFlags 1835008
    defaults write com.knollsoft.Rectangle centerHalf -dict keyCode 125 modifierFlags 1835008
    defaults write com.knollsoft.Rectangle leftHalf -dict keyCode 123 modifierFlags 1572864
    defaults write com.knollsoft.Rectangle rightHalf -dict keyCode 124 modifierFlags 1572864
    defaults write com.knollsoft.Rectangle topLeft -dict keyCode 123 modifierFlags 1310720
    defaults write com.knollsoft.Rectangle topRight -dict keyCode 124 modifierFlags 1310720
    defaults write com.knollsoft.Rectangle bottomRight -dict keyCode 124 modifierFlags 1441792
    defaults write com.knollsoft.Rectangle bottomLeft -dict keyCode 123 modifierFlags 1441792
    log "Rectangle shortcuts configured"
}
