---
name: commit
description: Create focused git commits with a consistent conventional commit format and safe staging discipline. Use when asked to commit changes, write a commit message, save work to git, or clean up staged files before committing.
---

# Commit

Create one or more logical, reviewable commits from the current working tree.
Each commit must represent exactly one review-friendly unit of work.
If multiple intents are present, split them into separate commits.

## Workflow

1. Confirm and partition commit scope
- Run `git status --short`.
- Identify all changes in scope for the user request.
- Partition changes by intent/context (`why`) before staging.
- Define each commit target as a single unit of work a reviewer can evaluate independently.
- If intents differ, plan multiple commits up front.

2. Validate branch safety
- Run `git branch --show-current`.
- If on `main` or `master`, ask before committing directly.

3. Commit in intent-sized loops
- Pick exactly one intent bucket.
- Stage only files/hunks for that intent.
- Use interactive staging (`git add -p`) when files contain mixed intent changes.
- Run `git diff --cached --stat`.
- Run `git diff --cached` for content sanity.
- If staged changes contain multiple intents, unstage/split before committing.
- If the staged change cannot be explained as one unit of work in one sentence, split it.

4. Write the commit message
- Use format: `<type>(<scope>): <subject>`.
- Scope is optional.
- Keep subject imperative and concise (typically <= 72 chars).
- Add a short body when context is needed, focused on why/intent.

Recommended `type` values:
- `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `perf`, `build`, `ci`, `style`

Issue footer patterns when relevant:
- `Fixes #123`
- `Refs #123`

5. Commit and verify
- Commit with `git commit`.
- Verify with `git show --name-status --oneline --no-patch HEAD`.
- If hooks fail, report the failure and next action.
- Repeat steps 3-5 for each remaining intent bucket.

6. Report result
- Return all commit hashes, final messages, and files per commit.
- Return remaining unstaged/untracked changes.

## Rules

- Do not include unrelated files just to get a "clean" tree.
- Do not rewrite or amend history unless explicitly requested.
- Do not invent issue IDs.
- Never combine unrelated intents into one commit for convenience.
- One commit must equal one review-friendly unit of work.
- Prefer multiple small commits over one mixed commit.
