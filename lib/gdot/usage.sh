# ------------------------------------------------------------------------------
# Usage and Help functions
# ------------------------------------------------------------------------------

# Show usage
function _usage() {
    if _is_init ; then
        _usage_main
    else
        _usage_init
    fi
}

# Show main usage
function _usage_main() {
    printf "\ngDot - Version 1.0\n"
    printf "  Dotfile and workstation management utility that handles shell and topic management.\n"
    printf "  https://github.com/gummigudm/gdot\n\n"

    printf "Usage: %s <command> [<subcommand>...]\n\n" "$(basename $0)"

    printf "Commands:\n"
    printf "  dot                         Bootstrap, install, configure, update (alias: update)\n"
    printf "  edit                        Open repo for editing\n"
    printf "  shell <command>             Shell management\n"
    printf "  topic <command>             Topic management\n"
    printf "  tools                       List available tools\n\n"

    printf "Options:\n"
    printf "  -c=ctx | --context=ctx      Set context for run\n"
    printf "  -h     | --help             Show help and usage\n"
    printf "  -v     | --verbose          Show verbose output\n\n"
}

# Show init usage
function _usage_init() {
    printf "\nUsage: %s init [options]\n\n" "$(basename $0)"

    printf "Commands:\n"
    printf "  init                        Initial requirement installation\n\n"
    printf "  edit                        Open repo for editing\n"

    printf "Options:\n"
    printf "  -h | --help                 Show help and usage\n"
    printf "  -v | --verbose              Show verbose output\n\n"
}

# Show shell usage
function _usage_shell() {
    printf "\nUsage: %s shell <command>\n\n" "$(basename $0)"

    printf "Commands:\n"
    printf "  list                        Lists available shell profiles or details\n"
    printf "  setup [<profile>]           Sets up all or single shell\n\n"

    printf "Options:\n"
    printf "  -c=ctx | --context=ctx      Set context for run\n"
    printf "  -h     | --help             Show help and usage\n"
    printf "  -v     | --verbose          Show verbose output\n\n"
}

# Show topic usage
function _usage_topic() {
    printf "\nUsage: %s topic <command>\n\n" "$(basename $0)"

    printf "Commands:\n"
    printf "  list                        Lists available topics or details\n"
    printf "  setup [<topic>]             Sets up all or single topic\n\n"

    printf "Options:\n"
    printf "  -c=ctx | --context=ctx      Set context for run\n"
    printf "  -h     | --help             Show help and usage\n"
    printf "  -v     | --verbose          Show verbose output\n\n"
}
