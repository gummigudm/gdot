# Variables
platforms="macos,deb,rpm"
context="base"

install() {
    brew_install
    yum_install "tree"
    apt_install "tree"
}
