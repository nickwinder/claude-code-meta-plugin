#!/bin/bash
# add-cron.sh - Safely add a cron job for Claude Code task scheduling
# Usage: ./add-cron.sh "schedule" "command" "task-id" "description"

set -e

SCHEDULE="$1"
COMMAND="$2"
TASK_ID="$3"
DESCRIPTION="$4"

if [[ -z "$SCHEDULE" || -z "$COMMAND" || -z "$TASK_ID" ]]; then
    echo "Error: Missing required arguments"
    echo "Usage: $0 <schedule> <command> <task-id> [description]"
    echo "Example: $0 '0 9 * * 1-5' '/path/to/wrapper.sh review-prs' 'review-prs' 'Review PRs'"
    exit 1
fi

# Backup existing crontab
BACKUP_FILE="/tmp/crontab.backup.$(date +%s)"
crontab -l > "$BACKUP_FILE" 2>/dev/null || touch "$BACKUP_FILE"
echo "Backed up crontab to: $BACKUP_FILE"

# Check for duplicate task ID
if crontab -l 2>/dev/null | grep -q "# CLAUDE_CODE_TASK: $TASK_ID"; then
    echo "Error: Task '$TASK_ID' already exists in crontab"
    echo "Use remove-cron.sh to remove it first, or choose a different task ID"
    exit 1
fi

# Create new cron entry
if [[ -n "$DESCRIPTION" ]]; then
    NEW_ENTRY="# CLAUDE_CODE_TASK: $TASK_ID - $DESCRIPTION
$SCHEDULE $COMMAND"
else
    NEW_ENTRY="# CLAUDE_CODE_TASK: $TASK_ID
$SCHEDULE $COMMAND"
fi

# Add to crontab
(crontab -l 2>/dev/null; echo "$NEW_ENTRY") | crontab -

echo "✓ Cron job added successfully"
echo ""
echo "Task ID: $TASK_ID"
echo "Schedule: $SCHEDULE"
echo "Command: $COMMAND"
echo ""
echo "Entry added:"
echo "$NEW_ENTRY"
echo ""
echo "Verify with: crontab -l | grep '$TASK_ID'"
