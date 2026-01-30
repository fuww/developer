# AGENTS.md

This file provides instructions for AI coding agents working with this repository.

## Task Tracking with Beads

Use `bd` (Beads) for all task and issue tracking. See [Beads documentation](https://github.com/steveyegge/beads) for full details.

### Session Start

1. Run `bd ready` to see unblocked tasks
2. Pick a task and run `bd update <id> --status in_progress`
3. Work on the task

### During Work

- Create new issues: `bd create "Issue title" -p <priority>`
- Update progress: `bd update <id> --status <status>`
- View details: `bd show <id>`
- List all: `bd list`

### Session End (Landing the Plane)

**Critical: Work is NOT complete until `git push` succeeds.**

1. File issues for any incomplete work
2. Run quality checks if code changed (`bun run build`, `bun test:e2e`)
3. Update all issue statuses appropriately
4. Close completed issues: `bd close <id> --reason "Completed"`
5. Run `bd sync` to export changes
6. Run `git push` - **absolutely required**
7. Verify with `git status` showing "up to date with origin"

### Important Rules

- **Never use `bd edit`** - It launches an interactive editor. Use `bd update` with flags instead:
  - `--title "New title"`
  - `--description "Description"`
  - `--status <status>`
  - `--priority <1-5>`
  - `--notes "Additional notes"`

- **Include issue IDs in commits** - Format: `"Fix authentication bug (bd-abc)"`

- **Status values**: `inbox`, `backlog`, `in_progress`, `blocked`, `done`

- **Priority values**: 1 (highest) to 5 (lowest)

## Project-Specific Commands

```bash
bun dev           # Start dev server
bun run build     # Type check and build
bun test:e2e      # Run E2E tests
```

## Code Quality

Before ending a session with code changes:
1. Run `bun run build` to verify types
2. Run `bun test:e2e` if UI was modified
3. Commit with descriptive message including issue ID
## Issue Tracking

This project uses **bd (beads)** for issue tracking.
Run `bd prime` for workflow context, or install hooks (`bd hooks install`) for auto-injection.

**Quick reference:**
- `bd ready` - Find unblocked work
- `bd create "Title" --type task --priority 2` - Create issue
- `bd close <id>` - Complete work
- `bd sync` - Sync with jj (run at session end)

For full workflow details: `bd prime`

Always commit changes to .beads folder with other changes.



## Related Tools

- **Beads**: [github.com/steveyegge/beads](https://github.com/steveyegge/beads) - AI-native issue tracking


