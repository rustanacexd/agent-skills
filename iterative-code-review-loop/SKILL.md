---
name: iterative-code-review-loop
description: Use only when the user explicitly invokes `$iterative-code-review-loop` to run repeated post-implementation review, fix, and commit rounds until no Critical/Important findings remain or a round cap is reached.
---

# Iterative Code Review Loop

## Overview

Use this skill when implementation is done and you want repeated review/fix rounds before merge.

Core principle: **fresh reviewer each round + skeptical fixer + per-round commit boundary** keeps reviews focused and prevents tunneling on stale uncommitted diffs.

## When to Use

Use this skill only when:
1. The user explicitly names `$iterative-code-review-loop`.
2. Code is already implemented and needs hardening.
3. The user wants repeat `review -> fix -> review -> fix` rounds.

Do not use this skill when:
1. It was not explicitly invoked.
2. You still need design/planning first.
3. The user only wants a single review pass.

## Required Inputs (Plain Text)

1. Target implementation context (summary, files, plan, or branch intent).
2. Optional review focus (correctness, regressions, test quality, architecture fit).
3. Optional maximum rounds (default: `3`).

No rigid JSON schema is required.

## Loop Contract

1. Main agent is the orchestrator and handoff hub.
2. Reviewer phase uses `$requesting-code-review` and is review-only.
3. Fixer phase uses `$receiving-code-review` and performs verify-before-fix.
4. Reviewer and fixer never talk directly; all handoff goes through main.
5. Use a brand-new reviewer subagent every round.
6. After fixer changes code, invoke `$commit` once for that round.
7. Stop when no `Critical`/`Important` findings remain, or max rounds is reached.

## Workflow

### Step 1: Baseline Snapshot (Round N)

Main agent records:
1. Current round (`1` initially).
2. Round limit (`3` default unless overridden).
3. `BASE_SHA` and `HEAD_SHA` for this review round.

### Step 2: Request Fresh Review

Main agent spawns a fresh reviewer with `$requesting-code-review` and includes:
1. What was implemented.
2. Plan/requirements context.
3. `BASE_SHA` and `HEAD_SHA`.
4. Round focus (if provided).

Reviewer returns findings to main only.

### Step 3: Main Triage and Handoff

Main agent:
1. Converts review findings into a fix queue.
2. Preserves severity (`Critical|Important|Minor`).
3. Passes full findings to fixer.

### Step 4: Receive Review and Fix

Main agent spawns fixer with `$receiving-code-review`.

Fixer must:
1. Verify each finding against codebase reality.
2. Fix valid issues in priority order.
3. Push back with technical reasoning when a finding is wrong.
4. Run targeted tests/verification and report evidence.

### Step 5: Commit Round Boundary

If fixer changed code:
1. Main agent invokes `$commit`.
2. Commit scope is this round's fixes only.
3. `$commit` may split into multiple commits if mixed intents are detected.

If no code changed, skip commit.

### Step 6: Repeat With Fresh Reviewer

Main agent computes next `BASE_SHA`/`HEAD_SHA` and spawns a brand-new reviewer for round `N+1`.

### Step 7: Stop Conditions

Stop when either condition is true:
1. Open `Critical` count is `0` and open `Important` count is `0`.
2. Round count reaches max.

If max rounds is reached with unresolved gate findings:
1. Report unresolved `Critical`/`Important` clearly.
2. Ask whether to continue with a higher cap.

## Reviewer Output Format (Required)

```markdown
## Review Round N

### Verdict
[NEEDS_FIX | PASS_WITH_MINORS | NO_FINDINGS]

### Findings
1. [Severity: Critical|Important|Minor] [Category] [Issue]
   - Evidence: [file/line or behavior]
   - Why it matters: [risk]
   - Required fix: [specific guidance]

### Final Gate
- Critical open: [count]
- Important open: [count]
- Minor open: [count]
```

## Fixer Output Format (Required)

```markdown
## Fix Round N

### Intake
- Findings received: [count]
- Clarifications needed: [none/list]

### Evaluation
1. [Finding ID]
   - Decision: [FIXED | REJECTED_WITH_REASON | DEFER_MINOR]
   - Rationale: [technical reason]
   - Changes: [files touched or none]
   - Verification: [tests/commands run]

### Round Result
- Critical remaining: [count]
- Important remaining: [count]
- Minor deferred: [count]
- Code changed: [yes|no]
```

## Main-Agent Output Format (Required)

```markdown
## Iteration Log

1. Round 1 review verdict: NEEDS_FIX
2. Round 1 fix result: [short summary]
3. Round 1 commit: [sha|none]
4. Round 1 remaining gate items: Critical=X, Important=Y
5. Round 2 review verdict: PASS_WITH_MINORS
6. Round 2 fix result: [short summary]
7. Round 2 commit: [sha|none]
8. Round 2 remaining gate items: Critical=0, Important=0

## Final Status
[PASSED: no Critical/Important] OR [STOPPED_AT_MAX_ROUNDS]
```

## Red Flags

Never:
1. Reuse the same reviewer subagent across rounds.
2. Let reviewer patch files.
3. Skip `$commit` when fixer changed code.
4. Continue with open `Critical`/`Important` findings without explicit user approval.
5. Stop on vague "looks good" without severity gate counts.

## Integration

1. Reviewer phase: `superpowers:requesting-code-review`.
2. Fixer phase: `superpowers:receiving-code-review`.
3. Per-round commit boundary: `commit`.
4. After passing gate, continue with normal branch completion flow.
