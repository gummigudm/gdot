# Variables
platforms="macos"
context="base"

# Bootstrap
bootstrap() {

    log "Setting Finder view"
    # Suppress warning when removing files from iCloud
    defaults write com.apple.finder FXEnableRemoveFromICloudDriveWarning -bool FALSE
    # New window target
    defaults write com.apple.finder NewWindowTarget -string PfHm
    defaults write com.apple.finder NewWindowTargetPath -string "file:///${HOME}/"
    # New window style
    defaults write com.apple.finder FXPreferredViewStyle -string "clmv"

    log "Setting MacOS interface"
    # Global Accent color
    defaults write NSGlobalDomain AppleAccentColor -int -1
    defaults write "Apple Global Domain" AppleAccentColor -int -1
    # Global Highlight color
    defaults write NSGlobalDomain AppleHighlightColor -string "0.847059 0.847059 0.862745 Graphite"
    defaults write "Apple Global Domain" AppleHighlightColor -string "0.847059 0.847059 0.862745 Graphite"
    # Interface Style - Dark mode
    defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
    defaults write "Apple Global Domain" AppleInterfaceStyle -string "Dark"
    # Desktop tinting
    defaults write NSGlobalDomain AppleReduceDesktopTinting -bool TRUE
    defaults write "Apple Global Domain" AppleReduceDesktopTinting -bool TRUE
    # Scrolling behaviour
    defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool TRUE
    defaults write "Apple Global Domain" AppleScrollerPagingBehavior -bool TRUE

    log "Setting global text handling"
    # Auto caps off
    defaults write "Apple Global Domain" NSAutomaticCapitalizationEnabled -bool FALSE
    # Dash substitution
    defaults write "Apple Global Domain" NSAutomaticDashSubstitutionEnabled -bool FALSE
    # Period substitution
    defaults write "Apple Global Domain" NSAutomaticPeriodSubstitutionEnabled -bool FALSE
    # Quote substitution
    defaults write "Apple Global Domain" NSAutomaticQuoteSubstitutionEnabled -bool FALSE
    # Auto spelling correction
    defaults write "Apple Global Domain" NSAutomaticSpellingCorrectionEnabled -bool FALSE
    # Auto text completion
    defaults write "Apple Global Domain" NSAutomaticTextCompletionEnabled -bool TRUE

    log "Setting dock preferences"
    # Auto hide
    defaults write com.apple.dock autohide -bool TRUE
    # Show process indicators (dot under icon)
    defaults write com.apple.dock show-process-indicators -bool FALSE
    # Recent apps
    defaults write com.apple.dock show-recents -bool FALSE

    reload_finder
}
