# Claude Code Setup Analysis Report

**Project:** {{PROJECT_NAME}}
**Analysis Date:** {{ANALYSIS_DATE}}
**Baseline Tokens:** {{BASELINE_TOKENS}} ({{BASELINE_PERCENT}}% of 200k context)
**Health Status:** {{HEALTH_STATUS}}

---

## Executive Summary

{{SUMMARY_TEXT}}

**Key Metrics:**
- Total configuration files: {{FILE_COUNT}}
- Baseline token usage: {{BASELINE_TOKENS}} tokens
- Estimated average session: {{AVERAGE_TOKENS}} tokens
- Optimization potential: {{OPTIMIZATION_POTENTIAL}}% reduction
- Critical issues found: {{CRITICAL_COUNT}}
- Total issues found: {{TOTAL_ISSUES}}

**Recommendation:** {{OVERALL_RECOMMENDATION}}

---

## Configuration Inventory

### Always-Loaded Files

| File | Lines | Words | Tokens | Loading Context |
|------|-------|-------|--------|-----------------|
{{ALWAYS_LOADED_TABLE}}

### Conditionally-Loaded Files

| File | Lines | Words | Tokens | Condition |
|------|-------|-------|--------|-----------|
{{CONDITIONAL_LOADED_TABLE}}

### Skills & Commands

| Type | Count | Overhead |
|------|-------|----------|
| Skills | {{SKILL_COUNT}} | {{SKILL_OVERHEAD}} tokens |
| Commands | {{COMMAND_COUNT}} | {{COMMAND_OVERHEAD}} tokens |
| Agents | {{AGENT_COUNT}} | {{AGENT_OVERHEAD}} tokens |

---

## Token Distribution

```
Baseline Token Usage: {{BASELINE_TOKENS}} / 200,000 ({{BASELINE_PERCENT}}%)

{{TOKEN_BAR_VISUAL}}

Breakdown:
- Root/Project CLAUDE.md: {{CLAUDE_MD_TOKENS}} tokens
- User Global CLAUDE.md: {{USER_GLOBAL_TOKENS}} tokens
- Skill Descriptions: {{SKILL_OVERHEAD}} tokens
- Other Config: {{OTHER_CONFIG_TOKENS}} tokens
```

---

## Analysis Findings

### Content Redundancy

