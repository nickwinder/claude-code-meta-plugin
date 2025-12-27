#!/bin/bash
# remove-cron.sh - Safely remove a Claude Code cron job
# Usage: ./remove-cron.sh "task-id"

set -e

TASK_ID="$1"

if [[ -z "$TASK_ID" ]]; then
    echo "Error: Missing task ID"
    echo "Usage: $0 <task-id>"
    echo "Example: $0 review-prs"
    exit 1
fi

# Backup existing crontab
BACKUP_FILE="/tmp/crontab.backup.$(date +%s)"
crontab -l > "$BACKUP_FILE" 2>/dev/null || touch "$BACKUP_FILE"
echo "Backed up crontab to: $BACKUP_FILE"

# Check if task exists
if ! crontab -l 2>/dev/null | grep -q "# CLAUDE_CODE_TASK: $TASK_ID"; then
    echo "Error: Task '$TASK_ID' not found in crontab"
    echo ""
    echo "Available Claude Code tasks:"
    crontab -l 2>/dev/null | grep "# CLAUDE_CODE_TASK:" || echo "  (none)"
    exit 1
fi

# Remove task (removes the comment line and the cron entry following it)
crontab -l 2>/dev/null | grep -v "# CLAUDE_CODE_TASK: $TASK_ID" | grep -A1 "." | grep -v "^--$" | crontab -

echo "✓ Cron job removed successfully"
echo ""
echo "Task ID: $TASK_ID"
echo ""
echo "Backup saved at: $BACKUP_FILE"
echo "Restore with: crontab $BACKUP_FILE"
