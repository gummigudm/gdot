# -------------------------------------------------------------------
# Claude iTerm Profile initialization script
# -------------------------------------------------------------------

initiate_aws_sso_login() {
  print -r -- "  * AWS SSO login initiated in browser"
  local prof="${1:?AWS profile required}"

  (
    # ---- everything below runs in a subshell ----
    set -euo pipefail

    # Create a private temp dir + FIFO
    tmpdir="$(mktemp -d)"; fifo="$tmpdir/aws_sso_login.fifo"
    mkfifo "$fifo"

    cleanup() {
      [[ -p "$fifo" ]] && rm -f "$fifo"
      [[ -d "$tmpdir" ]] && rmdir "$tmpdir"
      # If aws is still running, wait for it (avoid zombie)
      [[ -n "${pid:-}" ]] && kill -0 "$pid" 2>/dev/null && wait "$pid" || true
    }
    trap 'cleanup' EXIT INT TERM HUP

    # Start login without auto-opening a browser; stream stdout+stderr to FIFO
    ( aws sso login --profile "$prof" --no-browser >"$fifo" 2>&1 ) & pid=$!

    # Read output live; grab the first URL anywhere in the line
    local line url
    while IFS= read -r line <"$fifo"; do
      if [[ -z "${url:-}" ]]; then
        if [[ "$line" =~ (https?://[^[:space:]]+) ]]; then
          # zsh: $match[1] ; bash: ${BASH_REMATCH[1]}
          url="${BASH_REMATCH[1]:-${match[1]}}"
          # Clipboard helpers for macOS and Linux
          case "$OSTYPE" in
            darwin*) command -v open >/dev/null && open "$url"
                     command -v pbcopy >/dev/null && print -rn -- "$url" | pbcopy
                     print -r -- "  * AWS auth url copied to clipboard"
                     ;;
            linux*)  command -v xdg-open >/dev/null && xdg-open "$url" >/dev/null 2>&1 &
                     command -v xclip >/dev/null && print -rn -- "$url" | xclip -selection clipboard
                     print -r -- "  * AWS auth url copied to clipboard"
                     ;;
          esac
        fi
      fi
      # Uncomment to see full CLI output:
      # print -r -- "$line"
    done

    # Wait for aws sso login to finish (blocks until you complete auth)
    wait "$pid"
  )
}

start_claude_on_bedrock() {
    # Ensure claude CLI is installed
    if ! command -v claude >/dev/null 2>&1; then
        print -r -- "Error: Claude CLI not found in PATH"
        return 1
    fi

    # Check AWS credentials explicitly against this profile
    if ! command -v aws >/dev/null 2>&1; then
        print -r -- "Error: Claude could not find AWS CLI - cannot verify credentials"
        return 1
    fi

    if ! aws sts get-caller-identity --profile "$AWS_PROFILE" >/dev/null 2>&1; then
        initiate_aws_sso_login "$AWS_PROFILE"
    else
        print -r -- "  * AWS credentials present and valid"
    fi

    # Finally, start
    claude
}

# Run only when the iTerm profile is "Claude" (case-insensitive; zsh-specific ${var:l})
if [[ "${ITERM_PROFILE:l}" == "claude bedrock" ]]; then
  export CLAUDE_CODE_USE_BEDROCK=1
  export AWS_PROFILE="apro-genai-uat"
  export AWS_REGION="eu-west-1"
  export ANTHROPIC_MODEL="eu.anthropic.claude-sonnet-4-5-20250929-v1:0"
  print -r -- "Claude starting with profile: $AWS_PROFILE"
  start_claude_on_bedrock
fi

if [[ "${ITERM_PROFILE:l}" == "claude apro" ]]; then
  export ANTHROPIC_BASE_URL=https://litellm.ai.apro.is
  export ANTHROPIC_AUTH_TOKEN="$(op --account my.1password.com read 'op://Work - Apro/LiteLLM - AI Apro/key2' 2>/dev/null)"
  export ANTHROPIC_MODEL=claude-sonnet-4.5 
  export ANTHROPIC_SMALL_FAST_MODEL='claude-haiku'
fi

# Clean up helper functions so they don’t persist in your shell session
if typeset -f unfunction >/dev/null 2>&1; then
  unfunction initiate_aws_sso_login 2>/dev/null
  unfunction start_claude 2>/dev/null
else
  unset -f initiate_aws_sso_login 2>/dev/null
  unset -f start_claude_on_bedrock 2>/dev/null
fi