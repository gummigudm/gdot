#!/bin/bash
set -euo pipefail

# --- Configuration ---

# Name of the Shortcut to run
SHORTCUT_NAME="Camera Active"

# Debounce window in seconds (prevents duplicate triggers)
DEBOUNCE_SECONDS=10

PREDICATE='sender contains "appleh13camerad" and (composedMessage contains "PowerOnCamera" or composedMessage contains "PowerOffCamera")'

last_event=""
last_ts=0

run_shortcut() {
  local action="$1"
  # Call Shortcuts CLI; errors should not kill the watcher loop.
  /usr/bin/shortcuts run "$SHORTCUT_NAME" -i "$action" >/dev/null 2>&1 || true
}

# Stream logs and react to messages.
# --style syslog gives a stable-ish plain-text line format that we can grep reliably.
# If you prefer JSON, you can switch to: --style json
/usr/bin/log stream --style syslog --predicate "$PREDICATE" --info 2>/dev/null | while IFS= read -r line; do
  event=""

  if [[ "$line" == *"sender CONTAINS"* ]]; then
    # Skip initial log lines that just confirm the predicate.
    continue
  elif [[ "$line" == *"ISP_PowerOnCamera"* ]]; then
    event="on"
  elif [[ "$line" == *"ISP_PowerOffCamera"* ]]; then
    event="off"
  else
    continue
  fi

  now=$( /bin/date +%s )

  # Debounce: ignore repeats of the same event within N seconds.
  if [[ "$event" == "$last_event" ]] && (( now - last_ts < DEBOUNCE_SECONDS )); then
    continue
  fi

  last_event="$event"
  last_ts="$now"

  if [[ "$event" == "on" ]]; then
    run_shortcut "true"
  else
    run_shortcut "false"
  fi
done