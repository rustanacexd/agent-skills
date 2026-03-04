---
name: iterative-plan-review-loop
description: Use only when the user explicitly invokes `$iterative-plan-review-loop` to run a fresh-subagent review/patch loop on a plan.
---

# Iterative Plan Review Loop

## Overview

Use this skill when a plan keeps going through manual `review -> patch -> review -> patch` loops.

Core principle: **fresh reviewer subagent per iteration + main-agent-only patching** reduces reviewer bias and progressively hardens the plan.

## When to Use

Use this skill only when:
1. The user explicitly names `$iterative-plan-review-loop`.
2. A plan already exists and needs hardening before execution.
3. The user wants repeated fresh-subagent reviews until no findings remain.

Do not use this skill when:
1. It was not explicitly invoked by name.
2. No plan file exists yet (use `superpowers:writing-plans` first).
3. The user only wants a single, quick sanity-check review.

## Required Inputs

1. Target plan path (for example: `docs/plans/2026-03-04-feature-x.md`).
2. Optional review scope (for example: completeness only, TDD compliance, sequencing).
3. Maximum iterations (default: `5`).

## Loop Contract

1. Reviewer subagent is review-only. It does not patch files.
2. Main agent patches the plan between reviews.
3. Each iteration must use a brand-new reviewer subagent (never reuse reviewer context).
4. Stop only when reviewer returns zero findings, or max iterations is reached.

## Workflow

### Step 1: Baseline Read

Main agent reads the target plan once and records:
1. File path and timestamp.
2. Current round number (`1`).
3. Iteration limit (`5` default).

### Step 2: Spawn Fresh Reviewer (Round N)

Spawn a new subagent with this review brief:
1. Review only; do not patch.
2. Find gaps in completeness, correctness, sequencing, testability, and ambiguity.
3. Return actionable findings with severity and exact fix guidance.
4. Return `NO_FINDINGS` only if no actionable issues remain.

### Step 3: Triage Findings in Main Agent

Main agent:
1. Converts reviewer findings into a concrete patch list.
2. Applies edits directly to the plan.
3. Records which findings were resolved.
4. Keeps a short per-round log in the session output.

### Step 4: Spawn Another Fresh Reviewer (Round N+1)

Spawn a brand-new reviewer subagent again with:
1. Updated plan content.
2. Prior findings and claimed resolutions (for verification).
3. Instruction to both verify previous fixes and search for new gaps.

### Step 5: Stop Conditions

Stop when either condition is true:
1. Reviewer returns `NO_FINDINGS`.
2. Iteration count reaches max (`5` unless user overrides).

If max is hit with remaining findings:
1. Report unresolved items clearly.
2. Ask user whether to continue with a higher cap or stop.

## Reviewer Output Format (Required)

```markdown
## Review Round N

### Verdict
[NEEDS_PATCH | NO_FINDINGS]

### Findings
1. [Severity: Critical|High|Medium|Low] [Category] [Issue]
   - Evidence: [exact quote or section]
   - Why it matters: [risk]
   - Required fix: [specific patch guidance]

### Regression Check
- Previously fixed items re-opened: [none/list]

### Final Token
[NO_FINDINGS only when no actionable findings remain]
```

## Main-Agent Output Format (Required)

```markdown
## Iteration Log

1. Round 1 reviewer verdict: NEEDS_PATCH
2. Round 1 patches applied: [short list]
3. Round 2 reviewer verdict: NEEDS_PATCH
4. Round 2 patches applied: [short list]
5. Round 3 reviewer verdict: NO_FINDINGS

## Final Status
Plan hardened with 3 review rounds.
```

## Quality Checklist for Reviewers

Reviewer must check:
1. Goal and scope clarity.
2. Explicit file targets.
3. Test-first sequence and verification commands.
4. Dependency order between tasks.
5. Edge cases, risks, and rollback/mitigation coverage.
6. Ambiguous language ("etc", "as needed", "handle errors") replaced with concrete actions.
7. Completion criteria are measurable.

## Red Flags

Never:
1. Reuse the same reviewer subagent for multiple rounds.
2. Let reviewer patch files directly.
3. Stop on "looks good" without explicit `NO_FINDINGS`.
4. Hide unresolved findings after max-iteration cutoff.
5. Accept vague findings without actionable fix guidance.

## Integration

1. Use `superpowers:writing-plans` to generate the first draft plan.
2. Use this skill to harden the draft through unbiased review loops.
3. Then proceed with `superpowers:subagent-driven-development` or `superpowers:executing-plans` for implementation.
