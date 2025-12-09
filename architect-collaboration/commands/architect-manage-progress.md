---
name: "architect:manage-progress"
description: "Progress tracking and documentation publishing command for monitoring task completion, phase status, and exporting to documentation systems"
argument-hint: "[--project <name>] [--export <format>] [--publish <system>] [--url <url>] [--status] [--report]"
allowed-tools: ["Read", "Write", "Bash", "Edit", "Grep"]
---

# /architect:manage-progress

This command manages progress tracking and documentation publishing for the Senior Architect Collaboration workflow. It monitors task completion, tracks phase status, and exports to various documentation systems.

## Usage

### Interactive Mode (Recommended)
```bash
/architect:manage-progress
```
Interactive prompts for progress tracking and publishing.

### Track Progress
```bash
/architect:manage-progress --status
```

### Export Documentation
```bash
/architect:manage-progress --export markdown --project "E-commerce Platform"
```

### Publish to Documentation System
```bash
/architect:manage-progress --publish confluence --url "https://wiki.company.com" --project "E-commerce Platform"
```

## Arguments

- `--project <name>`: Project name for progress tracking

- `--export <format>`: Export format
  - `markdown`: Markdown format (default)
  - `json`: JSON format for programmatic use
  - `pdf`: PDF report
  - `html`: HTML report
  - `csv`: CSV for spreadsheets

- `--publish <system>`: Documentation system
  - `confluence`: Atlassian Confluence
  - `gitbook`: GitBook
  - `wiki`: Generic wiki
  - `github`: GitHub Wiki
  - `notion`: Notion workspace
  - `slack`: Slack channel summary

- `--url <url>`: Documentation system URL

- `--status`: Show current progress status

- `--report`: Generate progress report

- `--update`: Update task status (interactive)

- `--help`: Show help information

## Examples

### Example 1: View Progress Status
```bash
/architect:manage-progress --status
```
Output:
```
📊 Project Progress: User Authentication System

Phase Status:
┌────────────────────────────────────────┬──────────┬────────────┐
│ Phase                                  │ Status   │ Progress   │
├────────────────────────────────────────┼──────────┼────────────┤
│ 1. Requirements Analysis               │ ✅ Done  │ 100% (6/6) │
│ 2. Technical Design                    │ ✅ Done  │ 100% (6/6) │
│ 3. Task Breakdown                      │ 🔄 Active│  60% (6/10)│
│ 4. Feature Development                 │ ⏳ Pending│   0% (0/12)│
└────────────────────────────────────────┴──────────┴────────────┘

Task Summary:
- Total Tasks: 28
- Completed: 12 (43%)
- In Progress: 6 (21%)
- Pending: 10 (36%)

Current Sprint:
- Sprint: 2024-W3
- Tasks Completed This Sprint: 3/8
- Velocity: 5.2 tasks/sprint

Workload Distribution:
核心功能:   ████████████ 100% (12/12)
辅助功能:   ██████ 50% (3/6)
扩展功能:   █ 10% (1/10)

Next Milestone: Phase 3 Complete (ETA: 2024-01-20)
```

