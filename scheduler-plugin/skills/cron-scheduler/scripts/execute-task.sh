#!/bin/bash
# execute-task.sh - Wrapper script for executing Claude Code tasks from cron
# Usage: ./execute-task.sh "task-id" "task-description" "working-directory"

TASK_ID="$1"
TASK_DESC="$2"
WORK_DIR="${3:-$HOME}"
LOG_DIR="$HOME/.claude/scheduler/logs"
REGISTRY_FILE="$HOME/.claude/scheduler/tasks.json"

# Ensure log directory exists
mkdir -p "$LOG_DIR"

LOG_FILE="$LOG_DIR/$TASK_ID.log"
MAX_LOG_SIZE=$((10 * 1024 * 1024)) # 10MB

# Rotate log if too large
if [[ -f "$LOG_FILE" ]] && [[ $(stat -f%z "$LOG_FILE" 2>/dev/null || stat -c%s "$LOG_FILE" 2>/dev/null) -gt $MAX_LOG_SIZE ]]; then
    mv "$LOG_FILE" "$LOG_FILE.1"
    gzip "$LOG_FILE.1" 2>/dev/null || true
    # Keep only last 5 rotated logs
    ls -t "$LOG_DIR/$TASK_ID.log."* 2>/dev/null | tail -n +6 | xargs rm -f 2>/dev/null || true
fi

# Log function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
}

log "=========================================="
log "Task: $TASK_ID"
log "Description: $TASK_DESC"
log "Working Directory: $WORK_DIR"
log "=========================================="

# Change to working directory
if [[ ! -d "$WORK_DIR" ]]; then
    log "ERROR: Working directory does not exist: $WORK_DIR"
    exit 1
fi

cd "$WORK_DIR" || {
    log "ERROR: Failed to change to working directory"
    exit 1
}

# Check if claude-code is available
if ! command -v claude-code &> /dev/null; then
    log "ERROR: claude-code command not found in PATH"
    log "PATH: $PATH"
    exit 1
fi

# Check for API key
if [[ -z "$ANTHROPIC_API_KEY" ]]; then
    log "WARNING: ANTHROPIC_API_KEY not set in environment"
    # Try to load from common locations
    if [[ -f "$HOME/.config/claude/api_key" ]]; then
        export ANTHROPIC_API_KEY=$(cat "$HOME/.config/claude/api_key")
        log "Loaded API key from ~/.config/claude/api_key"
    elif [[ -f "$HOME/.anthropic_api_key" ]]; then
        export ANTHROPIC_API_KEY=$(cat "$HOME/.anthropic_api_key")
        log "Loaded API key from ~/.anthropic_api_key"
    else
        log "ERROR: Could not find API key"
        exit 1
    fi
fi

# Update registry - mark as running
if [[ -f "$REGISTRY_FILE" ]]; then
    TEMP_FILE=$(mktemp)
    jq --arg id "$TASK_ID" --arg time "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
        '(.tasks[] | select(.id == $id) | .last_run) = $time' \
        "$REGISTRY_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$REGISTRY_FILE"
fi

# Execute Claude Code task
log "Executing: claude-code --task \"$TASK_DESC\""
START_TIME=$(date +%s)

# Run claude-code and capture output
claude-code --task "$TASK_DESC" 2>&1 | tee -a "$LOG_FILE"
EXIT_CODE=${PIPESTATUS[0]}

END_TIME=$(date +%s)
DURATION=$((END_TIME - START_TIME))

log "=========================================="
log "Exit Code: $EXIT_CODE"
log "Duration: ${DURATION}s"

# Update registry with results
if [[ -f "$REGISTRY_FILE" ]]; then
    TEMP_FILE=$(mktemp)

    if [[ $EXIT_CODE -eq 0 ]]; then
        STATUS="success"
        log "Status: SUCCESS"
        jq --arg id "$TASK_ID" \
           --arg status "$STATUS" \
           --argjson code "$EXIT_CODE" \
           '(.tasks[] | select(.id == $id) |
             .last_status = $status |
             .last_exit_code = $code |
             .run_count = (.run_count // 0) + 1 |
             .success_count = (.success_count // 0) + 1)' \
           "$REGISTRY_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$REGISTRY_FILE"
    else
        STATUS="failure"
        log "Status: FAILURE"
        jq --arg id "$TASK_ID" \
           --arg status "$STATUS" \
           --argjson code "$EXIT_CODE" \
           '(.tasks[] | select(.id == $id) |
             .last_status = $status |
             .last_exit_code = $code |
             .run_count = (.run_count // 0) + 1 |
             .failure_count = (.failure_count // 0) + 1)' \
           "$REGISTRY_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$REGISTRY_FILE"
    fi
fi

log "=========================================="

# Send notifications if configured
if [[ -f "$REGISTRY_FILE" ]]; then
    NOTIFY_ON_FAILURE=$(jq -r --arg id "$TASK_ID" '.tasks[] | select(.id == $id) | .notifications.on_failure // false' "$REGISTRY_FILE")
    NOTIFY_ON_SUCCESS=$(jq -r --arg id "$TASK_ID" '.tasks[] | select(.id == $id) | .notifications.on_success // false' "$REGISTRY_FILE")

    if [[ "$EXIT_CODE" -ne 0 && "$NOTIFY_ON_FAILURE" == "true" ]] || \
       [[ "$EXIT_CODE" -eq 0 && "$NOTIFY_ON_SUCCESS" == "true" ]]; then
        log "Notification triggered (exit code: $EXIT_CODE)"
        # Future: Implement notification methods (email, slack, webhook)
    fi
fi

exit $EXIT_CODE
