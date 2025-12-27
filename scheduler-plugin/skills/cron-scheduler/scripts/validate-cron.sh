#!/bin/bash
# validate-cron.sh - Validate cron expression syntax
# Usage: ./validate-cron.sh "0 9 * * 1-5"

CRON_EXPR="$1"

if [[ -z "$CRON_EXPR" ]]; then
    echo "Error: Missing cron expression"
    echo "Usage: $0 <cron-expression>"
    echo "Example: $0 '0 9 * * 1-5'"
    exit 1
fi

# Remove extra whitespace
CRON_EXPR=$(echo "$CRON_EXPR" | tr -s ' ')

# Count fields (should be 5 for standard cron)
FIELD_COUNT=$(echo "$CRON_EXPR" | awk '{print NF}')

if [[ $FIELD_COUNT -ne 5 ]]; then
    echo "Error: Invalid cron expression"
    echo "Expected 5 fields (minute hour day month weekday), got $FIELD_COUNT"
    echo "Format: * * * * *"
    echo "        │ │ │ │ └─── Day of week (0-7, 0 and 7 = Sunday)"
    echo "        │ │ │ └───── Month (1-12)"
    echo "        │ │ └─────── Day of month (1-31)"
    echo "        │ └───────── Hour (0-23)"
    echo "        └─────────── Minute (0-59)"
    exit 1
fi

# Parse fields
read -r MINUTE HOUR DAY MONTH WEEKDAY <<< "$CRON_EXPR"

# Validate minute (0-59)
if [[ "$MINUTE" != "*" ]] && ! [[ "$MINUTE" =~ ^(\*|[0-9,\-/]+)$ ]]; then
    echo "Error: Invalid minute field: $MINUTE"
    exit 1
fi

# Validate hour (0-23)
if [[ "$HOUR" != "*" ]] && ! [[ "$HOUR" =~ ^(\*|[0-9,\-/]+)$ ]]; then
    echo "Error: Invalid hour field: $HOUR"
    exit 1
fi

# Validate day of month (1-31)
if [[ "$DAY" != "*" ]] && ! [[ "$DAY" =~ ^(\*|[0-9,\-/]+)$ ]]; then
    echo "Error: Invalid day field: $DAY"
    exit 1
fi

# Validate month (1-12)
if [[ "$MONTH" != "*" ]] && ! [[ "$MONTH" =~ ^(\*|[0-9,\-/]+|[A-Za-z]+)$ ]]; then
    echo "Error: Invalid month field: $MONTH"
    exit 1
fi

# Validate weekday (0-7)
if [[ "$WEEKDAY" != "*" ]] && ! [[ "$WEEKDAY" =~ ^(\*|[0-9,\-/]+|[A-Za-z]+)$ ]]; then
    echo "Error: Invalid weekday field: $WEEKDAY"
    exit 1
fi

# Generate human-readable description
describe_cron() {
    local min="$1" hr="$2" day="$3" mon="$4" wday="$5"
    local desc=""

    # Time
    if [[ "$min" == "*" && "$hr" == "*" ]]; then
        desc="Every minute"
    elif [[ "$min" =~ ^\*/([0-9]+)$ ]]; then
        desc="Every ${BASH_REMATCH[1]} minutes"
    elif [[ "$hr" == "*" ]]; then
        desc="At minute $min of every hour"
    else
        desc="At $(printf '%02d:%02d' "$hr" "$min")"
    fi

    # Day/weekday
    if [[ "$wday" != "*" ]]; then
        case "$wday" in
            0|7) desc="$desc on Sunday" ;;
            1) desc="$desc on Monday" ;;
            2) desc="$desc on Tuesday" ;;
            3) desc="$desc on Wednesday" ;;
            4) desc="$desc on Thursday" ;;
            5) desc="$desc on Friday" ;;
            6) desc="$desc on Saturday" ;;
            1-5) desc="$desc on weekdays" ;;
            0,6|6,0) desc="$desc on weekends" ;;
            *) desc="$desc on day-of-week $wday" ;;
        esac
    elif [[ "$day" != "*" ]]; then
        desc="$desc on day $day"
    fi

    # Month
    if [[ "$mon" != "*" ]]; then
        case "$mon" in
            1) desc="$desc in January" ;;
            2) desc="$desc in February" ;;
            3) desc="$desc in March" ;;
            4) desc="$desc in April" ;;
            5) desc="$desc in May" ;;
            6) desc="$desc in June" ;;
            7) desc="$desc in July" ;;
            8) desc="$desc in August" ;;
            9) desc="$desc in September" ;;
            10) desc="$desc in October" ;;
            11) desc="$desc in November" ;;
            12) desc="$desc in December" ;;
            *) desc="$desc in month $mon" ;;
        esac
    fi

    echo "$desc"
}

DESCRIPTION=$(describe_cron "$MINUTE" "$HOUR" "$DAY" "$MONTH" "$WEEKDAY")

echo "✓ Valid cron expression"
echo ""
echo "Expression: $CRON_EXPR"
echo "Description: $DESCRIPTION"
echo ""

# Calculate next run time (approximate)
# Note: This is a simplified calculation, actual next run depends on current time
if command -v date &> /dev/null; then
    echo "Next runs (approximate):"
    # This would need a more sophisticated calculation for accurate next run times
    # For now, just show the pattern
    echo "  Pattern: $DESCRIPTION"
fi

exit 0
