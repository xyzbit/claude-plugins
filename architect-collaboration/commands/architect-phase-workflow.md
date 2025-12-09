---
name: "architect:phase-workflow"
description: "Comprehensive phase management command that starts, validates, and generates templates for any of the 4 architect collaboration phases"
argument-hint: "[--phase <number>] [--project <name>] [--interactive] [--generate] [--validate]"
allowed-tools: ["Read", "Write", "Bash", "Edit", "Grep"]
---

# /architect:phase-workflow

This command provides comprehensive phase management for the Senior Architect Collaboration workflow. It can start a new phase with templates, validate phase completion criteria, or generate phase-specific documentation.

## Usage

### Interactive Mode (Recommended)
```bash
/architect:phase-workflow
```
Prompts will guide you through phase selection, project setup, and actions.

### Automated Mode
```bash
/architect:phase-workflow --phase 1 --project "E-commerce Platform" --generate
```

## Arguments

- `--phase <number>`: Phase number (1-4)
  - 1: Requirements Analysis
  - 2: Technical Design
  - 3: Task Breakdown
  - 4: Feature Development

- `--project <name>`: Project name for documentation

- `--interactive`: Force interactive mode (default if no other flags)

- `--generate`: Generate phase templates only

- `--validate`: Validate phase completion only

- `--help`: Show help information

## Examples

### Example 1: Start New Phase (Interactive)
```bash
/architect:phase-workflow
```
Output:
```
🚀 Architect Collaboration - Phase Workflow

Select phase:
1. Requirements Analysis
2. Technical Design
3. Task Breakdown
4. Feature Development

Enter choice (1-4): 2

Selected: Phase 2 - Technical Design
Project name: User Authentication System

What would you like to do?
[1] Generate templates and start phase
[2] Validate existing phase work
[3] Both generate and validate

Select option (1-3): 1

✅ Created: docs/technical-design.md
✅ Created: docs/architecture-diagram.md
✅ Created: docs/pseudocode.md

Phase 2 started successfully!
Next steps:
1. Review generated templates
2. Use Requirements Analysis Skill to gather requirements
3. Use Technical Design Skill for solution architecture
```

### Example 2: Generate Templates Only
```bash
/architect:phase-workflow --phase 3 --project "Payment Gateway" --generate
```
Output:
```
📋 Generating templates for Phase 3: Task Breakdown

✅ Created: docs/开发任务.md
✅ Created: docs/task-dependencies.md
✅ Created: docs/sprint-plan.md

Templates generated successfully!
Location: docs/
```

### Example 3: Validate Phase
```bash
/architect:phase-workflow --phase 1 --validate
```
Output:
```
🔍 Validating Phase 1: Requirements Analysis

Checking completion criteria:
✅ Business goals defined
✅ Success metrics established
✅ Stakeholders identified
⚠️  Risk assessment incomplete (see: docs/requirements.md:45)
❌ Stakeholder approval missing

Validation Summary:
- Completed: 4/6 criteria
- Status: Needs attention

Recommendations:
1. Complete risk assessment section
2. Obtain stakeholder sign-off
3. Review requirements for completeness

Next steps:
- Fix validation issues
- Run validation again: /architect:phase-workflow --phase 1 --validate
```

### Example 4: Complete Workflow
```bash
/architect:phase-workflow --phase 2 --project "API Gateway" --generate --validate
```
Output:
```
🚀 Phase Workflow - Phase 2: Technical Design

Generating templates...
✅ Created: docs/technical-design.md
✅ Created: docs/architecture-diagram.md
✅ Created: docs/pseudocode.md

Validating phase...
✅ Technical feasibility confirmed
✅ Architecture patterns documented
✅ Pseudo-code for complex logic present
✅ TDD approach planned
✅ Test strategy defined

Validation Summary:
- Completed: 6/6 criteria
- Status: ✅ Ready to proceed

Next steps:
1. Review technical design document
2. Proceed to Phase 3: Task Breakdown
3. Use Task Breakdown Skill
```

## Templates Generated

### Phase 1: Requirements Analysis
- `docs/requirements.md` - Requirements document template
- `docs/risk-assessment.md` - Risk assessment template
- `docs/stakeholder-analysis.md` - Stakeholder analysis template

### Phase 2: Technical Design
- `docs/technical-design.md` - Technical design document
- `docs/architecture-diagram.md` - Architecture diagram template
- `docs/pseudocode.md` - Pseudo-code template
- `docs/test-strategy.md` - TDD test strategy template

### Phase 3: Task Breakdown
- `docs/开发任务.md` - Task list template
- `docs/task-dependencies.md` - Dependency mapping template
- `docs/sprint-plan.md` - Sprint planning template
- `docs/estimation.md` - Effort estimation template

