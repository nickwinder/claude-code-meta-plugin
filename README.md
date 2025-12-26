# Claude Code Meta Plugin

**Version:** 0.0.1
**Author:** Nick Winder

A meta-plugin for extending and customizing Claude Code itself. Generate CLAUDE.md files, create custom skills, design slash commands, and architect new Claude Code projects with expert guidance.

## Overview

This plugin provides tools for meta-level Claude Code development - helping you build better Claude Code projects, skills, commands, and documentation. Perfect for power users who want to extend Claude Code's capabilities or create reusable project templates.

## Features

### 🎯 Skills (Auto-Discovered)

#### `claudemd-generator`
Automatically creates or updates CLAUDE.md files following official best practices.

**Triggers when:**
- Creating new CLAUDE.md files
- Updating existing project documentation
- Restructuring overly long CLAUDE.md files
- Fixing CLAUDE.md formatting issues

**What it does:**
- Consults claude-code-guide for current best practices
- Applies WHAT/WHY/HOW framework
- Implements progressive disclosure when needed
- Validates markdown and structure
- Prevents common anti-patterns

#### `command-generator`
Creates effective Claude Code slash commands with proper structure and validation.

**Triggers when:**
- Designing new slash commands
- Updating existing commands
- Creating workflow shortcuts
- Building custom prompts

**What it does:**
- Researches slash command best practices
- Designs appropriate argument patterns
- Creates proper YAML frontmatter
- Validates command structure
- Handles tool restrictions and model selection

#### `skill-generator`
Generates domain-specific skills tailored to your project workflows.

**Triggers when:**
- Creating automation workflows
- Building domain-specific capabilities
- Designing reusable procedures
- Structuring complex multi-step processes

**What it does:**
- Designs focused, composable skills
- Creates proper SKILL.md structure
- Bundles supporting resources (scripts, references, assets)
- Validates naming and descriptions
- Follows auto-discovery patterns

### 🤖 Agents (Specialized Expertise)

#### `project-architect`
Expert agent for designing Claude Code project structure and integrations.

**Model:** Sonnet (balanced for architectural decisions)

**Use when:**
- Designing new Claude Code projects
- Selecting appropriate MCP servers
- Planning skill and agent architecture
- Configuring permissions and security
- Choosing project templates

**Expertise:**
- Project structure and configuration
- MCP server ecosystem
- Skill and agent design principles
- Permission management
- Workflow automation

### 📋 Slash Commands

#### `/meta:retrospective`
Reflect on your work session and capture learnings into reusable artifacts.

**Usage:**
```bash
/meta:retrospective
```

**What it does:**
1. Analyzes the current conversation
2. Identifies successful approaches and pitfalls
3. Asks what you want to capture
4. Generates skills, commands, or CLAUDE.md updates
5. Provides a summary of artifacts created

**Perfect for:**
- End-of-session knowledge capture
- Building institutional knowledge
- Creating reusable workflows
- Documenting best practices

## Installation

### Option 1: Install from Repository

```bash
# Add the plugin marketplace (if not already added)
/plugin marketplace add nickwinder/claude-code-meta-plugin

# Install the plugin
/plugin install claude-code-meta

# Verify installation
/plugin list
```

### Option 2: Local Development

```bash
# Clone the repository
git clone https://github.com/nickwinder/claude-code-meta-plugin.git

# Test locally with --plugin-dir flag
claude --plugin-dir ./claude-code-meta-plugin
```

### Option 3: Manual Installation

1. Download or clone this repository
2. Copy to your Claude Code plugins directory:
   ```bash
   cp -r claude-code-meta-plugin ~/.claude/plugins/
   ```
3. Restart Claude Code

## Quick Start

### Creating a CLAUDE.md File

Simply describe what you want to document, and the `claudemd-generator` skill will activate:

```
Create a CLAUDE.md file explaining our API authentication patterns
```

The skill will:
- Consult official best practices
- Ask clarifying questions
- Structure content properly
- Validate the result

### Generating a New Skill

Describe the workflow you want to automate:

```
Create a skill for deploying our Next.js app to Vercel with pre-deployment checks
```

The `skill-generator` skill will:
- Ask about your workflow details
- Design the skill structure
- Generate SKILL.md with proper formatting
- Create any needed supporting files

### Creating a Slash Command

Request a new command:

```
Create a slash command for running our test suite with coverage reporting
```

The `command-generator` skill will:
- Research command best practices
- Design appropriate structure
- Ask about arguments and tool restrictions
- Generate the command file

### Capturing Session Learnings

At the end of your work session:

```
/meta:retrospective
```

Then describe what you want to capture:
```
The debugging workflow we used to find that race condition
```

The command will create reusable artifacts from your session.

### Architecting a New Project

Invoke the project-architect agent:

```
I need to design a Claude Code project for content creation with SEO optimization
```

The agent will:
- Analyze your requirements
- Recommend appropriate templates
- Suggest MCP server integrations
- Design custom skills
- Provide implementation guidance

## Plugin Structure

