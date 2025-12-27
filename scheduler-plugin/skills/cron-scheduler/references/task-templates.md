# Claude Code Task Templates

Pre-configured task templates for common automation workflows.

## Development Workflows

### Daily PR Review
**Purpose:** Review open pull requests and summarize changes
**Schedule:** `0 9 * * 1-5` (Weekdays at 9 AM)
**Task Description:**
```
Review all open pull requests in this repository. For each PR:
1. Summarize the changes
2. Identify potential issues or risks
3. Check for test coverage
4. Note any breaking changes
5. Create a daily PR review report in reports/pr-review-YYYY-MM-DD.md
```

**Best for:**
- Team leads
- Project maintainers
- Code reviewers

---

### Nightly Test Suite
**Purpose:** Run full test suite and report failures
**Schedule:** `0 2 * * *` (Daily at 2 AM)
**Task Description:**
```
Run the complete test suite:
1. Execute: npm test (or appropriate test command)
2. Analyze test results
3. Identify failing tests
4. Check for flaky tests (intermittent failures)
5. Create test report in reports/test-results-YYYY-MM-DD.md
6. If failures detected, create summary of what failed and why
```

**Best for:**
- CI/CD monitoring
- Test reliability tracking
- Early failure detection

---

### Weekly Code Quality Report
**Purpose:** Analyze code quality metrics and technical debt
**Schedule:** `0 18 * * 5` (Friday at 6 PM)
**Task Description:**
```
Generate comprehensive code quality report:
1. Run linting and static analysis
2. Check test coverage metrics
3. Identify code smells and anti-patterns
4. List TODO/FIXME comments
5. Analyze complexity metrics
6. Track technical debt
7. Create weekly report in reports/code-quality-YYYY-MM-DD.md
```

**Best for:**
- Engineering managers
- Tech leads
- Quality assurance teams

---

### Dependency Security Audit
**Purpose:** Check for vulnerable dependencies
**Schedule:** `0 9 * * 1` (Monday at 9 AM)
**Task Description:**
```
Perform security audit of dependencies:
1. Run npm audit (or equivalent)
2. Check for outdated packages
3. Review security advisories
4. Identify critical vulnerabilities
5. Suggest update strategy
6. Create security report in reports/security-audit-YYYY-MM-DD.md
```

**Best for:**
- Security-conscious teams
- Compliance requirements
- Production systems

---

## Documentation Workflows

### Documentation Sync Check
**Purpose:** Ensure documentation stays in sync with code
**Schedule:** `0 0 * * *` (Daily at midnight)
**Task Description:**
```
Check documentation for staleness:
1. Find code examples in documentation
2. Verify examples still work
3. Check for outdated API references
4. Identify missing documentation for new features
5. Flag deprecated content
6. Create sync report in reports/docs-sync-YYYY-MM-DD.md
```

**Best for:**
- Documentation maintainers
- Developer experience teams
- Open source projects

---

### README Update Check
**Purpose:** Keep README current with project changes
**Schedule:** `0 12 * * 1` (Monday at noon)
**Task Description:**
```
Review README for accuracy:
1. Check installation instructions
2. Verify example code works
3. Ensure dependency versions are current
4. Update contributor count
5. Check badge status
6. Suggest improvements
```

**Best for:**
- Open source maintainers
- Project documentation
- New contributor onboarding

---

## Data & Analytics Workflows

### Daily Metrics Collection
**Purpose:** Collect and analyze project metrics
**Schedule:** `0 0 * * *` (Daily at midnight)
**Task Description:**
```
Collect daily project metrics:
1. Count commits in last 24 hours
2. Track issue creation/closure rates
3. Measure PR merge time
4. Calculate code churn
5. Store metrics in data/metrics-YYYY-MM-DD.json
6. Generate trends visualization
```

**Best for:**
- Project analytics
- Team productivity tracking
- Sprint retrospectives

---

### Weekly Activity Summary
**Purpose:** Summarize repository activity
**Schedule:** `0 9 * * 1` (Monday at 9 AM)
**Task Description:**
```
Generate weekly activity summary:
1. List commits from past week
2. Summarize merged PRs
3. Track closed issues
4. Identify top contributors
5. Note milestone progress
6. Create summary in reports/weekly-activity-YYYY-MM-DD.md
```

**Best for:**
- Team standups
- Status reports
- Stakeholder updates

---

## Maintenance Workflows

### Log Cleanup
**Purpose:** Archive or remove old log files
**Schedule:** `0 3 * * 0` (Sunday at 3 AM)
**Task Description:**
```
Clean up old log files:
1. Find logs older than 30 days
2. Compress logs older than 7 days
3. Archive important logs to storage
4. Delete logs older than 90 days
5. Report disk space saved
```

**Best for:**
- Disk space management
- Log rotation
- System maintenance

---

### Dependency Update Check
**Purpose:** Identify outdated dependencies
**Schedule:** `0 10 1 * *` (First day of month at 10 AM)
**Task Description:**
```
Check for package updates:
1. List outdated dependencies
2. Categorize by type (major, minor, patch)
3. Check changelog for breaking changes
4. Identify security updates
5. Create update plan in reports/dependency-updates-YYYY-MM.md
6. Prioritize critical updates
```

**Best for:**
- Dependency management
- Security maintenance
- Staying current

---

### Backup Verification
**Purpose:** Verify backups are working
**Schedule:** `0 4 * * 1` (Monday at 4 AM)
**Task Description:**
```
Verify backup integrity:
1. Check backup job completion status
2. Verify backup file sizes
3. Test backup restoration (dry run)
4. Validate backup checksums
5. Report any backup failures
6. Create backup report in reports/backup-status-YYYY-MM-DD.md
```