### Phase 4: Feature Development
- `docs/implementation-plan.md` - Implementation guide
- `docs/code-standards.md` - Coding standards reference
- `docs/testing-guide.md` - Testing requirements
- `docs/progress-tracker.md` - Progress tracking template

## Validation Criteria

### Phase 1 Validation
- [ ] Business goals clearly defined
- [ ] Success metrics established
- [ ] Stakeholders identified
- [ ] Constraints documented
- [ ] Risk assessment completed
- [ ] Stakeholder approval obtained

### Phase 2 Validation
- [ ] Technical feasibility confirmed
- [ ] Architecture patterns documented
- [ ] Pseudo-code for complex logic present
- [ ] TDD approach planned
- [ ] Test strategy defined
- [ ] Technology stack justified

### Phase 3 Validation
- [ ] Tasks broken down (≤2 person-days each)
- [ ] Dependencies mapped
- [ ] Priorities assigned
- [ ] Estimates provided
- [ ] Acceptance criteria defined
- [ ] Resource allocation planned

### Phase 4 Validation
- [ ] Development workflow defined
- [ ] Code quality standards documented
- [ ] Test coverage target set (≥80%)
- [ ] Progress tracking mechanism in place
- [ ] Code review process defined
- [ ] Deployment strategy planned

## Interactive Prompts

When running in interactive mode, the command will ask:

1. **Phase Selection**
   - "Which phase would you like to work on? (1-4)"

2. **Project Name**
   - "What is your project name? (used for documentation)"

3. **Action Selection**
   - "What would you like to do?"
     - Generate templates and start phase
     - Validate existing phase work
     - Both generate and validate

4. **Template Customization** (optional)
   - "Do you want to customize template fields? (y/N)"

5. **Documentation Location**
   - "Where should templates be created? (default: docs/)"

6. **Next Steps Confirmation**
   - "Show next steps guide? (Y/n)"

## Configuration

### Settings File
Create `.claude/architect-collaboration.local.md`:

```markdown
# Phase Workflow Settings

## Default Phase
default_phase: 1

## Documentation Settings
default_doc_location: "docs/"
include_date_in_filenames: true

## Validation Settings
strict_validation: false
require_all_criteria: false

## Template Settings
use_custom_templates: false
template_version: "1.0"
```

## Integration with Skills

This command works seamlessly with the architect skills:

- **Phase 1**: Use with Requirements Analysis Skill
- **Phase 2**: Use with Technical Design Skill
- **Phase 3**: Use with Task Breakdown Skill
- **Phase 4**: Use with Feature Development Skill

Example workflow:
```bash
# Start Phase 2 with templates
/architect:phase-workflow --phase 2 --project "My Project"

# Get technical design guidance
# "Design solution for user authentication"

# Break down tasks
# "Break down tasks for authentication module"

# Start implementation
# "Help me implement feature with tests"
```

## Tips

1. **Start with Phase 1** - Always begin with requirements, even for small features
2. **Validate Early** - Use `--validate` flag to check progress frequently
3. **Customize Templates** - Modify generated templates to fit your project
4. **Track Progress** - Update task status regularly in generated documents
5. **Review Regularly** - Hold design reviews at each phase transition

## Troubleshooting

### Templates Not Generated
**Problem**: Command runs but no templates created
**Solution**:
- Check write permissions in target directory
- Ensure `docs/` directory exists or can be created
- Verify project name is valid

### Validation Always Fails
**Problem**: Validation reports criteria as incomplete
**Solution**:
- Check that required files exist in expected locations
- Verify document structure matches templates
- Review validation output for specific missing items
- Run with `--interactive` for guided validation

### Permission Denied
**Problem**: Cannot create files
**Solution**:
- Check directory permissions
- Run from project root directory
- Ensure sufficient disk space

## Advanced Usage

### Batch Phase Setup
```bash
# Set up all phases for a new project
for phase in {1..4}; do
  /architect:phase-workflow --phase $phase --project "New Project" --generate
done
```

### CI/CD Integration
```yaml
# .github/workflows/phase-validation.yml
- name: Validate Phase Completion
  run: |
    /architect:phase-workflow --phase 1 --validate
    /architect:phase-workflow --phase 2 --validate
```

### Custom Validation Script
```bash
#!/bin/bash
# Validate all phases
for phase in {1..4}; do
  echo "Validating Phase $phase..."
  /architect:phase-workflow --phase $phase --validate || exit 1
done
echo "All phases validated successfully!"
```

## Related Commands

- `/architect:manage-progress` - Track progress and publish documentation
- Skills: Each phase has a corresponding skill for detailed guidance

## Support

For issues or questions:
- Review phase templates in `docs/`
- Check skill documentation for detailed guidance
- Verify all validation criteria are met
