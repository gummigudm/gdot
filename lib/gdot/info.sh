# ------------------------------------------------------------------------------
# Info
# ------------------------------------------------------------------------------

## Get settings from gdot file
function _get_settings() {
    gdot_settings_file_def="${gdot_path}/.gdot.default"
    gdot_settings_file="${gdot_path}/.gdot"

    if [ -z "$gdot_path" ]; then
        printf "Error: gdot path variable is not set. Please set the gdot_path variable.\n" >&2
        exit 1
    fi

    if [ ! -f "$gdot_settings_file_def" ] && [ ! -f "$gdot_settings_file" ]; then
        printf "Error: gdot settings file missing from path '%s'\n" "$gdot_path" >&2
        exit 1
    fi

    if [ -f "$gdot_settings_file_def" ]; then
        source "$gdot_settings_file_def"
    fi

    if [ -f "$gdot_settings_file" ]; then
        source "$gdot_settings_file"
    fi
}

## Get platform being run on. workstation(mac) or server
function _get_platform() {
    os_type=$(uname -s | tr A-Z a-z)
    case $os_type in
    linux)
        source /etc/os-release
        case $ID in
        debian|ubuntu|mint)
            current_platform="deb"
            ;;
        fedora|rhel|centos)
            current_platform="rpm"
            ;;
        *)
            current_platform="unsupported"
        esac
    ;;
    darwin)
        current_platform="macos"
    ;;
    *)
        current_platform="unsupported"
    esac

    if [ "$current_platform" == "unsupported" ]; then
        printf "Error: Unsupported platform for gDot\n"
        exit 1
    fi
}