### Example 2: Generate Progress Report
```bash
/architect:manage-progress --report --project "Payment Gateway"
```
Output:
```
📋 Progress Report: Payment Gateway
Generated: 2024-01-15 14:30:00

═══════════════════════════════════════════════════════════

## Executive Summary

Project Status: ON TRACK
Overall Progress: 65%
Phase Completion: 3/4 phases complete
Tasks: 18/28 completed (64%)
Velocity: On target

## Phase Details

### Phase 1: Requirements Analysis ✅
Completion: 100% (6/6 criteria)
Duration: 5 days (planned: 5 days)
Quality Score: 9.5/10

Highlights:
- All stakeholders aligned
- Comprehensive risk assessment completed
- Business metrics defined and approved

### Phase 2: Technical Design ✅
Completion: 100% (6/6 criteria)
Duration: 8 days (planned: 7 days)
Quality Score: 9/10

Highlights:
- Microservices architecture selected
- TDD approach validated
- Performance benchmarks established

### Phase 3: Task Breakdown 🔄
Completion: 60% (6/10 criteria)
Duration: 3 days in progress
Planned: 5 days

Highlights:
- 18 tasks created and prioritized
- Dependencies mapped
- Sprint planning completed

Issues:
- Task #7 (OAuth integration) blocked by external API changes
- Mitigation: Pivoted to password-based auth for MVP

### Phase 4: Feature Development ⏳
Completion: 0% (0/12 criteria)
Status: Not started
Planned start: 2024-01-18

## Task Details

| Task | Status | Progress | Owner | ETA |
|------|--------|----------|-------|-----|
| User Auth Module | ✅ Done | 100% | Alice | 2024-01-10 |
| Password Reset | ✅ Done | 100% | Alice | 2024-01-11 |
| OAuth Integration | ⚠️ Blocked | 30% | Bob | 2024-01-20 |
| Email Notifications | 🔄 Active | 60% | Carol | 2024-01-16 |
| API Rate Limiting | ⏳ Pending | 0% | Dave | 2024-01-18 |

## Risk Assessment

| Risk | Severity | Status | Owner |
|------|----------|--------|-------|
| External API Changes | High | Active | Bob |
| Database Migration | Medium | Monitoring | Alice |
| Team Capacity | Low | Resolved | PM |

## Next Actions

### Immediate (This Week)
1. Complete email notification task (Carol)
2. Resolve OAuth integration blocker (Bob)
3. Begin Phase 4 implementation (Team)

### Short Term (Next 2 Weeks)
1. Complete Phase 3 validation
2. Finish Phase 4 technical spike
3. Begin user acceptance testing

### Medium Term (Next Month)
1. Production deployment
2. Performance testing
3. Security audit

## Resource Utilization

Team Velocity:
- Alice: 95% utilized
- Bob: 85% utilized
- Carol: 90% utilized
- Dave: 80% utilized

Budget:
- Spent: $45,000 / $60,000 (75%)
- Remaining: $15,000

## Recommendations

1. **Address OAuth Blocker** - Escalate to vendor, consider alternative approach
2. **Maintain Velocity** - Current pace is sustainable
3. **Prepare Phase 4** - Ensure environment setup complete before start
4. **Risk Mitigation** - Weekly risk review meetings
```

### Example 3: Export to Markdown
```bash
/architect:manage-progress --export markdown --project "E-commerce Platform"
```
Creates: `progress-report-ecommerce-platform-2024-01-15.md`

### Example 4: Publish to Confluence
```bash
/architect:manage-progress --publish confluence --url "https://company.atlassian.net/wiki" --project "E-commerce Platform"
```
Output:
```
🚀 Publishing to Confluence...

Connecting to: https://company.atlassian.net/wiki
Project Space: ENG - Payment Platform
Authenticating... ✅

Publishing documents:
✅ Uploading: requirements.md
✅ Uploading: technical-design.md
✅ Uploading: 开发任务.md
✅ Uploading: progress-report.md

Publishing complete!
View at: https://company.atlassian.net/wiki/ENG/Payment-Platform

Next steps:
- Share link with stakeholders
- Set up automatic sync (optional)
- Configure update notifications
```

### Example 5: Update Task Status (Interactive)
```bash
/architect:manage-progress --update
```
Output:
```
📝 Update Task Status

Current tasks from 开发任务.md:

1. [ ] 用户认证模块
   - Progress: 50%
   - Status: 进行中
   - Update to completed? (y/N): y

2. [ ] 密码重置功能
   - Progress: 0%
   - Status: 待开始
   - Update status:
     1) 进行中
     2) 已阻塞
     3) 待审核
     Select (1-3): 1

3. [ ] OAuth第三方登录
   - Progress: 30%
   - Status: 已阻塞
   - Reason: Waiting for external API
   - Update to in progress? (y/N): n

Updating 开发任务.md... ✅

Updated tasks:
✅ 用户认证模块 → 已完成
✅ 密码重置功能 → 进行中
```

## Progress Tracking Metrics

### Phase Metrics
- **Completion Percentage**: Criteria met / Total criteria
- **Quality Score**: Based on validation results
- **Time vs Plan**: Actual vs estimated duration
- **Stakeholder Satisfaction**: Survey scores

### Task Metrics
- **Status Distribution**: Completed / In Progress / Pending / Blocked
- **Velocity**: Tasks completed per sprint
- **Burndown**: Remaining work over time
- **Blockers**: Tasks awaiting dependencies

### Team Metrics
- **Utilization**: Capacity used / Total capacity
- **Individual Velocity**: Tasks per developer
- **Workload Balance**: Distribution across team
- **Collaboration Score**: Cross-team dependencies

## Export Formats

### Markdown Format
```markdown
# Progress Report: [Project Name]

## Phase Overview
[Phase completion details]

## Task Summary
[Task status table]

## Next Steps
[Action items]
```

