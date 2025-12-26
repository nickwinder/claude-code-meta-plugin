# Getting Started with Claude Code Meta Plugin

Welcome to the Claude Code Meta Plugin! This guide will help you get up and running quickly.

## What is This Plugin?

The Claude Code Meta Plugin is a set of tools for extending and customizing Claude Code itself. Think of it as "Claude Code for Claude Code" - it helps you:

- Generate well-structured CLAUDE.md files
- Create custom skills for automation
- Design slash commands for workflows
- Architect new Claude Code projects
- Capture session learnings into reusable artifacts

## Installation

### Quick Install

```bash
# Add the marketplace (one time)
/plugin marketplace add nickwinder/claude-code-meta-plugin

# Install the plugin
/plugin install claude-code-meta

# Verify it's installed
/plugin list
```

You should see `claude-code-meta (v0.0.1)` in the list.

### Local Development Install

```bash
# Clone the repo
git clone https://github.com/nickwinder/claude-code-meta-plugin.git

# Run Claude Code with the plugin
claude --plugin-dir ./claude-code-meta-plugin
```

## What Gets Installed?

When you install this plugin, you get:

### 3 Auto-Discovered Skills
- **claudemd-generator**: Creates/updates CLAUDE.md files
- **command-generator**: Generates slash commands
- **skill-generator**: Creates custom skills

### 1 Specialized Agent
- **project-architect**: Expert in project design and architecture

### 1 Slash Command
- **/meta:retrospective**: Capture session learnings

## Your First Steps

### Step 1: Try the Retrospective Command

At the end of any work session, run:

```bash
/meta:retrospective
```

Claude will analyze your conversation and ask what you'd like to capture. Try it with:

```
"The workflow we just used to solve that problem"
```

You'll get options to create a skill, slash command, or update CLAUDE.md.

### Step 2: Generate a CLAUDE.md File

If your project doesn't have a CLAUDE.md file yet:

```
Create a CLAUDE.md file that explains this is a testing playground for Claude Code features
```

The `claudemd-generator` skill will automatically activate and:
- Check official best practices
- Create a well-structured file
- Follow the WHAT/WHY/HOW framework
- Validate the result

### Step 3: Create Your First Skill

Describe a workflow you want to automate:

```
Create a skill for analyzing log files and summarizing error patterns
```

The `skill-generator` skill will:
- Ask clarifying questions
- Design the skill structure
- Generate SKILL.md with proper formatting
- Validate everything

### Step 4: Make a Slash Command

Create a quick shortcut:

```
Create a slash command called /status that shows git status and recent commits
```

The `command-generator` skill will:
- Design the command structure
- Ask about tool restrictions
- Generate the command file
- Validate YAML and markdown

### Step 5: Architecture Consultation

When starting a new project:

```
I need to design a Claude Code project for managing blog content with SEO optimization
```

The `project-architect` agent will provide:
- Template recommendations
- MCP server suggestions
- Custom skill designs
- Permission configurations

## Common Workflows

### Workflow 1: Documenting Your Project

**Goal:** Create comprehensive project documentation

**Steps:**
1. Start with: `"Create a CLAUDE.md for this project"`
2. Answer the questions about your project
3. Review the generated file
4. Add more sections as needed: `"Add a section about our testing conventions"`

**Result:** Well-structured, scannable CLAUDE.md following best practices

### Workflow 2: Building Reusable Automation

**Goal:** Create a skill for a common task

**Steps:**
1. Describe the workflow: `"Create a skill for deploying to production with checks"`
2. Answer questions about the steps
3. Test the generated skill by describing a deployment task
4. Refine if needed

**Result:** Auto-discovered skill that activates when relevant

### Workflow 3: Creating Quick Shortcuts

**Goal:** Make a slash command for a frequent action

**Steps:**
1. Request: `"Create a /test command that runs our test suite"`
2. Specify if you want arguments or tool restrictions
3. Review the generated command
4. Test: `/meta:test`

**Result:** Quick shortcut you can invoke anytime

### Workflow 4: Knowledge Capture

**Goal:** Preserve learnings from a session

**Steps:**
1. At end of session: `/meta:retrospective`
2. Describe what you want to capture
3. Choose artifact type(s)
4. Review the generated artifacts

**Result:** Reusable knowledge for future sessions

### Workflow 5: Project Architecture

**Goal:** Design a new Claude Code project

**Steps:**
1. Describe your needs: `"Design a project for data analysis with Jupyter"`
2. Review the recommendations
3. Ask follow-up questions about specific aspects
4. Implement the suggested structure

**Result:** Well-designed project architecture

## Understanding Auto-Discovery

### How Skills Activate

Skills in this plugin use **auto-discovery** - Claude automatically uses them when your request matches their description.

**Example:**

```
# This will activate claudemd-generator
"Update CLAUDE.md with our coding standards"

# This will activate command-generator
"Create a slash command for database backups"

# This will activate skill-generator
"Create a skill for processing CSV files"
```

You don't need to explicitly invoke these skills - Claude uses them automatically when relevant.

### When Skills Don't Activate

If a skill doesn't activate when expected:

1. **Be more specific** about what you want
   - Instead of: "Help with docs"
   - Try: "Create a CLAUDE.md file explaining our API patterns"

2. **Use keywords** from the skill description
   - claudemd-generator: "CLAUDE.md", "update documentation"
   - command-generator: "slash command", "create command"
   - skill-generator: "create skill", "automate workflow"

