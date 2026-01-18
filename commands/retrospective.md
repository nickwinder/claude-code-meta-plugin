---
description: Reflect on conversation history and capture learnings into reusable artifacts
argument-hint: "[optional: what to focus on]"
---

# Retrospective

Reflect on the current conversation session and capture learnings into reusable artifacts.

## Purpose

At the end of a work session, use this command to:
- Reflect on what worked well and what didn't
- Extract successful approaches and common pitfalls
- Create persistent knowledge artifacts from temporary conversation context
- Build up your project's institutional knowledge over time

## Workflow

### Step 1: Gather User Input (Optional)

**If the user provided arguments when invoking this command (`$ARGUMENTS`):**
- Use `$ARGUMENTS` as the primary focus area
- This is the user's explicit direction on what to capture
- Example: `/retrospective the debugging workflow we used`
- STILL do full conversation analysis (Step 2) - you may discover additional issues
- Present both user-requested items AND discovered issues

**If NO arguments provided:**
- Ask the user: "What should I capture from this session?"
- User input is OPTIONAL and serves as a hint, not a requirement
- Listen for signals like:
  - "The way we debugged X"
  - "That workflow for Y"
  - "The pattern we used for Z"
  - "How to avoid mistake X"
  - "The steps we took to accomplish Y"

**If user says "you decide" or provides no specific direction:**
- Proceed to Step 2 and analyze the conversation yourself
- Discover friction points and success patterns proactively
- Use your analysis to drive the retrospective

### Step 2: Read Conversation History with Pattern Detection

Read the entire current conversation to understand context AND identify specific friction points:

**Control Flow Analysis - Look for:**
- **Course corrections**: User said "no", "don't", "not like that", "actually", "change that"
- **Tool failures**: Tools returned errors, unexpected results, or required workarounds
- **User interventions**: User had to manually fix automated outputs
- **Rejected tool use**: `[Request interrupted]` messages or user stopping tool execution
- **Decision pivots**: Mid-session approach changes or strategy shifts
- **Repetitive patterns**: Same manual task performed multiple times

**Success Pattern Analysis - Look for:**
- What tasks were performed successfully
- What approaches worked smoothly
- What workflows flowed without interruption
- What tools/techniques were effective
- What decisions were made and why

**Output from this step:**
- List of identified friction points with specific examples
- List of successful patterns worth preserving
- Clear categorization: Problems vs Successes

### Step 3: Root Cause Analysis and Intelligent Mapping

For each identified friction point, determine the root cause and map it to a solution type:

**Problem Type → Solution Mapping:**

1. **Skill/Command Failed or Inadequate**
   - Root Cause: Existing skill didn't handle edge case, had wrong logic, or incomplete workflow
   - Solution: Update the specific Skill that failed
   - Example: "The deploy-check skill didn't verify database migrations"

2. **Missing Project Context**
   - Root Cause: Claude lacked project-specific knowledge, conventions, or preferences
   - Solution: Update CLAUDE.md with missing information
   - Example: "Claude didn't know the team uses Jest, not Mocha"

3. **Repetitive Manual Work**
   - Root Cause: User performed same task 2+ times manually (no automation exists)
   - Solution: Create new Slash Command for explicit invocation
   - Example: "User manually formatted PR descriptions 3 times"

4. **Complex Workflow Without Guidance**
   - Root Cause: Multi-step process exists but Claude doesn't know it
   - Solution: Create new Skill for automatic discovery
   - Example: "Complete code review process with security checks, tests, docs"

5. **Successful New Pattern Worth Preserving**
   - Root Cause: New approach worked well and should be reusable
   - Solution: Choose based on complexity:
     - Simple/explicit → Slash Command
     - Complex/autonomous → Skill
     - Project-wide → CLAUDE.md

**Output from this step:**
- For each problem: Root cause + Recommended solution type + Specific artifact to create/update
- For each success: Pattern description + Recommended preservation method

### Step 4: Targeted Solution Questions

Instead of asking generic "what artifact type?", ask intelligent, targeted questions based on Step 3 analysis.

**If specific problems were identified:**

Use AskUserQuestion with targeted questions for EACH identified issue:

