# Variables
platforms="macos"
context="base"

# Install
configure() {
    close_application "TextEdit"

    log "Setting preferences"
    # Start with rich text doc
    defaults write com.apple.TextEdit RichText -bool FALSE
    # Show ruler
    defaults write com.apple.TextEdit ShowRuler -bool FALSE
    # Smart Copy and paste
    defaults write com.apple.TextEdit SmartCopyPaste -bool FALSE
    # Smart dashes
    defaults write com.apple.TextEdit SmartDashes -bool FALSE
    # Smart quotes
    defaults write com.apple.TextEdit SmartQuotes -bool FALSE
    # Smart Substitution in rich text only
    defaults write com.apple.TextEdit SmartSubstitutionsEnabledInRichTextOnly -bool FALSE
    # Text replacement
    defaults write com.apple.TextEdit TextReplacement -bool FALSE
    # Check spelling
    defaults write com.apple.TextEdit CheckSpellingWhileTyping -bool FALSE
    # Auto correct spelling
    defaults write com.apple.TextEdit CorrectSpellingAutomatically -bool FALSE
    # Ignore HTML (Show raw)
    defaults write com.apple.TextEdit IgnoreHTML -bool TRUE
    # Author
    defaults write com.apple.TextEdit author -string "$gdot_name"
    # Company
    defaults write com.apple.TextEdit company -string "$gdot_org"
    # Copyright
    defaults write com.apple.TextEdit copyright -string "$gdot_name"
}
