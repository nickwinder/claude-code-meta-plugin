---
name: analyze-claude-setup
description: This skill should be used when analyzing, optimizing, or auditing Claude Code project configurations. It measures token usage, detects redundancy, identifies anti-patterns, and provides actionable optimization recommendations with quantified improvements.
---

# Claude Code Setup Analyzer

Expert skill for analyzing and optimizing Claude Code project configurations to reduce context bloat and improve efficiency.

## Overview

This skill performs comprehensive analysis of Claude Code configurations using natural language understanding to identify optimization opportunities. Unlike keyword-based tools, it understands context and meaning to provide intelligent recommendations.

**Capabilities:**
- **Token usage measurement** - Calculate baseline and average-case consumption
- **Semantic redundancy detection** - Find duplicate concepts, not just matching words
- **Contextual anti-pattern identification** - Understand when content is bloat vs. helpful
- **Best practice validation** - Check against official Claude Code guidelines
- **Actionable recommendations** - Specific improvements with token savings estimates
- **Interactive implementation** - Optionally apply fixes with user approval

**Target Metrics:**
- Baseline tokens: <5k (excellent) or <10k (good)
- Average session: <10k-13k tokens
- Health status: Based on context percentage consumed (200k window)

## When to Use This Skill

**Automatically triggered when users ask:**
- "Analyze my Claude Code setup"
- "Optimize my CLAUDE.md configuration"
- "Why is Claude loading so much context?"
- "Audit my .claude/ directory"
- "Find redundant content in my config"
- "How can I reduce token usage?"
- "Is my Claude setup efficient?"
- "Check my configuration for issues"

**Also appropriate for:**
- New project setup validation
- After adding multiple skills/commands
- Before team adoption
- Troubleshooting performance
- Quarterly maintenance audits

## Core Workflow

### Phase 1: Discovery & Inventory

**Goal:** Build complete inventory with token measurements using natural file exploration.

**Steps:**

1. **Find all Claude Code configuration files:**

   Use Glob to discover:
   ```
   - CLAUDE.md (root)
   - .claude/CLAUDE.md
   - CLAUDE.local.md
   - .claude/skills/*/SKILL.md
   - .claude/commands/*.md
   - .claude/agents/*.md
   - .claude/rules/**/*.md
   - ~/.claude/CLAUDE.md (user global)
   ```

   **Glob patterns to use:**
   - `CLAUDE.md` - Root project memory
   - `.claude/CLAUDE.md` - Alternative location
   - `CLAUDE.local.md` - Local overrides
   - `.claude/skills/*/SKILL.md` - All skills
   - `.claude/commands/*.md` - All commands
   - `.claude/agents/*.md` - All agents
   - `.claude/rules/**/*.md` - All rules (recursive)