```
Question: "I noticed [specific problem]. How should I address this?"
Header: "[Problem area]"
Options:
1. Update [existing-artifact] to fix this (Recommended)
   - Description: [Explain what specifically would be updated]
2. Create new [artifact-type] for this
   - Description: [Explain why a new artifact might be better]
3. Skip this issue
   - Description: Not important enough to capture right now

multiSelect: false (one issue at a time)
```

**Example 1 - Skill Failed:**
```
Question: "The deploy-check skill failed to verify database migrations. How should I address this?"
Header: "Skill Failure"
Options:
1. Update deploy-check skill to add migration verification (Recommended)
   - Description: Add migration check step to existing workflow
2. Create new skill for migration verification
   - Description: Separate skill specifically for database migrations
3. Skip this issue
   - Description: Not important enough to capture right now
```

**Example 2 - Missing Context:**
```
Question: "Claude didn't know this project uses Jest for testing. How should I address this?"
Header: "Missing Context"
Options:
1. Update CLAUDE.md to document testing preferences (Recommended)
   - Description: Add testing framework and conventions to project context
2. Create test-setup command for initializing tests
   - Description: Create slash command for test configuration
3. Skip this issue
   - Description: Not important enough to capture right now
```

**Example 3 - Repetitive Manual Task:**
```
Question: "You manually formatted PR descriptions 3 times. How should I address this?"
Header: "Manual Work"
Options:
1. Create /format-pr command for this workflow (Recommended)
   - Description: Slash command to format PR descriptions on demand
2. Update existing pr skill to auto-format
   - Description: Integrate into existing PR creation workflow
3. Skip this issue
   - Description: Not important enough to capture right now
```

**If NO specific problems identified (Happy Path):**

Analyze what work categories were performed and ask about preserving successful patterns:

```
Question: "This session went smoothly! I identified these work areas that were performed successfully. Which would you like to document or automate for future use?"
Header: "Successful Patterns"
Options:
[Dynamically generate based on actual work done]
Example options:
1. Daily planning workflow
   - Description: Capture the structured planning approach used
2. Task management process
   - Description: Document how tasks were organized and tracked
3. PR review checklist
   - Description: Preserve the review steps that worked well
4. None - session was too specific
   - Description: This work doesn't need preservation

multiSelect: true (can select multiple successful patterns)
```

**Follow-up question (if needed):**

If user selects a pattern, ask HOW to preserve it:

```
Question: "How should I preserve the [selected pattern]?"
Header: "Artifact Type"
Options:
1. Create Skill (for autonomous use) (Recommended)
   - Description: Claude will automatically discover and apply this
2. Create Slash Command (for manual invocation)
   - Description: You invoke explicitly when needed
3. Update CLAUDE.md (for project context)
   - Description: Document as project-wide guideline

multiSelect: false
```

**Key Principles:**
- Ask about ONE specific problem at a time (not multi-select for problems)
- Recommend the obvious solution based on root cause
- Allow user to override recommendation if they prefer different approach
- For happy-path sessions, allow multi-select of successful patterns to preserve
- Always provide "Skip" option to give user control

**Prioritization When Multiple Issues Found:**

If you identify multiple friction points, ask about them in this priority order:

1. **Tool/Skill failures** (highest priority - these block work)
   - Example: "The deploy-check skill failed..."

2. **Repetitive manual work** (high priority - direct productivity impact)
   - Example: "You manually formatted PR descriptions 3 times..."

3. **Missing context** (medium priority - causes wrong assumptions)
   - Example: "Claude didn't know the project uses Jest..."

4. **Decision pivots** (lower priority - learning experiences)
   - Example: "We changed approach from X to Y..."

Within each category, prioritize by:
- **Frequency**: How many times did this occur?
- **Impact**: How much time did this waste?
- **Reusability**: Will this help in future sessions?

**Maximum questions**: Ask about top 3-5 issues maximum. Don't overwhelm user with minor problems.

### Step 5: Generate Artifacts

For each selected artifact type:

#### If Creating/Updating a Skill:

**Invoke the `skill-generator` skill:**

