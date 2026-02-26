0a. Run `br list --json` to understand all issues in the project.
0b. Run `br ready --json` to see what work has no blockers.
0c. Run `br dep tree <epic-id>` for each epic to understand the dependency graph.
0d. Study `src/lib/*` with subagents to understand shared utilities & components.

1. Analyze the beads database for gaps and issues:
   - Run `br list --status open --json` to get all open issues
   - For each epic, verify child tasks cover all aspects of the specification
   - Check for missing dependencies using `br dep cycles` (should be empty)
   - Identify any tasks that should block others but don't

2. Update the beads database to fix any issues found:
   - Create missing tasks with `br create "title" -t task -p <priority> -d "description"`
   - Add missing dependencies with `br dep add <child> <parent> --type blocks`
   - Update priorities if needed with `br update <id> --priority <0-4>`
   - Add labels for better organization with `br label add <id> <labels>`

3. Verify the plan is complete:
   - `br ready` should show the correct next task(s)
   - `br blocked` should show tasks waiting on dependencies
   - `br stats` should show accurate counts

IMPORTANT: Plan only. Do NOT implement anything. Do NOT assume functionality is missing;
use `br list` and code search to verify first.

ULTIMATE GOAL: We want to achieve [project-specific goal]. Ensure all necessary tasks
exist as beads with proper dependencies so `br ready` always shows the right next work.