2. **Read and measure each file:**

   For each discovered file:
   - Use **Read** tool to examine content
   - Count words naturally (don't use external commands)
   - Calculate tokens: `words × 1.3` (standard estimation)
   - Note file size and structure

3. **Check user global configuration:**

   If accessible, read `~/.claude/CLAUDE.md` to include in baseline.

4. **Categorize by loading context:**

   **Always Loaded (Baseline):**
   - CLAUDE.md (root or .claude/)
   - CLAUDE.local.md (if exists)
   - ~/.claude/CLAUDE.md (user global)
   - Skill descriptions (~50 tokens overhead per skill)

   **Conditionally Loaded:**
   - `.claude/rules/*.md` with `paths` frontmatter
   - Skill content (when skill invoked)
   - Command content (when command run)

   **On-Demand:**
   - Files referenced with `@import`
   - Skill scripts and references

5. **Calculate metrics:**

   ```
   Baseline = (Always loaded files) + (skill overhead × count)
   Average = Baseline + (typical conditional rules)
   Percentage = (Baseline / 200000) × 100
   ```

   **Health scoring:**
   - Excellent: <2.5% (<5k tokens)
   - Good: 2.5-5% (5k-10k tokens)
   - Warning: 5-6.5% (10k-13k tokens)
   - Critical: >6.5% (>13k tokens)

6. **Build inventory table:**

   Create structured overview:

   | File | Lines | Words | Tokens | Loading Context |
   |------|-------|-------|--------|-----------------|
   | CLAUDE.md | 500 | 650 | 845 | Always |
   | ~/.claude/CLAUDE.md | 200 | 260 | 338 | Always |
   | Skills (4 total) | - | - | 200 | Always (overhead) |
   | .claude/rules/api.md | 300 | 390 | 507 | When paths match |

**Output:** Complete inventory with baseline: X tokens (Y% of context), health: Z

---

### Phase 2: Content Analysis

**Goal:** Use natural language understanding to identify optimization opportunities.

**Steps:**

1. **Detect semantic redundancy:**

   Read all configuration files and identify:

   **Duplicate concepts** - Same information expressed differently:
   - Example: "Monorepo with multiple packages" appears in multiple files
   - Example: Project structure described in both root and sub-directories

   **Similar content** - Overlapping instructions that could be consolidated:
   - Use understanding, not statistical word matching
   - Recognize when two sections serve the same purpose
   - Note approximately how much content overlaps

   **Action:** For each redundancy found, estimate token savings if consolidated.

2. **Identify anti-patterns through contextual understanding:**

   Read each major config file and recognize these patterns:

   **Linter Configuration in CLAUDE.md:**
   - ❌ BAD: "Use 2-space indentation, max 100 chars, single quotes..." (50+ rules listed)
   - ✓ GOOD: "Follow ESLint config in .eslintrc.json"
   - Understanding: It's not about the word "eslint", it's about whether configuration details are duplicated vs. referenced
   - Savings: ~800 tokens

   **Inline Code Examples:**
   - ❌ BAD: 100+ lines of example code pasted into CLAUDE.md
   - ✓ GOOD: "See @src/api/users.ts for endpoint pattern"
   - Understanding: Examples are helpful, but should reference actual code, not duplicate it
   - Savings: ~1,800 tokens per large example

   **Obvious/Redundant Language:**
   - ❌ BAD: "This section explains our approach to...", "As you can see..."
   - ✓ GOOD: Direct, concise statements
   - Understanding: Filler words that don't add information
   - Savings: ~100-300 tokens

   **Setup Instructions in Always-Loaded Files:**
   - ❌ BAD: Detailed installation, troubleshooting in CLAUDE.md
   - ✓ GOOD: Quick start + link to docs, or move to .claude/rules/setup.md
   - Understanding: Setup is one-time, shouldn't consume context every conversation
   - Savings: ~1,200 tokens

   **Domain-Specific Content Without Conditional Loading:**
   - ❌ BAD: Testing guidelines, API rules, database schemas all in CLAUDE.md
   - ✓ GOOD: Extract to .claude/rules/ with path conditions
   - Understanding: Content only relevant to specific file types should load conditionally
   - Savings: ~900-1,500 tokens per domain

   **Style Guides as Inline Content:**
   - ❌ BAD: 80+ lines of naming conventions, file organization rules
   - ✓ GOOD: High-level principles + link to docs
   - Understanding: Detailed style guides belong in documentation
   - Savings: ~1,000 tokens

3. **Identify size hotspots:**

   For each file, assess:
   - Very large (>2,000 lines or >2,500 words): CRITICAL - must split
   - Large (>1,000 lines or >1,500 words): HIGH - strongly recommend optimization
   - Medium (>500 lines or >800 words): MEDIUM - consider if domain-specific content exists

4. **Recognize conditional loading opportunities:**

   Read content and identify sections that:
   - Only apply to specific file types (TypeScript, React, SQL, etc.)
   - Only relevant to specific workflows (testing, deployment, CI/CD)
   - Only needed for specific domains (API, frontend, database)
   - Are currently in always-loaded files

   **For each opportunity:**
   - Recommend extraction to .claude/rules/[name].md
   - Suggest appropriate path pattern (e.g., `paths: ["src/api/**/*.ts"]`)
   - Estimate token savings

5. **Check for structural issues:**

   - Duplicate CLAUDE.md files (both root and .claude/)
   - Skills without YAML frontmatter
   - Rules without proper path conditions
   - Missing .claude/rules/ directory despite large config

**Output:** Prioritized list of issues with severity, description, location, and estimated savings.

---

### Phase 3: Best Practices Validation

**Goal:** Validate against official Claude Code guidelines and calculate optimization potential.

**Steps:**

1. **Consult claude-code-guide agent:**

   Use Task tool to query official documentation for current best practices:

   ```
   Task({
     subagent_type: 'claude-code-guide',
     prompt: 'What are the current Claude Code best practices for:
     1. Token budget targets (baseline, average, peak)
     2. CLAUDE.md file size recommendations
     3. When to use progressive disclosure with .claude/rules/
     4. Common anti-patterns to avoid in configuration
     5. Ideal file organization structure
     6. Conditional loading with path patterns
     7. Common optimization patterns and their token savings

     I need specific numbers and guidelines for analyzing a project configuration.',
     model: 'haiku'
   })
   ```

   Extract key metrics, recommendations, and optimization patterns from official documentation.

2. **Read references documentation:**

   Read `references/README.md` which points to official Claude Code documentation sources.

3. **Compare project to targets:**

   - Current baseline vs. target (<5k)
   - Current health vs. target (excellent/good)
   - Gaps in best practices
   - Optimization potential

4. **Prioritize issues by severity:**

   **CRITICAL (Fix immediately):**
   - Baseline >13k tokens
   - Duplicate CLAUDE.md files
   - Very large files (>2,000 lines)
   - Missing skill frontmatter
   - Malformed YAML

   **HIGH (Fix this week):**
   - Baseline 10k-13k tokens
   - Large files without progressive disclosure
   - No .claude/rules/ with large config
   - Significant semantic redundancy
   - Multiple anti-patterns in single file

   **MEDIUM (Fix this month):**
   - Baseline 5k-10k tokens
   - Medium files with domain-specific content
   - Linter rules in CLAUDE.md
   - Excessive inline examples
   - Setup content in always-loaded files

   **LOW (When available):**
   - Baseline <5k (already good, minor optimizations)
   - Obvious phrases
   - Small optimization opportunities

**Output:** Prioritized issue list with severity levels, recommendations, and expected improvements.

---

### Phase 4: Generate Analysis Report

**Goal:** Create comprehensive, actionable report with specific recommendations.

**Steps:**

1. **Read report template:**

   Read `assets/report-template.md` for structure.

2. **Synthesize executive summary:**

   Based on findings:
   ```
   Your Claude Code configuration uses {{BASELINE}} tokens as baseline
   ({{PERCENT}}% of 200k context). Health: {{HEALTH}}.

   Found {{ISSUES}} issues ({{CRITICAL}} critical). Optimization could
   reduce baseline by {{SAVINGS_PERCENT}}% (~{{SAVINGS}} tokens).
   ```

3. **Generate inventory section:**

   Format discovered files into clear table with:
   - File path
   - Size metrics (lines, words, tokens)
   - Loading context (Always/Conditional/On-Demand)

4. **Report redundancy findings:**

   For each redundancy detected:
   - Quote relevant sections from files
   - Explain semantic overlap
   - Recommend consolidation approach
   - Estimate token savings

   Example:
   ```
   ### Redundant Project Structure Description

   Found in 3 files:
   - CLAUDE.md (lines 15-25): "This is a monorepo with apps/web, apps/api..."
   - apps/web/CLAUDE.md (lines 5-10): "Our monorepo contains web app, API..."
   - .claude/rules/structure.md (lines 1-8): "Monorepo structure includes..."

   **Recommendation:** Define once in root CLAUDE.md, remove from others.
   **Savings:** ~400 tokens
   ```

5. **Detail anti-patterns with context:**

   For each anti-pattern:
   - Quote the problematic section
   - Explain WHY it's an issue (not just keyword matching)
   - Provide specific fix with example
   - Calculate savings

   Example:
   ```
   ### Linter Configuration in CLAUDE.md

   **Issue:** CLAUDE.md contains 50+ lines of ESLint rules (lines 150-200)

   **Why it's problematic:** These rules are already enforced by .eslintrc.json.
   Including them here duplicates configuration and wastes ~650 tokens every
   conversation. When rules change, they must be updated in two places.

   **Fix:**
   Replace lines 150-200 with:
   "Follow ESLint configuration in .eslintrc.json. Run `npm run lint` to check."

   **Savings:** ~600 tokens
   ```

6. **Create optimization roadmap:**

   Organize by priority and effort:

   **Phase 1: Critical (Immediate - 15 min)**
   - [ ] Remove duplicate CLAUDE.md files
   - [ ] Fix malformed YAML frontmatter
   - Savings: ~X tokens

   **Phase 2: High-Impact (This Week - 45 min)**
   - [ ] Create .claude/rules/ structure
   - [ ] Extract domain-specific content
   - [ ] Move linter rules to config files
   - Savings: ~X tokens

   **Phase 3: Medium-Impact (This Month - 30 min)**
   - [ ] Convert inline examples to @imports
   - [ ] Move setup docs to documentation
   - Savings: ~X tokens

   **Phase 4: Polish (When Available - 20 min)**
   - [ ] Remove obvious phrases
   - [ ] Add path conditions to rules
   - Savings: ~X tokens

7. **Generate before/after comparison:**

   ```
   ### Current State
   Baseline: 5,500 tokens (2.75%)
   Average: 7,200 tokens (3.60%)
   Health: Warning
   [████████░░░░░░░░░░░░]

   ### After Optimization
   Baseline: 1,900 tokens (0.95%)
   Average: 3,200 tokens (1.60%)
   Health: Excellent
   [██░░░░░░░░░░░░░░░░░░]

   ### Total Improvement
   - Baseline: ↓3,600 tokens (65% reduction)
   - Average: ↓4,000 tokens (56% reduction)
   - Freed: 1.8% of context window
   ```

8. **Add validation steps:**

   Provide commands user can run to verify:
   ```
   # View loaded memory
   /memory

   # Check token usage
   /cost

   # Re-run analysis after changes
   [Instructions to invoke this skill again]
   ```

9. **Format complete report:**

   Combine all sections following report template structure:
   - Executive Summary
   - Configuration Inventory
   - Token Distribution
   - Analysis Findings
   - Issues by Severity
   - Optimization Roadmap
   - Expected Improvements
   - Recommended Structure
   - Validation Commands
   - Implementation Checklist
   - Next Steps

**Output:** Display complete report to user, offer interactive implementation.

---

## Interactive Mode

After displaying report, ask:

```markdown
## Next Steps

Would you like me to help implement these optimizations?

1. **Yes, implement all recommendations** - I'll make all changes automatically
2. **Yes, but let me choose which ones** - I'll ask before each change
3. **No, I'll implement manually** - I'll provide detailed instructions

What would you like to do?
```

**If user chooses 1 or 2:**

For each optimization (filtered by user choice):

1. **Announce the change:**
   ```
   Implementing: Move linter rules from CLAUDE.md to .eslintrc.json
   This will save ~600 tokens from baseline.
   ```

2. **Make the change using appropriate tools:**
   - **Edit** tool to modify existing files
   - **Write** tool to create new rule files
   - **Read** first to understand current content
   - Use **claudemd-generator** skill for CLAUDE.md restructuring

3. **Verify the change:**
   - Read the modified file to confirm
   - Check that content is preserved (not lost)
   - Validate YAML frontmatter if applicable

4. **Report progress:**
   ```
   ✓ Moved linter rules to .eslintrc.json
   ✓ Updated CLAUDE.md to reference config file
   ```

5. **If option 2 (selective), ask before next fix:**
   ```
   Next: Extract testing content to .claude/rules/testing.md (~900 token savings)

   Apply this optimization? [Y/n]
   ```

**After all changes:**

Recalculate baseline naturally:
- Use Glob to find files again
- Read and count words
- Calculate new baseline
- Show before/after:

```markdown
## Optimization Complete

Applied 5 of 7 recommendations:
✓ Removed duplicate CLAUDE.md
✓ Created .claude/rules/ structure
✓ Extracted testing content to rules
✓ Moved linter rules to .eslintrc.json
✓ Converted inline examples to @imports

Results:
- Before: 5,500 tokens baseline
- After: 2,100 tokens baseline
- Savings: 3,400 tokens (62% reduction)
- New health: Excellent

Verify with `/memory` and `/cost` commands.
```

**If user chooses 3 (manual):**

Provide detailed step-by-step instructions with exact file paths and content.

---

## Examples

### Example 1: New Project (Good State)

**User:** "Check my Claude setup"

**Discovery:**
- .claude/CLAUDE.md: 450 words → 585 tokens
- 2 skills: 100 tokens overhead
- Baseline: 685 tokens (0.34%)

**Analysis:**
- ✓ No redundancy
- ✓ No anti-patterns
- ✓ Appropriate size
- ✓ Good structure

**Report:**
```markdown
## Analysis: Excellent Configuration ✓

Your configuration is well-optimized:
- Baseline: 685 tokens (0.34% - excellent)
- No issues found
- Clean, focused setup

**Recommendations:**
- Continue quarterly audits as project grows
- Consider .claude/rules/ when CLAUDE.md exceeds 800 words
- Current setup needs no changes

Keep up the good work!
```

---

### Example 2: Monolithic Configuration

**User:** "Analyze my setup"

**Discovery:**
- CLAUDE.md: 2,400 words → 3,120 tokens
- No .claude/rules/
- 3 skills: 150 tokens overhead
- Baseline: 3,270 tokens (1.64%)

**Analysis (reading CLAUDE.md):**
- Contains 400 words of testing guidelines
- Contains 300 words of deployment instructions
- Contains 350 words of database schema documentation
- Contains 50+ lines of ESLint rules
- All content is always loaded

**Report:**
```markdown
## Analysis: Optimization Needed ⚠️

Baseline: 3,270 tokens (1.64% - good, but improvable)

### Critical Finding
CLAUDE.md is very large (2,400 words) with domain-specific content
that should be conditionally loaded.

### Recommendations

**1. Create .claude/rules/ structure**
Extract these sections:

- Testing guidelines (lines 150-220) → .claude/rules/testing.md
  Path condition: `**/*.{test,spec}.{ts,tsx}`
  Savings: ~520 tokens

- Deployment instructions (lines 350-405) → .claude/rules/deployment.md
  Path condition: `{Dockerfile,docker-compose.yml,.github/workflows/**}`
  Savings: ~390 tokens

- Database schemas (lines 450-520) → .claude/rules/database.md
  Path condition: `{prisma/**,migrations/**,src/db/**}`
  Savings: ~455 tokens

**2. Move linter rules to .eslintrc.json**
Lines 100-145 duplicate ESLint configuration
Savings: ~585 tokens

**Total potential savings: ~1,950 tokens (60% reduction)**
New baseline: ~1,320 tokens (excellent)

Would you like me to implement these changes?
```

---

### Example 3: Duplicate Content Across Monorepo

**User:** "Why is my context usage so high?"

**Discovery:**
- Root CLAUDE.md: 600 words → 780 tokens
- .claude/CLAUDE.md: 600 words → 780 tokens [DUPLICATE!]
- apps/web/CLAUDE.md: 400 words → 520 tokens
- apps/api/CLAUDE.md: 350 words → 455 tokens
- Baseline: 2,535 tokens (1.27%)

**Analysis (reading all files):**
- Root and .claude/ CLAUDE.md are semantically identical
- apps/web and apps/api both describe monorepo structure (redundant)
- ~200 words of shared content across app-specific files

**Report:**
```markdown
## Analysis: Redundancy Issues 🚨

Baseline: 2,535 tokens (1.27% - good, but with critical issue)

### Critical Issue
CLAUDE.md exists in TWO locations with identical content!
This wastes 780 tokens unnecessarily.

### Semantic Redundancy
Both apps/web and apps/api CLAUDE.md files describe:
- Monorepo structure (redundant with root)
- Build system (redundant with root)
- Common dependencies (redundant with root)

Only ~30% of content is actually app-specific.

### Recommendations

**1. Remove duplicate root file (CRITICAL)**
Delete root CLAUDE.md, keep .claude/CLAUDE.md
Savings: 780 tokens

**2. Consolidate app-specific files**
Move shared content to root, keep only unique content in app files:
- apps/web/CLAUDE.md: Keep only Next.js specific info (~150 words)
- apps/api/CLAUDE.md: Keep only Express specific info (~120 words)
Savings: ~520 tokens

**Total savings: ~1,300 tokens (51% reduction)**
New baseline: ~1,235 tokens (excellent)

Would you like me to fix these issues?
```

---

## Error Handling

### No Configuration Found

```markdown
## Analysis: No Configuration Found

I couldn't find any Claude Code configuration in this project.

This means:
- No CLAUDE.md file
- No .claude/ directory
- Baseline: 0 tokens (excellent!)

Would you like me to help set up a basic configuration?
1. Create starter CLAUDE.md
2. Set up .claude/ directory structure
3. Skip (no configuration needed)
```

### Permission Errors

```markdown
## Analysis: Incomplete (Permission Issues)

⚠️ Some files could not be accessed:
- ~/.claude/CLAUDE.md (permission denied)

Analysis completed for accessible files only.

**Accessible files baseline:** 1,450 tokens
**Note:** Actual baseline may be higher due to inaccessible user global config.

To get complete analysis, ensure read access to all configuration files.
```

### Malformed Files

```markdown
## Critical Issue: Invalid Configuration ��

File: .claude/skills/my-skill/SKILL.md

**Problem:** YAML frontmatter is malformed
- Line 1: Opens with `---`
- Missing closing `---` delimiter

**Impact:** This skill may not load correctly.

**Fix:**
```yaml
---
name: my-skill
description: Skill description here
---
```

Would you like me to fix this?
```

---

## Integration Points

### claude-code-guide Agent
**When:** Phase 3 (Best Practices Validation)
**Purpose:** Get current official recommendations
**Usage:** `Task({ subagent_type: 'claude-code-guide', ... })`

### claudemd-generator Skill
**When:** Interactive mode (fixing CLAUDE.md)
**Purpose:** Create/update CLAUDE.md following best practices
**Usage:** Invoke when restructuring main config files

### skill-generator Skill
**When:** Interactive mode (creating rule files)
**Purpose:** Generate .claude/rules/ files with proper structure
**Usage:** Invoke when extracting content to conditional rules

---

## Key Principles

**Use Natural Language Understanding:**
- Recognize semantic similarity, not just word matching
- Understand context to identify anti-patterns
- Judge content value vs. bloat intelligently

**Provide Specific Recommendations:**
- Quote actual content from files
- Explain reasoning with context
- Give exact file paths and line numbers
- Show before/after examples

**Quantify Everything:**
- Token counts for all files
- Estimated savings for each optimization
- Before/after comparisons
- Percentage improvements

**Make It Actionable:**
- Prioritize by impact and effort
- Provide implementation steps
- Offer to do the work
- Validate improvements

---

## Validation Checklist

After running this skill, verify:
- [ ] All CLAUDE.md files discovered via Glob
- [ ] Token measurements accurate (compare with `/cost`)
- [ ] Anti-patterns identified through understanding, not keywords
- [ ] Recommendations are specific with file paths
- [ ] Token savings estimates are reasonable
- [ ] Report is comprehensive and actionable
- [ ] Interactive mode offers appropriate help

---

## Notes

- **No external scripts needed** - Use Glob, Read, and natural language reasoning
- **Semantic understanding** - Recognize patterns contextually, not mechanically
- **Progressive disclosure** - Read reference files on demand
- **Token efficiency** - SKILL.md ~3,900 tokens (loaded only when skill invoked)
- **Maintainable** - Pure Claude reasoning, no bash compatibility issues
- **Extensible** - Easy to add new anti-pattern detection