Use the Skill tool: `skill: "skill-generator"`

Provide context from the reflection:
- Project purpose and domain
- Skill name (ask user if needed, use verb-noun format)
- Description of what the skill should do
- Expected workflow steps (from successful approaches)
- Common pitfalls identified in reflection
- Verification strategies
- Concrete examples from the conversation

The skill-generator will:
- Check if skill already exists
- Generate SKILL.md with proper YAML frontmatter
- Create supporting scripts/templates/references if needed
- Validate the skill structure
- Place files in .claude/skills/[skill-name]/

**If updating an existing skill:**
1. Check if skill exists: `ls .claude/skills/[skill-name]`
2. Ask user: "Skill '[skill-name]' already exists. Should I update it or create a new one?"
3. If updating, provide the existing skill content to skill-generator along with what should be added/changed

#### If Creating/Updating a Slash Command:

**Invoke the `command-generator` skill:**

Use the Skill tool: `skill: "command-generator"`

Provide context from the reflection:
- Conversation history (for retrospective context)
- Command purpose and workflow
- Whether arguments are needed
- Expected inputs/outputs
- Successful approaches from the session
- Common pitfalls identified
- Concrete usage examples from the conversation

The command-generator will:
- Check if command already exists
- Ask user for command name and details
- Design appropriate command structure
- Determine frontmatter requirements
- Generate command markdown with proper formatting
- Validate YAML and markdown syntax
- Place file in .claude/commands/

**If updating an existing command:**
1. Check if command exists: `ls .claude/commands/[command-name].md`
2. Ask user: "Command '/[command-name]' already exists. Should I update it or create a new one?"
3. If updating, provide existing content to command-generator with changes needed

#### If Updating CLAUDE.md:

**Invoke the `claudemd-generator` skill:**

Use the Skill tool: `skill: "claudemd-generator"`

Provide context from the reflection:
- What information should be added
- Why this is important for the project
- Where it fits in the project context
- Successful approaches from the session
- Project-specific conventions identified
- Team standards that emerged

The claudemd-generator will:
- Read existing .claude/CLAUDE.md
- Analyze current structure and length
- Determine appropriate section for new content
- Apply WHAT/WHY/HOW framework
- Recommend progressive disclosure if approaching 300 lines
- Update CLAUDE.md with proper formatting
- Validate markdown syntax
- Provide summary of changes made

### Step 6: Validate Generated Artifacts

For each artifact created:

**Skills:**
The skill-generator skill handles:
- Valid YAML frontmatter with `name` and `description` fields
- Correct markdown formatting
- Proper file paths in `.claude/skills/`

**Slash Commands:**
The command-generator skill handles:
- Valid YAML frontmatter (if present)
- Correct markdown formatting
- Proper file placement in `.claude/commands/`
- No naming conflicts with existing commands

**CLAUDE.md:**
The claudemd-generator skill handles:
- Valid markdown formatting
- No syntax errors
- Proper heading hierarchy
- Structure preservation
- Length warnings (300+ lines)

If any skill reports validation errors, review and address before proceeding.

### Step 7: Summary Report

Present a clear, actionable summary that connects problems to solutions:

```markdown
## Retrospective Complete

### Session Analysis:

**Friction Points Addressed:**
- [Problem 1]: [Root cause] → [Solution applied]
- [Problem 2]: [Root cause] → [Solution applied]

**Successful Patterns Preserved:**
- [Pattern 1]: [Why it worked] → [How it was captured]
- [Pattern 2]: [Why it worked] → [How it was captured]

### Artifacts Created/Updated:

**Skills:**
- [skill-name]: [what was fixed/added] (`.claude/skills/[skill-name]/SKILL.md`)
  - Addresses: [specific problem this solves]

**Slash Commands:**
- /[command-name]: [what it automates] (`.claude/commands/[command-name].md`)
  - Addresses: [specific repetitive task this handles]

**CLAUDE.md Updates:**
- Section: [section-name]
- Added: [specific context/convention documented]
- Addresses: [specific knowledge gap this fills]

### Impact:

**Problems Solved:**
- [Explain how each artifact prevents the friction point from recurring]

**Patterns Codified:**
- [Explain how successful approaches are now reusable]

### Next Steps:

- **Skills**: Claude will automatically apply these fixes in future sessions
- **Slash Commands**: Type `/[command-name]` when you need this workflow
- **CLAUDE.md**: All future sessions will have this context available

Your session learnings are now institutional knowledge!
```

