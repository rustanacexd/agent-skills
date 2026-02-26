# pr-review-loop

A [Claude Code](https://docs.anthropic.com/en/docs/claude-code) skill that automates the PR review-fix-verify cycle. Runs a comprehensive review, evaluates feedback, implements fixes, verifies correctness, and re-reviews — looping until the review comes back clean.

## The Problem

When using Claude Code with [superpowers](https://github.com/obra/superpowers) and [pr-review-toolkit](https://github.com/anthropics/claude-code/tree/main/plugins), the review workflow has a gap:

1. You run `/pr-review-toolkit:review-pr` — get a detailed report
2. You copy-paste the output and say "fix this"
3. `superpowers:receiving-code-review` auto-invokes, evaluates feedback, and starts fixing
4. **It stops here.** No verification that tests pass. No re-review to confirm fixes are clean. No structured exit.

The review-fix cycle is a single pass with a manual handoff. There's no loop.

## The Solution

`pr-review-loop` automates the full cycle end-to-end:

```
review → evaluate → implement → verify → re-review → loop or exit
```

One invocation. No manual copy-pasting between steps. Loops until clean.

### The Loop

```
pr-review-toolkit:review-pr          ← comprehensive review (Skill tool)
        ↓
receiving-code-review                ← evaluate feedback, push back if wrong
        ↓
    ┌───┴───┐
  small    large
    │        │
 implement  writing-plans → subagent-driven-development
 directly    (per-task spec + code quality review)
    │        │
    └───┬────┘
        ↓
verification-before-completion       ← confirm tests pass
        ↓
re-run pr-review-toolkit:review-pr   ← re-review
        ↓
    ┌───┴───┐
  issues   clean
  found      │
    │        ↓
    │   finishing-a-development-branch
    │
    └──→ back to evaluate
```

### Small vs Large

After evaluating feedback, the skill assesses fix complexity **overall** (not per-issue):

- **Small** — straightforward fixes (typos, imports, single-logic changes). Implement directly. The outer re-review loop catches anything missed.
- **Large** — complex fixes where "did I implement this correctly?" is a real question. Routes through `writing-plans` to create a plan file, then `subagent-driven-development` for per-task spec compliance + code quality review gates.

When unsure, defaults to small.

### Why the large path needs a plan file

`subagent-driven-development` requires a plan file as input — it reads the plan, extracts tasks, and dispatches one implementer subagent per task sequentially. The value isn't parallelization (it's sequential), it's:

- Fresh context per task (no pollution)
- Two-stage review after each task (spec compliance, then code quality)
- Self-review before handoff

So the large path adds `writing-plans` as an intermediate step to convert review feedback into the plan format that `subagent-driven-development` expects.

## Skills Orchestrated

| Skill | Role | Type |
|-------|------|------|
| `pr-review-toolkit:review-pr` | Comprehensive review with specialized agents | Skill (Skill tool) |
| `superpowers:receiving-code-review` | Evaluate feedback with technical rigor | Sub-skill |
| `superpowers:writing-plans` | Convert fixes to plan file (large path only) | Sub-skill |
| `superpowers:subagent-driven-development` | Execute plan with review gates (large path only) | Sub-skill |
| `superpowers:verification-before-completion` | Confirm tests pass | Sub-skill |
| `superpowers:finishing-a-development-branch` | Complete development branch | Sub-skill |

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) — **required** (not compatible with Codex or other agents)
- [superpowers](https://github.com/obra/superpowers) plugin (provides receiving-code-review, writing-plans, subagent-driven-development, verification-before-completion, finishing-a-development-branch)
- [pr-review-toolkit](https://github.com/anthropics/claude-code/tree/main/plugins) plugin (provides review-pr and specialized review agents)

> **Claude Code only.** This skill depends on `pr-review-toolkit` (a Claude Code plugin) and dispatches subagents via the Task tool. These capabilities are not available in Codex or other agents.

## Installation

Copy the `SKILL.md` file to your Claude Code personal skills directory:

```bash
mkdir -p ~/.claude/skills/pr-review-loop
cp SKILL.md ~/.claude/skills/pr-review-loop/
```

The skill will be available as `pr-review-loop` in all Claude Code sessions.

## Usage

```
/pr-review-loop
```

That's it. The skill handles the full cycle automatically.

## Design Decisions

### Why not use `requesting-code-review` for the review step?

`pr-review-toolkit:review-pr` replaces it — it launches multiple specialized agents (code-reviewer, silent-failure-hunter, test-analyzer, type-design-analyzer, comment-analyzer) and produces a categorized report with Critical/Important/Suggestions. It's more comprehensive than a single code review.

### Why assess complexity overall, not per-issue?

The decision is about workflow, not individual fixes. Mixing small-path and large-path fixes in the same pass would be messy. One assessment, one path.

### Why default to small when unsure?

The outer loop (re-review) is the safety net. If small-path fixes introduce issues, the re-review catches them. The large path adds significant overhead (plan file creation + subagent dispatch + two-stage review per task) that's only worth it for genuinely complex changes.

### What about context window / context rot?

Less of a concern than it appears. The heavy work is offloaded to subagents:
- `pr-review-toolkit:review-pr` dispatches review agents as subagents
- `subagent-driven-development` (large path) uses fresh subagents per task
- The main session primarily holds orchestration state and review output

## License

MIT