{{#if HAS_REDUNDANCY}}
**Duplicate Headings Found:**

{{DUPLICATE_HEADINGS_TABLE}}

**Similar Files:**

{{SIMILAR_FILES_TABLE}}

**Recommendation:** Consolidate duplicate content to reduce redundancy by ~{{REDUNDANCY_SAVINGS}} tokens.
{{else}}
✓ No significant content redundancy detected.
{{/if}}

### Anti-Patterns Detected

{{#if HAS_ANTIPATTERNS}}
{{ANTIPATTERN_LIST}}
{{else}}
✓ No major anti-patterns detected.
{{/if}}

### Size Hotspots

{{#if HAS_LARGE_FILES}}
**Files Exceeding Recommended Size:**

| File | Size | Category | Issue |
|------|------|----------|-------|
{{LARGE_FILES_TABLE}}

**Recommendation:** Files marked "very-large" should be split immediately. Files marked "large" should be considered for optimization.
{{else}}
✓ All configuration files are within recommended size limits.
{{/if}}

### Conditional Loading Opportunities

{{#if HAS_CONDITIONAL_OPPORTUNITIES}}
**Content That Could Use Path Conditions:**

{{CONDITIONAL_OPPORTUNITIES_LIST}}

**Potential Savings:** ~{{CONDITIONAL_SAVINGS}} tokens from baseline
{{else}}
✓ Conditional loading already well-optimized or not applicable.
{{/if}}

---

## Issues by Severity

### 🚨 Critical Issues (Fix Immediately)

{{#if HAS_CRITICAL}}
{{CRITICAL_ISSUES_LIST}}
{{else}}
✓ No critical issues found.
{{/if}}

### ⚠️ High Priority Issues

{{#if HAS_HIGH}}
{{HIGH_ISSUES_LIST}}
{{else}}
✓ No high priority issues found.
{{/if}}

### ℹ️ Medium Priority Issues

{{#if HAS_MEDIUM}}
{{MEDIUM_ISSUES_LIST}}
{{else}}
✓ No medium priority issues found.
{{/if}}

### 💡 Low Priority Suggestions

{{#if HAS_LOW}}
{{LOW_ISSUES_LIST}}
{{else}}
✓ No low priority suggestions.
{{/if}}

---

## Optimization Roadmap

### Phase 1: Critical Fixes (Immediate)

**Estimated Time:** {{PHASE1_TIME}}
**Expected Savings:** ~{{PHASE1_SAVINGS}} tokens ({{PHASE1_PERCENT}}%)

{{PHASE1_TASKS}}

### Phase 2: High-Impact Optimizations (This Week)

**Estimated Time:** {{PHASE2_TIME}}
**Expected Savings:** ~{{PHASE2_SAVINGS}} tokens ({{PHASE2_PERCENT}}%)

{{PHASE2_TASKS}}

### Phase 3: Medium-Impact Improvements (This Month)

**Estimated Time:** {{PHASE3_TIME}}
**Expected Savings:** ~{{PHASE3_SAVINGS}} tokens ({{PHASE3_PERCENT}}%)

{{PHASE3_TASKS}}

### Phase 4: Low-Impact Polish (When Available)

**Estimated Time:** {{PHASE4_TIME}}
**Expected Savings:** ~{{PHASE4_SAVINGS}} tokens ({{PHASE4_PERCENT}}%)

{{PHASE4_TASKS}}

---

## Expected Improvements

### Before Optimization

```
Baseline: {{BASELINE_TOKENS}} tokens ({{BASELINE_PERCENT}}%)
Average Session: {{AVERAGE_TOKENS}} tokens ({{AVERAGE_PERCENT}}%)
Health Status: {{HEALTH_STATUS}}

{{BEFORE_VISUAL}}
```

### After Optimization

```
Baseline: {{OPTIMIZED_BASELINE}} tokens ({{OPTIMIZED_BASELINE_PERCENT}}%)
Average Session: {{OPTIMIZED_AVERAGE}} tokens ({{OPTIMIZED_AVERAGE_PERCENT}}%)
Health Status: {{OPTIMIZED_HEALTH}}

{{AFTER_VISUAL}}
```

### Total Savings

- **Baseline Reduction:** {{BASELINE_SAVINGS}} tokens ({{BASELINE_SAVINGS_PERCENT}}%)
- **Average Session Reduction:** {{AVERAGE_SAVINGS}} tokens ({{AVERAGE_SAVINGS_PERCENT}}%)
- **Freed Context:** {{FREED_CONTEXT}}% of total context window

---

## Recommended Structure

Based on analysis, here's the recommended directory structure:

```
{{RECOMMENDED_STRUCTURE}}
```

**Key Changes:**
{{STRUCTURE_CHANGES}}

---

## Validation Commands

After implementing optimizations, run these commands to verify improvements:

```bash
# Re-run analysis
./skills/analyze-claude-setup/scripts/calculate-baseline.sh .

# Check for duplicates
./skills/analyze-claude-setup/scripts/detect-redundancy.sh .

# Validate structure
./skills/analyze-claude-setup/scripts/validate-structure.sh .

# View loaded memory
/memory

# Check token usage
/cost
```

**Expected Results:**
- Baseline tokens: ~{{OPTIMIZED_BASELINE}} (down from {{BASELINE_TOKENS}})
- No critical issues
- Reduced redundancy
- Proper conditional loading

---

## Implementation Checklist

Track your progress as you implement optimizations:

### Phase 1 Tasks
{{PHASE1_CHECKLIST}}

### Phase 2 Tasks
{{PHASE2_CHECKLIST}}

### Phase 3 Tasks
{{PHASE3_CHECKLIST}}

### Phase 4 Tasks
{{PHASE4_CHECKLIST}}

---

## Next Steps

{{#if USER_WANTS_HELP}}
I can help you implement these optimizations. Would you like me to:

1. **Implement all recommendations** - I'll make all changes automatically
2. **Step through each optimization** - I'll confirm each change before making it
3. **Implement specific fixes only** - You choose which optimizations to apply
4. **Provide guidance only** - I'll give you instructions, you make the changes

Please let me know how you'd like to proceed.
{{else}}
**Manual Implementation:**

1. Review this report and prioritize optimizations
2. Start with Phase 1 (critical fixes)
3. Run validation commands after each phase
4. Re-run this analysis to verify improvements

**Get Help:**
If you'd like assistance implementing these changes, just ask and I can walk you through each optimization step-by-step.
{{/if}}

---

## Additional Notes

{{ADDITIONAL_NOTES}}

---

**Report generated by:** analyze-claude-setup skill
**Report ID:** {{REPORT_ID}}
**Claude Code Version:** {{CLAUDE_VERSION}}

*For questions about this analysis or implementation help, ask Claude to explain any section in detail.*
