# Claude Code Scheduler Plugin

**Version:** 0.1.0
**Author:** Nick Winder

Automate recurring Claude Code tasks with intelligent cron job management. Schedule AI-powered workflows to run daily, weekly, or on custom intervals.

## Overview

The Scheduler plugin brings enterprise-grade task automation to Claude Code. Schedule recurring workflows like PR reviews, code analysis, report generation, and maintenance tasks without manual intervention.

**Key Features:**
- 🕐 **Natural Language Scheduling** - "every weekday at 9am" → cron expression
- 🤖 **AI-Powered Execution** - Claude Code tasks run on schedule
- 📊 **Execution Tracking** - Monitor success rates, view logs, track history
- 🔒 **Safe Management** - Namespaced jobs, backups, validation
- 📝 **Task Templates** - Pre-configured workflows for common use cases
- ⚡ **Easy Setup** - Interactive task creation with smart defaults

## What Can You Automate?

### Development Workflows
- **PR Reviews**: Analyze open PRs every morning
- **Test Monitoring**: Run test suite nightly, report failures
- **Code Quality**: Weekly code quality and technical debt reports
- **Security Audits**: Check dependencies for vulnerabilities

### Documentation
- **Sync Checks**: Ensure docs stay current with code
- **README Updates**: Keep installation instructions accurate
- **Changelog Drafts**: Auto-generate from commit history

### Data & Analytics
- **Metrics Collection**: Track project metrics daily
- **Activity Summaries**: Weekly repository activity reports
- **Performance Benchmarks**: Track performance trends

### Maintenance
- **Log Cleanup**: Rotate and archive old logs
- **Dependency Updates**: Monthly update planning
- **Backup Verification**: Test backup integrity

## Installation

### Prerequisites
- Claude Code CLI installed
- Cron daemon running (standard on Linux/macOS)
- Anthropic API key configured

### Install from Marketplace

```bash
# Add the marketplace
/plugin marketplace add nickwinder/claude-code-scheduler-plugin

# Install the plugin
/plugin install claude-code-scheduler

# Verify installation
/plugin list
```

### Local Development

```bash
# Clone the repository
git clone https://github.com/nickwinder/claude-code-scheduler-plugin.git
cd claude-code-scheduler-plugin

# Add local marketplace
/plugin marketplace add .

# Install from local marketplace
/plugin install claude-code-scheduler
```

## Quick Start

### Schedule Your First Task

Simply describe what you want to schedule, and the cron-scheduler skill will activate:

```
Schedule a task to review open PRs every weekday morning
```

Claude will:
1. Ask for scheduling details (time, frequency)
2. Confirm the task description
3. Create the cron job
4. Set up logging and tracking

**Example interaction:**
```
User: Schedule a task to review open PRs every weekday morning

Claude: I'll set up a recurring task for PR reviews.

What time should it run?
User: 9am

Claude:
✓ Task created: review-prs
- Description: Review all open pull requests and create summary
- Schedule: Every weekday at 9:00 AM (0 9 * * 1-5)
- Working directory: /Users/dev/my-project
- Logs: ~/.claude/scheduler/logs/review-prs.log
- Next run: Tomorrow at 9:00 AM

Cron job added successfully!
```

### View Scheduled Tasks

```
Show my scheduled tasks
```

**Output:**
```
Scheduled Tasks (3 active, 1 disabled)

ID              | Description           | Schedule      | Last Run   | Next Run   | Status
----------------|----------------------|---------------|------------|------------|--------
review-prs      | Review open PRs      | 0 9 * * 1-5   | 2h ago     | Tomorrow   | ✓ Active
weekly-report   | Generate report      | 0 18 * * 5    | 2d ago     | Friday     | ✓ Active
test-suite      | Run test suite       | */30 * * * *  | 12m ago    | 18m        | ✓ Active
cleanup-logs    | Clean old logs       | 0 0 * * 0     | 6d ago     | Sunday     | ⊗ Disabled

Total runs today: 24 (23 successful, 1 failed)
```

### View Task Logs

```
Show logs for the PR review task
```

Claude will display recent log entries, highlight errors, and provide analysis.

### Remove a Task

```
Remove the test suite task
```

Claude will confirm and safely remove the cron job while preserving logs.

## Natural Language Scheduling

The scheduler understands common time expressions:

| You Say | Cron Expression | When It Runs |
|---------|----------------|--------------|
| "daily at 9am" | `0 9 * * *` | Every day at 9:00 AM |
| "every weekday at 6pm" | `0 18 * * 1-5` | Mon-Fri at 6:00 PM |
| "every monday at 10am" | `0 10 * * 1` | Monday at 10:00 AM |
| "every 30 minutes" | `*/30 * * * *` | :00, :30 of each hour |
| "twice daily" | `0 9,21 * * *` | 9:00 AM and 9:00 PM |
| "first day of month" | `0 0 1 * *` | 1st at midnight |
| "weekly" | `0 0 * * 0` | Sunday at midnight |