```
claude-code-meta-plugin/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── skills/
│   ├── claudemd-generator/
│   │   └── SKILL.md
│   ├── command-generator/
│   │   └── SKILL.md
│   └── skill-generator/
│       └── SKILL.md
├── agents/
│   └── project-architect.md
├── commands/
│   └── retrospective.md
├── docs/
│   └── getting-started.md
├── README.md
└── LICENSE
```

## Use Cases

### For Plugin Developers
- Generate plugin scaffolding
- Create well-structured skills
- Design effective slash commands
- Follow Claude Code best practices

### For Project Creators
- Set up new Claude Code projects
- Select appropriate integrations
- Design project-specific workflows
- Build institutional knowledge

### For Power Users
- Customize Claude Code behavior
- Create reusable automation
- Document project patterns
- Capture session learnings

### For Teams
- Standardize project structure
- Share reusable components
- Document team conventions
- Build knowledge repositories

## Best Practices

### When to Use Each Component

**Use `claudemd-generator` for:**
- Project-wide instructions and context
- Team conventions and standards
- Background knowledge Claude needs
- Universal guidelines

**Use `command-generator` for:**
- Manual workflows you want control over
- Shortcuts for frequent tasks
- Parameterized operations
- Explicit invocations

**Use `skill-generator` for:**
- Complex multi-step automation
- Domain-specific capabilities
- Workflows Claude should auto-discover
- Reusable procedures

**Use `project-architect` for:**
- Greenfield project setup
- Architecture decisions
- Integration selection
- Permission design

**Use `/meta:retrospective` for:**
- End-of-session knowledge capture
- Creating artifacts from conversations
- Building reusable patterns
- Documenting learnings

### Naming Conventions

**Skills:** Use kebab-case with verb-noun format
- ✓ `deploy-app`, `analyze-code`, `log-workout`
- ✗ `helper`, `utility`, `processor`

**Commands:** Short, memorable, kebab-case
- ✓ `deploy`, `review`, `analyze`
- ✗ `do-deployment-process`, `helper-script`

**Agents:** Role-based names
- ✓ `project-architect`, `senior-developer`, `qa-specialist`
- ✗ `agent-1`, `helper-bot`

## Advanced Configuration

### Using with Existing Projects

This plugin works great in any Claude Code project. Simply install and the skills will auto-discover when relevant.

### Combining with Other Plugins

The meta plugin is designed to work alongside other plugins:
- Use with development plugins to generate code-specific skills
- Combine with content plugins to create publishing workflows
- Integrate with data plugins for analysis automation

### Custom Templates

The `project-architect` agent can recommend custom templates for your use case. After generating a few projects, you'll have reusable patterns for your domain.

## Examples

### Example 1: Documenting API Patterns

```
Update CLAUDE.md with our GraphQL mutation patterns and error handling conventions
```

Result: `claudemd-generator` creates a well-structured section following best practices.

### Example 2: Creating a Deployment Skill

```
Create a skill that deploys our app to staging, runs smoke tests, and notifies the team
```

Result: `skill-generator` creates a complete skill with validation and error handling.

### Example 3: Session Retrospective

```
/meta:retrospective
"The pattern we used for handling file uploads with progress tracking"
```

Result: Multiple artifacts capturing the upload workflow as a skill and updating CLAUDE.md with best practices.

### Example 4: New Project Architecture

```
Design a Claude Code project for a fitness tracking app with local data storage
```

Result: `project-architect` provides comprehensive recommendations for template, MCP servers, skills, and structure.

## Troubleshooting

### Skills Not Auto-Discovering

**Issue:** Skills aren't activating when expected
**Solution:** Check skill descriptions - they must clearly indicate when to use the skill

### Commands Not Found

**Issue:** `/meta:retrospective` not recognized
**Solution:** Ensure plugin is installed correctly with `/plugin list`

### Agent Not Responding

**Issue:** project-architect agent not providing recommendations
**Solution:** Be specific about what you're trying to design or architect

## Contributing

This plugin is designed to evolve with Claude Code. Contributions welcome!

### Reporting Issues

Found a bug or have a suggestion? [Open an issue](https://github.com/nickwinder/claude-code-meta-plugin/issues)

### Submitting Changes

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## License

MIT License - see LICENSE file for details

## Changelog

### v0.0.1 (Initial Release)
- Added `claudemd-generator` skill
- Added `command-generator` skill
- Added `skill-generator` skill
- Added `project-architect` agent
- Added `/meta:retrospective` command
- Initial documentation

## Resources

- [Claude Code Documentation](https://code.claude.com/docs/en/)
- [Plugin Development Guide](https://code.claude.com/docs/en/plugins.md)
- [MCP Documentation](https://modelcontextprotocol.io/)
- [Claude Code GitHub](https://github.com/anthropics/claude-code)

## Support

For questions, issues, or suggestions:
- GitHub Issues: [nickwinder/claude-code-meta-plugin/issues](https://github.com/nickwinder/claude-code-meta-plugin/issues)
- Documentation: See `docs/getting-started.md`

---

**Built with Claude Code** 🤖

Extend Claude Code with Claude Code - meta all the way down!
