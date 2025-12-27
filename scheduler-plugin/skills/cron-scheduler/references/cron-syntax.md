# Cron Expression Syntax Reference

## Basic Format

```
* * * * *
│ │ │ │ └─── Day of week (0-7, where 0 and 7 = Sunday)
│ │ │ └───── Month (1-12)
│ │ └─────── Day of month (1-31)
│ └───────── Hour (0-23)
└─────────── Minute (0-59)
```

## Field Values

### Minute (0-59)
- `*` = Every minute
- `0` = At minute 0 (top of the hour)
- `*/15` = Every 15 minutes
- `0,30` = At minute 0 and 30
- `0-30` = Every minute from 0 to 30

### Hour (0-23)
- `*` = Every hour
- `0` = Midnight (12:00 AM)
- `12` = Noon (12:00 PM)
- `18` = 6:00 PM
- `*/2` = Every 2 hours
- `9-17` = 9 AM to 5 PM

### Day of Month (1-31)
- `*` = Every day
- `1` = First day of month
- `15` = 15th day of month
- `*/2` = Every other day
- `1,15` = 1st and 15th

### Month (1-12)
- `*` = Every month
- `1` = January
- `6` = June
- `*/3` = Every 3 months (quarterly)
- `1-6` = January through June
- Can use names: `JAN`, `FEB`, `MAR`, etc.

### Day of Week (0-7)
- `*` = Every day
- `0` or `7` = Sunday
- `1` = Monday
- `2` = Tuesday
- `3` = Wednesday
- `4` = Thursday
- `5` = Friday
- `6` = Saturday
- `1-5` = Monday through Friday (weekdays)
- `0,6` = Saturday and Sunday (weekends)
- Can use names: `SUN`, `MON`, `TUE`, etc.

## Special Characters

### Asterisk (*)
Matches all values in the field.
```
* * * * * = Every minute
0 * * * * = Every hour (at minute 0)
```

### Comma (,)
Separates multiple values.
```
0 9,12,18 * * * = At 9 AM, 12 PM, and 6 PM
0 0 * * 1,3,5 = Midnight on Mon, Wed, Fri
```

### Hyphen (-)
Defines a range of values.
```
0 9-17 * * * = Every hour from 9 AM to 5 PM
0 0 * * 1-5 = Midnight on weekdays
```

### Slash (/)
Defines step values (intervals).
```
*/5 * * * * = Every 5 minutes
0 */2 * * * = Every 2 hours
0 0 */2 * * = Every 2 days
```

## Common Examples

### Time-Based

**Every minute:**
```
* * * * *
```

**Every 5 minutes:**
```
*/5 * * * *
```

**Every 15 minutes:**
```
*/15 * * * *
or
0,15,30,45 * * * *
```

**Every 30 minutes:**
```
*/30 * * * *
or
0,30 * * * *
```

**Every hour:**
```
0 * * * *
```

**Every 2 hours:**
```
0 */2 * * *
```

**Twice daily (9 AM and 9 PM):**
```
0 9,21 * * *
```

### Specific Times

**At 9:00 AM:**
```
0 9 * * *
```

**At 9:30 AM:**
```
30 9 * * *
```

**At midnight:**
```
0 0 * * *
```

**At noon:**
```
0 12 * * *
```

**At 6:00 PM:**
```
0 18 * * *
```

### Daily Patterns

**Daily at 3:30 AM:**
```
30 3 * * *
```

**Daily at 9 AM and 6 PM:**
```
0 9,18 * * *
```

**Every day at quarter past each hour:**
```
15 * * * *
```

**Business hours (9-5, every hour):**
```
0 9-17 * * *
```

### Weekly Patterns

**Every Monday at 9 AM:**
```
0 9 * * 1
```

**Every Friday at 5 PM:**
```
0 17 * * 5
```

**Weekdays at 9 AM:**
```
0 9 * * 1-5
```

**Weekends at 10 AM:**
```
0 10 * * 0,6
```

**Sunday midnight:**
```
0 0 * * 0
```

**Mon, Wed, Fri at 3 PM:**
```
0 15 * * 1,3,5
```

### Monthly Patterns

**First day of month at midnight:**
```
0 0 1 * *
```

**15th of each month at noon:**
```
0 12 15 * *
```

**Last day of month (approximate - 28-31):**
```
0 0 28-31 * *
```

**First Monday of month (requires special handling):**
```
0 0 * * 1
# Then check if day is 1-7
```

### Quarterly/Yearly

**First day of each quarter:**
```
0 0 1 1,4,7,10 *
# Jan 1, Apr 1, Jul 1, Oct 1
```

**Every 3 months:**
```
0 0 1 */3 *
```

**Once a year (Jan 1):**
```
0 0 1 1 *
```

## Advanced Patterns

### Business Hours