## Conversation Analysis Guide

This section provides detailed guidance on HOW to analyze the conversation for patterns.

### Detecting Friction Points

**Look for these conversation markers:**

1. **User Corrections (High-priority signals):**
   - "No, not like that"
   - "Actually, [different approach]"
   - "Don't do that"
   - "Change that to [different approach]"
   - "I meant [clarification]"
   - User interrupting tool execution

2. **Tool Failures:**
   - Error messages in tool results
   - Unexpected output that user points out
   - Tools that run multiple times with different approaches
   - Workarounds implemented after tool failures
   - User manually fixing tool output

3. **Repetitive Manual Work:**
   - User performs same task 2+ times
   - Similar commands/edits repeated with slight variations
   - User copy-pasting similar content
   - Pattern: User does X, then later does X again, then does X a third time

4. **Missing Context Indicators:**
   - Claude makes wrong assumptions about project setup
   - User has to explain project conventions/preferences
   - Claude uses wrong library/framework/tool
   - User corrects project-specific information
   - Questions that should have been answerable from context

5. **Decision Pivots:**
   - "Let's try a different approach"
   - "On second thought..."
   - Strategy changes mid-session
   - Backtracking to earlier state

### Detecting Success Patterns

**Look for these positive markers:**

1. **Smooth Workflows:**
   - Multi-step processes that complete without intervention
   - User says "perfect", "exactly", "great", "that's what I needed"
   - No corrections needed
   - Natural progression from start to finish

2. **Effective Problem-Solving:**
   - Problem identified → Solution applied → Validation passed
   - User satisfied with outcome
   - Approach worked on first try

3. **Reusable Techniques:**
   - Novel approaches that worked well
   - Creative solutions to common problems
   - Processes that could apply to similar tasks
   - User says "let's do that again later" or "remember this for next time"

### Analysis Output Format

After reading the conversation, create a structured analysis:

```markdown
## Friction Point Analysis

### Problem 1: [Brief description]
- **Evidence**: [Quote or describe what happened]
- **Root Cause**: [Why this happened]
- **Impact**: [How it affected the session]
- **Recommended Solution**: [Specific artifact to create/update]

### Problem 2: [Brief description]
...

## Success Pattern Analysis

### Pattern 1: [Brief description]
- **What Worked**: [Describe the approach]
- **Why It Worked**: [Key factors for success]
- **Reusability**: [How this could apply elsewhere]
- **Recommended Preservation**: [How to capture this]

### Pattern 2: [Brief description]
...
```

This structured analysis becomes the basis for targeted questions in Step 4.

## Best Practices

1. **Analyze conversation thoroughly**: Don't just ask user what to capture - discover friction points yourself
2. **Be specific in solutions**: "Update deploy-check skill" not "improve deployment process"
3. **Connect problems to solutions**: Every artifact should address a specific pain point
4. **One problem at a time**: Ask about each issue separately, don't overwhelm with multi-select
5. **Preserve user voice**: Include actual quotes from conversation in artifacts
6. **Root cause over symptoms**: Fix why something failed, not just the symptom
7. **Recommend intelligently**: Based on root cause, suggest the obvious solution type
8. **Allow overrides**: User can choose different approach if they prefer

## Error Handling

**If directory doesn't exist:**
- Create it: `mkdir -p .claude/skills/[skill-name]` or `mkdir -p .claude/commands`

**If file already exists:**
- Ask user whether to update or create new with different name
- Never overwrite without explicit permission

**If validation fails:**
- Report specific errors clearly
- Attempt automatic fixes for common issues (YAML syntax)
- Ask user for guidance if automatic fix isn't possible

**If conversation history unavailable:**
- Ask user to describe what should be captured
- Work from user's verbal summary
- Note in artifact that it was created from summary, not full conversation

## Examples

