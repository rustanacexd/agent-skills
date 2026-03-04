---
name: merge-main-safely
description: Use when asked to sync the current PR/worktree branch with the latest upstream base branch and do a careful, non-destructive merge with conflict-aware validation.
---

# Merge Main Safely

## Overview

Merge the latest upstream base branch into the current working branch with conservative conflict resolution.
Preserve meaningful changes from both sides and validate the result before finalizing.

## Workflow

1. Confirm branch and tree safety.
- Identify current branch and working-tree state.
- If there are uncommitted changes, stop and ask before proceeding.
- Never merge directly into protected/default branches without explicit approval.

2. Resolve the merge source branch.
- Use an explicitly provided base branch when available.
- Otherwise detect the remote default branch and use that.
- Fetch latest remote refs before merging.

3. Start merge.
- Merge the fetched upstream base branch into the current branch with an auto-generated merge message.

4. Resolve conflicts conservatively.
- Enumerate unresolved files.
- Read both versions fully before editing.
- Keep both sides when behavior is non-overlapping or complementary.
- Avoid whole-file `ours/theirs` decisions unless explicitly requested.
- Remove all conflict markers and verify none remain.

5. Validate merge integrity.
- Run targeted checks for files touched by conflict resolution first.
- Discover project verification commands from repo-native sources (scripts, make targets, documented verification guides) instead of hardcoding.
- Execute fast deterministic checks first (type/lint/unit-integration), then broader suites as needed.
- Run E2E only when explicitly requested.
- If failures are pre-existing or unrelated, report that clearly with evidence.

6. Finalize and report.
- Confirm merge state is clean and conflict-free.
- Complete merge commit if still pending.
- Report source branch, merge commit hash, resolved files, and verification results.

## Safety Rules

- Never run destructive history commands unless explicitly requested.
- Never discard user-authored changes during conflict resolution without clear instruction.
- Prefer minimal, explicit edits tied to observed behavior.