**Best for:**
- Disaster recovery
- Data integrity
- Compliance

---

## Content & Communication Workflows

### Social Media Post Generator
**Purpose:** Create social media updates about project
**Schedule:** `0 14 * * 1,3,5` (Mon, Wed, Fri at 2 PM)
**Task Description:**
```
Generate social media content:
1. Review recent commits and PRs
2. Identify interesting changes
3. Draft social media posts (Twitter/LinkedIn format)
4. Suggest hashtags
5. Create content in content/social-media-YYYY-MM-DD.md
6. Include relevant links and images
```

**Best for:**
- Developer relations
- Open source promotion
- Community engagement

---

### Changelog Draft
**Purpose:** Draft changelog entries from commits
**Schedule:** `0 17 * * 5` (Friday at 5 PM)
**Task Description:**
```
Draft changelog for upcoming release:
1. Collect commits since last release
2. Categorize changes (features, fixes, breaking)
3. Format in Keep a Changelog style
4. Identify missing PR descriptions
5. Create draft in CHANGELOG-draft-YYYY-MM-DD.md
```

**Best for:**
- Release management
- Version documentation
- Communication with users

---

## Issue & Project Management Workflows

### Stale Issue Triage
**Purpose:** Identify and label stale issues
**Schedule:** `0 10 * * 1` (Monday at 10 AM)
**Task Description:**
```
Triage stale issues:
1. Find issues with no activity in 30+ days
2. Check if issues are still relevant
3. Identify duplicates
4. Suggest closing candidates
5. Flag issues needing maintainer attention
6. Create triage report in reports/issue-triage-YYYY-MM-DD.md
```

**Best for:**
- Issue management
- Project cleanup
- Community health

---

### Sprint Planning Assistant
**Purpose:** Prepare for sprint planning
**Schedule:** `0 16 * * 5` (Friday at 4 PM before sprint)
**Task Description:**
```
Prepare sprint planning materials:
1. Review completed work from current sprint
2. Identify incomplete tasks
3. Analyze velocity trends
4. Suggest issues for next sprint
5. Estimate complexity of proposed issues
6. Create planning document in reports/sprint-planning-YYYY-MM-DD.md
```

**Best for:**
- Agile teams
- Sprint planning
- Workload estimation

---

## Performance & Monitoring Workflows

### Performance Benchmark
**Purpose:** Run performance benchmarks
**Schedule:** `0 3 * * 0` (Sunday at 3 AM)
**Task Description:**
```
Run performance benchmarks:
1. Execute benchmark suite
2. Compare against baseline
3. Identify performance regressions
4. Track metrics over time
5. Create performance report in reports/benchmark-YYYY-MM-DD.md
6. Flag significant degradations
```

**Best for:**
- Performance optimization
- Regression detection
- Capacity planning

---

### Error Log Analysis
**Purpose:** Analyze application error logs
**Schedule:** `0 8 * * *` (Daily at 8 AM)
**Task Description:**
```
Analyze error logs:
1. Parse error logs from last 24 hours
2. Group errors by type/frequency
3. Identify new error patterns
4. Track error trends
5. Suggest fixes for common errors
6. Create error report in reports/error-analysis-YYYY-MM-DD.md
```

**Best for:**
- Production monitoring
- Issue identification
- Proactive debugging

---

## Custom Template Format

When creating your own templates, use this format:

```markdown
### Template Name
**Purpose:** One-line description
**Schedule:** Cron expression and human-readable
**Task Description:**
```
Detailed task description for Claude Code:
1. Step 1
2. Step 2
3. Step 3
...
```

**Best for:**
- Use case 1
- Use case 2
- Use case 3
```

## Using Templates

### Via cron-scheduler skill:
```
User: "Schedule a daily PR review task"
Claude: I'll set that up using the Daily PR Review template...
```

### Customize a template:
```
User: "Use the PR review template but run it twice daily"
Claude: I'll modify the schedule to run at 9 AM and 5 PM...
```

### Combine templates:
```
User: "Create a task that combines dependency audit and security check"
Claude: I'll create a custom task combining both workflows...
```

## Tips for Creating Effective Tasks

1. **Be Specific**: Clearly define what Claude should do
2. **Include Context**: Explain why each step matters
3. **Define Output**: Specify where results should go
4. **Handle Errors**: Include error handling steps
5. **Set Expectations**: Define success criteria
6. **Consider Timing**: Choose appropriate schedule frequency
7. **Test First**: Run task manually before scheduling

## Frequency Guidelines

| Frequency | Best For | Example |
|-----------|----------|---------|
| Every few minutes | Monitoring, alerts | Error detection |
| Hourly | Active monitoring | Test runs |
| Daily | Regular maintenance | Log analysis |
| Weekdays | Team workflows | PR reviews |
| Weekly | Planning, reports | Sprint summaries |
| Monthly | Audits, updates | Dependency checks |

## Task Chaining

For complex workflows, chain tasks together:

```
Task 1: Run tests (nightly)
  → If pass: Task 2: Deploy to staging
    → If successful: Task 3: Notify team

Task A: Security audit (weekly)
  → If vulnerabilities found: Task B: Create security report
    → Task C: Notify security team
```

## Environment-Specific Templates

### Development Environment
- Frequent tests
- Quick feedback loops
- Verbose logging

### Staging Environment
- Integration tests
- Deployment verification
- Pre-production checks

### Production Environment
- Minimal disruption
- Error monitoring
- Performance tracking
- Security audits

## Additional Resources

- See `cron-syntax.md` for scheduling patterns
- Use `parse-schedule.sh` to convert natural language
- Test with `validate-cron.sh` before deploying
