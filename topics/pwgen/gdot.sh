# Variables
platforms="macos,deb"
context="base"

install() {
    brew_install
    apt_install "pwgen"
}
