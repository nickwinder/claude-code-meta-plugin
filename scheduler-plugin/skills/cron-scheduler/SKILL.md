---
name: cron-scheduler
description: This skill should be used when scheduling, managing, or automating recurring Claude Code tasks using cron jobs. It handles task scheduling, cron management, execution logging, and task lifecycle operations.
---

# Cron Scheduler

A comprehensive skill for scheduling and managing recurring Claude Code tasks using cron jobs. Automate AI-powered workflows to run on schedules like daily, weekly, or custom intervals.

## Overview

The cron-scheduler skill provides intelligent automation for Claude Code tasks by:
- Converting natural language schedules to cron expressions
- Managing cron job lifecycle (add, remove, list, enable/disable)
- Executing Claude Code tasks with proper logging and error handling
- Tracking task history and execution status
- Providing task templates for common workflows

## When to Use This Skill

This skill activates when you need to:
- Schedule recurring Claude Code tasks (daily, weekly, monthly, custom intervals)
- Automate workflows like PR reviews, code analysis, or report generation
- Manage existing scheduled tasks (list, remove, enable/disable)
- View execution logs and task history
- Set up task notifications and alerts

## Core Workflows

### 1. Adding a Scheduled Task

**User Intent Examples:**
- "Schedule a daily task to review open PRs"
- "Add a cron job to run tests every Monday at 9am"
- "Set up automated weekly code quality reports"

**Workflow:**

1. **Gather Task Information**
   - Ask for task description (what Claude Code should do)
   - Ask for schedule (natural language or cron expression)
   - Ask for working directory (defaults to current)
   - Ask for notification preferences (optional)

2. **Validate Schedule**
   - If natural language: Convert to cron expression using `scripts/parse-schedule.sh`
   - If cron expression: Validate syntax using `scripts/validate-cron.sh`
   - Show human-readable interpretation
   - Ask for confirmation

3. **Create Task Entry**
   - Generate unique task ID (kebab-case from description)
   - Create task registry entry in `~/.claude/scheduler/tasks.json`
   - Prepare execution wrapper command

4. **Add to Crontab**
   - Use `scripts/add-cron.sh` to add job safely
   - Prefix with `# CLAUDE_CODE_TASK: {task-id}`
   - Include full path to wrapper script
   - Redirect output to task-specific log

5. **Confirm Creation**
   - Display task details (ID, schedule, next run time)
   - Show cron entry added
   - Explain how to view logs and manage task

**Example:**
```
User: "Schedule a task to review PRs every weekday at 9am"

Claude:
- Task: Review open pull requests and create summary
- Schedule: Every weekday at 9:00 AM (0 9 * * 1-5)
- Next run: Tomorrow at 9:00 AM
- Logs: ~/.claude/scheduler/logs/review-prs.log

Task created successfully! Use `/cron-scheduler list` to view all tasks.
```

### 2. Listing Scheduled Tasks

**User Intent Examples:**
- "Show me all scheduled tasks"
- "List my cron jobs"
- "What tasks are scheduled?"

**Workflow:**

1. **Load Task Registry**
   - Read `~/.claude/scheduler/tasks.json`
   - Filter tasks if requested (enabled/disabled, specific patterns)

2. **Fetch Current Status**
   - Check if task exists in crontab
   - Get last execution time from logs
   - Calculate next run time

3. **Display Task Table**
   - Show: ID, Description, Schedule, Status, Last Run, Next Run
   - Highlight disabled tasks
   - Show tasks with recent failures

**Example Output:**
```
Scheduled Tasks (3 active, 1 disabled)

ID              | Description           | Schedule      | Last Run   | Next Run   | Status
----------------|----------------------|---------------|------------|------------|--------
review-prs      | Review open PRs      | 0 9 * * 1-5   | 2h ago     | Tomorrow   | ✓ Active
weekly-report   | Generate report      | 0 18 * * 5    | 2d ago     | Friday     | ✓ Active
test-suite      | Run test suite       | */30 * * * *  | 12m ago    | 18m        | ✓ Active
cleanup-logs    | Clean old logs       | 0 0 * * 0     | 6d ago     | Sunday     | ⊗ Disabled
```

### 3. Removing a Scheduled Task

**User Intent Examples:**
- "Remove the PR review task"
- "Delete the weekly report cron job"
- "Stop scheduling the test suite"

**Workflow:**

1. **Identify Task**
   - Match task by ID or description
   - If ambiguous, show options and ask for clarification