### Example 1: Skill Failure Detection and Fix

**User:** `/retrospective`

**Analysis:**
- Detected that `deploy-check` skill failed to verify database migrations (tool error + user had to manually check)
- Root cause: Skill missing migration verification step

**Question Asked:**
"The deploy-check skill failed to verify database migrations. How should I address this?"
- Option 1: Update deploy-check skill to add migration verification (Recommended) ✓ Selected
- Option 2: Create new skill for migration verification
- Option 3: Skip this issue

**Outcome:** Updated `.claude/skills/deploy-check/SKILL.md`:
- Added migration verification step to workflow
- Included database connection check
- Added migration status validation

### Example 2: Missing Context Detection

**User:** `/retrospective`

**Analysis:**
- Detected Claude used wrong testing framework (user corrected: "we use Jest, not Mocha")
- Root cause: CLAUDE.md lacks testing framework preferences

**Question Asked:**
"Claude didn't know this project uses Jest for testing. How should I address this?"
- Option 1: Update CLAUDE.md to document testing preferences (Recommended) ✓ Selected
- Option 2: Create test-setup command for initializing tests
- Option 3: Skip this issue

**Outcome:** Updated `.claude/CLAUDE.md`:
- Added "Testing" section
- Documented Jest as standard framework
- Included test file naming conventions
- Added example test structure

### Example 3: Repetitive Manual Work Detection

**User:** `/retrospective`

**Analysis:**
- Detected user manually formatted PR descriptions 3 times during session
- Root cause: No automation exists for this repetitive task

**Question Asked:**
"You manually formatted PR descriptions 3 times. How should I address this?"
- Option 1: Create /format-pr command for this workflow (Recommended) ✓ Selected
- Option 2: Update existing pr skill to auto-format
- Option 3: Skip this issue

**Outcome:** Created `.claude/commands/format-pr.md`:
- Slash command for on-demand PR formatting
- Includes title formatting, section structure, checklist generation
- User invokes with `/format-pr` when needed

### Example 4: Happy Path - Successful Patterns

**User:** `/retrospective`

**Analysis:**
- No friction points detected (session went smoothly!)
- Identified successful patterns: Daily planning workflow, Git commit message formatting

**Question Asked:**
"This session went smoothly! I identified these work areas that were performed successfully. Which would you like to document or automate for future use?"
- Option 1: Daily planning workflow ✓ Selected
- Option 2: Git commit message formatting ✓ Selected
- Option 3: Code review checklist
- Option 4: None - session was too specific

**Follow-up Questions:**
For each selected pattern, asked:
"How should I preserve the daily planning workflow?"
- Option 1: Create Skill (for autonomous use) ✓ Selected
- Option 2: Create Slash Command (for manual invocation)
- Option 3: Update CLAUDE.md (for project context)

**Outcome:** Created:
- Skill `daily-planning` (autonomous workflow for planning sessions)
- Skill `format-commit-messages` (auto-applies commit message standards)

### Example 5: Multiple Problems in One Session

**User:** `/retrospective`

**Analysis:**
- Problem 1: Skill `api-client` failed on timeout handling
- Problem 2: Claude didn't know project's error handling conventions
- Problem 3: User manually wrote API docs 4 times

**Questions Asked (one at a time):**
1. "The api-client skill failed on timeout handling. How should I address this?"
   - Selected: Update api-client skill ✓

2. "Claude didn't know this project's error handling conventions. How should I address this?"
   - Selected: Update CLAUDE.md ✓

3. "You manually wrote API documentation 4 times. How should I address this?"
   - Selected: Create /document-api command ✓

**Outcome:**
- Updated `.claude/skills/api-client/SKILL.md` with timeout handling
- Updated `.claude/CLAUDE.md` with error handling section
- Created `.claude/commands/document-api.md` for API documentation workflow

## Important Notes

- Always read the full conversation before analyzing
- Preserve the user's voice and preferences
- Focus on what's actually useful and reusable
- Don't over-engineer - keep artifacts simple and focused
- Test that artifact names don't conflict with existing ones
- Format all YAML and markdown correctly
- Provide clear, actionable summary at the end