### JSON Format
```json
{
  "project": "Project Name",
  "timestamp": "2024-01-15T14:30:00Z",
  "phases": [
    {
      "id": 1,
      "name": "Requirements Analysis",
      "status": "completed",
      "completion": 100,
      "criteria_met": 6,
      "total_criteria": 6
    }
  ],
  "tasks": [
    {
      "id": "task-1",
      "name": "User Authentication",
      "status": "completed",
      "progress": 100,
      "owner": "Alice"
    }
  ]
}
```

### PDF Report
- Professional formatting
- Charts and graphs
- Executive summary
- Detailed breakdowns

## Documentation System Integration

### Confluence
```bash
/architect:manage-progress --publish confluence \
  --url "https://company.atlassian.net/wiki" \
  --project "Payment Platform"
```

### GitBook
```bash
/architect:manage-progress --publish gitbook \
  --url "https://company.gitbook.io/engineering" \
  --project "API Documentation"
```

### GitHub Wiki
```bash
/architect:manage-progress --publish github \
  --url "https://github.com/company/project/wiki" \
  --project "Development Workflow"
```

### Notion
```bash
/architect:manage-progress --publish notion \
  --url "https://notion.so/company/Project-Tracking" \
  --project "E-commerce Platform"
```

### Slack
```bash
/architect:manage-progress --publish slack \
  --project "Payment Gateway"
```
Posts summary to #engineering-updates channel

## Configuration

### Settings File
Create `.claude/architect-collaboration.local.md`:

```markdown
# Progress Management Settings

## Default Project
default_project: "Default Project Name"

## Export Settings
default_export_format: "markdown"
include_charts: true
include_executive_summary: true

## Publishing Settings
auto_publish: false
publish_frequency: "weekly"

## Confluence Settings
confluence_space_key: "ENG"
confluence_parent_page: "Project Tracking"

## Slack Settings
slack_channel: "#engineering-updates"
slack_mention_leads: true

## Metrics
track_velocity: true
track_quality_scores: true
track_resource_utilization: true
```

## Interactive Workflows

### Daily Standup
```bash
/architect:manage-progress --update
# Updates task statuses
# Generates daily summary
```

### Weekly Review
```bash
/architect:manage-progress --report --export markdown
# Creates weekly progress report
# Updates stakeholders
```

### Phase Transition
```bash
/architect:manage-progress --status
# Review phase completion
# Export phase deliverables
# Publish to documentation
```

## Tips

1. **Update Daily** - Keep task status current for accurate tracking
2. **Use Labels** - Tag tasks with priority, complexity, owner
3. **Review Weekly** - Generate reports for team retrospectives
4. **Automate Publishing** - Set up scheduled exports to keep docs current
5. **Track Blockers** - Flag blocked tasks immediately for resolution

## Troubleshooting

### No Progress Data Found
**Problem**: Command cannot find task files
**Solution**:
- Ensure 开发任务.md exists in docs/ directory
- Check file has proper markdown structure
- Verify task format matches templates

### Publishing Fails
**Problem**: Cannot connect to documentation system
**Solution**:
- Verify URL is correct and accessible
- Check authentication credentials
- Ensure proper permissions in target system
- Try with --export first to verify content

### Export Generates Empty Report
**Problem**: Report has no data
**Solution**:
- Check tasks have status field populated
- Verify phase information is complete
- Run with --status to see current state
- Update task statuses if needed

## Advanced Usage

### Automated Weekly Reports
```bash
#!/bin/bash
# Weekly progress report
/architect:manage-progress --report \
  --project "Payment Gateway" \
  --export pdf \
  --publish confluence \
  --url "https://wiki.company.com"
```

### Multi-Project Dashboard
```bash
# Aggregate progress across projects
for project in "Project1" "Project2" "Project3"; do
  /architect:manage-progress \
    --project "$project" \
    --export json \
    --output "reports/$project-progress.json"
done

# Generate dashboard
./create-dashboard.py reports/*.json
```

### CI/CD Integration
```yaml
# .github/workflows/progress-update.yml
- name: Update Progress
  run: |
    /architect:manage-progress --update
    /architect:manage-progress --status

- name: Publish Weekly Report
  if: github.event_name == 'schedule'
  run: |
    /architect:manage-progress \
      --report \
      --export markdown \
      --publish slack
```

## Related Commands

- `/architect:phase-workflow` - Phase management and validation
- Skills - Detailed guidance for each phase

## Support

For issues or questions:
- Check progress status: `/architect:manage-progress --status`
- Review configuration in `.claude/architect-collaboration.local.md`
- Verify task files exist and are properly formatted