2. **Confirm Removal**
   - Show task details
   - Ask for confirmation
   - Warn if task has recent successful runs

3. **Remove from Crontab**
   - Use `scripts/remove-cron.sh` to remove job safely
   - Remove by CLAUDE_CODE_TASK comment

4. **Update Registry**
   - Mark task as deleted in registry (for history)
   - Archive logs (don't delete)

5. **Confirm Removal**
   - Show removal confirmation
   - Note that logs are preserved

### 4. Viewing Task Logs

**User Intent Examples:**
- "Show logs for the PR review task"
- "What happened in the last test run?"
- "View execution history for weekly report"

**Workflow:**

1. **Locate Log File**
   - Find log at `~/.claude/scheduler/logs/{task-id}.log`
   - Check if log exists and is readable

2. **Display Recent Entries**
   - Show last 50 lines by default
   - Highlight errors and failures
   - Show execution timestamps

3. **Provide Analysis**
   - Summarize success/failure rate
   - Identify common errors
   - Suggest fixes if failures detected

### 5. Enabling/Disabling Tasks

**User Intent Examples:**
- "Disable the nightly build task"
- "Pause the PR review automation"
- "Re-enable the weekly report"

**Workflow:**

1. **Identify Task**
   - Match by ID or description

2. **Toggle State**
   - **Disable**: Comment out cron entry, update registry
   - **Enable**: Uncomment cron entry, update registry

3. **Confirm Change**
   - Show new status
   - Explain impact (when it will/won't run)

## Helper Scripts

### `scripts/add-cron.sh`

Safely adds a cron job to the user's crontab.

**Features:**
- Backs up existing crontab
- Checks for duplicates
- Adds namespaced comment marker
- Validates before applying

**Usage:**
```bash
./add-cron.sh "0 9 * * 1-5" "/path/to/wrapper.sh" "review-prs" "Review PRs"
```

### `scripts/remove-cron.sh`

Safely removes a cron job by task ID.

**Features:**
- Finds job by CLAUDE_CODE_TASK marker
- Backs up before modification
- Handles multiple matches
- Validates removal

**Usage:**
```bash
./remove-cron.sh "review-prs"
```

### `scripts/list-crons.sh`

Lists all Claude Code managed cron jobs.

**Features:**
- Filters to only CLAUDE_CODE_TASK entries
- Shows human-readable schedule
- Displays next run time
- Checks registry for additional metadata

**Usage:**
```bash
./list-crons.sh
```

### `scripts/execute-task.sh`

Wrapper script that executes Claude Code tasks.

**Features:**
- Loads environment and API keys
- Changes to correct working directory
- Executes Claude Code with task description
- Captures output and exit codes
- Handles errors and notifications
- Rotates logs to prevent disk filling

**Usage:**
```bash
./execute-task.sh "review-prs" "Review all open PRs and create summary" "/path/to/repo"
```

### `scripts/validate-cron.sh`

Validates cron expression syntax.

**Features:**
- Checks field count (5 or 6 fields)
- Validates field ranges
- Catches common errors
- Returns human-readable explanation

**Usage:**
```bash
./validate-cron.sh "0 9 * * 1-5"
# Output: Valid - At 09:00 on every day-of-week from Monday through Friday
```

### `scripts/parse-schedule.sh`

Converts natural language to cron expressions.

**Supported Patterns:**
- "daily at 9am" → `0 9 * * *`
- "every weekday at 6pm" → `0 18 * * 1-5`
- "every monday" → `0 0 * * 1`
- "twice daily" → `0 9,21 * * *`
- "every 30 minutes" → `*/30 * * * *`
- "first day of month" → `0 0 1 * *`

**Usage:**
```bash
./parse-schedule.sh "every weekday at 9am"
# Output: 0 9 * * 1-5
```

## Task Registry Format

Tasks are stored in `~/.claude/scheduler/tasks.json`:

```json
{
  "tasks": [
    {
      "id": "review-prs",
      "name": "Daily PR Review",
      "description": "Review all open PRs and create summary",
      "schedule": "0 9 * * 1-5",
      "schedule_human": "Every weekday at 9:00 AM",
      "working_dir": "/Users/dev/my-project",
      "enabled": true,
      "created_at": "2025-12-27T10:00:00Z",
      "last_run": "2025-12-27T09:00:00Z",
      "last_status": "success",
      "last_exit_code": 0,
      "run_count": 45,
      "success_count": 43,
      "failure_count": 2,
      "notifications": {
        "on_failure": true,
        "on_success": false,
        "method": "log"
      }
    }
  ]
}
```

## Task Templates

### PR Review Template
**Schedule:** Every weekday at 9am
**Task:** "Review all open pull requests, summarize changes, identify risks, and create daily report"
**Best for:** Team leads, maintainers

### Code Quality Report
**Schedule:** Weekly on Friday at 6pm
**Task:** "Run code quality analysis, check test coverage, identify technical debt, generate report"
**Best for:** Engineering managers

### Dependency Updates
**Schedule:** First Monday of month
**Task:** "Check for outdated dependencies, review security advisories, create update plan"
**Best for:** Security-conscious teams

### Test Suite Monitor
**Schedule:** Every 4 hours
**Task:** "Run full test suite, report failures, track flaky tests"
**Best for:** CI/CD monitoring

### Documentation Sync
**Schedule:** Daily at midnight
**Task:** "Check for outdated documentation, verify code examples, update README if needed"
**Best for:** Documentation maintainers

## Safety Features

### 1. Dry-Run Mode
Before adding any cron job, show what would be added:
```
DRY RUN - This would add:
---
# CLAUDE_CODE_TASK: review-prs
0 9 * * 1-5 cd /path/to/repo && /usr/local/bin/claude-scheduler-wrapper "review-prs" >> ~/.claude/scheduler/logs/review-prs.log 2>&1
---
Proceed? [y/N]
```

### 2. Validation Checks
- Validate cron syntax before adding
- Check for existing tasks with same schedule/description
- Verify working directory exists
- Ensure Claude Code is installed and accessible
- Check for API key configuration

### 3. Namespacing
All cron entries are prefixed with `# CLAUDE_CODE_TASK: {task-id}` to:
- Avoid conflicts with user's existing crons
- Enable safe removal (won't touch non-Claude crons)
- Support multiple Claude projects

### 4. Log Rotation
Prevent disk filling by:
- Rotating logs when they exceed 10MB
- Keeping last 5 rotated logs
- Compressing old logs
- Auto-cleanup logs older than 90 days

### 5. Rate Limiting
Prevent API abuse by:
- Warning when tasks scheduled more frequently than every 15 minutes
- Tracking API usage per task
- Suggesting batch operations for frequent tasks

## Error Handling

### Cron Job Fails to Execute
1. Check execution logs: `~/.claude/scheduler/logs/{task-id}.log`
2. Verify Claude Code installation: `which claude-code`
3. Check API key configuration
4. Verify working directory exists
5. Test task manually: `claude-code --task "your task"`

### Task Not Running at Expected Time
1. Verify cron is running: `ps aux | grep cron`
2. Check crontab entry exists: `crontab -l | grep CLAUDE_CODE_TASK`
3. Check task is enabled in registry
4. Verify system time and timezone
5. Check cron daemon logs: `/var/log/cron` or `journalctl -u cron`

### Permission Errors
1. Ensure wrapper script is executable: `chmod +x scripts/execute-task.sh`
2. Check log directory permissions
3. Verify crontab access: `crontab -l`

### API Key Issues
1. Check environment variable: `echo $ANTHROPIC_API_KEY`
2. Verify key in wrapper script
3. Check key expiration
4. Test with manual Claude Code invocation

## Platform-Specific Notes

### macOS
- Uses user-level crontab
- May need to grant Terminal/cron Full Disk Access in Security & Privacy
- Consider using `launchd` for more reliability (future enhancement)

### Linux
- Uses standard cron daemon
- Check specific distro's cron implementation
- May use `systemd-timers` on modern systems (future enhancement)

### Windows
- Not currently supported (cron is Unix/Linux only)
- Future: Could use Task Scheduler integration

## Examples

### Example 1: Daily PR Review
```
User: Schedule a task to review PRs every morning

Claude: I'll set up a daily PR review task.

What time should it run?
User: 9am on weekdays

Claude:
✓ Task created: review-prs
- Description: Review all open pull requests and create summary
- Schedule: Every weekday at 9:00 AM (0 9 * * 1-5)
- Working directory: /Users/dev/my-project
- Logs: ~/.claude/scheduler/logs/review-prs.log
- Next run: Tomorrow at 9:00 AM

Cron entry added successfully!
```

### Example 2: Viewing Task Status
```
User: Show my scheduled tasks

Claude:
Scheduled Tasks (2 active)

ID           | Description        | Schedule      | Last Run | Next Run  | Status
-------------|-------------------|---------------|----------|-----------|--------
review-prs   | Review open PRs   | 0 9 * * 1-5   | 2h ago   | Tomorrow  | ✓ Active
test-suite   | Run tests         | */30 * * * *  | 8m ago   | 22m       | ✓ Active

Total runs today: 24 (23 successful, 1 failed)
```

### Example 3: Removing a Task
```
User: Remove the test suite task

Claude:
Found task: test-suite
- Description: Run test suite and report failures
- Schedule: Every 30 minutes
- Last run: 8 minutes ago (successful)

This task has run 143 times with 98% success rate.
Are you sure you want to remove it? [y/N]

User: y

Claude:
✓ Task removed from crontab
✓ Registry updated
ℹ Logs preserved at ~/.claude/scheduler/logs/test-suite.log

Task "test-suite" removed successfully.
```

## Advanced Features

### Conditional Execution
Tasks can include conditions in their descriptions:
```
"Review PRs only if more than 5 are open"
"Run tests only if code changed since last run"
```

The wrapper script will evaluate conditions before executing.

### Notifications
Configure task completion notifications:
- **Log only** (default): Write to log file
- **Email**: Send summary via configured email
- **Slack**: Post to webhook
- **Custom webhook**: POST JSON to URL

### Task Chaining
Create task dependencies:
```json
{
  "after_success": ["deploy-staging"],
  "after_failure": ["notify-team"]
}
```

### Environment Variables
Pass custom environment variables to tasks:
```json
{
  "env": {
    "REVIEW_THRESHOLD": "5",
    "NOTIFICATION_CHANNEL": "#engineering"
  }
}
```

## Best Practices

1. **Start Simple**: Begin with one task, verify it works, then add more
2. **Check Logs**: Always review logs after first few runs
3. **Use Templates**: Start with templates and customize
4. **Test Manually**: Run tasks manually before scheduling
5. **Monitor Initially**: Check task execution frequently when first set up
6. **Appropriate Frequency**: Don't over-schedule (respect API limits)
7. **Meaningful Names**: Use clear, descriptive task IDs
8. **Document Tasks**: Add context in task description
9. **Review Regularly**: Audit scheduled tasks monthly
10. **Archive Unused**: Remove tasks that are no longer needed

## Troubleshooting Guide

### Task not executing
1. Check if cron daemon is running
2. Verify task is enabled in registry
3. Check crontab entry exists
4. Review logs for errors
5. Test wrapper script manually

### High failure rate
1. Review execution logs
2. Check API key validity
3. Verify working directory
4. Test task description manually
5. Adjust task complexity or timeout

### Missing log entries
1. Check log file permissions
2. Verify log directory exists
3. Check disk space
4. Review wrapper script output redirection

### Unexpected timing
1. Verify system timezone
2. Check cron expression
3. Review "next run" calculation
4. Consider DST transitions

## Future Enhancements

- **Web Dashboard**: View and manage tasks via web interface
- **Task Analytics**: Track execution trends and performance
- **Smart Scheduling**: AI-suggested optimal run times
- **Distributed Execution**: Run tasks across multiple machines
- **Task Versioning**: Track changes to task definitions
- **Rollback Support**: Revert to previous task versions
- **Integration with MCP**: Use MCP server for enhanced functionality
- **Cross-platform**: Support Windows Task Scheduler
- **launchd Support**: Better macOS integration
- **systemd Timers**: Modern Linux scheduling

## Related Tools

- **crontab**: System cron management
- **at**: One-time task scheduling
- **launchd**: macOS service management
- **systemd timers**: Linux service scheduling
- **GitHub Actions**: Repository-based automation
- **Jenkins**: CI/CD automation

## Security Considerations

1. **API Keys**: Store securely, never log or commit
2. **Command Injection**: Validate all task descriptions
3. **File Permissions**: Restrict log and registry file access
4. **Crontab Backup**: Always backup before modifications
5. **Task Isolation**: Each task runs in isolated environment
6. **Audit Trail**: Log all task management operations
7. **Rate Limiting**: Prevent abuse of Claude Code API

## Conclusion

The cron-scheduler skill provides a powerful, safe, and user-friendly way to automate Claude Code tasks. By combining cron's reliability with Claude's intelligence, you can build sophisticated automation workflows that run reliably in the background.

Start small, test thoroughly, and gradually build up your automation suite. The skill handles all the complexity of cron management, letting you focus on what tasks to automate, not how to schedule them.
