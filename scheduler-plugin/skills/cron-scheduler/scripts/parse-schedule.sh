#!/bin/bash
# parse-schedule.sh - Convert natural language to cron expressions
# Usage: ./parse-schedule.sh "every weekday at 9am"

INPUT="$1"

if [[ -z "$INPUT" ]]; then
    echo "Error: Missing schedule description"
    echo "Usage: $0 <natural-language-schedule>"
    echo ""
    echo "Examples:"
    echo "  'daily at 9am'           → 0 9 * * *"
    echo "  'every weekday at 6pm'   → 0 18 * * 1-5"
    echo "  'every monday at 10am'   → 0 10 * * 1"
    echo "  'every 30 minutes'       → */30 * * * *"
    echo "  'twice daily'            → 0 9,21 * * *"
    echo "  'first day of month'     → 0 0 1 * *"
    exit 1
fi

# Convert to lowercase for easier matching
INPUT_LOWER=$(echo "$INPUT" | tr '[:upper:]' '[:lower:]')

# Extract time if present
TIME_PATTERN="([0-9]{1,2}):?([0-9]{2})?\s*(am|pm)?"
if [[ "$INPUT_LOWER" =~ $TIME_PATTERN ]]; then
    HOUR="${BASH_REMATCH[1]}"
    MINUTE="${BASH_REMATCH[2]:-00}"
    AMPM="${BASH_REMATCH[3]}"

    # Convert to 24-hour format
    if [[ "$AMPM" == "pm" && "$HOUR" -ne 12 ]]; then
        HOUR=$((HOUR + 12))
    elif [[ "$AMPM" == "am" && "$HOUR" -eq 12 ]]; then
        HOUR=0
    fi

    # Remove leading zeros
    HOUR=$((10#$HOUR))
    MINUTE=$((10#$MINUTE))
else
    HOUR="*"
    MINUTE="*"
fi

# Detect patterns
CRON=""

# Every X minutes/hours
if [[ "$INPUT_LOWER" =~ every[[:space:]]+([0-9]+)[[:space:]]+(minute|minutes) ]]; then
    INTERVAL="${BASH_REMATCH[1]}"
    CRON="*/$INTERVAL * * * *"

elif [[ "$INPUT_LOWER" =~ every[[:space:]]+([0-9]+)[[:space:]]+(hour|hours) ]]; then
    INTERVAL="${BASH_REMATCH[1]}"
    CRON="0 */$INTERVAL * * *"

# Twice daily
elif [[ "$INPUT_LOWER" =~ (twice|2x)[[:space:]]+(daily|day) ]]; then
    CRON="0 9,21 * * *"

# Daily
elif [[ "$INPUT_LOWER" =~ daily|every[[:space:]]+day ]]; then
    if [[ "$HOUR" != "*" ]]; then
        CRON="$MINUTE $HOUR * * *"
    else
        CRON="0 0 * * *"
    fi

# Weekdays
elif [[ "$INPUT_LOWER" =~ weekday|weekdays|monday[[:space:]]+through[[:space:]]+friday ]]; then
    if [[ "$HOUR" != "*" ]]; then
        CRON="$MINUTE $HOUR * * 1-5"
    else
        CRON="0 0 * * 1-5"
    fi

# Weekends
elif [[ "$INPUT_LOWER" =~ weekend|weekends|saturday[[:space:]]+and[[:space:]]+sunday ]]; then
    if [[ "$HOUR" != "*" ]]; then
        CRON="$MINUTE $HOUR * * 0,6"
    else
        CRON="0 0 * * 0,6"
    fi

# Specific days of week
elif [[ "$INPUT_LOWER" =~ every[[:space:]]+sunday ]]; then
    CRON="$MINUTE $HOUR * * 0"
elif [[ "$INPUT_LOWER" =~ every[[:space:]]+monday ]]; then
    CRON="$MINUTE $HOUR * * 1"
elif [[ "$INPUT_LOWER" =~ every[[:space:]]+tuesday ]]; then
    CRON="$MINUTE $HOUR * * 2"
elif [[ "$INPUT_LOWER" =~ every[[:space:]]+wednesday ]]; then
    CRON="$MINUTE $HOUR * * 3"
elif [[ "$INPUT_LOWER" =~ every[[:space:]]+thursday ]]; then
    CRON="$MINUTE $HOUR * * 4"
elif [[ "$INPUT_LOWER" =~ every[[:space:]]+friday ]]; then
    CRON="$MINUTE $HOUR * * 5"
elif [[ "$INPUT_LOWER" =~ every[[:space:]]+saturday ]]; then
    CRON="$MINUTE $HOUR * * 6"

# Weekly
elif [[ "$INPUT_LOWER" =~ weekly|every[[:space:]]+week ]]; then
    CRON="$MINUTE $HOUR * * 0"

# Monthly
elif [[ "$INPUT_LOWER" =~ first[[:space:]]+day[[:space:]]+of[[:space:]]+(the[[:space:]]+)?month ]]; then
    CRON="$MINUTE $HOUR 1 * *"
elif [[ "$INPUT_LOWER" =~ last[[:space:]]+day[[:space:]]+of[[:space:]]+(the[[:space:]]+)?month ]]; then
    # Last day requires special handling, using 28 as approximation
    CRON="$MINUTE $HOUR 28-31 * *"
elif [[ "$INPUT_LOWER" =~ monthly|every[[:space:]]+month ]]; then
    CRON="$MINUTE $HOUR 1 * *"

# Yearly/annually
elif [[ "$INPUT_LOWER" =~ yearly|annually|every[[:space:]]+year ]]; then
    CRON="$MINUTE $HOUR 1 1 *"

else
    echo "Error: Could not parse schedule: $INPUT"
    echo ""
    echo "Supported patterns:"
    echo "  - 'daily at 9am'"
    echo "  - 'every weekday at 6pm'"
    echo "  - 'every monday at 10am'"
    echo "  - 'every 30 minutes'"
    echo "  - 'every 2 hours'"
    echo "  - 'twice daily'"
    echo "  - 'weekly'"
    echo "  - 'first day of month'"
    echo "  - 'monthly'"
    echo ""
    echo "Tip: You can also provide a cron expression directly:"
    echo "  '0 9 * * 1-5' for weekdays at 9am"
    exit 1
fi

# Set defaults for * fields
CRON=$(echo "$CRON" | sed 's/\*\*/*/g')

echo "$CRON"
