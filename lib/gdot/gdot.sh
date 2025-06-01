# ------------------------------------------------------------------------------
# Variables
# ------------------------------------------------------------------------------

## Define what platforms topic or profile should be provisioned on
#     all or comma separated list of platforms
#     supported: all, macos, deb, rpm
platforms="unsupported"

## Define what context topic or shell should be provisioned on
#     all, or a single named context
context="unsupported"

# ------------------------------------------------------------------------------
# Available variables
# ------------------------------------------------------------------------------

## $current_directory
#     Current topic directory
#     Useful for path to topic files when creating links etc.

# ------------------------------------------------------------------------------
# Available functions
# ------------------------------------------------------------------------------

## log <message>
#     Logs a message to the console
#     arg 1: message to log

## log_header <message>
#     Logs a header message to the console
#     arg 1: message to log as header
#     Useful for logging section headers in the install process

## is_macos
#     Checks if current platform is macOS
#     Returns 0 if true, 1 if false

## is_rpm
#     Checks if current platform is RPM based (f.x. Fedora, CentOS)
#     Returns 0 if true, 1 if false

## is_deb
#     Checks if current platform is DEB based (f.x. Ubuntu, Debian)
#     Returns 0 if true, 1 if false

## supply_sudo
#     Asks user for sudo password if not already supplied.
#     If sudo password is already provided,
#     it prolongs credentials for long running installs.

## was_changed
#     Checks if the previous action made changes.
#     Useful f.x. if actions are required only after an install
#     Use: if was_changed; then...

## open_application <application_name> <application_path> <sleep>
#     Opens applications on macOS
#     arg 1: Name
#     arg 2: Path
#     arg 3: sleep time seconds before continuing

## close_application <application_name>
#     Closes application on macOS
#     arg 1: Name

## reload_finder
#     Reloads finder on macOS if changes were made
#     Used with plist changes that might need a reload

## create_dir <dir_path> [<mode>]
#     Creates directory
#     arg 1: dir_path
#     arg 2: mode (optional)

## create_link <src> <dst>
#     Creates symlink
#     will replace existing content at destination
#     arg 1: source content
#     arg 2: destination link

## brew_install [<brewfile>]
#     Install package with Brew
#     arg 1: optional brewfile path
#            if not provided it will use 'brewfile' in current directory

## yum_install <name>
#     Install cask/application with Brew
#     arg 1: cask name

## mas_install_application <name> <id>
#     Install App store application with MAS
#     arg 1: app name
#     arg 2: app identifier

# ------------------------------------------------------------------------------
# Functions to overwrite
# ------------------------------------------------------------------------------

## Runs to bootstrap, before install
function bootstrap() {
    :
    # printf "* No bootstrap actions\n"
}

## Runs to install
function install() {
    :
    # printf "* No install actions\n"
}

## Runs to configure, after install
function configure() {
    :
    # printf "* No configure actions\n"
}