**Every 15 minutes during business hours (9-5):**
```
*/15 9-17 * * 1-5
```

**Hourly on weekdays during work hours:**
```
0 9-17 * * 1-5
```

### Night/Off-Hours

**Nightly maintenance (2 AM):**
```
0 2 * * *
```

**Weekend batch jobs (Saturday 3 AM):**
```
0 3 * * 6
```

### Complex Schedules

**Every 10 minutes during business hours on weekdays:**
```
*/10 9-17 * * 1-5
```

**First and last day of month:**
```
0 0 1,28-31 * *
```

**Every 2 hours between 8 AM and 8 PM:**
```
0 8-20/2 * * *
# Runs at: 8:00, 10:00, 12:00, 14:00, 16:00, 18:00, 20:00
```

## Common Mistakes

### ❌ Wrong: Using 24 for midnight
```
0 24 * * *  # Invalid - hour must be 0-23
```
**✓ Correct:**
```
0 0 * * *   # Use 0 for midnight
```

### ❌ Wrong: Day and weekday conflict
```
0 0 13 * 5  # Confusing - 13th AND Friday?
```
**✓ Better:** Use one or the other
```
0 0 13 * *  # 13th of every month
0 0 * * 5   # Every Friday
```

### ❌ Wrong: Month 0 or day 0
```
0 0 0 0 *   # Invalid - months are 1-12, days are 1-31
```
**✓ Correct:**
```
0 0 1 1 *   # January 1st
```

### ❌ Wrong: Reversed fields
```
9 0 * * *   # This runs every day at 00:09 (9 minutes past midnight)
```
**✓ Correct for 9 AM:**
```
0 9 * * *   # Minute first, then hour
```

## Testing Cron Expressions

### Online Tools
- [crontab.guru](https://crontab.guru/) - Best for human-readable explanations
- [crontab-generator.org](https://crontab-generator.org/) - Visual cron builder

### Command Line
```bash
# Validate with validate-cron.sh
./validate-cron.sh "0 9 * * 1-5"

# Parse natural language
./parse-schedule.sh "every weekday at 9am"
```

### Manual Testing
```bash
# List current crontab
crontab -l

# Edit crontab
crontab -e

# View cron logs (varies by system)
grep CRON /var/log/syslog  # Debian/Ubuntu
tail -f /var/log/cron      # CentOS/RHEL
```

## Platform Differences

### Standard Cron (Linux/Unix)
- 5 fields (minute hour day month weekday)
- User-level and system-level crontabs

### Vixie Cron (Most Linux)
- Supports `/etc/cron.d/` for system tasks
- Additional environment variables

### macOS Cron
- Same 5-field format
- Limited compared to launchd
- May require Full Disk Access permissions

### Alternative: launchd (macOS)
Consider using launchd for better macOS integration:
- Better error handling
- Runs missed jobs
- More flexible scheduling
- Better logging

## Best Practices

1. **Be Explicit**: Use specific values when possible
   ```
   # Good
   0 9 * * 1-5

   # Less clear
   * * * * *
   ```

2. **Test First**: Always test cron expressions before deploying
   ```bash
   # Dry run
   ./add-cron.sh --dry-run "0 9 * * *" "command"
   ```

3. **Use Comments**: Document complex expressions
   ```
   # Weekday mornings at 9 AM
   0 9 * * 1-5
   ```

4. **Avoid Overlap**: Don't schedule tasks too frequently
   ```
   # Risky - if task takes > 5 min, will overlap
   */5 * * * *

   # Better - ensure previous run completes
   */15 * * * *
   ```

5. **Consider Timezones**: Cron uses system timezone
   ```bash
   # Check timezone
   date
   timedatectl  # On systemd systems
   ```

6. **Redirect Output**: Always capture logs
   ```
   0 9 * * * /path/to/script.sh >> /var/log/script.log 2>&1
   ```

## Quick Reference Chart

| Pattern | Description | Example Time |
|---------|-------------|--------------|
| `* * * * *` | Every minute | Always |
| `*/5 * * * *` | Every 5 minutes | :00, :05, :10, ... |
| `0 * * * *` | Every hour | :00 |
| `0 */2 * * *` | Every 2 hours | 00:00, 02:00, 04:00, ... |
| `0 9 * * *` | Daily at 9 AM | 09:00 |
| `0 9 * * 1-5` | Weekdays at 9 AM | Mon-Fri 09:00 |
| `0 9 * * 1` | Every Monday at 9 AM | Mon 09:00 |
| `0 0 1 * *` | First of month | 1st 00:00 |
| `0 0 * * 0` | Every Sunday | Sun 00:00 |

## Resources

- **Man Page**: `man 5 crontab`
- **crontab.guru**: Interactive cron expression editor
- **Wikipedia**: [Cron](https://en.wikipedia.org/wiki/Cron)
