#!/bin/bash
# list-crons.sh - List all Claude Code managed cron jobs
# Usage: ./list-crons.sh

echo "Claude Code Scheduled Tasks"
echo "======================================"
echo ""

if ! crontab -l &>/dev/null; then
    echo "No crontab found for current user"
    exit 0
fi

# Find all Claude Code tasks
TASKS=$(crontab -l 2>/dev/null | grep -A1 "# CLAUDE_CODE_TASK:" || true)

if [[ -z "$TASKS" ]]; then
    echo "No Claude Code tasks found"
    echo ""
    echo "Add a task with: add-cron.sh"
    exit 0
fi

# Parse and display tasks
echo "ID                  | Schedule        | Command"
echo "--------------------|-----------------|------------------------------------------"

crontab -l 2>/dev/null | grep -B1 -A1 "# CLAUDE_CODE_TASK:" | while IFS= read -r line; do
    if [[ "$line" =~ ^#\ CLAUDE_CODE_TASK:\ (.+)$ ]]; then
        TASK_ID="${BASH_REMATCH[1]}"
        # Read next line for cron entry
        read -r cron_line
        if [[ "$cron_line" =~ ^([^\ ]+\ [^\ ]+\ [^\ ]+\ [^\ ]+\ [^\ ]+)\ (.+)$ ]]; then
            SCHEDULE="${BASH_REMATCH[1]}"
            COMMAND="${BASH_REMATCH[2]}"
            printf "%-19s | %-15s | %s\n" "$TASK_ID" "$SCHEDULE" "$COMMAND"
        fi
    fi
done

echo ""
echo "Total tasks: $(crontab -l 2>/dev/null | grep -c "# CLAUDE_CODE_TASK:" || echo 0)"
