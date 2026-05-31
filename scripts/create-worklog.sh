#!/usr/bin/env bash
# SessionStart hook (macOS / Linux).
# Create the two log files if missing; start empty, grow by appending.
for f in WORKLOG.md WORKLOG_index.md; do
  [ -f "$f" ] || : > "$f"
done
