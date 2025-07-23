# ------------------------------------------------------------------------------
# Parse and run
# ------------------------------------------------------------------------------

## Parse commands and execute
function _gdot() {
    local show_help=0
    local options=()
    local commands=()
    local usage=""
    local action="none"
    local param=""
    local context_from_args=""

    _get_platform
    _get_shell
    _get_settings

    while [ $# -gt 0 ]; do
        case "$1" in
            -*)
                options+=("$1")
                ;;
            *)
                commands+=("$1")
                ;;
        esac
        shift
    done

    if [ "${#commands[@]}" -eq 0 ]; then
        _usage
        exit 0
    fi

    case "${commands[0]}" in
        init)
            if _is_init ; then
                printf "gdot is already initialized.\n" >&2
                _usage
                exit 0
            fi
            action="_init"
            if [ -n "${commands[1]}" ]; then
                printf "Error: Invalid argument '${commands[1]}'\n" >&2
                _usage
                exit 1
            fi
            ;;
        edit)
            action="_edit"
            if [ -n "${commands[1]}" ]; then
                printf "Error: Invalid argument '${commands[1]}'\n" >&2
                _usage
                exit 1
            fi
            ;;
        shell)
            if ! _is_init ; then
                printf "gdot is not initialized. Please run 'gdot init' first.\n" >&2
                exit 1
            fi
            action="_shell"
            case "${commands[1]}" in
                list)
                    action="${action}_list"
                    if [ -n "${commands[2]}" ]; then
                        printf "Error: Invalid argument '${commands[2]}'\n" >&2
                        _usage_shell
                        exit 1
                    fi
                    ;;
                setup)
                    action="${action}_setup"
                    if [ -n "${commands[2]}" ]; then
                        param="${commands[2]}"
                    fi
                    if [ -n "${commands[3]}" ]; then
                        printf "Error: Invalid argument '${commands[3]}'\n" >&2
                        _usage_shell
                        exit 1
                    fi
                    ;;
                copy)
                    action="${action}_copy"
                    if [ -n "${commands[2]}" ]; then
                        param="${commands[2]}"
                    else
                        printf "Error: Missing shell profile name argument\n" >&2
                        _usage_shell
                        exit 1
                    fi
                    if [ -n "${commands[3]}" ]; then
                        printf "Error: Invalid argument '${commands[3]}'\n" >&2
                        _usage_shell
                        exit 1
                    fi
                    ;;
                '')
                    _usage_shell
                    exit 0
                    ;;
                *)
                    printf "Error: Invalid command '${commands[1]}'\n" >&2
                    _usage_shell
                    exit 1
                    ;;
            esac
            ;;
        topic)
            if ! _is_init ; then
                printf "gdot is not initialized. Please run 'gdot init' first.\n" >&2
                exit 1
            fi
            action="_topic"
            case "${commands[1]}" in
                list)
                    action="${action}_list"
                    if [ -n "${commands[2]}" ]; then
                        printf "Error: Invalid argument '${commands[2]}'\n" >&2
                        _usage_topic
                        exit 1
                    fi
                    ;;
                setup)
                    action="${action}_setup"
                    if [ -n "${commands[2]}" ]; then
                        param="${commands[2]}"
                    fi
                    if [ -n "${commands[3]}" ]; then
                        printf "Error: Invalid argument '${commands[3]}'\n" >&2
                        _usage_topic
                        exit 1
                    fi
                    ;;
                '')
                    _usage_topic
                    exit 0
                    ;;
                *)
                    printf "Error: Invalid command '${commands[1]}'\n" >&2
                    _usage_topic
                    exit 1
                    ;;
            esac
            ;;
        dot|update)
            if ! _is_init ; then
                printf "gdot is not initialized. Please run 'gdot init' first.\n" >&2
                exit 1
            fi
            action="_dot"
            if [ -n "${commands[1]}" ]; then
                printf "Error: Invalid argument '${commands[1]}'\n" >&2
                _usage
                exit 1
            fi
            ;;
        tools)
            action="_tool_list"
            if [ -n "${commands[1]}" ]; then
                printf "Error: Invalid argument '${commands[1]}'\n" >&2
                _usage
                exit 1
            fi
            ;;
        *)
            printf "Error: Invalid command '${commands[0]}'\n" >&2
            _usage
            exit 1
            ;;
    esac

    for option in "${options[@]}"; do
        case "$option" in
            -c=*|--context=*)
                context_from_args="${option#*=}"
                if [[ -z "$context_from_args" ]]; then
                    printf "Error: Invalid context value, cannot be empty\n" >&2
                    exit 1
                fi
                ;;
            -h|--help)
                usage="_usage${usage}"
                $usage
                exit 0
                ;;
            -v|--verbose)
                verbose=1
                ;;
            *)
                printf "Error: Invalid option '$option'\n" >&2
                exit 1
                ;;
        esac
    done

    if [[ -n "$context_from_args" ]]; then
        gdot_context="$context_from_args"
    fi

    "$action" "$param"
}