Or provide a cron expression directly:
```
Schedule task with cron expression: 0 */2 * * *
```

## Task Templates

Pre-configured templates for common workflows:

### Development
- **Daily PR Review** - Review and summarize open PRs
- **Nightly Test Suite** - Run tests, report failures
- **Weekly Code Quality** - Analyze code quality and technical debt
- **Dependency Security Audit** - Check for vulnerabilities

### Documentation
- **Documentation Sync Check** - Ensure docs match code
- **README Update Check** - Verify accuracy
- **Changelog Draft** - Auto-generate from commits

### Maintenance
- **Log Cleanup** - Archive and rotate logs
- **Dependency Update Check** - Identify outdated packages
- **Backup Verification** - Test backup integrity

### Analytics
- **Daily Metrics Collection** - Track project metrics
- **Weekly Activity Summary** - Summarize repository activity
- **Performance Benchmark** - Track performance over time

**Use a template:**
```
Set up the daily PR review template
```

**Customize a template:**
```
Use the PR review template but run it twice daily
```

## Advanced Features

### Task Management

**Enable/Disable tasks:**
```
Disable the nightly build task
Re-enable the weekly report
```

**View execution history:**
```
Show execution history for review-prs
```

**Update task schedule:**
```
Change the PR review task to run at 10am instead
```

### Notifications

Configure notifications for task completion:
- Log only (default)
- Email (future)
- Slack webhook (future)
- Custom webhook (future)

### Conditional Execution

Tasks can include conditions:
```
"Review PRs only if more than 5 are open"
"Run tests only if code changed since last run"
```

### Environment Variables

Pass custom environment to tasks:
```json
{
  "env": {
    "REVIEW_THRESHOLD": "5",
    "NOTIFICATION_CHANNEL": "#engineering"
  }
}
```

## Architecture

### Components

```
scheduler-plugin/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest
│   └── marketplace.json         # Marketplace config
├── skills/
│   └── cron-scheduler/
│       ├── SKILL.md             # Main skill definition
│       ├── scripts/             # Helper scripts
│       │   ├── add-cron.sh      # Add cron job
│       │   ├── remove-cron.sh   # Remove cron job
│       │   ├── list-crons.sh    # List jobs
│       │   ├── execute-task.sh  # Task wrapper
│       │   ├── validate-cron.sh # Validate syntax
│       │   └── parse-schedule.sh # Parse natural language
│       └── references/          # Documentation
│           ├── cron-syntax.md   # Cron reference
│           └── task-templates.md # Task examples
└── README.md
```

### Data Storage

**Task Registry:** `~/.claude/scheduler/tasks.json`
- Task definitions and metadata
- Execution history and statistics
- Configuration and preferences

**Logs:** `~/.claude/scheduler/logs/`
- Individual log per task
- Automatic rotation at 10MB
- Keeps last 5 rotated logs

**Crontab Entries:**
```bash
# CLAUDE_CODE_TASK: review-prs - Review PRs
0 9 * * 1-5 /path/to/execute-task.sh "review-prs" "Review all open PRs" >> ~/.claude/scheduler/logs/review-prs.log 2>&1
```

### Execution Flow

1. **Cron triggers** at scheduled time
2. **execute-task.sh wrapper** runs:
   - Loads environment and API keys
   - Changes to working directory
   - Updates task registry (mark as running)
   - Executes `claude-code --task "description"`
   - Captures output and exit code
   - Updates registry with results
   - Rotates logs if needed
   - Sends notifications (if configured)

## Safety Features

### 1. Namespacing
All cron jobs prefixed with `# CLAUDE_CODE_TASK:` to:
- Avoid conflicts with existing crons
- Enable safe removal
- Support multiple projects

### 2. Backups
Automatic crontab backup before any modification:
```bash
/tmp/crontab.backup.1735334400
```

### 3. Validation
Before adding jobs:
- Validate cron syntax
- Check for duplicates
- Verify working directory exists
- Confirm Claude Code is installed
- Check API key configuration

### 4. Log Rotation
- Rotate at 10MB
- Keep 5 historical logs
- Compress old logs
- Auto-cleanup after 90 days

### 5. Rate Limiting
- Warning for tasks < 15 minutes apart
- API usage tracking per task
- Suggestions for batch operations

## Platform Support

### macOS ✓
- User-level crontab
- May need Full Disk Access for Terminal
- Consider launchd for production (future)

### Linux ✓
- Standard cron daemon
- Both user and system crontabs
- systemd timers support (future)

### Windows ✗
- Not currently supported (cron unavailable)
- Task Scheduler integration (future)

## Troubleshooting

### Task not executing

**Symptom:** Scheduled task doesn't run

**Solutions:**
1. Check cron daemon: `ps aux | grep cron`
2. Verify crontab entry: `crontab -l | grep review-prs`
3. Check task enabled: View in task list
4. Test manually: `~/.claude/scheduler/scripts/execute-task.sh ...`
5. Review logs: `~/.claude/scheduler/logs/review-prs.log`