3. **Explicitly mention** the skill type you want
   - "Generate a skill for..."
   - "Create a slash command that..."
   - "Update CLAUDE.md with..."

## Using the Agent

The `project-architect` agent is different from skills - it's a specialized expert you can consult.

### When to Use the Agent

- Designing new Claude Code projects
- Selecting MCP servers for your use case
- Planning skill and agent architecture
- Configuring permissions
- Getting architecture advice

### How to Invoke

Just describe your architectural need:

```
I need help designing a Claude Code project for automated testing
```

Or ask architectural questions:

```
What MCP servers should I use for a content creation project?
```

The agent will analyze your needs and provide expert recommendations.

## Customizing the Plugin

### Adding Your Own Patterns

As you use the plugin, you'll develop patterns specific to your domain. The `/meta:retrospective` command helps capture these:

1. Work on a task using the plugin tools
2. At the end: `/meta:retrospective`
3. Capture what worked well
4. Generate new skills/commands for your patterns

Over time, you'll build a library of domain-specific automation.

### Extending Skills

The generated skills can be modified:

1. Find the skill: `.claude/skills/[skill-name]/SKILL.md`
2. Edit the workflow or add examples
3. Add supporting scripts in `scripts/`
4. Add reference docs in `references/`

Changes take effect immediately.

## Tips and Tricks

### Tip 1: Start Simple

Don't try to capture everything at once. Start with:
1. Basic CLAUDE.md
2. One or two essential skills
3. A few handy slash commands

Build complexity gradually.

### Tip 2: Use Retrospectives Regularly

Make `/meta:retrospective` a habit at the end of productive sessions. This builds your knowledge base incrementally.

### Tip 3: Be Specific in Descriptions

When generating skills or commands, specific descriptions work better:
- ✓ "Deploy Next.js app to Vercel with pre-deployment validation"
- ✗ "Deploy stuff"

### Tip 4: Iterate and Refine

Generated artifacts are starting points. You can:
- Ask for updates: "Add error handling to that skill"
- Request changes: "Make that command use haiku model"
- Refine over time as you learn what works

### Tip 5: Combine Components

The most powerful setups combine multiple types:
- CLAUDE.md for project-wide context
- Skills for automation
- Commands for manual workflows
- Agent for ongoing consultation

## Troubleshooting

### "Skill not activating"

**Symptoms:** You expect a skill to run but it doesn't

**Solutions:**
1. Be more explicit: "Use claudemd-generator to create a CLAUDE.md file"
2. Check skill exists: `ls .claude/skills/`
3. Verify SKILL.md has proper YAML frontmatter

### "Command not found"

**Symptoms:** `/meta:retrospective` not recognized

**Solutions:**
1. Verify plugin installed: `/plugin list`
2. Check namespace: Plugin commands are `/meta:command-name`
3. Reinstall if needed: `/plugin uninstall claude-code-meta && /plugin install claude-code-meta`

### "Agent not responding"

**Symptoms:** project-architect not providing recommendations

**Solutions:**
1. Be specific about what you're designing
2. Include context: "for data analysis", "for web development"
3. Ask direct questions: "What template should I use for X?"

### "Generated file has errors"

**Symptoms:** YAML or markdown validation errors

**Solutions:**
1. The generators include validation - report specific errors
2. Check frontmatter indentation (YAML is whitespace-sensitive)
3. Ask for regeneration: "Fix the YAML in that skill"

## Next Steps

Now that you're up and running:

1. **Explore each component** - Try generating each artifact type
2. **Build your library** - Create skills and commands for your workflows
3. **Capture learnings** - Use `/meta:retrospective` after sessions
4. **Share with team** - Generated artifacts work great in version control
5. **Iterate and improve** - Refine artifacts as you learn what works

## Examples

### Example 1: Complete Project Setup

```
# Step 1: Architecture consultation
"I need a Claude Code project for managing customer support tickets"

# Step 2: Create CLAUDE.md
"Create a CLAUDE.md explaining this is a customer support project with ticket tracking"

# Step 3: Generate skills
"Create a skill for logging new support tickets with priority and category"
"Create a skill for analyzing ticket resolution times"

# Step 4: Make commands
"Create a /ticket-stats command that shows ticket metrics"

# Result: Complete, customized Claude Code project
```

### Example 2: Knowledge Capture Workflow

```
# After solving a complex problem
/meta:retrospective
"The debugging approach we used to find that memory leak"

# Choose: Create Skill + Update CLAUDE.md
# Result: Skill for memory leak debugging + CLAUDE.md with debugging guidelines
```

### Example 3: Team Standardization

```
# Create team standards
"Update CLAUDE.md with our code review checklist"
"Create a /review command that applies our review standards"
"Create a skill for automated code formatting checks"

# Result: Standardized team workflows
```

## Getting Help

- **Documentation:** Check the main README.md
- **Issues:** https://github.com/nickwinder/claude-code-meta-plugin/issues
- **Examples:** See the examples/ directory (coming soon)
- **Community:** Share your generated artifacts!

## Best Practices Learned

From users of this plugin:

1. **Version control everything** - Generated artifacts work great in git
2. **Namespace carefully** - Use clear, specific skill names
3. **Document as you go** - Use retrospectives to capture learnings
4. **Start project-specific** - Build generic skills later
5. **Review generated code** - Validate before committing
6. **Iterate based on usage** - Refine skills as you learn patterns

---

**You're all set!** Start generating skills, commands, and documentation for your Claude Code projects.

Happy meta-programming! 🚀
