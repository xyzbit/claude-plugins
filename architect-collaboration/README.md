# Architect Collaboration Plugin

A comprehensive Claude Code plugin that guides senior architects and development teams through a structured 4-phase collaboration workflow.

## Overview

This plugin implements the **Senior Architect Collaboration** methodology, providing interactive guidance, template generation, validation, and progress tracking throughout the software development lifecycle.

## Features

### Four-Phase Workflow

1. **Requirements Analysis** - Collaborative requirement gathering, breakdown, feasibility assessment
2. **Technical Design** - Solution architecture, TDD approach, documentation generation
3. **Task Breakdown** - Granular task creation with dependencies and priorities
4. **Feature Development** - Implementation guidance with quality checks and progress tracking

### Core Capabilities

- ✅ Interactive phase guidance with structured prompts
- ✅ Automatic template generation for each phase
- ✅ Validation and quality checks
- ✅ Progress tracking and dependency management
- ✅ Documentation system integration
- ✅ Risk identification and communication
- ✅ Pseudo-code generation for complex logic
- ✅ Test-driven development support

## Installation

```bash
# Install as a Claude Code plugin
cc --plugin-dir /path/to/architect-collaboration

# Or copy to plugins directory
cp -r architect-collaboration ~/.claude-plugins/
```

## Usage

### Skills

Invoke architect guidance using natural language:

```
"Analyze requirements for my new feature"
"Design a solution for user authentication"
"Break down tasks for the payment module"
"Help me implement the feature with tests"
```

### Commands

#### Phase Workflow Management

```bash
/architect:phase-workflow --phase 1 --project "E-commerce Platform"
```

Interactive mode (recommended):
```bash
/architect:phase-workflow
# Follow prompts for phase selection and project details
```

#### Progress Tracking

```bash
/architect:manage-progress --export markdown
/architect:manage-progress --publish confluence --url "https://wiki.company.com"
```

## Plugin Components

### Skills (4)

1. **Requirements Analysis Skill** - Guides Phase 1: Requirements gathering and validation
2. **Technical Design Skill** - Guides Phase 2: Architecture and solution design
3. **Task Breakdown Skill** - Guides Phase 3: Task creation and prioritization
4. **Feature Development Skill** - Guides Phase 4: Implementation and testing

### Commands (2)

1. **`/architect:phase-workflow`** - Complete phase management (start, validate, generate templates)
2. **`/architect:manage-progress`** - Progress tracking and documentation publishing

## Documentation Templates

The plugin generates standardized templates:

- **Requirements Document** - Business goals, constraints, success metrics
- **Technical Design Document** - Architecture, flowcharts, pseudo-code
- **Task List** - 开发任务.md with priorities and dependencies
- **Progress Reports** - Status tracking and completion metrics

## Configuration

### Settings (Optional)

Create `.claude/architect-collaboration.local.md` for custom settings:

```markdown
# Project Defaults
default_phase_duration: "2 weeks"
max_task_size: "2 person-days"

# Documentation
default_doc_format: "markdown"
export_formats: ["markdown", "pdf"]

# Quality Standards
test_coverage_threshold: 80
require_validation: true
```

## Workflow Principles

### Core Guidelines

1. **Confirmation Principle** - Quantify ambiguous descriptions and confirm key decisions
2. **Risk Communication** - Identify and communicate technical/business risks proactively
3. **Pseudo-code Requirement** - Generate pseudo-code for complex logic and algorithms
4. **Validation First** - Ensure each phase meets completion criteria before proceeding

### Phase Execution

Each phase follows:
- **Input** - Gather requirements and context
- **Process** - Apply structured methodology
- **Output** - Generate validated deliverables
- **Validate** - Check against quality criteria
- **Confirm** - User approval before proceeding

## Examples

### Requirements Analysis Example

```
User: "I need to build a user authentication system"

Architect: "Let's analyze the requirements. What are your success metrics?
- Response time < 200ms?
- Support for OAuth and password?
- Any regulatory requirements?"
```

### Technical Design Example

```
User: "Design the authentication solution"

Architect: "I'll create a technical design with TDD approach.
First, let me write test cases for login flow..."
```

## Best Practices

1. **Start with Requirements** - Always begin with Phase 1, even for small features
2. **Validate Continuously** - Use validation commands at each phase transition
3. **Document Everything** - Generate templates and keep them updated
4. **Track Progress** - Update task status regularly
5. **Communicate Risks** - Identify and escalate risks early

## Troubleshooting

### Common Issues

**Skills not triggering?**
- Ensure you're using trigger phrases: "analyze requirements", "design solution", "break down tasks", "implement feature"

**Commands not found?**
- Verify plugin is installed: `cc --list-plugins`
- Check plugin directory permissions

**Templates not generating?**
- Ensure write permissions in project directory
- Check `.claude/` directory exists

## Contributing

Contributions welcome! Please read our contributing guidelines and submit PRs for:
- New phase templates
- Additional validation rules
- Integration with other tools
- Documentation improvements

## License

MIT License - see LICENSE file for details

## Support

For issues and questions:
- GitHub Issues: https://github.com/anthropics/claude-plugins/issues
- Documentation: https://docs.anthropic.com/claude-plugins

---

**Built with ❤️ by Claude Code Plugin Team**