### Permission errors

**Symptom:** "Permission denied" in logs

**Solutions:**
1. Make scripts executable: `chmod +x scripts/*.sh`
2. Check log directory: `ls -la ~/.claude/scheduler/logs`
3. Verify crontab access: `crontab -l`

### API key issues

**Symptom:** "API key not found" errors

**Solutions:**
1. Check environment: `echo $ANTHROPIC_API_KEY`
2. Add to wrapper script or ~/.bashrc
3. Store in `~/.config/claude/api_key`

### Tasks failing

**Symptom:** High failure rate in registry

**Solutions:**
1. Review execution logs for errors
2. Test task description manually
3. Check working directory exists
4. Reduce task complexity
5. Increase timeout if needed

## Best Practices

1. **Start Simple** - One task first, verify it works
2. **Test Manually** - Run task manually before scheduling
3. **Check Logs** - Review logs after first few runs
4. **Appropriate Frequency** - Don't over-schedule
5. **Meaningful Names** - Use clear, descriptive task IDs
6. **Monitor Initially** - Watch new tasks closely
7. **Regular Audits** - Review scheduled tasks monthly
8. **Archive Unused** - Remove obsolete tasks

## Examples

### Example 1: Daily PR Review

```
User: Schedule a task to review PRs every weekday morning at 9am

Claude: Creates task with:
- ID: review-prs
- Schedule: 0 9 * * 1-5
- Task: "Review all open pull requests, summarize changes, identify risks, create daily report"
- Logs: ~/.claude/scheduler/logs/review-prs.log

User: (Next day at 9am, task runs automatically)

User: Show me the PR review log

Claude: Displays latest log entries and summary
```

### Example 2: Weekly Code Quality Report

```
User: Set up the weekly code quality template

Claude: I'll configure the Weekly Code Quality Report task.
- Runs: Friday at 6 PM
- Analyzes: Code quality, test coverage, technical debt
- Creates: Weekly report

Proceed? [y/N]

User: y

Claude: ✓ Task created successfully
Next run: This Friday at 6:00 PM
```

### Example 3: Custom Security Audit

```
User: Create a task that checks for security issues every Monday

Claude: What time should it run?

User: 9am

Claude: What should the security check include?

User: Check dependencies, scan for secrets, review permissions

Claude:
✓ Task created: security-audit
- Schedule: Every Monday at 9:00 AM (0 9 * * 1)
- Checks: Dependencies, secrets, permissions
- Next run: Monday at 9:00 AM
```

## Use Cases

### For Solo Developers
- Automate routine maintenance
- Track personal projects
- Stay on top of updates
- Monitor production apps

### For Teams
- Standardize workflows
- Automate reviews
- Track team metrics
- Ensure consistency

### For Open Source Maintainers
- Triage stale issues
- Review community PRs
- Generate changelogs
- Monitor project health

### For DevOps
- Monitor deployments
- Track performance
- Verify backups
- Security audits

## Roadmap

### v0.2.0 (Planned)
- [ ] Web dashboard for task management
- [ ] Email/Slack notifications
- [ ] Task chaining and dependencies
- [ ] Enhanced analytics

### v0.3.0 (Planned)
- [ ] Windows Task Scheduler support
- [ ] macOS launchd integration
- [ ] systemd timers for Linux
- [ ] MCP server integration

### Future
- [ ] Distributed task execution
- [ ] Smart scheduling (AI-suggested times)
- [ ] Task versioning and rollback
- [ ] Multi-project support
- [ ] Cloud-based scheduling

## Contributing

Contributions welcome! Areas needing help:
- Windows Task Scheduler integration
- Enhanced notification systems
- Web dashboard UI
- Additional task templates
- Platform-specific optimizations

## Resources

### Documentation
- `skills/cron-scheduler/SKILL.md` - Complete skill documentation
- `references/cron-syntax.md` - Cron expression reference
- `references/task-templates.md` - Pre-built task templates

### External Resources
- [Cron Documentation](https://man7.org/linux/man-pages/man5/crontab.5.html)
- [crontab.guru](https://crontab.guru) - Cron expression tester
- [Claude Code Docs](https://code.claude.com/docs/en/)

## Support

**Issues:** [GitHub Issues](https://github.com/nickwinder/claude-code-scheduler-plugin/issues)
**Discussions:** [GitHub Discussions](https://github.com/nickwinder/claude-code-scheduler-plugin/discussions)

## License

MIT License - see LICENSE file for details

## Changelog

### v0.1.0 (Initial Release)
- ✓ Natural language schedule parsing
- ✓ Cron job management (add, remove, list)
- ✓ Task execution wrapper with logging
- ✓ Task registry and history tracking
- ✓ Pre-built task templates
- ✓ Comprehensive cron syntax reference
- ✓ Safety features (backups, validation, namespacing)
- ✓ macOS and Linux support

---

**Built with Claude Code** 🤖

*Automate your workflows, reclaim your time.*
